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

-- Types
-- Constants
local TOP_BAR_HEIGHT = Config.HEIGHT
local TOP_BUTTON_HEIGHT = Config.BUTTON.HEIGHT
local TOP_BUTTON_PADDING = Config.BUTTON.PADDING

local TOP_BAR_TOP_MARGIN = Config.MARGIN.TOP
local PADDING = Config.PADDING
local CONTAINER_BACKGROUND_COLOR = Config.THEME.BACKGROUND.UI.CONTRAST.COLOR
local CONTAINER_BACKGROUND_TRANSPARENCY = Config.THEME.BACKGROUND.UI.CONTRAST.TRANSPARENCY

-- Variables
-- References
local Player = Players.LocalPlayer

-- Private Functions
-- Types
type Maid = Maid.Maid
type ValueState<T> = ColdFusion.ValueState<T>
type State<T> = ColdFusion.State<T>
export type TopBar = {
	__index: TopBar,
	_Maid: Maid,
	_IsAlive: boolean,
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

	self.Instance = _new("ScreenGui")({
		Name = "TopBar",
		IgnoreGuiInset = true,
		ClipToDeviceSafeArea = true,
		SafeAreaCompatibility = Enum.SafeAreaCompatibility.FullscreenExtension,
		ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets,
		Parent = if Player then Player:WaitForChild("PlayerGui") else game:GetService("CoreGui"),
		DisplayOrder = 7,
		Children = {
			_new("Frame")({
				Name = "Container",
				BackgroundColor3 = CONTAINER_BACKGROUND_COLOR,
				BackgroundTransparency = CONTAINER_BACKGROUND_TRANSPARENCY,
				Size = UDim2.new(0.5, 0, 0, TOP_BUTTON_HEIGHT),
				Position = UDim2.new(0.5, 0, 0, TOP_BAR_TOP_MARGIN+TOP_BUTTON_PADDING),
				AnchorPoint = Vector2.new(0.5, 0),
				Children = {
					_new("UICorner")({
						CornerRadius = UDim.new(1, 0),
					}),
					_new("UIPadding")({
						PaddingBottom = UDim.new(0,2),
						PaddingTop = UDim.new(0,2),
					}),
					_new("UIListLayout")({
						Padding = UDim.new(0, PADDING),
						FillDirection = Enum.FillDirection.Horizontal,
						HorizontalAlignment = Enum.HorizontalAlignment.Right,
						SortOrder = Enum.SortOrder.LayoutOrder,
						VerticalAlignment = Enum.VerticalAlignment.Top,
					}),
				}
			})
		}
	}) :: ScreenGui

	if CurrentTopBar ~= nil then
		 CurrentTopBar:Destroy()
		 CurrentTopBar = nil :: any
	end
	CurrentTopBar = self

	return self
end

return TopBar