--!strict
-- Services
local RunService = game:GetService("RunService")
-- Packages
local React = require("@wally/React")
--Modules
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
return function(isActive: boolean): number
	-- state
	local onStart: number?, setOnStart = React.useState(nil :: number?)
	local onTime, setOnTime = React.useState(0)

	if isActive and not onStart then
		setOnStart(tick())
	elseif not isActive and onStart then
		setOnStart(nil)
	end

	React.useEffect(function()
		if onStart then
			local connection = RunService.RenderStepped:Connect(function()
				setOnTime(tick() - onStart)
			end)
			return function()
				connection:Disconnect()
			end
		else
			if onTime ~= 0 then
				setOnTime(0)
			end
			return function() end
		end
	end, { onStart })

	return onTime
end