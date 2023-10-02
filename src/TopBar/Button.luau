--!strict
local _Package = script.Parent.Parent
local _Packages = _Package.Parent
-- Services
-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
-- Modules
local Config = require(_Package:WaitForChild("TopBar"):WaitForChild("Config"))
local ToolTipConstructor = require(_Package:WaitForChild("TopBar"):WaitForChild("ToolTip"))

-- Types
-- Constants
local BUTTON_HEIGHT = Config.BUTTON.HEIGHT
local BUTTON_BORDER = Config.BUTTON.BORDER
local BUTTON_COLOR = Config.THEME.BACKGROUND.DEFAULT.COLOR
local BUTTON_HOVER_TRANSPARENCY = Config.THEME.BACKGROUND.EVENT.ON_HOVER.TRANSPARENCY
local BUTTON_HOVER_COLOR = Config.THEME.BACKGROUND.EVENT.ON_HOVER.COLOR
local BUTTON_PRESS_TRANSPARENCY = BUTTON_HOVER_TRANSPARENCY--Config.THEME.BACKGROUND.EVENT.ON_PRESS.TRANSPARENCY
local BUTTON_PRESS_COLOR = BUTTON_COLOR--Config.THEME.BACKGROUND.EVENT.ON_PRESS.COLOR
local ICON_COLOR = Config.THEME.ICON.EMPHASIS.COLOR
local ICON_TRANSPARENCY = Config.THEME.ICON.EMPHASIS.TRANSPARENCY
local ICON_HOVER_COLOR = Config.THEME.ICON.ON_HOVER.COLOR
local ICON_HOVER_TRANSPARENCY = Config.THEME.ICON.ON_HOVER.TRANSPARENCY
local ICON_PRESS_COLOR = ICON_HOVER_COLOR
local ICON_PRESS_TRANSPARENCY = ICON_HOVER_TRANSPARENCY

-- Variables
-- References
-- Private Functions
-- Class
-- Types
type State<V> = ColdFusion.State<V>
type ValueState<V> = ColdFusion.ValueState<V>
type Maid = Maid.Maid
type ButtonState = "Pressed" | "Default" | "Selected"
type OnClickInvoke = () -> ()
export type TopBarButton = {
	__index: TopBarButton,
	_Maid: Maid,
	_IsAlive: boolean,
	_OnClickInvoke: OnClickInvoke,
	_IconLabel: ImageLabel,
	IconImage: {
		Default: ValueState<string>,
		Selection: ValueState<string?>,
	},
	IconRect: {
		Default: ValueState<Rect?>,
		Selection: ValueState<Rect?>,
	},
	IconScaleType: {
		Default: ValueState<Enum.ScaleType?>,
		Selection: ValueState<Enum.ScaleType?>,
	},
	IconScale: {
		Default: ValueState<number>,
		Selection: ValueState<number?>,
	},
	ToolTip: {
		Default: ValueState<string?>,
		Selection: ValueState<string?>,
	},
	Instance: TextButton,
	HighlightOnSelection: ValueState<boolean>,
	ReplaceIconWithXOnSelection: ValueState<boolean>,
	IsSelected: ValueState<boolean>,
	SetOnClickInvoke: (self: TopBarButton, onInvoke: OnClickInvoke) -> (),
	Destroy: (self: TopBarButton) -> (),
	new: () -> TopBarButton,
}

-- Class
local TopBarButton = {} :: TopBarButton
TopBarButton.__index = TopBarButton

function TopBarButton:Destroy()
	if not self._IsAlive then return end
	self._IsAlive = false
	self._Maid:Destroy()
	local t: any = self
	for k, v in pairs(t) do
		t[k] = nil
	end
	setmetatable(t, nil)
end

function TopBarButton:SetOnClickInvoke(onInvoke: OnClickInvoke): ()
	self._OnClickInvoke = onInvoke
end

