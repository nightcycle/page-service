--!strict
local _Package = script
local _Packages = _Package.Parent
-- Services
-- Packages

local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
local ServiceProxy = require(_Packages:WaitForChild("ServiceProxy"))

-- Modules
local TopBar = require(_Package:WaitForChild("TopBar"))


-- Types
type Maid = Maid.Maid
type Fuse = ColdFusion.Fuse
type ValueState<T> = ColdFusion.ValueState<T>
type State<T> = ColdFusion.State<T>
type ParameterValue<T> = (State<T> | T)
type TopBar = TopBar.TopBar
export type PageService = {
	__index: PageService,
	_IsAlive: boolean,
	_Maid: Maid,
	TopBar: TopBar,
	Destroy: (self: PageService) -> nil,
	new: (parent: GuiObject?) -> PageService,
	init: (maid: Maid) -> nil,
}

-- Constants
-- Class
local Service: PageService = {} :: any
Service.__index = Service

local currentService: PageService

function Service:Destroy(): nil
	if not self._IsAlive then
		return
	end
	if currentService == self then
		currentService = nil :: any
	end
	self._IsAlive = false
	self._Maid:Destroy()
	local t: any = self
	for k, v in pairs(t) do
		t[k] = nil
	end
	setmetatable(t, nil)
	return nil
end

function Service.new(): PageService
	local self: PageService = setmetatable({}, Service) :: any
	self._IsAlive = true
	self._Maid = Maid.new()

	-- sub classes
	self.TopBar = self._Maid:GiveTask(TopBar.new())


	-- fusion workspace
	local _fuse = ColdFusion.fuse(self._Maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import
	
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	if currentService then
		currentService:Destroy()
		currentService = nil :: any
	end
	currentService = self

	return self
end

function Service.init(maid: Maid)
	if currentService == nil then
		maid:GiveTask(Service.new())
	end
	return nil
end

return ServiceProxy(function()
	return currentService or Service
end)
