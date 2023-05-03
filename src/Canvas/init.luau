--!strict
-- Services
-- Packages
local Package = script.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages ~= nil)
local Maid = require(Packages:WaitForChild("Maid"))
local Signal = require(Packages:WaitForChild("Signal"))
local ColdFusion = require(Packages:WaitForChild("ColdFusion"))
local GuiLibrary = require(Packages:WaitForChild("GuiLibrary"))

-- Modules
local Page = require(script:WaitForChild("Page"))

-- Types
type Maid = Maid.Maid
type Signal = Signal.Signal
type Page = Page.Page
-- Constants
-- Variables
-- References
-- Class
-- Types
type Canvas = {
	__index: Canvas,
	_Maid: Maid,
	_IsAlive: boolean,
	_Pages: {[string]: Page},
	Instance: Frame,
	Destroy: (self: Canvas) -> nil,
	new: () -> Canvas,
	init: (maid: Maid) -> nil
}

-- Class
local Canvas = {}
Canvas.__index = Canvas

function Canvas:Destroy()
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

function Canvas.new()
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	local _library = GuiLibrary.new(maid)
	
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import
	
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local self: Canvas = setmetatable({}, Canvas) :: any
	self._IsAlive = true
	self._Maid = maid
	self.Instance = _new("Frame")({
		Name = "Canvas",
	}) :: Frame

	return self
end

function Canvas.init(maid: Maid)
	return nil
end

return Canvas