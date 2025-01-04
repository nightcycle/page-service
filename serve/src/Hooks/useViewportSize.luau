--!strict
-- Services
-- Packages
local React = require(script.Parent.Parent.Parent:WaitForChild('React'))-- Modules
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
-- Class

return function(): Vector2
	local viewportSize, setViewportSize = React.useState(workspace.CurrentCamera.ViewportSize)

	React.useEffect(function()
		local connection = workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			setViewportSize(workspace.CurrentCamera.ViewportSize)
		end)
		return function()
			connection:Disconnect()
		end
	end, { workspace.CurrentCamera })

	return viewportSize
end