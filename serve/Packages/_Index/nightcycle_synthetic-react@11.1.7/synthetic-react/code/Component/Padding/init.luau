--!strict
-- Services
-- Packages
local React = require(script.Parent.Parent.Parent:WaitForChild('React'))-- Modules

local RobloxTypes = require(script.Parent.Parent:WaitForChild('RobloxTypes'))
local Types = require(script.Parent.Parent:WaitForChild('Types'))
local Style = require(script.Parent.Parent:WaitForChild('Style'))-- Types

type ImageData = Types.ImageData
type Style = Style.Style
export type StylePaddingProperties = {
	LeftRightDp: number,
	TopBottomDp: number,
	Style: Style
}
export type StylePaddingSimpleProperties = {
	PaddingDp: number,
	Style: Style
}
-- Constants
-- Variables
-- References
-- Private Functions
local e = React.createElement
-- Class
local Util = {}

function Util.Style(props: StylePaddingProperties): React.ReactNode
	local leftRight = UDim.new(0, math.round(props.LeftRightDp * props.Style.Scale))
	local topBottom = UDim.new(0, math.round(props.TopBottomDp * props.Style.Scale))

	return e(
		"UIPadding",
		{
			PaddingTop = topBottom,
			PaddingBottom = topBottom,
			PaddingLeft = leftRight,
			PaddingRight = leftRight,
		} :: RobloxTypes.UIPaddingProperties
	)
end

function Util.StyleSimple(props: StylePaddingSimpleProperties): React.ReactNode
	local padding = UDim.new(0, math.round(props.PaddingDp * props.Style.Scale))

	return e(
		"UIPadding",
		{
			PaddingTop = padding,
			PaddingBottom = padding,
			PaddingLeft = padding,
			PaddingRight = padding,
		} :: RobloxTypes.UIPaddingProperties
	)
end

return Util
