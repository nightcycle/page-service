--!strict
-- https://github.com/MaximumADHD/Roblox-Client-Tracker/blob/roblox/scripts/CoreScripts/Modules/TopBar/init.lua
local _Package = script.Parent
local _Packages = _Package.Parent

-- Services
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Config = require(script:WaitForChild("Config"))
local Container = require(script:WaitForChild("Container"))

-- Types
-- Constants
local TOP_BAR_HEIGHT = Config.HEIGHT
local TOP_BAR_MARGIN = Config.MARGIN.TOP
local TOP_BUTTON_PADDING = Config.BUTTON.PADDING
local TOP_BUTTON_HEIGHT = Config.BUTTON.HEIGHT
local TOP_BUTTON_BORDER = Config.BUTTON.BORDER
local UNIBAR_DIVIDER_WIDTH = Config.UNIBAR.DIVIDER_CELL_WIDTH
local UNIBAR_CELL_WIDTH = Config.UNIBAR.ICON_CELL_WIDTH
local PADDING = Config.PADDING
local HEALTH_BAR_WIDTH = 80

-- Variables
-- References
local Player = Players.LocalPlayer

-- Private Functions
-- Types
type Maid = Maid.Maid
type ValueState<T> = ColdFusion.ValueState<T>
type State<T> = ColdFusion.State<T>
export type TopBarButton = Container.TopBarButton
export type TopBarContainer = Container.TopBarContainer
export type TopBar = {
	__index: TopBar,
	_Maid: Maid,
	_IsAlive: boolean,
	_Frame: Frame,
	_Containers: {[number]: TopBarContainer},
	Instance: ScreenGui,
	IsEnabled: ValueState<boolean>,
	AlignUsingMinimumFootprint: ValueState<boolean>,
	CreateContainer: (self: TopBar) -> TopBarContainer,
	GetContainers: (self: TopBar) -> {[number]: TopBarContainer},
	FindFirstContainer: (self: TopBar, name: string) -> TopBarContainer?,
	Destroy: (self: TopBar) -> (),
	new: () -> TopBar,
}

-- Class
local CurrentTopBar: TopBar = nil :: any
local TopBar = {} :: TopBar
TopBar.__index = TopBar

function TopBar:Destroy()
	if not self._IsAlive then return end
	self._IsAlive = false
	if CurrentTopBar == self then
		CurrentTopBar = nil :: any
	end
	self._Maid:Destroy()
	local t: any = self
	for k, v in pairs(t) do
		t[k] = nil
	end
	setmetatable(t, nil)
end

function TopBar:GetContainers(): {[number]: TopBarContainer}
	return table.clone(self._Containers)
end

function TopBar:CreateContainer(): TopBarContainer
	local container = self._Maid:GiveTask(Container.new())
	table.insert(self._Containers, container)
	container.Instance.Parent = self._Frame
	return container
end

function TopBar:FindFirstContainer(name: string): TopBarContainer?
	for i, v in ipairs(self:GetContainers()) do
		if v.Instance.Name == name then
			return v
		end
	end
	return nil
end

