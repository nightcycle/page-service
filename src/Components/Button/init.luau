--!strict
-- Services
local TweenService = game:GetService("TweenService")
-- Packages
local React = require("@wally/React")
local Synthetic = require("@wally/Synthetic")
-- Modules
local RobloxTypes = require("@proj/RobloxTypes")
local Config = require("@proj/Config")
-- Components
local ToolTip = require("@proj/Components/ToolTip")
-- Hooks
-- Types
type ButtonState = "Selected" | "Pressed" | "Default"
type ButtonData = Synthetic.ButtonData
type ToolTipProperties = ToolTip.ToolTipProperties
export type ButtonProperties = RobloxTypes.GuiButtonProperties & {
	Icon: Synthetic.ImageData?,
	IconScale: number?,
	IconScaleType: Enum.ScaleType?,
	ToolTip: string?,
	HighlightOnSelection: boolean,
	ReplaceIconWithXOnSelection: boolean,
	IsSelected: boolean,
	IsVisible: boolean,
	OnClick: () -> (),
}
-- Constants
local BUTTON_HEIGHT = Config.BUTTON.HEIGHT
local BUTTON_BORDER = Config.BUTTON.BORDER
local BUTTON_COLOR = Config.THEME.BACKGROUND.DEFAULT.COLOR
local BUTTON_HOVER_TRANSPARENCY = Config.THEME.BACKGROUND.EVENT.ON_HOVER.TRANSPARENCY
local BUTTON_HOVER_COLOR = Config.THEME.BACKGROUND.EVENT.ON_HOVER.COLOR
local BUTTON_PRESS_TRANSPARENCY = BUTTON_HOVER_TRANSPARENCY
local BUTTON_PRESS_COLOR = BUTTON_COLOR
local ICON_COLOR = Config.THEME.ICON.EMPHASIS.COLOR
local ICON_TRANSPARENCY = Config.THEME.ICON.EMPHASIS.TRANSPARENCY
local ICON_HOVER_COLOR = Config.THEME.ICON.ON_HOVER.COLOR
local ICON_HOVER_TRANSPARENCY = Config.THEME.ICON.ON_HOVER.TRANSPARENCY
local ICON_PRESS_COLOR = ICON_HOVER_COLOR
local ICON_PRESS_TRANSPARENCY = ICON_HOVER_TRANSPARENCY
local X_BAR_COLOR = Color3.fromRGB(27, 42, 53)