function TopBarButton.new()

	local self: TopBarButton = setmetatable({}, TopBarButton) :: any
	self._IsAlive = true
	self._Maid = Maid.new()

	local toolTipMaid = Maid.new()
	self._Maid:GiveTask(toolTipMaid)

	local _fuse = ColdFusion.fuse(self._Maid)
	
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import
	
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local IsPressed = _Value(false)
	local IsHovering = _Value(false)

	self.IconImage = {
		Default = _Value(""),
		Selection = _Value(nil :: string?),
	}
	self.IconRect = {
		Default = _Value(nil :: Rect?),
		Selection = _Value(nil :: Rect?),
	}
	self.IconScaleType = {
		Default = _Value(nil :: Enum.ScaleType?),
		Selection = _Value(nil :: Enum.ScaleType?),
	}
	self.IconScale = {
		Default = _Value(1),
		Selection = _Value(nil :: number?),
	}
	self.ToolTip = {
		Default = _Value(nil :: string?),
		Selection = _Value(nil :: string?),
	}

	self.ReplaceIconWithXOnSelection = _Value(false)
	self.HighlightOnSelection = _Value(false)
	self.IsSelected = _Value(false)
	self._OnClickInvoke = function()
		self.IsSelected:Set(not self.IsSelected:Get())
	end
	local ButtonState: State<ButtonState> = _Computed(function(isPressed: boolean, isHovering: boolean, isSelected: boolean): any
		if isSelected then
			return "Selected"
		elseif isPressed then
			return "Pressed"
		else
			return "Default"
		end
	end, IsPressed, IsHovering, self.IsSelected)


	local ToolTip = _Computed(function(buttonState: ButtonState, defTip: string?, selectionTip: string?)
		if buttonState == "Selected" then
			return selectionTip or defTip or ""
		else
			return defTip or ""
		end
	end, ButtonState, self.ToolTip.Default, self.ToolTip.Selection)
	local IconScale = _Computed(function(
		buttonState: ButtonState, 
		defScale: number, 
		selScale: number?
	): number
		if selScale and buttonState == "Selected" then
			return selScale
		else
			return defScale
		end
	end, ButtonState, self.IconScale.Default, self.IconScale.Selection)
	self._IconLabel = _new("ImageLabel")({
		BackgroundTransparency = 1,
		Image = _Computed(function(isSelected: boolean, defaultImage: string, selectionImage: string?): string
			if selectionImage and isSelected then
				return selectionImage
			else
				return defaultImage
			end
		end, self.IsSelected, self.IconImage.Default, self.IconImage.Selection),
		ScaleType = _Computed(function(isSelected: boolean, defaultScaleType: Enum.ScaleType?, selectionScaleType: Enum.ScaleType?): Enum.ScaleType
			if selectionScaleType and isSelected then
				return selectionScaleType
			else
				return defaultScaleType or Enum.ScaleType.Stretch
			end
		end, self.IsSelected, self.IconScaleType.Default, self.IconScaleType.Selection),
		ImageRectOffset = _Computed(function(isSelected: boolean, defaultRect: Rect?, selectionRect: Rect?): Vector2
			if selectionRect and isSelected then
				return selectionRect.Min
			else
				return if defaultRect then defaultRect.Min else Vector2.zero
			end
		end, self.IsSelected, self.IconRect.Default, self.IconRect.Selection),	
		ImageRectSize = _Computed(function(isSelected: boolean, defaultRect: Rect?, selectionRect: Rect?): Vector2
			if selectionRect and isSelected then
				return selectionRect.Max - selectionRect.Min
			else
				return if defaultRect then defaultRect.Max - defaultRect.Min else Vector2.zero
			end
		end, self.IsSelected, self.IconRect.Default, self.IconRect.Selection),	
		Size = _Computed(function(isSelected: boolean, scale: number, replaceWithX: boolean): UDim2
			if replaceWithX then
				if not isSelected then
					return UDim2.fromScale(scale,scale)
				else
					return UDim2.fromScale(0,0)
				end
			else
				return UDim2.fromScale(scale,scale)
			end
		end, self.IsSelected, IconScale, self.ReplaceIconWithXOnSelection):Tween(
			0.1,
			Enum.EasingStyle.Cubic,
			Enum.EasingDirection.Out
		),
		-- :Spring(SPRING_FREQUENCY, SPRING_DAMPING_RATIO),
		ImageColor3 = _Computed(function(buttonState: ButtonState, highlightOnSelection: boolean): Color3
			if buttonState == "Pressed" then
				return ICON_PRESS_COLOR
			elseif buttonState == "Selected" and highlightOnSelection then
				return ICON_HOVER_COLOR
			else
				return ICON_COLOR
			end
		end, ButtonState, self.HighlightOnSelection),
		ImageTransparency = _Computed(function(buttonState: ButtonState, highlightOnSelection: boolean): number
			if buttonState == "Pressed" then
				return ICON_PRESS_TRANSPARENCY
			elseif buttonState == "Selected" and highlightOnSelection then
				return ICON_HOVER_TRANSPARENCY
			else
				return ICON_TRANSPARENCY
			end
		end, ButtonState, self.HighlightOnSelection),
		Position = UDim2.fromScale(0.5,0.5),
		AnchorPoint = Vector2.new(0.5,0.5),
		Children = {}
	}) :: ImageLabel

	self.Instance = _new("TextButton")({
		Size = UDim2.fromOffset(
			BUTTON_HEIGHT,
			BUTTON_HEIGHT
		),
		BackgroundTransparency = 1,
		Children = {
			_new("UIPadding")({
				PaddingBottom = UDim.new(0,BUTTON_BORDER),
				PaddingTop = UDim.new(0,BUTTON_BORDER),
				PaddingRight = UDim.new(0,BUTTON_BORDER),
				PaddingLeft = UDim.new(0,BUTTON_BORDER),
			}),
			_new("Frame")({
				BackgroundTransparency = _Computed(function(buttonState: ButtonState, highlightOnSelection: boolean): number
					if buttonState == "Pressed" then
						return BUTTON_PRESS_TRANSPARENCY
					elseif buttonState == "Selected" and highlightOnSelection then
						return BUTTON_HOVER_TRANSPARENCY
					else
						return 1
					end
				end, ButtonState, self.HighlightOnSelection),
				BackgroundColor3 = _Computed(function(buttonState: ButtonState, highlightOnSelection: boolean): Color3
					if buttonState == "Pressed" then
						return BUTTON_PRESS_COLOR
					elseif buttonState == "Selected" and highlightOnSelection then
						return BUTTON_HOVER_COLOR
					else
						return BUTTON_COLOR
					end
				end, ButtonState, self.HighlightOnSelection),
				Size = UDim2.fromOffset(
					BUTTON_HEIGHT-BUTTON_BORDER*2,
					BUTTON_HEIGHT-BUTTON_BORDER*2
				),
				Children = {
					self._IconLabel :: any,
					_new("Frame")({
						Name = "XIcon",
						BackgroundTransparency = 1,
						Visible = self.ReplaceIconWithXOnSelection,
						Size = UDim2.fromScale(1,1),
						Position = UDim2.fromScale(0.5,0.5),
						AnchorPoint = Vector2.new(0.5,0.5),
						Children = {
							_new("Frame")({
								Name = "XBar1",
								BorderColor3 = Color3.fromRGB(27, 42, 53),
								BackgroundColor3 = _Computed(function(buttonState: ButtonState): Color3
									if buttonState == "Pressed" then
										return ICON_PRESS_COLOR
									elseif buttonState == "Selected" then
										return ICON_HOVER_COLOR
									else
										return ICON_COLOR
									end
								end, ButtonState),
								BackgroundTransparency = _Computed(function(buttonState: ButtonState): number
									if buttonState == "Pressed" then
										return ICON_PRESS_TRANSPARENCY
									elseif buttonState == "Selected" then
										return ICON_HOVER_TRANSPARENCY
									else
										return ICON_TRANSPARENCY
									end
								end, ButtonState),
								Rotation = 45,
								Position = UDim2.fromScale(0.5, 0.5),
								AnchorPoint = Vector2.new(0.5,0.5),
								Size = _Computed(function(isSelected: boolean, scale: number?): UDim2
									scale = scale or 1
									assert(scale)
									if isSelected then
										return UDim2.fromOffset(
											math.ceil(16*scale),
											math.ceil(2*scale)
										)
									else
										return UDim2.fromScale(0,0)
									end
								end, self.IsSelected, self.IconScale.Selection):Tween(
									0.25,
									Enum.EasingStyle.Cubic,
									Enum.EasingDirection.Out
								),
								-- :Spring(SPRING_FREQUENCY, SPRING_DAMPING_RATIO),
								-- Size = UDim2.fromOffset(16,2),
								Children = {

								},
							}),
							_new("Frame")({
								Name = "XBar2",
								BorderColor3 = Color3.fromRGB(27, 42, 53),
								BackgroundColor3 = _Computed(function(buttonState: ButtonState): Color3
									if buttonState == "Pressed" then
										return ICON_PRESS_COLOR
									elseif buttonState == "Selected" then
										return ICON_HOVER_COLOR
									else
										return ICON_COLOR
									end
								end, ButtonState),
								BackgroundTransparency = _Computed(function(buttonState: ButtonState): number
									if buttonState == "Pressed" then
										return ICON_PRESS_TRANSPARENCY
									elseif buttonState == "Selected" then
										return ICON_HOVER_TRANSPARENCY
									else
										return ICON_TRANSPARENCY
									end
								end, ButtonState),
								Rotation = -45,
								Position = UDim2.fromScale(0.5, 0.5),
								AnchorPoint = Vector2.new(0.5,0.5),
								Size = _Computed(function(isSelected: boolean, scale: number?): UDim2
									scale = scale or 1
									assert(scale)
									if isSelected then
										return UDim2.fromOffset(
											math.ceil(16*scale),
											math.ceil(2*scale)
										)
									else
										return UDim2.fromScale(0,0)
									end
								end, self.IsSelected, self.IconScale.Selection):Tween(
									0.25,
									Enum.EasingStyle.Cubic,
									Enum.EasingDirection.Out
								), --Spring(SPRING_FREQUENCY, SPRING_DAMPING_RATIO),
								-- Size = UDim2.fromOffset(16,2),
								Children = {

								},
							}),
						},
					}),
					_new("Frame")({
						Name = "HoverEffect",
						ZIndex = 2,
						BackgroundTransparency = _Computed(function(isHovering: boolean): number
							if isHovering then
								return BUTTON_HOVER_TRANSPARENCY
							else
								return 1
							end
						end, IsHovering),
						BackgroundColor3 = BUTTON_HOVER_COLOR,
						Size = UDim2.fromScale(1,1),
						Children = {
							_new("UICorner")({
								CornerRadius = UDim.new(1, 0),
							})
						},
					}),
					_new("UICorner")({
						CornerRadius = UDim.new(1, 0),
					})
				}
			}) :: ImageLabel,
		},
		Events = {
			Activated = function()
				self._OnClickInvoke()
			end,
			MouseButton1Down = function()
				IsPressed:Set(false)
			end,
			MouseButton1Up = function()
				IsPressed:Set(true)
			end,
			MouseEnter = function()
				IsHovering:Set(true)
				if ToolTip:Get() ~= "" then
					print("tip")
					local pos = self.Instance.AbsolutePosition + self.Instance.AbsoluteSize * Vector2.new(0.5,1)
					
					toolTipMaid:GiveTask(ToolTipConstructor(
						ToolTip, 
						UDim2.fromOffset(pos.X, pos.Y)
					))

				end
			end,
			MouseLeave = function()
				IsPressed:Set(false)
				IsHovering:Set(false)
				toolTipMaid:DoCleaning()
			end,
		}
	}) :: TextButton

	return self
end

return TopBarButton