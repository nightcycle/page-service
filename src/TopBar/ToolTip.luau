--!strict
-- written to mimic this component
-- https://github.com/MaximumADHD/Roblox-Client-Tracker/blob/8ef5688266cc0d8f613388db109b35400dbf7051/scripts/CoreScripts/Modules/DevConsole/Components/Tooltip.lua#L4
local _Package = script.Parent.Parent
local _Packages = _Package.Parent
-- Services
local Players = game:GetService("Players")

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
-- Modules
-- Types
type CanBeState<V> = ColdFusion.CanBeState<V>
-- Constants
local FONT = Enum.Font.SourceSansBold
local TEXT_SIZE = 12
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)
local BACKGROUND_COLOR = Color3.fromRGB(78, 84, 96)
local PADDING = UDim.new(0, 6)
local OFFSET = UDim2.fromOffset(12, 12)
local MAX_WIDTH = 300
local DELAY = 0.35
-- Variables
-- References
local Player = Players.LocalPlayer

-- Private Functions
-- Class
return function(
	TextParameter: CanBeState<string>, 
	PositionParameter: CanBeState<UDim2>
): ScreenGui
	local maid = Maid.new()
	local _fuse = ColdFusion.fuse(maid)
	
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import
	
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local Text = _import(TextParameter, "")
	local Position = _import(PositionParameter, UDim2.fromScale(0,0))

	local Visible = _Value(false)

	local isCancelled = false
	maid:GiveTask(function()
		isCancelled = true
	end)

	task.delay(DELAY, function()
		if not isCancelled then
			Visible:Set(true)
		end
	end)

	local inst = _new("ScreenGui")({
		DisplayOrder = 20,
		IgnoreGuiInset = true,
		-- OnTopOfCoreBlur = true,
		Enabled = Visible,
		Parent = if Player then Player:WaitForChild("PlayerGui") else game:GetService("CoreGui"),
		Children = {
			_new("TextLabel")({
				Text = Text,
				TextSize = TEXT_SIZE,
				TextColor3 = TEXT_COLOR,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				Font = FONT,
				AutomaticSize = Enum.AutomaticSize.XY,
				Position = _Computed(function(pos: UDim2): UDim2
					return pos + OFFSET
				end, Position),
				BackgroundColor3 = BACKGROUND_COLOR,
				BackgroundTransparency = 0,
				BorderSizePixel = 0,
				Children = {
					Padding = _new("UIPadding")({
						PaddingTop = PADDING,
						PaddingBottom = PADDING,
						PaddingLeft = PADDING,
						PaddingRight = PADDING
					}),
					SizeConstraint = _new("UISizeConstraint")({
						MaxSize = Vector2.new(MAX_WIDTH, math.huge)
					})
				},
			})
		},
	}) :: ScreenGui

	maid.bind(inst)

	return inst
end