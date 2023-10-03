--!strict
local _Package = script.Parent.Parent
local _Packages = _Package.Parent

-- Services

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Config = require(_Package:WaitForChild("TopBar"):WaitForChild("Config"))
local TopBarButton = require(_Package:WaitForChild("TopBar"):WaitForChild("Button"))

-- Types
type Maid = Maid.Maid
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
export type TopBarButton = TopBarButton.TopBarButton
export type TopBarContainer = {
	__index: TopBarContainer,
	_Maid: Maid,
	_IsAlive: boolean,
	_Buttons: {[number]: TopBarButton},
	_Frames: {[number]: Frame},
	_GuiWidths: {[GuiObject]: number},
	_UnlockButton: TopBarButton?,
	Instance: Frame,
	_ListFrame: Frame,
	IsOpen: ValueState<boolean>,
	IsEnabled: ValueState<boolean>,
	_HasUnlockButton: ValueState<boolean>,
	_ClosedOffsetX: ValueState<number>,
	_OpenWidth: ValueState<number>,
	CreateFrame: (self: TopBarContainer, width: number) -> Frame,
	CreateButton: (self: TopBarContainer) -> TopBarButton,
	FindFirstButton: (self: TopBarContainer, name: string) -> TopBarButton?,
	FindFirstFrame: (self: TopBarContainer, name: string) -> Frame?,
	GetButtons: (self: TopBarContainer) -> {[number]: TopBarButton},
	GetFrames: (self: TopBarContainer) -> {[number]: Frame},
	SetUnlockButton: (self: TopBarContainer, topBarButton: TopBarButton?) -> (),
	GetUnlockButton: (self: TopBarContainer) -> TopBarButton?,
	ToggleExclusiveSelect: (self: TopBarContainer, button: TopBarButton?) -> (), 
	_UpdateClosedOffset: (self: TopBarContainer) -> (),
	Destroy: (self: TopBarContainer) -> (),
	new: () -> TopBarContainer,
}
-- Constants
local BUTTON_PADDING = Config.BUTTON.PADDING
local BUTTON_HEIGHT = Config.BUTTON.HEIGHT
local TOP_BAR_TOP_MARGIN = Config.MARGIN.TOP
local CONTAINER_BACKGROUND_COLOR = Config.THEME.BACKGROUND.UI.CONTRAST.COLOR
local CONTAINER_BACKGROUND_TRANSPARENCY = Config.THEME.BACKGROUND.UI.CONTRAST.TRANSPARENCY
local CLOSED_WIDTH = BUTTON_HEIGHT
-- Variables
-- References
-- Private Functions

-- Class
local TopBarContainer = {} :: TopBarContainer
TopBarContainer.__index = TopBarContainer

function TopBarContainer:Destroy()
	if not self._IsAlive then return end
	self._IsAlive = false
	self._Maid:Destroy()
	local t: any = self
	for k, v in pairs(t) do
		t[k] = nil
	end
	setmetatable(t, nil)
end

function TopBarContainer:CreateButton(): TopBarButton
	local button = self._Maid:GiveTask(TopBarButton.new())
	self._GuiWidths[button.Instance] = BUTTON_HEIGHT + BUTTON_PADDING

	self._OpenWidth:Set(self._OpenWidth:Get() + BUTTON_HEIGHT + BUTTON_PADDING)

	-- self._Maid:GiveTask(button.Instance:GetPropertyChangedSignal("Visible"):Connect(function(...: any)
	-- 	if button.Instance.Visible then
	-- 		self._OpenWidth:Set(self._OpenWidth:Get() + BUTTON_HEIGHT + BUTTON_PADDING)
	-- 	else
	-- 		self._OpenWidth:Set(self._OpenWidth:Get() - BUTTON_HEIGHT - BUTTON_PADDING)
	-- 	end
	-- end))
	self._Maid:GiveTask(button.IsEnabled:Connect(function()
		if button == self._UnlockButton then
			self._HasUnlockButton:Set(button.IsEnabled:Get())
		end
		if button.IsEnabled:Get() then
			self._OpenWidth:Set(self._OpenWidth:Get() + BUTTON_HEIGHT + BUTTON_PADDING)
		else
			self._OpenWidth:Set(self._OpenWidth:Get() - BUTTON_HEIGHT - BUTTON_PADDING)
		end
	end))


	self._Maid:GiveTask(button.Instance:GetPropertyChangedSignal("LayoutOrder"):Connect(function(...: any)
		self:_UpdateClosedOffset()
	end))

	button.Instance.Parent = self._ListFrame
	table.insert(self._Buttons, button)
	self:_UpdateClosedOffset()
	return button
