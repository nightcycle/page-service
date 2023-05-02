--!strict

-- Packages
local Package = script.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages ~= nil)
local Maid = require(Packages:WaitForChild("Maid"))
local Signal = require(Packages:WaitForChild("Signal"))
local Synthetic = require(Packages:WaitForChild("Synthetic"))
local ColdFusion = require(Packages:WaitForChild("ColdFusion"))
local GuiLibrary = require(Packages:WaitForChild("GuiLibrary"))
local StyleGuide = GuiLibrary:GetStyleGuide()

-- Modules
local PseudoEnum = require(Package:WaitForChild("PseudoEnum"))

type Maid = Maid.Maid
type Signal = Signal.Signal
type Fuse = ColdFusion.Fuse
type ValueState<T> = ColdFusion.ValueState<T>
type State<T> = ColdFusion.State<T>
type ParameterValue<T> = (State<T> | T)

export type PromptFrameParameters = {
	AnchorPoint: ParameterValue<Vector2>?,
	Size: ParameterValue<UDim2>?,
	Position: ParameterValue<UDim2>?,
	Parent: ParameterValue<GuiObject>?,
}
export type PromptFrame = {
	__index: PromptFrame,
	Maid: Maid,
	Library: GuiLibrary.GuiLibrary,
	Index: number,
	Destroy: (self: PromptFrame) -> nil,
	Instance: Frame,
	_OpenItems: { [string]: boolean },
	Fire: (self: PromptFrame, text: string, onConfirm: () -> nil, onDecline: (() -> nil)?) -> nil,
	new: (config: PromptFrameParameters?) -> PromptFrame,
}

local PromptFrame: PromptFrame = {} :: any
PromptFrame.__index = PromptFrame

function PromptFrame:Fire(text: string, onConfirm: () -> nil, onDecline: (() -> nil)?)
	if self._OpenItems[text] then
		return
	end
	self.Index += 1

	local _maid = Maid.new()
	self.Maid:GiveTask(_maid)
	local _synth = Synthetic(_maid)
	local _fuse = ColdFusion.fuse(_maid)
	local _library = GuiLibrary.new(_maid)
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	self._OpenItems[text] = true

	local resolved = false
	_new("Frame")({
		AnchorPoint = Vector2.new(0.5, 0.5),
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromScale(0, 0),
		BackgroundColor3 = StyleGuide:GetColor(PseudoEnum.GuiColorPalette.Surface6),
		BackgroundTransparency = 0,
		LayoutOrder = 1000000 - self.Index,
		Parent = self.Instance,
		Children = {
			_new("TextLabel")({
				Name = "Text",
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 0,
				LayoutOrder = 1,
				RichText = true,
				Font = StyleGuide:GetFont(PseudoEnum.GuiTypography.Body1),
				Text = text,
				TextTransparency = 0,
				TextSize = StyleGuide:GetTextSize(PseudoEnum.GuiTypography.Button),
				BackgroundColor3 = StyleGuide:GetColor(PseudoEnum.GuiColorPalette.Surface5),
				TextColor3 = StyleGuide:GetContrastColor(PseudoEnum.GuiColorPalette.Surface5),
				TextScaled = false,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.fromScale(0, 0),
				Children = {
					_library.Layout:GetUIPadding(PseudoEnum.GuiDensityModifier.High) :: any,
					_new("UISizeConstraint")({
						MinSize = _Computed(function(vSize: Vector2)
							return Vector2.new(vSize.X * 0.1, 0)
						end, StyleGuide.ViewportSize),
						MaxSize = _Computed(function(vSize: Vector2)
							return Vector2.new(vSize.X * 0.3, math.huge)
						end, StyleGuide.ViewportSize),
					}),
				},
			}),
			_new("Frame")({
				Name = "Buttons",
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundTransparency = 1,
				LayoutOrder = 2,
				Size = UDim2.fromScale(0, 0),
				Children = {
					_library.Layout:GetHorizontalList(
						PseudoEnum.GuiAlignmentType.Center,
						PseudoEnum.GuiDensityModifier.Low
					) :: any,
					_library.Input.Button:GetFilled(
						function()
							if resolved then
								return
							end
							resolved = true
							self._OpenItems[text] = nil
							onConfirm()
							_maid:Destroy()
						end,
						"CONTINUE",
						PseudoEnum.GuiColorPalette.Primary1,
						PseudoEnum.GuiDensityModifier.Default,
						PseudoEnum.GuiTypography.Button,
						2
					),
					if onDecline ~= nil
						then _library.Input.Button:GetText(
							function()
								if resolved then
									return
								end
								resolved = true
								self._OpenItems[text] = nil
								onDecline()
								_maid:Destroy()
							end,
							"BACK",
							PseudoEnum.GuiColorPalette.Surface6,
							PseudoEnum.GuiDensityModifier.Default,
							PseudoEnum.GuiTypography.Button,
							1
						)
						else nil,
				},
			}),
			_library.Effect:GetUICorner() :: any,
			_library.Layout:GetVerticalList(PseudoEnum.GuiAlignmentType.Right, PseudoEnum.GuiDensityModifier.Default) :: any,
			_library.Layout:GetUIPadding(PseudoEnum.GuiDensityModifier.High),
		} :: { [number]: any },
	})

	return nil
end

function PromptFrame:Destroy()
	self.Maid:Destroy()
	local t: any = self
	for k, v in pairs(t) do
		t[k] = nil
	end
	setmetatable(t, nil)
	return nil
end

function PromptFrame.new(config: PromptFrameParameters?): PromptFrame
	config = config or {}
	assert(config ~= nil)

	local _maid = Maid.new()
	local _buildMaid = Maid.new()
	_maid:GiveTask(_buildMaid)

	local _synth = Synthetic(_maid)
	local _fuse = ColdFusion.fuse(_maid)
	local _new = _fuse.new
	local _library = GuiLibrary.new(_maid)
	local _bind = _fuse.bind
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local AnchorPoint = _import(config.AnchorPoint, Vector2.new(1, 1))
	local Size = _import(config.Size, UDim2.fromScale(0.5, 1))
	local Position = _import(config.Position, UDim2.fromScale(1, 1))
	local Parent = _import(config.Parent, nil :: GuiObject?)

	local self: PromptFrame = setmetatable({
		_Synth = _synth,
		_Fuse = _fuse,
		Maid = _maid,
		Library = _library,
		_OpenItems = {},
		Index = 0,
		["Instance"] = _new("Frame")({
			Parent = Parent,
			AnchorPoint = AnchorPoint,
			Size = Size,
			Position = Position,
			BackgroundColor3 = StyleGuide:GetColor(PseudoEnum.GuiColorPalette.Secondary1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 1000,
			Name = "PromptFrame",
			Children = {
				_library.Layout:GetUIPadding(PseudoEnum.GuiDensityModifier.Default) :: any,
				_library.Layout:GetVerticalList(
					PseudoEnum.GuiAlignmentType.Center,
					PseudoEnum.GuiDensityModifier.Default
				) :: any,
			},
		}),
	}, PromptFrame) :: any

	self.Maid:GiveTask(self.Instance.Destroying:Connect(function()
		self:Destroy()
	end))

	return self
end

return PromptFrame
