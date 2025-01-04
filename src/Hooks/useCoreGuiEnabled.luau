--!strict
-- Services
local StarterGui = game:GetService("StarterGui")
local RunService = game:GetService("RunService")
-- Packages
local React = require("@wally/React")
-- Modules
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
function getCoreGuiEnabled(): {[Enum.CoreGuiType]: boolean}
	local output = {}
	for _, coreGuiType in ipairs(Enum.CoreGuiType:GetEnumItems()) do
		output[coreGuiType] = StarterGui:GetCoreGuiEnabled(coreGuiType)
	end
	table.freeze(output)
	return output
end
-- Class
return function(): {[Enum.CoreGuiType]: boolean}
	local coreEnabled, setCoreEnabled = React.useState(getCoreGuiEnabled())

	React.useEffect(function()
		local connection = RunService.RenderStepped:Connect(function()
			local newCoreEnabled = getCoreGuiEnabled()
			for k, v in pairs(newCoreEnabled) do
				if coreEnabled[k] ~= v then
					setCoreEnabled(newCoreEnabled)
					break
				end
			end
		end)
		return function()
			connection:Disconnect()
		end
	end, {})

	return coreEnabled
end