end

function TopBarContainer:FindFirstButton(name: string): TopBarButton?
	for i, v in ipairs(self:GetButtons()) do
		if v.Instance.Name == name then
			return v
		end
	end
	return nil
end

function TopBarContainer:GetFrames(): {[number]: Frame}
	return table.clone(self._Frames)
end

function TopBarContainer:FindFirstFrame(name: string): Frame?
	for i, v in ipairs(self:GetFrames()) do
		if v.Name == name then
			return v
		end
	end
	return nil
end

function TopBarContainer:CreateFrame(width: number): Frame
	
	local frame = self._Maid:GiveTask(Instance.new("Frame"))
	frame.Size = UDim2.fromOffset(width, BUTTON_HEIGHT)
	frame.Transparency = 1
	frame.Parent = self._ListFrame

	self._GuiWidths[frame] = width

	self._OpenWidth:Set(self._OpenWidth:Get() + width)

	self._Maid:GiveTask(frame:GetPropertyChangedSignal("Visible"):Connect(function(...: any)
		if frame.Visible then
			self._OpenWidth:Set(self._OpenWidth:Get() + width)
		else
			self._OpenWidth:Set(self._OpenWidth:Get() - width)
		end
		self:_UpdateClosedOffset()
	end))

	self._Maid:GiveTask(frame:GetPropertyChangedSignal("LayoutOrder"):Connect(function(...: any)
		self:_UpdateClosedOffset()
	end))
	table.insert(self._Frames, frame)

	self:_UpdateClosedOffset()

	return frame
end

function TopBarContainer:ToggleExclusiveSelect(button: TopBarButton?): ()
	for i, v in ipairs(self:GetButtons()) do
		if v == button then
			if v.IsSelected:Get() then
				v.IsSelected:Set(false)
			else
				v.IsSelected:Set(true)
			end
		elseif v ~= self._UnlockButton then
			v.IsSelected:Set(false)
		end
	end
end

function TopBarContainer:_UpdateClosedOffset()
	-- table.sort(buttons, function(a: TopBarButton, b: TopBarButton): boolean
	-- 	return a.Instance.AbsolutePosition.X < b.Instance.AbsolutePosition.X
	-- end)
	local buttonRegistry: {[GuiObject]: TopBarButton} = {}
	for i, button in ipairs(self:GetButtons()) do
		buttonRegistry[button.Instance] = button
	end
	local offset = -BUTTON_PADDING*0.5
	local guiObjects = self._ListFrame:GetChildren()
	table.sort(guiObjects, function(a: Instance, b: Instance): boolean
		if a:IsA("GuiObject") and b:IsA("GuiObject") then
			return a.AbsolutePosition.X < b.AbsolutePosition.X
		elseif a:IsA("GuiObject") then
			return true
		elseif b:IsA("GuiObject") then
			return false
		else
			return false
		end
	end)
	for i, guiObject in ipairs(guiObjects) do
		if guiObject:IsA("GuiObject") then
			local width = self._GuiWidths[guiObject] -- BUTTON_HEIGHT + BUTTON_PADDING
			local button = buttonRegistry[guiObject]
			if button and not button.IsEnabled:Get() then
				width *= 0
			end
			if guiObject.Visible == false then
				width *= 0
			end
			if self._UnlockButton and button and button == self._UnlockButton then
				offset += width * 0.5
				break
			elseif width then
				offset += width
			end
		end
	end
	if not self._UnlockButton then
		offset *= 0.5
	end
	self._ClosedOffsetX:Set(offset)
end

function TopBarContainer:GetButtons(): {[number]: TopBarButton}
	return table.clone(self._Buttons)
