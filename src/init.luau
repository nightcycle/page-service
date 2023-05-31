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
local TableUtil = require(Packages:WaitForChild("TableUtil"))

-- Modules
local Prompt = require(script:WaitForChild("Prompt"))
local Notification = require(script:WaitForChild("Notification"))
local Menu = require(script:WaitForChild("Menu"))
local Canvas = require(script:WaitForChild("Canvas"))
local Settings = require(script:WaitForChild("Settings"))

-- Types
type Maid = Maid.Maid
type Signal = Signal.Signal
type Fuse = ColdFusion.Fuse
type ValueState<T> = ColdFusion.ValueState<T>
type State<T> = ColdFusion.State<T>
type ParameterValue<T> = (State<T> | T)
export type Page = Canvas.Page
export type PageConstructor = Canvas.Constructor
export type PromptFrame = Prompt.PromptFrame
export type NotificationFrame = Notification.NotificationFrame
export type Menu = Menu.Menu
export type Canvas = Canvas.Canvas
export type SettingsConstructor = Settings.SettingsConstructor
export type StyleGuide = GuiLibrary.StyleGuide
export type ButtonData = Menu.ButtonData
export type SettingsRowData = Settings.RowData
export type PageService = {
	__index: PageService,
	_IsAlive: boolean,
	_Maid: Maid,
	Prompt: PromptFrame,
	Notification: NotificationFrame,
	Menu: Menu,
	Canvas: Canvas,
	Settings: SettingsConstructor,
	Instance: ScreenGui,
	VersionText: ValueState<string>,
	SetStyleGuide: (self: PageService, styleGuide: StyleGuide) -> nil,
	GetStyleGuide: (self: PageService) -> StyleGuide,
	RegisterPage: (
		self: PageService,
		path: string,
		icon: string,
		hint: string,
		constructor: PageConstructor,
		isFullScreen: boolean?,
		layoutOrder: number?
	) -> nil,
	Destroy: (self: PageService) -> nil,
	new: (parent: GuiObject?) -> PageService,
	init: (maid: Maid) -> nil,
}

-- Constants
local HOME_PATH = "home"

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

function Service:SetStyleGuide(styleGuide: StyleGuide): nil
	GuiLibrary.setStyleGuide(styleGuide)
	return nil
end

function Service:GetStyleGuide(): StyleGuide
	return GuiLibrary.getStyleGuide()
end

function Service:RegisterPage(
	path: string,
	icon: string,
	hint: string,
	constructor: PageConstructor,
	isFullScreen: boolean?,
	layoutOrder: number?
): nil
	if isFullScreen == nil then
		isFullScreen = true
	end
	assert(isFullScreen ~= nil)

	if layoutOrder == nil then
		layoutOrder = #TableUtil.keys(self.Canvas._Pages) + 1
	end
	assert(layoutOrder ~= nil)

	local _fuse = ColdFusion.fuse(self._Maid)
	local _library = GuiLibrary.new(self._Maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local onClick = self._Maid:GiveTask(Signal.new())
	local IsSelected = _Computed(function(page: Page?)
		if page then
			return page.Path == path
		else
			return false
		end
	end, self.Canvas.CurrentPage)

	self.Menu:SetButton({
		Path = path,
		Icon = icon,
		Hint = hint,
		LayoutOrder = layoutOrder,
		OnClick = onClick,
		IsSelected = IsSelected,
	} :: ButtonData)

	self.Canvas:RegisterPage(path, constructor, isFullScreen)
	self._Maid:GiveTask(onClick:Connect(function()
		if IsSelected:Get() then
			self.Canvas:Open(HOME_PATH)
		else
			self.Canvas:Open(path)
		end
	end))
	return nil
end

function Service.new(): PageService
	local self: PageService = setmetatable({}, Service) :: any
	self._IsAlive = true
	self._Maid = Maid.new()

	-- sub classes
	self.Prompt = self._Maid:GiveTask(Prompt.new())
	self.Notification = self._Maid:GiveTask(Notification.new())
	self.Settings = self._Maid:GiveTask(Settings.new())
	self.Canvas = self._Maid:GiveTask(Canvas.new())
	self.Menu = self._Maid:GiveTask(Menu.new())

	-- fusion workspace
	local _fuse = ColdFusion.fuse(self._Maid)
	local _library = GuiLibrary.new(self._Maid)

	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import
	
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	self.VersionText = _Value("")
	self.Instance = _new("ScreenGui")({
		Name = "PageService",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		Children = {
			self.Prompt.Instance,
			self.Notification.Instance,
			self.Menu.Instance,
			self.Canvas.Instance,
			_bind(_library.Media:GetTextLabel(
				self.VersionText,
				"Caption",
				"Surface1",
				1,
				"Title"
			))({
				ZIndex = 1000,
				Position = UDim2.fromScale(1,1),
				AnchorPoint = Vector2.new(1,1),
			}) :: Frame,
		},
	}) :: ScreenGui

	if currentService then
		currentService:Destroy()
		currentService = nil :: any
	end
	currentService = self

	self:RegisterPage(
		HOME_PATH,
		"home",
		"home",
		function() return nil end
	)

	self:RegisterPage(
		"settings",
		"settings",
		"game settings",
		function() return self.Settings:Build() end
	)

	self.Canvas:Open(HOME_PATH)

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
