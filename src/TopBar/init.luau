--!strict
-- https://github.com/MaximumADHD/Roblox-Client-Tracker/blob/roblox/scripts/CoreScripts/Modules/TopBar/init.lua
local _Package = script.Parent
local _Packages = _Package.Parent

-- Services
local Players = game:GetService("Players")

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
local Config = require(script:WaitForChild("Config"))
local Container = require(script:WaitForChild("Container"))

-- Types
-- Constants
local TOP_BAR_HEIGHT = Config.HEIGHT
local TOP_BAR_MARGIN = Config.MARGIN.TOP
local TOP_BUTTON_PADDING = Config.BUTTON.PADDING

local PADDING = Config.PADDING

-- Variables
-- References
local Player = Players.LocalPlayer

-- Private Functions
-- Types
type Maid = Maid.Maid
type ValueState<T> = ColdFusion.ValueState<T>
type State<T> = ColdFusion.State<T>
export type TopBarContainer = Container.TopBarContainer
export type TopBar = {
	__index: TopBar,
	_Maid: Maid,
	_IsAlive: boolean,
	_Frame: Frame,
	_Containers: {[number]: TopBarContainer},
	CreateContainer: (self: TopBar) -> TopBarContainer,
	GetContainers: (self: TopBar) -> {[number]: TopBarContainer},
	Instance: ScreenGui,
	Destroy: (self: TopBar) -> (),
	new: () -> TopBar,
}

-- Class
local CurrentTopBar: TopBar = nil :: any
local TopBar = {} :: TopBar
TopBar.__index = TopBar

function TopBar:Destroy()
	if not self._IsAlive then return end
	self._IsAlive = false
	if CurrentTopBar == self then
		CurrentTopBar = nil :: any
	end
	self._Maid:Destroy()
	local t: any = self
	for k, v in pairs(t) do
		t[k] = nil
	end
	setmetatable(t, nil)
end

function TopBar:GetContainers(): {[number]: TopBarContainer}
	return table.clone(self._Containers)
end

function TopBar:CreateContainer(): TopBarContainer
	local container = self._Maid:GiveTask(Container.new())
	table.insert(self._Containers, container)
	container.Instance.Parent = self._Frame
	return container
end

function TopBar.new()

	local self: TopBar = setmetatable({}, TopBar) :: any
	self._IsAlive = true
	self._Maid = Maid.new()
	
	local _fuse = ColdFusion.fuse(self._Maid)
	
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import
	
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	self._Containers = {}
	self._Frame = _new("Frame")({
		Name = "TopBarFrame",
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5,0,0,TOP_BAR_MARGIN),
		AnchorPoint = Vector2.new(0.5,0),
		Size = UDim2.new(1, 0, 0, TOP_BAR_HEIGHT),
		Children = {
			_new("UIPadding")({
				PaddingTop = UDim.new(0, TOP_BUTTON_PADDING),
			}),
			_new("UIListLayout")({
				Padding = UDim.new(0,PADDING),
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalAlignment = Enum.VerticalAlignment.Top,
			}),
		}
	}) :: Frame

	self.Instance = _new("ScreenGui")({
		Name = "TopBar",
		IgnoreGuiInset = true,
		ClipToDeviceSafeArea = true,
		SafeAreaCompatibility = Enum.SafeAreaCompatibility.FullscreenExtension,
		ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets,
		Parent = if Player then Player:WaitForChild("PlayerGui") else game:GetService("CoreGui"),
		DisplayOrder = 7,
		Children = {
			self._Frame,
		}
	}) :: ScreenGui


	-- I don't know why, but it'll just set itself to false sometimes
	local function forceIgnoreGuiInset()
		if not self.Instance.IgnoreGuiInset then
			self.Instance.IgnoreGuiInset = true
		end
	end
	self._Maid:GiveTask(self.Instance:GetPropertyChangedSignal("IgnoreGuiInset"):Connect(forceIgnoreGuiInset))
	forceIgnoreGuiInset()

	if CurrentTopBar ~= nil then
		 CurrentTopBar:Destroy()
		 CurrentTopBar = nil :: any
	end
	CurrentTopBar = self

	return self
end

return TopBar