end
function TopBarContainer:SetUnlockButton(button: TopBarButton?): ()
	self._UnlockButton = button
	if button then
		self._HasUnlockButton:Set(button.IsEnabled:Get())
		button.ReplaceIconWithXOnSelection:Set(true)
		button.HighlightOnSelection:Set(true)
		self._Maid._unlockSelection = button.IsSelected:Connect(function()
			self.IsOpen:Set(button.IsSelected:Get())
		end)
		self._Maid._topDownUnlockSelection = self.IsOpen:Connect(function()
			button.IsSelected:Set(self.IsOpen:Get())
		end)
		button.IsSelected:Set(self.IsOpen:Get())
		self:_UpdateClosedOffset()
	else
		self._HasUnlockButton:Set(false)
	end
end

function TopBarContainer:GetUnlockButton(): TopBarButton?
	return self._UnlockButton
end

function TopBarContainer.new()

	local self: TopBarContainer = setmetatable({}, TopBarContainer) :: any
	self._IsAlive = true
	self._Buttons = {}
	self._UnlockButton = nil

	self._Maid = Maid.new()

	local _fuse = ColdFusion.fuse(self._Maid)
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import
	
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	self.IsEnabled = _Value(true)
	self.IsOpen = _Value(true)
	self._HasUnlockButton = _Value(false)

	self._Maid:GiveTask(self.IsOpen:Connect(function()
		if self.IsOpen:Get() == false then
			for i, v in ipairs(self:GetButtons()) do
				v.IsSelected:Set(false)
			end
		end
	end))
	self._Frames = {}
	self._GuiWidths = {}
	self._OpenWidth = _Value(-BUTTON_PADDING)
	self._ClosedOffsetX = _Value(0)
	local AnchorX = _Computed(function(openWidth: number, offsetX: number): number
		local anchorX = offsetX/openWidth
		return anchorX
	end, self._OpenWidth, self._ClosedOffsetX)

	local GroupTransparency = _Computed(function(isOpen: boolean): number
		return if isOpen then 0 else 1
	end, self.IsEnabled):Tween(
		0.1,
		Enum.EasingStyle.Cubic,
		Enum.EasingDirection.Out
	)

	self._ListFrame = _new("Frame")({
		Name = "ButtonList",
		BackgroundTransparency = 1,
		Size = _Computed(function(width: number): UDim2
			return UDim2.fromOffset(width, BUTTON_HEIGHT)
		end, self._OpenWidth):Tween(
			0.1,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.In
		),
		Position =_Computed(function(anchorX: number, isOpen: boolean): UDim2
			return UDim2.fromScale(if not isOpen then 0.5 else anchorX, 0)
		end, AnchorX, self.IsOpen):Tween(
			0.1,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.In
		),
		AnchorPoint = _Computed(function(anchorX: number): Vector2
			return Vector2.new(anchorX, 0)
		end, AnchorX):Tween(
			0.1,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.In
		),
		ClipsDescendants = false,
		Children = {
			_new("UIListLayout")({
				Padding = UDim.new(0, BUTTON_PADDING),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
			}),
		}
	}) :: Frame



	self.Instance = _new("Frame")({
		Name = "TopBarContainer",
		BackgroundColor3 = CONTAINER_BACKGROUND_COLOR,
		BackgroundTransparency = _Computed(function(groupTransparency: number)
			return 1 - ((1-CONTAINER_BACKGROUND_TRANSPARENCY) * (1-groupTransparency))
		end, GroupTransparency),
		-- GroupTransparency = GroupTransparency,
		Visible = _Computed(function(groupTransparency: number)
			return groupTransparency < 1
		end, GroupTransparency),
		Size = _Computed(function(isOpen: boolean, openWidth: number, isEnabled: boolean, hasUnlockButton: boolean): UDim2
			return UDim2.new(
				0, 
				if isEnabled then
					if hasUnlockButton then
						if isOpen then openWidth else CLOSED_WIDTH
					else
						if isOpen then openWidth else 0
				else
					0,
				0, 
				BUTTON_HEIGHT
			)
		end, self.IsOpen, self._OpenWidth, self.IsEnabled, self._HasUnlockButton):Tween(
			0.1,
			Enum.EasingStyle.Quad,
			Enum.EasingDirection.In
		),
		Position = UDim2.new(0.5, 0, 0, TOP_BAR_TOP_MARGIN+BUTTON_PADDING),
		AnchorPoint = Vector2.new(0.5, 0),
		ClipsDescendants = true,
		Children = {
			self._ListFrame :: any,
			_new("UICorner")({
				CornerRadius = UDim.new(1, 0),
			}),
		}
	}) :: Frame
	return self
end

return TopBarContainer