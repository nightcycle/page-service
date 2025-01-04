--!strict
-- Services
local TweenService = game:GetService("TweenService")
-- Packages
local React = require(script.Parent.Parent.Parent:WaitForChild('React'))
local Synthetic = require(script.Parent.Parent.Parent:WaitForChild('Synthetic'))-- Modules

local RobloxTypes = require(script.Parent.Parent:WaitForChild('RobloxTypes'))
local Config = require(script.Parent.Parent:WaitForChild('Config'))-- Hooks
-- Types

type ButtonData = Synthetic.ButtonData
export type ContainerProperties = RobloxTypes.GuiObjectProperties & {
	IsOpen: boolean,
	IsExpanded: boolean,
	ExpandButton: ButtonData?,
	SelectionIndex: number?,
	Buttons: {ButtonData}
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
local e = React.createElement
-- Class
return function(props: ContainerProperties): React.ReactNode
	-- props
	local isOpen = props.IsOpen
	local isExpanded = props.IsExpanded
	local expandButton = props.ExpandButton
	local selectionIndex = props.SelectionIndex
	local buttons = props.Buttons

	-- states

	-- hooks
	local openAlpha = TweenService:GetValue(Synthetic.Hook.useLerp(
		if isOpen then 1 else 0,
		if isOpen then 1 else 0,
		0.1,
		true
	), Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
	local expansionAlpha = TweenService:GetValue(Synthetic.Hook.useLerp(
		if isExpanded then 1 else 0,
		if isExpanded then 1 else 0,
		0.1,
		true
	), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	-- memos
	local expandedWidth: number = React.useMemo(function()

	end, {})
	local unexpandedWidth: number = React.useMemo(function(): number
		if expandButton then
			return CLOSED_WIDTH
		else
			return 0
		end
	end, {expandButton})
	local closedOffsetX: number = React.useMemo(function()

	end, {})
	local anchorX: number = React.useMemo(function(): number
		return closedOffsetX/expandedWidth
	end, {expandedWidth, closedOffsetX})
	return e("Frame", RobloxTypes.mergeGuiObject( {
		BackgroundColor3 = CONTAINER_BACKGROUND_COLOR,
		BackgroundTransparency = 1-((1-CONTAINER_BACKGROUND_TRANSPARENCY)*openAlpha),
		Visible = openAlpha > 0,
		Size = UDim2.fromOffset(expansionAlpha*(expandedWidth-unexpandedWidth)*openAlpha + unexpandedWidth*openAlpha,BUTTON_HEIGHT),
		Position = UDim2.new(0.5,0,0,TOP_BAR_TOP_MARGIN+BUTTON_PADDING),
		AnchorPoint = Vector2.new(0.5,0),
		ClipsDescendants = true,
		children = {
			ButtonList = e("Frame", {
				BackgroundTransparency = 1,
				Size =  UDim2.fromOffset(expandedWidth, BUTTON_HEIGHT),
				Position = UDim2.fromScale(expansionAlpha*(anchorX-0.5)+0.5,0),
				AnchorPoint = Vector2.new(anchorX,0),
				ClipsDescendants = false,
				children = {
					UIListLayout = e("UIListLayout", {
						Padding = UDim.new(0,BUTTON_PADDING),
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Top,
					} :: RobloxTypes.UIListLayoutProperties),
				}
			} :: RobloxTypes.FrameProperties),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(1,0),
			} :: RobloxTypes.UICornerProperties),
		}
	} :: RobloxTypes.GuiObjectProperties, props))
end