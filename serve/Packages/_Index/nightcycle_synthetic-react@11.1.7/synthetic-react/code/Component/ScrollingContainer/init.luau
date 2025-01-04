--!strict
-- Services
-- Packages
local React = require(script.Parent.Parent.Parent:WaitForChild('React'))-- Modules

local RobloxTypes = require(script.Parent.Parent:WaitForChild('RobloxTypes'))
local PropUtil = require(script.Parent.Parent:WaitForChild('PropUtil'))-- Types
-- Constants

local MID_IMAGE = "http://www.roblox.com/asset/?id=16331943650"
local TOP_IMAGE = "http://www.roblox.com/asset/?id=16331984401"
local BOTTOM_IMAGE = "http://www.roblox.com/asset/?id=16331988989"
-- Variables
-- References
-- Private Functions
-- Private Functions
local e = React.createElement
-- Class
return function(props: RobloxTypes.ScrollingFrameProperties): React.ReactNode
	return e(
		"ScrollingFrame",
		PropUtil.mergeScrollingFrame(
			{
				BottomImage = BOTTOM_IMAGE,
				TopImage = TOP_IMAGE,
				MidImage = MID_IMAGE,
				VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
				HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
			} :: RobloxTypes.ScrollingFrameProperties,
			props
		)
	)
end
