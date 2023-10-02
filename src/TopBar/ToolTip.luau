--!strict
-- written to mimic this component
-- https://github.com/MaximumADHD/Roblox-Client-Tracker/blob/8ef5688266cc0d8f613388db109b35400dbf7051/scripts/CoreScripts/Modules/DevConsole/Components/Tooltip.lua#L4
local _Package = script.Parent.Parent
local _Packages = _Package.Parent
-- Services
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")

-- Packages
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))
-- Modules
-- Types
type CanBeState<V> = ColdFusion.CanBeState<V>
-- Constants
local BACKGROUND_COLOR = Color3.fromRGB(101, 102, 104)
local TEXT_SIZE = 14
local PADDING = 19
local FONT = Font.fromEnum(Enum.Font.Gotham)
local MAX_WIDTH = 300 - PADDING * 2
local DELAY = 0.35
-- Variables
-- References
local Player = Players.LocalPlayer

-- Private Functions
-- Class
return function(
	TextParameter: CanBeState<string>, 
	PositionParameter: CanBeState<UDim2>
): () -> ()
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

	local Size = _Computed(function(text: string): UDim2
		local size = TextService:GetTextSize(
			text,
			TEXT_SIZE,
			Enum.Font.Gotham,
			Vector2.new(MAX_WIDTH, workspace.CurrentCamera.ViewportSize.Y)
		)
		return UDim2.fromOffset(size.X + PADDING*2, size.Y + PADDING*2)
	end, Text)
	
	local Visible = _Value(false)

	local Transparency = _Computed(function(vis: boolean)
		if vis then
			return 0
		else
			return 1
		end
	end, Visible):Tween(0.075, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)

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
		Enabled = true,
		Parent = if Player then Player:WaitForChild("PlayerGui") else game:GetService("CoreGui"),
		Children = {
			_new("CanvasGroup")({
				Position = _Computed(function(pos: UDim2, size: UDim2, trans: number): UDim2
					return UDim2.new(pos.X, pos.Y + size.Y + UDim.new(0, (1-trans)*5))
				end, Position, Size, Transparency),
				AnchorPoint = Vector2.new(0.5,0),
				Size = Size,
				BackgroundTransparency = 1,
				GroupTransparency = Transparency,
				Children = {
					_new("Frame")({
						Name = "Box",
						Position = UDim2.fromOffset(4,7),
						AutomaticSize = Enum.AutomaticSize.XY,
						BackgroundColor3 = BACKGROUND_COLOR,
						ZIndex = 2,
						Children = {
							_new("UICorner")({
								CornerRadius = UDim.new(0,8),
							}),
							_new("UIListLayout")({
								Padding = UDim.new(0, 8),
								FillDirection = Enum.FillDirection.Vertical,
								HorizontalAlignment = Enum.HorizontalAlignment.Left,
								SortOrder = Enum.SortOrder.LayoutOrder,
								VerticalAlignment = Enum.VerticalAlignment.Top,
							}),
							_new("UIPadding")({
								PaddingTop = UDim.new(0, 12),
								PaddingBottom = UDim.new(0, 12),
								PaddingLeft = UDim.new(0, 12),
								PaddingRight = UDim.new(0, 12),
							}),
							_new("TextLabel")({
								Name = "Header",
								RichText = true,
								Text = Text,
								Size = UDim2.fromOffset(47, 16),
								LayoutOrder = 1,
								BorderSizePixel = 1,
								BackgroundTransparency = 1,
								FontFace = FONT,
								BorderColor3 = Color3.fromRGB(27, 42, 53),
								TextColor3 = Color3.new(1,1,1),
								AutomaticSize = Enum.AutomaticSize.XY,
								ZIndex = 1,
								TextSize = TEXT_SIZE,
								TextDirection = Enum.TextDirection.Auto,
								TextScaled = false,
								TextStrokeTransparency = 1,
								TextTruncate = Enum.TextTruncate.AtEnd,
								TextXAlignment = Enum.TextXAlignment.Left,
								TextYAlignment = Enum.TextYAlignment.Center,
								TextWrapped = true,
							}),
						},
					}),
					_new("ImageLabel")({
						Name = "Caret",
						AnchorPoint = Vector2.new(0.5,0.5),
						BackgroundTransparency = 1,
						BorderSizePixel = 1,
						BorderColor3 = Color3.fromRGB(27, 42, 53),
						BorderMode = Enum.BorderMode.Outline,
						Position = _Computed(function(size: UDim2)
							return UDim2.new(
								UDim.new(size.X.Scale/2,size.X.Offset/2), 
								UDim.new(0,4)
							)
						end, Size),
						Size = UDim2.fromOffset(16, 8),
						ZIndex = 2,
						Image = "rbxasset://LuaPackages/Packages/_Index/UIBlox/UIBlox/AppImageAtlas/img_set_1x_1.png",
						ImageColor3 = BACKGROUND_COLOR,
						ImageRectOffset = Vector2.new(260, 440),
						ImageRectSize = Vector2.new(16, 8),
						Rotation = 180,
					}),
					_new("ImageLabel")({
						Name = "DropShadow",
						BackgroundTransparency = 1,
						BorderMode = Enum.BorderMode.Outline,
						BorderColor3 = Color3.fromRGB(27, 42, 53),
						BorderSizePixel = 1,
						ZIndex = 1,
						Size = _Computed(function(size: UDim2)
							return UDim2.new(size.X, size.Y - UDim.new(0,4))
						end, Size),
						Image = "rbxasset://LuaPackages/Packages/_Index/UIBlox/UIBlox/AppImageAtlas/img_set_1x_1.png",
						ImageColor3 = Color3.new(0,0,0),
						ImageRectOffset = Vector2.new(217, 486),
						ImageRectSize = Vector2.new(25, 25),
						ImageTransparency = 0.5,
						ScaleType = Enum.ScaleType.Slice,
						SliceCenter = Rect.new(
							Vector2.new(12, 12),
							Vector2.new(13, 13)
						),
						SliceScale = 1,
					})
				}
			}),
		},
	}) :: ScreenGui

	maid.bind(inst)

	return function()
		isCancelled = true
		Visible:Set(false)
		task.wait(0.075)
		maid:Destroy()
	end
end