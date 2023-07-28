--!strict
-- Services
-- Packages
local CanvasModule = script.Parent
local Package = CanvasModule.Parent
local Packages = Package.Parent
local Maid = require(Packages:WaitForChild("Maid"))
local ColdFusion = require(Packages:WaitForChild("ColdFusion"))
local GuiLibrary = require(Packages:WaitForChild("GuiLibrary"))
local StyleGuide = GuiLibrary.getStyleGuide()

-- Modules
-- Types
type Maid = Maid.Maid
-- Constants
-- Variables
-- References
-- Class
export type Constructor = ((...any) -> GuiObject?)
export type Page = {
	new: (
		path: string,
		constructor: Constructor,
		isFullScreen: boolean,
		priority: number
	) -> Page,
	Path: string,
	_IsAlive: boolean,
	_Constructor: Constructor,
	_IsFullScreen: boolean,
	_BuildMaid: Maid,
	_Maid: Maid,
	_Priority: number,
	Build: (self: Page, canvas: Frame, ...any) -> nil,
	Clear: (self: Page) -> nil,
	Destroy: (self: Page) -> nil,
	__index: Page,
}

-- Constants
local TRANSITION_DURATION = 0.5
local TOP_BAR_HEIGHT = 32

-- Page class
local Page: Page = {} :: any
Page.__index = Page

function Page:Destroy()
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

function Page:Clear()
	local success, msg = pcall(function()
		self._BuildMaid:DoCleaning()
	end)
	if not success then
		warn(msg)
	end

	return nil
end

function Page:Build(canvas: Frame, ...)

	local component = self._Constructor(...)
	if component then

		local maid = self._Maid:GiveTask(Maid.new())
		maid:GiveTask(component)

		local _fuse = ColdFusion.fuse(maid)
		local _library = GuiLibrary.new(maid)
		
		local _new = _fuse.new
		local _bind = _fuse.bind
		local _clone = _fuse.clone
		local _import = _fuse.import
		
		local _Value = _fuse.Value
		local _Computed = _fuse.Computed
		
		local IsOpen = _Value(false)

		_new("Frame")({
			Name = "TopBar",
			Parent = canvas,
			Position = UDim2.new(0.5,0, -TOP_BAR_HEIGHT, 0),
			AnchorPoint = Vector2.new(0.5,0),
			Size = _Computed(function(isOpen: boolean)
				if isOpen then
					return UDim2.new(1, 0, 0, TOP_BAR_HEIGHT)
				else
					return UDim2.new(1, 0, 0, 0)
				end
			end, IsOpen):Tween(TRANSITION_DURATION),
			BackgroundColor3 = StyleGuide:GetColor("Surface1"),
		})

		_new("Frame")({
			Name = self.Path,
			Parent = canvas,
			ClipsDescendants = true,
			Position = UDim2.fromScale(0.5,0.5),
			AnchorPoint = Vector2.new(0.5,0.5),
			Size = _Computed(function(isOpen: boolean)
				if isOpen then
					return UDim2.fromScale(1,1)
				else
					return UDim2.fromScale(0,0)
				end
			end, IsOpen):Tween(TRANSITION_DURATION),
			BackgroundTransparency = 1,
			Children = {
				_bind(component)({
					Position = UDim2.fromScale(0.5,0.5),
					AnchorPoint = Vector2.new(0.5,0.5),
				}),
			}
		})

		IsOpen:Set(true)

		self._BuildMaid:GiveTask(function()	
			IsOpen:Set(false)
			task.wait(TRANSITION_DURATION)
			maid:Destroy()
		end)
	end


	return nil
end

function Page.new(
	path: string, 
	constructor: Constructor,
	isFullScreen: boolean,
	priority: number
)
	assert(path ~= nil, "Bad path")
	assert(constructor ~= nil, "Bad constructor")

	local self: Page = setmetatable({}, Page) :: any
	self.Path = path
	self._IsAlive = true
	self._Priority = priority
	self._Maid = Maid.new()
	self._BuildMaid = self._Maid:GiveTask(Maid.new())
	self._IsFullScreen = if isFullScreen == nil then false else isFullScreen
	self._Constructor = constructor

	return self
end

return Page