function TopBar.new()

	local self: TopBar = setmetatable({}, TopBar) :: any
	self._IsAlive = true
	self._Maid = Maid.new()
	
	local _fuse = ColdFusion.fuse(self._Maid)
	
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import
	
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local LeftMargin = _Value(0)
	local RightMargin = _Value(0)
	self.IsEnabled = _Value(true)

	local GroupTransparency = _Computed(function(isOpen: boolean): number
		return if isOpen then 0 else 1
	end, self.IsEnabled):Tween(
		0.1,
		Enum.EasingStyle.Cubic,
		Enum.EasingDirection.Out
	)

	self.AlignUsingMinimumFootprint = _Value(true)
	self._Containers = {}
	self._Frame = _new("Frame")({
		Name = "ContainerFrame",
		BackgroundTransparency = 1,
		-- GroupTransparency = GroupTransparency,
		Visible = _Computed(function(groupTransparency: number)
			return groupTransparency < 1
		end, GroupTransparency),
		AutomaticSize = Enum.AutomaticSize.X,
		Position = UDim2.fromScale(1,0.5),
		AnchorPoint = Vector2.new(1,0.5),
		Size = UDim2.fromScale(0,1),
		Children = {
			_new("UIPadding")({
				PaddingTop = UDim.new(0, TOP_BUTTON_PADDING),
			}),
			_new("UIListLayout")({
				Padding = UDim.new(0,PADDING),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
			}),
		}
	}) :: Frame
	local AbsoluteWidth = _Value(self._Frame.AbsoluteSize.X)
	local ScreenWidth = _Value(workspace.CurrentCamera.ViewportSize.X)

	self.Instance = _new("ScreenGui")({
		Name = "TopBar",
		IgnoreGuiInset = true,
		ClipToDeviceSafeArea = true,
		Enabled = true,
		ResetOnSpawn = false,
		SafeAreaCompatibility = Enum.SafeAreaCompatibility.FullscreenExtension,
		ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets,
		Parent = if Player then Player:WaitForChild("PlayerGui") else game:GetService("CoreGui"),
		DisplayOrder = 7,
		Children = {
			_new("Frame")({
				Name = "TopBarFrame",
				BackgroundTransparency = 1,
				Position = _Computed(function(left: number, right: number, containerWidth: number, screenWidth: number): UDim2
					if (0.5*screenWidth - math.max(right, left)) > containerWidth * 0.5 then
						return UDim2.new(0.5, 0, 0, TOP_BAR_MARGIN)
					else
						if left > right then
							return UDim2.new(0, left + containerWidth * 0.5, 0, TOP_BAR_MARGIN)
						else
							return UDim2.new(1, -right - containerWidth * 0.5, 0, TOP_BAR_MARGIN)
						end
					end
				end, LeftMargin, RightMargin, AbsoluteWidth, ScreenWidth),
				AnchorPoint = Vector2.new(0.5,0),
				Size = _Computed(function(containerWidth: number, screenWidth: number, isOpen: boolean): UDim2
					if isOpen then
						return UDim2.new(0, containerWidth, 0, TOP_BAR_HEIGHT)
					else
						return UDim2.new(0, 0, 0, TOP_BAR_HEIGHT)
					end
				end, AbsoluteWidth, ScreenWidth, self.IsEnabled):Tween(
					0.1,
					Enum.EasingStyle.Cubic,
					Enum.EasingDirection.Out
				),
				Children = {
					self._Frame
				}
			}) :: Frame
		}
	}) :: ScreenGui

	self._Maid:GiveTask(RunService.PreRender:Connect(function(deltaTime: number)
		local rightOffset = TOP_BAR_MARGIN + TOP_BUTTON_BORDER + TOP_BUTTON_PADDING * 0.5
		local buttonWidth = UNIBAR_CELL_WIDTH
		local leftOffset = rightOffset + TOP_BUTTON_PADDING + TOP_BUTTON_HEIGHT
		if not self.AlignUsingMinimumFootprint:Get() then
			rightOffset += buttonWidth * 3
			rightOffset += UNIBAR_DIVIDER_WIDTH + TOP_BUTTON_PADDING * 2
			if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Backpack) then
				rightOffset += buttonWidth
			end
			if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat) then
				rightOffset += buttonWidth
			end
			if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu) then
				rightOffset += buttonWidth
			end
			if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Health) then
				rightOffset += HEALTH_BAR_WIDTH + PADDING
			end
			if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.PlayerList) then
				rightOffset += buttonWidth
			end
			if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.SelfView) then
				-- rightOffset += buttonWidth
			end
		else
			rightOffset = leftOffset
		end
		
		AbsoluteWidth:Set(self._Frame.AbsoluteSize.X)
		ScreenWidth:Set(workspace.CurrentCamera.ViewportSize.X)
		LeftMargin:Set(leftOffset + PADDING)
		RightMargin:Set(rightOffset + PADDING)
	end))

	-- I don't know why, but it'll just set itself to false sometimes
	local function forceIgnoreGuiInset()
		if not self.Instance.IgnoreGuiInset then
			self.Instance.IgnoreGuiInset = true
		end
	end
	self._Maid:GiveTask(self.Instance:GetPropertyChangedSignal("IgnoreGuiInset"):Connect(forceIgnoreGuiInset))
	forceIgnoreGuiInset()

	if CurrentTopBar ~= nil then
		 CurrentTopBar:Destroy()
		 CurrentTopBar = nil :: any
	end
	CurrentTopBar = self

	return self
end

return TopBar