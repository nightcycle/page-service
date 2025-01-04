--!strict
--!native
-- Services
-- @Packages
local React = require(script.Parent.Parent.Parent.Parent:WaitForChild('React'))
local ReactRoblox = require(script.Parent.Parent.Parent.Parent:WaitForChild('ReactRoblox'))-- Modules

local RobloxTypes = require(script.Parent.Parent.Parent:WaitForChild('RobloxTypes'))
local Enums = require(script.Parent.Parent.Parent:WaitForChild('Enums'))
-- Types
-- Constants
-- Variables
-- References
-- Private Functions

local e = React.createElement
-- Class
return function(target: Frame)
	local folder = Instance.new("Folder")
	local root = ReactRoblox.createRoot(folder)

	local ButtonContainer = require(script.Parent)	
local TextDisplay = require(script.Parent.Parent:WaitForChild('TextDisplay'))	
local UIPadding = require(script.Parent.Parent:WaitForChild('Padding'))	
local Style = require(script.Parent.Parent.Parent:WaitForChild('Style'))	
local Theme = require(script.Parent.Parent.Parent:WaitForChild('Theme'))	
local Typography = require(script.Parent.Parent.Parent:WaitForChild('Typography'))	
local style = Style.new(
		1,
		0.5,
		true,
		Theme.new(Color3.new(1, 0, 0), "Dark", 0),
		Typography.fromFont(Enum.Font.BuilderSans)
	)
	local function newButton(renderType: Enums.ButtonRenderType): React.ReactNode
		local lineColorRole = if renderType == Enums.ButtonRenderType.Filled
			then Enums.ColorRoleType.OnPrimary
			else Enums.ColorRoleType.OnSurface
		return e(
			ButtonContainer,
			{
				AutomaticSize = Enum.AutomaticSize.XY,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				TargetPaddingDp = 12,
				Type = renderType,
				Content = function(
					props: ButtonContainer.ButtonContainerContentProperties
				): React.ReactNode
					return e(
						TextDisplay.StyleSimple,
						{
							AutomaticSize = Enum.AutomaticSize.XY,
							Text = renderType,
							ColorRoleType = lineColorRole,
							Color = props.Color3,
							TextTransparency = props.Transparency,
							FontType = Enums.FontType.LabelLarge,
							Style = style,
						} :: TextDisplay.StyleTextDisplayProperties
					)
				end,
				FillColor3 = style.Theme.Primary,
				LineColor3 = style.Theme[lineColorRole],
				RippleDuration = 0.5,
				BorderSizePixel = 0,
				IsAnimated = true,
				[React.Event.Activated] = function()
					print(`click "{renderType}"`)
				end :: any,
				children = {
					UICorners = e(
						"UICorner",
						{
							CornerRadius = UDim.new(0.5, 0),
						} :: RobloxTypes.UICornerProperties
					),
					UIPadding = e(
						UIPadding.StyleSimple,
						{
							Style = style,
							PaddingDp = 6,
						} :: UIPadding.StylePaddingSimpleProperties
					),
				},
			} :: ButtonContainer.ButtonContainerProperties
		)
	end

	local element = e("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
		BackgroundColor3 = style.Theme.Surface,
	}, {

		FilledButton = newButton(Enums.ButtonRenderType.Filled),
		OutlinedButton = newButton(Enums.ButtonRenderType.Outlined),
		TextButton = newButton(Enums.ButtonRenderType.TextIcon),
		UIListLayout = e(
			"UIListLayout",
			{
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				Padding = UDim.new(0, math.round(5 * style.Scale)),
			} :: RobloxTypes.UIListLayoutProperties
		),
	})

	local portal = ReactRoblox.createPortal(element, target)
	root:render(portal)

	return function()
		root:unmount()
		folder:Destroy()
	end
end
