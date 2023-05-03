--!strict
-- Services
-- Packages
local Package = script
local Packages = Package.Parent
assert(Packages ~= nil)
local Maid = require(Packages:WaitForChild("Maid"))
local Signal = require(Packages:WaitForChild("Signal"))
local ColdFusion = require(Packages:WaitForChild("ColdFusion"))
local ServiceProxy = require(Packages:WaitForChild("ServiceProxy"))
local GuiLibrary = require(Packages:WaitForChild("GuiLibrary"))

-- Modules
local Prompt = require(script:WaitForChild("Prompt"))
local Notification = require(script:WaitForChild("Notification"))
local Menu = require(script:WaitForChild("Menu"))

-- Types
type Maid = Maid.Maid
type Signal = Signal.Signal
type Fuse = ColdFusion.Fuse
type ValueState<T> = ColdFusion.ValueState<T>
type State<T> = ColdFusion.State<T>
type ParameterValue<T> = (State<T> | T)
type PromptFrame = Prompt.PromptFrame
type NotificationFrame = Notification.NotificationFrame
type Menu = Menu.Menu

type Step = {
	Path: string,
	Parameters: { [number]: any },
}

export type PageService = {
	__index: PageService,
	_IsAlive: boolean,
	_Maid: Maid,
	Prompt: PromptFrame,
	Notification: NotificationFrame,
	Menu: Menu,
	Instance: ScreenGui,
	Destroy: (self: PageService) -> nil,
	new: (parent: GuiObject?) -> PageService,
	init: (maid: Maid) -> nil,
}

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

	local _fuse = ColdFusion.fuse(self._Maid)
	local _library = GuiLibrary.new(self._Maid)
	
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import
	
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	self.Instance = _new("ScreenGui")({
		Name = "PageService",
	}) :: ScreenGui

	self.Prompt = self._Maid:GiveTask(Prompt.new())
	self.Prompt.Instance.Parent = self.Instance

	self.Notification = self._Maid:GiveTask(Notification.new())
	self.Notification.Instance.Parent = self.Instance

	self.Menu = self._Maid:GiveTask(Menu.new())
	self.Menu.Instance.Parent = self.Instance

	if currentService then
		currentService:Destroy()
		currentService = nil :: any
	end
	currentService = self

	return self
end

function Service.init(maid: Maid)
	if currentService == nil then
		GuiLibrary.init(maid)
		maid:GiveTask(Service.new())
	end
	return nil
end

return ServiceProxy(function()
	return currentService or Service
end)
