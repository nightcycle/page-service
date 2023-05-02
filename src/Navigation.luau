--!strict
-- Services
-- Packages
local Package = script.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages ~= nil)
local Maid = require(Packages:WaitForChild("Maid"))
local Signal = require(Packages:WaitForChild("Signal"))
-- Modules
-- Types
type Maid = Maid.Maid
type Signal = Signal.Signal
-- Constants
-- Variables
-- References
-- Class
-- Types
type Navigation = {
	__index: Navigation,
	_Maid: Maid,
	_IsAlive: boolean,
	Destroy: (self: Navigation) -> nil,
	new: () -> Navigation,
	init: (maid: Maid) -> nil
}

-- Class
local Navigation = {}
Navigation.__index = Navigation

function Navigation:Destroy()
	if not self._IsAlive then return end
	self._IsAlive = false
	self._Maid:Destroy()
	local t: any = self
	for k, v in pairs(t) do
		t[k] = nil
	end
	setmetatable(t, nil)
	return nil
end

function Navigation.new()
	local maid = Maid.new()

	local self: Navigation = setmetatable({}, Navigation) :: any
	self._IsAlive = true
	self._Maid = maid

	return self
end

function Navigation.init(maid: Maid)
	return nil
end

return Navigation