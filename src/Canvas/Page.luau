--!strict
-- Services
-- Packages
local CanvasModule = script.Parent
assert(CanvasModule)
local Package = CanvasModule.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages ~= nil)
local Maid = require(Packages:WaitForChild("Maid"))

-- Modules
-- Types
type Maid = Maid.Maid
-- Constants
-- Variables
-- References
-- Class

export type Page = {
	new: (
		path: string,
		constructor: (...any) -> GuiObject,
		isFullScreen: boolean
	) -> Page,
	Path: string,
	_Constructor: (...any) -> GuiObject,
	_IsFullScreen: boolean,
	_BuildMaid: Maid,
	_Maid: Maid,
	Build: (self: Page, canvas: Frame, ...any) -> nil,
	Clear: (self: Page) -> nil,
	__index: Page,
}

-- Constants

-- Page class
local Page: Page = {} :: any
Page.__index = Page

function Page:Clear()
	local success, msg = pcall(function()
		self._Maid:DoCleaning()
	end)
	if not success then
		warn(msg)
	end

	return nil
end

function Page:Build(canvas: Frame, ...)
	local component = self._Constructor(...)
	if component then
		component.Parent = canvas
		self._BuildMaid:GiveTask(component)
	end
	return nil
end

function Page.new(
	path: string, 
	constructor: (...any) -> GuiObject,
	isFullScreen: boolean
)
	assert(path ~= nil, "Bad path")
	assert(constructor ~= nil, "Bad constructor")

	local self: Page = setmetatable({}, Page) :: any
	self.Path = path
	self._Maid = Maid.new()
	self._BuildMaid = self._Maid:GiveTask(Maid.new())
	self._IsFullScreen = if isFullScreen == nil then false else isFullScreen
	self._Constructor = constructor

	return self
end

return Page