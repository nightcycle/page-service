--!strict
-- Services
local TweenService = game:GetService("TweenService")
-- Packages
local React = require(script.Parent.Parent.Parent:WaitForChild('React'))
local Synthetic = require(script.Parent.Parent.Parent:WaitForChild('Synthetic'))-- Modules

local RobloxTypes = require(script.Parent.Parent:WaitForChild('RobloxTypes'))
local Config = require(script.Parent.Parent:WaitForChild('Config'))-- Components

local Container = require(script.Parent:WaitForChild('Container'))-- Hooks

local useViewportSize = require(script.Parent.Parent:WaitForChild('Hooks'):WaitForChild('useViewportSize'))
local useCoreGuiEnabled = require(script.Parent.Parent:WaitForChild('Hooks'):WaitForChild('useCoreGuiEnabled'))-- Types

type ButtonData = Synthetic.ButtonData
export type ContainerDisplayProperties = RobloxTypes.FrameProperties & {
	IsExpanded: boolean,
	Position: UDim2,
	Size: UDim2
}
export type ContainerData = {
	IsEnabled: boolean,
	IsExpanded: boolean,
	ExpansionButton: ButtonData?,
	SelectionIndex: number?,
	Buttons: {ButtonData},
	DisplayConstructor: ((props: ContainerDisplayProperties) -> (React.ReactNode?))?
}
export type TopBarProperties = RobloxTypes.ScreenGuiProperties & {
	AlignUsingMinimumFootprint: boolean,
	IsOpen: boolean,
	Containers: {ContainerData}
}
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
-- Private Functions
local e = React.createElement
-- Class
return function(props: TopBarProperties): React.ReactNode
	-- props
	local alignUsingMinimumFootprint = props.AlignUsingMinimumFootprint
	local isOpen = props.IsOpen

	-- states
	local absoluteWidth, setAbsoluteWidth = React.useState(0)

	-- hooks
	local isOpenAlpha = TweenService:GetValue(Synthetic.Hook.useLerp(
		if isOpen then 1 else 0,
		if isOpen then 1 else 0,
		0.1,
		true
	), Enum.EasingStyle.Cubic, Enum.EasingDirection.In)
	local viewportSize = useViewportSize()
	local coreGuiEnabled = useCoreGuiEnabled()

	-- memos
	local baseRightOffset = React.useMemo(function(): number
		return TOP_BAR_MARGIN + TOP_BUTTON_BORDER + TOP_BUTTON_PADDING * 0.5
	end, {TOP_BAR_HEIGHT, TOP_BUTTON_BORDER, TOP_BUTTON_PADDING})
	local leftOffset = React.useMemo(function(): number
		return baseRightOffset + TOP_BUTTON_PADDING + TOP_BUTTON_HEIGHT
	end, {baseRightOffset, TOP_BUTTON_PADDING, TOP_BUTTON_HEIGHT})
	local rightOffset = React.useMemo(function(): number
		if alignUsingMinimumFootprint then
			 local offset = UNIBAR_CELL_WIDTH * 3
			 offset += UNIBAR_DIVIDER_WIDTH + TOP_BUTTON_PADDING * 2
			 if coreGuiEnabled[Enum.CoreGuiType.Backpack] then
				offset += UNIBAR_CELL_WIDTH
			end
			if coreGuiEnabled[Enum.CoreGuiType.Chat] then
				offset += UNIBAR_CELL_WIDTH
			end
			if coreGuiEnabled[Enum.CoreGuiType.EmotesMenu] then
				offset += UNIBAR_CELL_WIDTH
			end
			if coreGuiEnabled[Enum.CoreGuiType.Health] then
				offset += HEALTH_BAR_WIDTH + PADDING
			end
			if coreGuiEnabled[Enum.CoreGuiType.PlayerList] then
				offset += UNIBAR_CELL_WIDTH
			end
			 return offset
		else
			return leftOffset
		end
	end, {alignUsingMinimumFootprint :: any, coreGuiEnabled, baseRightOffset, UNIBAR_CELL_WIDTH, UNIBAR_DIVIDER_WIDTH, TOP_BUTTON_PADDING})

	local leftMargin = React.useMemo(function()
		return leftOffset + PADDING
	end, {leftOffset, PADDING})
	local rightMargin = React.useMemo(function()
		return rightOffset + PADDING
	end, {rightOffset, PADDING})

	return e("ScreenGui", RobloxTypes.mergeScreenGui( {
		IgnoreGuiInset = props.IgnoreGuiInset or true,
		ClipToDeviceSafeArea = props.ClipToDeviceSafeArea or true,
		DisplayOrder = props.DisplayOrder or 10,
		ResetOnSpawn = if typeof(props.ResetOnSpawn) == "nil" then false else props.ResetOnSpawn,
		children = {
			TopBarFrame = e("Frame", {
				BackgroundTransparency = 1,
				Position = if (0.5*viewportSize.X-math.max(rightMargin, leftMargin)) > absoluteWidth *0.5 then
						UDim2.new(0.5, 0, 0, TOP_BAR_MARGIN)
					elseif leftMargin > rightMargin then
						UDim2.new(0, leftMargin + absoluteWidth * 0.5, 0, TOP_BAR_MARGIN)
					else
						UDim2.new(1, -rightMargin - absoluteWidth * 0.5, 0, TOP_BAR_MARGIN)
					,
				AnchorPoint = Vector2.new(0.5,0),
				Size = if isOpen then UDim2.fromOffset(absoluteWidth*isOpenAlpha, TOP_BAR_HEIGHT)
					else UDim2.fromOffset(0, TOP_BAR_HEIGHT),
				children = {
					ContainerFrame = if isOpenAlpha <= 0 then nil else e("Frame", {
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.X,
						Position = UDim2.fromScale(1,0.5),
						AnchorPoint = Vector2.new(1,0.5),
						Size = UDim2.fromScale(0,1),
						[React.Change.AbsoluteSize] = function(inst: Frame)
							if inst.AbsoluteSize.X ~= absoluteWidth then
								setAbsoluteWidth(inst.AbsoluteSize.X)
							end
						end :: any,
						children = {
							UIPadding = e("UIPadding", {
								PaddingLeft = UDim.new(0, TOP_BUTTON_PADDING),
								PaddingRight = UDim.new(0, TOP_BUTTON_PADDING),
							} :: RobloxTypes.UIPaddingProperties),
							UIListLayout = e("UIListLayout", {
								FillDirection = Enum.FillDirection.Horizontal,
								HorizontalAlignment = Enum.HorizontalAlignment.Center,
								SortOrder = Enum.SortOrder.LayoutOrder,
								VerticalAlignment = Enum.VerticalAlignment.Top,
								Padding = UDim.new(0, PADDING),
							} :: RobloxTypes.UIListLayoutProperties),
						}
					} :: RobloxTypes.FrameProperties),
				},
			} :: RobloxTypes.FrameProperties),
		}
	} :: RobloxTypes.ScreenGuiProperties, props))
end