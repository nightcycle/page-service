--!strict
-- Services
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
-- Packages
local React = require(script.Parent.Parent.Parent:WaitForChild('React'))
local Synthetic = require(script.Parent.Parent.Parent:WaitForChild('Synthetic'))-- Modules

local RobloxTypes = require(script.Parent.Parent:WaitForChild('RobloxTypes'))-- Hooks

local useViewportSize = require(script.Parent.Parent:WaitForChild('Hooks'):WaitForChild('useViewportSize'))
local useTime = require(script.Parent.Parent:WaitForChild('Hooks'):WaitForChild('useTime'))-- Types

export type ToolTipProperties = RobloxTypes.ScreenGuiProperties & {
	Text: string,
	AbsolutePosition: Vector2,
	IsOpen: boolean,
	OnCloseComplete: () -> ()
}
-- Constants
local BACKGROUND_COLOR = Color3.fromRGB(101, 102, 104)
local TEXT_SIZE = 14
local PADDING = 19
local MAX_WIDTH = 300 - PADDING * 2
local DELAY = 0.35
local FONT = Enum.Font.Gotham
local FONT_FACE = Font.fromEnum(FONT)

-- Variables
-- References
-- Private Functions
local e = React.createElement
-- Class
return function(props: ToolTipProperties): React.ReactNode
	-- props
	local text = props.Text
	local absolutePosition = props.AbsolutePosition
	local isOpen = props.IsOpen
	local onCloseComplete = props.OnCloseComplete

	-- states
	local hasClosed, setHasClosed = React.useState(false)

	-- hooks
	local isDelayOver = useTime(true) > DELAY
	local viewportSize = useViewportSize()
	local isOpenAlpha = TweenService:GetValue(Synthetic.Hook.useLerp(
		if isOpen and isDelayOver then 1 else 0,
		if isOpen and isDelayOver then 1 else 0,
		0.075,
		true
	), Enum.EasingStyle.Cubic, Enum.EasingDirection.In)


	if not isOpen and isOpenAlpha <= 0 and not hasClosed and isDelayOver then
		setHasClosed(true)
		onCloseComplete()
	end

	-- memos
	local size: UDim2 = React.useMemo(function(): UDim2
		local size = TextService:GetTextSize(
			text,
			TEXT_SIZE,
			FONT,
			Vector2.new(MAX_WIDTH, viewportSize.Y)
		)
		return UDim2.fromOffset(size.X + PADDING*2, size.Y + PADDING*2)
	end, {TEXT_SIZE :: any, PADDING, text, viewportSize})


	return e("ScreenGui", RobloxTypes.mergeScreenGui( {
		DisplayOrder = props.DisplayOrder or 20,
		IgnoreGuiInset = if typeof(props.IgnoreGuiInset) == "nil" then true else props.IgnoreGuiInset,
		Enabled = if typeof(props.Enabled) == "nil" then true else props.Enabled,
		ResetOnSpawn = if typeof(props.ResetOnSpawn) == "nil" then false else props.ResetOnSpawn,
		children = {
			CanvasGroup = if isOpenAlpha > 0 then e("CanvasGroup", {
				Position = UDim2.fromOffset(absolutePosition.X+size.X.Offset, absolutePosition.Y+size.Y.Offset),
				Size = size,
				BackgroundTransparency = 1,
				GroupTransparency = 1-isOpenAlpha,
				children = {
					Box = e("Frame", {
						Position = UDim2.fromOffset(4, 7),
						AutomaticSize = Enum.AutomaticSize.XY,
						ZIndex = 2,
						children = {
							UICorner = e("UICorner", {
								CornerRadius = UDim.new(0, 8),
							} :: RobloxTypes.UICornerProperties),
							UIListLayout = e("UIListLayout", {
								Padding = UDim.new(0, 8),
								FillDirection = Enum.FillDirection.Vertical,
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
								VerticalAlignment = Enum.VerticalAlignment.Top,
								SortOrder = Enum.SortOrder.LayoutOrder,
							} :: RobloxTypes.UIListLayoutProperties),
							UIPadding = e("UIPadding", {
								PaddingLeft = UDim.new(0, 12),
								PaddingRight = UDim.new(0, 12),
								PaddingTop = UDim.new(0, 12),
								PaddingBottom = UDim.new(0, 12),
							} :: RobloxTypes.UIPaddingProperties),
							Header = e("TextLabel", {
								RichText = true,
								Text = text,
								Size = UDim2.fromOffset(47, 16),
								LayoutOrder = 1,
								BorderSizePixel = 1,
								BackgroundTransparency = 1,
								FontFace = FONT_FACE,
								BorderColor3 = Color3.fromRGB(27, 42, 53),
								TextColor3 = Color3.fromRGB(255, 255, 255),
								AutomaticSize = Enum.AutomaticSize.XY,
								ZIndex = 1,
								TextSize = TEXT_SIZE,
								TextDirection = Enum.TextDirection.Auto,
								TextScaled = false,
								TextStrokeTransparency = 1,
								TextTruncate = Enum.TextTruncate.AtEnd,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Top,
								TextWrapped = true,
							} :: RobloxTypes.TextLabelProperties),
						}
					} :: RobloxTypes.FrameProperties),
					Caret = e("ImageLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						BackgroundTransparency = 1,
						BorderSizePixel = 1,
						BorderColor3 = Color3.fromRGB(27, 42, 53),
						BorderMode = Enum.BorderMode.Outline,
						Position = UDim2.new(
							UDim.new(size.X.Scale/2, size.X.Offset/2),
							UDim.new(0, 4)
						),
						Size = UDim2.fromOffset(16, 8),
						ZIndex = 2,
						Image = "rbxasset://LuaPackages/Packages/_Index/UIBlox/UIBlox/AppImageAtlas/img_set_1x_1.png",
						ImageColor3 = BACKGROUND_COLOR,
						ImageRectOffset = Vector2.new(260, 440),
						ImageRectSize = Vector2.new(16, 8),
						Rotation = 180,
					} :: RobloxTypes.ImageLabelProperties),
					DropShadow = e("ImageLabel", {
						BackgroundTransparency = 1,
						BorderMode = Enum.BorderMode.Outline,
						BorderColor3 = Color3.fromRGB(27, 42, 53),
						BorderSizePixel = 1,
						ZIndex = 1,
						Size = UDim2.new(size.X, size.Y-UDim.new(0,4)),
						Image = "rbxasset://LuaPackages/Packages/_Index/UIBlox/UIBlox/AppImageAtlas/img_set_1x_1.png",
						ImageColor3 = Color3.new(0,0,0),
						ImageRectOffset = Vector2.new(217, 486),
						ImageRectSize = Vector2.new(25,25),
						ImageTransparency = 0.5,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(12, 12, 13, 13),
						SliceScale = 1,
					} :: RobloxTypes.ImageLabelProperties),
				}
			} :: RobloxTypes.CanvasGroupProperties) else nil,
		}
	} :: RobloxTypes.ScreenGuiProperties, props))
end