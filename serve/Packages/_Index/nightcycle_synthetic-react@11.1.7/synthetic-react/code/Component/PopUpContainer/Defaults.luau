--!strict

-- Modules
local Enums = require(script.Parent.Parent.Parent:WaitForChild('Enums'))
-- Types

return {
	Elevation = 0,
	SchemeType = Enums.SchemeType.Light,
	Scale = 1,
	SurfaceColor3 = Color3.new(1, 1, 1),
	DropShadowColor3 = Color3.new(0, 0, 0),
	DropShadowTransparency = 0.1,
}