-- Variables
-- References
-- Private Functions
local e = React.createElement
-- Class
return function(props: ButtonProperties): React.ReactNode
	-- props
	local icon = props.Icon
	local toolTip = props.ToolTip
	local highlightOnSelection = props.HighlightOnSelection
	local replaceIconWithXOnSelection = props.ReplaceIconWithXOnSelection
	local isSelected = props.IsSelected
	local onClick = props.OnClick
	local isVisible = props.IsVisible
	local iconScale = props.IconScale
	local iconScaleType = props.IconScaleType

	-- states
	local isHovering, setIsHovering = React.useState(false)
	local isPressed, setIsPressed = React.useState(false)
	local absoluteSize, setAbsoluteSize = React.useState(Vector2.new(0,0))
	local absolutePosition, setAbsolutePosition = React.useState(Vector2.new(0,0))
	local toolTipVisible, setToolTipVisible = React.useState(false)
	local toolTipCloseComplete, setToolTipCloseComplete = React.useState(true)
	-- hooks
	local isVisibleAlpha = TweenService:GetValue(Synthetic.Hook.useLerp(
		if isVisible then 1 else 0,
		if isVisible then 1 else 0,
		0.1,
		true
	), Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
	local selectionAlpha = TweenService:GetValue(Synthetic.Hook.useLerp(
		if isSelected then 1 else 0,
		if isSelected then 1 else 0,
		0.25,
		true
	), Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
	-- memos
	local buttonState: ButtonState = React.useMemo(function(): any
		if isSelected then
			return "Selected" :: ButtonState
		elseif isPressed then
			return "Pressed" :: ButtonState
		else
			return "Default" :: ButtonState
		end
	end, {isSelected, isPressed})

	return e("TextButton", RobloxTypes.mergeGuiButton( {
		Size = UDim2.fromOffset(BUTTON_HEIGHT*isVisibleAlpha,BUTTON_HEIGHT),
		BackgroundTransparency = 1,
		[React.Event.MouseEnter] = function()
			if not isHovering then
				setIsHovering(true)
			end
			if toolTip and not toolTipVisible then
				setToolTipVisible(true)
				if toolTipCloseComplete then
					setToolTipCloseComplete(false)
				end
			end
		end :: any,
		[React.Event.MouseLeave] = function()
			if isHovering then
				setIsHovering(false)
			end
			if toolTipVisible then
				setToolTipVisible(false)
			end
		end,
		[React.Event.MouseButton1Down   ] = function()
			if not isPressed then
				setIsPressed(true)
			end
		end,
		[React.Event.MouseButton1Up  ] = function()
			if isPressed then
				setIsPressed(false)
			end
		end,
		[React.Event.Activated] = function()
			if isVisible then
				onClick()
			end
		end,
		[React.Change.AbsolutePosition] = function(inst: TextButton)
			if inst.AbsolutePosition ~= absolutePosition then
				setAbsolutePosition(inst.AbsolutePosition)
			end
		end,
		[React.Change.AbsoluteSize] = function(inst: TextButton)
			if inst.AbsoluteSize ~= absoluteSize then
				setAbsoluteSize(inst.AbsoluteSize)
			end
		end,
		children = {
			ToolTip = if toolTip and (toolTipVisible or not toolTipCloseComplete) then e(ToolTip, {
				Text = toolTip,
				AbsolutePosition = absolutePosition+Vector2.new(0.5,1)*absoluteSize,
				IsOpen = toolTipVisible,
				OnCloseComplete = function()
					if toolTipCloseComplete then
						setToolTipCloseComplete(true)
					end
				end,
			} :: ToolTipProperties) else nil,
			UIPadding = e("UIPadding", {
				PaddingTop = UDim.new(0, BUTTON_BORDER),
				PaddingBottom = UDim.new(0, BUTTON_BORDER),
				PaddingLeft = UDim.new(0, BUTTON_BORDER),
				PaddingRight = UDim.new(0, BUTTON_BORDER),
			} :: RobloxTypes.UIPaddingProperties),
			Content = if isVisibleAlpha <= 0 then nil else e("Frame", {
				BackgroundTransparency = if buttonState == "Pressed" then BUTTON_PRESS_TRANSPARENCY elseif isHovering then BUTTON_HOVER_TRANSPARENCY else 1,
				BackgroundColor3 = if buttonState == "Pressed" then BUTTON_PRESS_COLOR elseif isHovering then BUTTON_HOVER_COLOR else BUTTON_COLOR,
				Size = UDim2.fromOffset(BUTTON_HEIGHT-BUTTON_BORDER*2,BUTTON_HEIGHT-BUTTON_BORDER*2),
				children = {
					Icon = if replaceIconWithXOnSelection and isSelected then e("ImageLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.fromScale(1,1),
						Position = UDim2.fromScale(0.5,0.5),
						AnchorPoint = Vector2.new(0.5,0.5),
						children = {
							XBar1 = e("Frame", {
								BorderColor3 = X_BAR_COLOR,
								BackgroundColor3 = if buttonState == "Pressed" then ICON_PRESS_COLOR elseif buttonState == "Selected" then ICON_HOVER_COLOR else ICON_COLOR,
								BackgroundTransparency = if buttonState == "Pressed" then ICON_PRESS_TRANSPARENCY elseif buttonState == "Selected" then ICON_HOVER_TRANSPARENCY else ICON_TRANSPARENCY,
								Rotation = 45,
								Position = UDim2.fromScale(0.5,0.5),
								AnchorPoint = Vector2.new(0.5,0.5),
								Size = UDim2.fromOffset(
									math.ceil(16*selectionAlpha*(iconScale or 1)),
									math.ceil(2*selectionAlpha*(iconScale or 1))
								)
							} :: RobloxTypes.FrameProperties),
							XBar2 = e("Frame", {
								BorderColor3 = X_BAR_COLOR,
								BackgroundColor3 = if buttonState == "Pressed" then ICON_PRESS_COLOR elseif buttonState == "Selected" then ICON_HOVER_COLOR else ICON_COLOR,
								BackgroundTransparency = if buttonState == "Pressed" then ICON_PRESS_TRANSPARENCY elseif buttonState == "Selected" then ICON_HOVER_TRANSPARENCY else ICON_TRANSPARENCY,
								Rotation = -45,
								Position = UDim2.fromScale(0.5,0.5),
								AnchorPoint = Vector2.new(0.5,0.5),
								Size = UDim2.fromOffset(
									math.ceil(16*selectionAlpha*(iconScale or 1)),
									math.ceil(2*selectionAlpha*(iconScale or 1))
								)
							} :: RobloxTypes.FrameProperties),
						},
					} :: RobloxTypes.ImageLabelProperties) elseif icon then e("ImageLabel", {
						BackgroundTransparency = 1,
						Image = if typeof(icon.Image) == "string" then icon.Image else "",
						ImageContent = if typeof(icon.Image) == "Content" then icon.Image else nil,
						ScaleType = iconScaleType or Enum.ScaleType.Stretch,
						ImageRectOffset = icon.ImageRectOffset,
						ImageRectSize = icon.ImageRectSize,
						Size = UDim2.fromScale(iconScale or 1,iconScale or 1),
						ImageColor3 = if buttonState == "Pressed" then ICON_PRESS_COLOR elseif buttonState == "Selected" and highlightOnSelection then ICON_HOVER_COLOR else ICON_COLOR,
						ImageTransparency = if buttonState == "Pressed" then ICON_PRESS_TRANSPARENCY elseif buttonState == "Selected" and highlightOnSelection then ICON_HOVER_TRANSPARENCY else ICON_TRANSPARENCY,
						Position = UDim2.fromScale(0.5,0.5),
						AnchorPoint = Vector2.new(0.5,0.5),
					} :: RobloxTypes.ImageLabelProperties) else nil,
					HoverEffect = if isHovering then e("Frame", {
						ZIndex = 2,
						BackgroundTransparency = BUTTON_HOVER_TRANSPARENCY,
						BackgroundColor3 = BUTTON_HOVER_COLOR,
						Size = UDim2.fromScale(1,1),
						children = {
							UICorner = e("UICorner", {
								CornerRadius = UDim.new(1, 0),
							} :: RobloxTypes.UICornerProperties),
						}
					} :: RobloxTypes.FrameProperties) else nil,
					UICorner = e("UICorner", {
						CornerRadius = UDim.new(1, 0),
					} :: RobloxTypes.UICornerProperties),
				}
			} :: RobloxTypes.FrameProperties),
		}
	} :: RobloxTypes.GuiButtonProperties, props))
end