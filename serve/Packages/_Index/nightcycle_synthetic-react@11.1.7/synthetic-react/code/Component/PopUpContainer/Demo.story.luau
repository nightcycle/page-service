--!strict
--!native
-- Services
-- @Packages
local React = require(script.Parent.Parent.Parent.Parent:WaitForChild('React'))
local ReactRoblox = require(script.Parent.Parent.Parent.Parent:WaitForChild('ReactRoblox'))-- Modules

local RobloxTypes = require(script.Parent.Parent.Parent:WaitForChild('RobloxTypes'))-- Types
-- Constants
-- Variables
-- References
-- Private Functions

local e = React.createElement
-- Class
return function(target: Frame)
	local folder = Instance.new("Folder")
	local root = ReactRoblox.createRoot(folder)

	local PopUpContainer = require(script.Parent)
	
local function newPopUp()
		local Style = require(script.Parent.Parent.Parent:WaitForChild('Style'))		
local Theme = require(script.Parent.Parent.Parent:WaitForChild('Theme'))		
local Typography = require(script.Parent.Parent.Parent:WaitForChild('Typography'))		
local style = Style.new(
			2,
			0.5,
			true,
			Theme.new(Color3.new(1, 0, 0), "Dark", 0),
			Typography.fromFont(Enum.Font.BuilderSans)
		)
		-- Style.new(
		-- 	1,
		-- 	Enum.Font.SourceSans,
		-- 	if props.IsDarkMode then Enums.SchemeType.Dark else Enums.SchemeType.Light,
		-- 	props.Color3
		-- )

		local absolutePosition, setAbsolutePosition = React.useState(Vector2.new(0, 0))
		local absoluteSize, setAbsoluteSize = React.useState(Vector2.new(0, 0))
		local popUpPosition = absolutePosition + absoluteSize * Vector2.new(0, 1)

		return ReactRoblox.createPortal(
			e(
				"TextButton",
				{
					Text = "Test",
					Size = UDim2.new(0, 200, 0, 40),
					Position = UDim2.fromScale(0.4, 0.8),
					BackgroundTransparency = 0.5,

					BackgroundColor3 = style.Theme.PrimaryContainer,
					TextColor3 = style.Theme.OnPrimaryContainer,
					[React.Change.AbsolutePosition] = function(inst: TextButton)
						setAbsolutePosition(inst.AbsolutePosition)
					end :: any,
					[React.Change.AbsoluteSize] = function(inst: TextButton)
						setAbsoluteSize(inst.AbsoluteSize)
					end :: any,
				} :: RobloxTypes.TextButtonProperties,
				{
					PopUpContainer = e(
						PopUpContainer,
						{
							TargetAbsolutePosition = popUpPosition,
							TargetAbsoluteWidth = absoluteSize.X,
							SurfaceColor3 = style.Theme.SurfaceContainerHigh,
							DisplayComponent = function(): React.ReactNode
								return e(
									"TextButton",
									{
										Text = "Container Content",
										Size = UDim2.new(0, 200, 0, 200),
										Position = UDim2.fromScale(0.4, 0.5),
										BackgroundTransparency = 1,
										TextColor3 = style.Theme.OnSurface,
									} :: RobloxTypes.TextButtonProperties
								)
							end,
						} :: PopUpContainer.PopUpContainerProperties
					),
				}
			),
			target
		)
	end

	root:render(e(newPopUp, {}))

	return function()
		root:unmount()
		folder:Destroy()
	end
end
