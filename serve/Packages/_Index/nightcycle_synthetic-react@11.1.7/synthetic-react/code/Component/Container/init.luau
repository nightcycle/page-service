--!strict
-- Services
-- Packages
local React = require(script.Parent.Parent.Parent:WaitForChild('React'))-- Modules

local RobloxTypes = require(script.Parent.Parent:WaitForChild('RobloxTypes'))
local PropUtil = require(script.Parent.Parent:WaitForChild('PropUtil'))-- Types
-- Constants
-- Variables
-- References
-- Private Functions

local e = React.createElement
-- Class
return function(props: RobloxTypes.GuiObjectProperties): React.ReactNode
	local newProps = PropUtil.mergeGuiObject({
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromScale(0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, props)
	if props.BackgroundTransparency then
		newProps.BackgroundTransparency = props.BackgroundTransparency
	end
	if props.BorderSizePixel then
		newProps.BorderSizePixel = props.BorderSizePixel
	end
	if props.Size then
		newProps.Size = props.Size
	end
	if props.AutomaticSize then
		newProps.AutomaticSize = props.AutomaticSize
	end
	return e("Frame", newProps)
end
