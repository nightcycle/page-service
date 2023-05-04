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
local TableUtil = require(Packages:WaitForChild("TableUtil"))

-- Modules
local Page = require(script:WaitForChild("Page"))

-- Types
type Maid = Maid.Maid
type Signal = Signal.Signal
export type Page = Page.Page
type Fuse = ColdFusion.Fuse
type ValueState<T> = ColdFusion.ValueState<T>
type State<T> = ColdFusion.State<T>
-- Constants
-- Variables
-- References
-- Class
-- Types
export type Constructor = Page.Constructor
export type Canvas = {
	__index: Canvas,
	_Maid: Maid,
	_IsAlive: boolean,
	_Pages: {[string]: Page},
	CurrentPage: ValueState<Page?>,
	Instance: Frame,
	RegisterPage: (
		self: Canvas,
		path: string,
		constructor: Constructor,
		isFullScreen: boolean
	) -> nil,
	Open: (self: Canvas, path: string, ...any) -> nil,
	Destroy: (self: Canvas) -> nil,
	new: () -> Canvas,
	init: (maid: Maid) -> nil
}

-- Class
local Canvas: Canvas = {} :: any
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

function Canvas:RegisterPage(
	path: string,
	constructor: Constructor,
	isFullScreen: boolean
): nil
	local priority = 10000 - #TableUtil.keys(self._Pages)
	if not isFullScreen then
		priority -= 1000
	end
	assert(priority > 0, "somehow you've made thousands of pages")
	self._Pages[path] = self._Maid:GiveTask(Page.new(path, constructor, isFullScreen, priority))
	return nil
end

function Canvas:Open(path: string?, ...:any)
	if not path then
		path = "home"
	end
	assert(path)

	local page: Page? = self._Pages[path] :: any
	local currentPage = self.CurrentPage:Get()
	if currentPage then
		currentPage:Clear()
	end	
	if not page then
		warn("path doesn't exist: "..tostring(path))
		self.CurrentPage:Set(nil)
	else
		assert(page ~= nil)
		self.CurrentPage:Set(page :: Page)
		page:Build(self.Instance, ...)
	end
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
	self.CurrentPage = _Value(nil :: Page?)
	self._IsAlive = true
	self._Maid = maid
	self._Pages = {}
	self.Instance = _new("Frame")({
		Size = UDim2.fromScale(1,1),
		Position = UDim2.fromScale(0.5,0.5),
		AnchorPoint = Vector2.new(0.5,0.5),
		BackgroundTransparency = 1,
		ZIndex = 5,
		Name = "Canvas",
	}) :: Frame

	return self
end

function Canvas.init(maid: Maid)
	return nil
end

return Canvas