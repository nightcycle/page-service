--!strict

-- Packages
local Package = script.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages)
local Maid = require(Packages:WaitForChild("Maid"))
local Signal = require(Packages:WaitForChild("Signal"))
local ColdFusion = require(Packages:WaitForChild("ColdFusion"))
local GuiLibrary = require(Packages:WaitForChild("GuiLibrary"))
local StyleGuide = GuiLibrary.getStyleGuide()

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
	_Maid: Maid,
	_IsAlive: boolean,
	_Index: number,
	_OpenItems: { [string]: boolean },
	AnchorPoint: ValueState<Vector2>,
	Size: ValueState<UDim2>,
	Position: ValueState<UDim2>,	
	Instance: Frame,
	Destroy: (self: PromptFrame) -> nil,
	Fire: (self: PromptFrame, text: string, onConfirm: () -> nil, onDecline: (() -> nil)?) -> nil,
	new: () -> PromptFrame,
}

local PromptFrame: PromptFrame = {} :: any
PromptFrame.__index = PromptFrame

function PromptFrame:Fire(text: string, onConfirm: () -> nil, onDecline: (() -> nil)?)
	if self._OpenItems[text] then
		return
	end
	self._Index += 1

	local maid = self._Maid:GiveTask(Maid.new())
	local _fuse = ColdFusion.fuse(maid)
	local _library = GuiLibrary.new(maid)
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _import = _fuse.import
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	self._OpenItems[text] = true

	local resolved = false
	
	local container = _library.Layout:GetContainer({
		_library.Layout:GetVerticalList(
			if onDecline then PseudoEnum.GuiAlignmentType.Right else PseudoEnum.GuiAlignmentType.Center,
			PseudoEnum.GuiDensityModifier.High
		) :: any,
		_new("Frame")({
			Name = "Text",
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 0,
			BackgroundColor3 = StyleGuide:GetColor(PseudoEnum.GuiColorPalette.Surface5),
			LayoutOrder = 1,
			Size = _Computed(function(vSize: Vector2)
				return UDim2.fromOffset(vSize.X * 0.2, 0)
			end, StyleGuide.ViewportSize),
			Children = {
				_new("TextLabel")({
					RichText = true,
					Size = UDim2.fromScale(0, 0),
					AutomaticSize = Enum.AutomaticSize.XY,
					FontFace = StyleGuide:GetFont(PseudoEnum.GuiTypography.Body1),
					Text = text,
					TextTransparency = 0,
					TextSize = StyleGuide:GetTextSize(PseudoEnum.GuiTypography.Button),
					TextColor3 = StyleGuide:GetContrastColor(PseudoEnum.GuiColorPalette.Surface5),
					TextScaled = false,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
					BackgroundTransparency = 1,
				}),
				_library.Effect:GetUICorner(),
				_library.Layout:GetUIPadding(PseudoEnum.GuiDensityModifier.Default, true) :: any,
				_library.Layout:GetHorizontalList(
					PseudoEnum.GuiAlignmentType.Center
				) :: any,
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
					PseudoEnum.GuiDensityModifier.High
				) :: any,
				_library.Input.Button:GetFilled(
					function()
						if resolved then
							return
						end
						resolved = true
						self._OpenItems[text] = nil
						onConfirm()
						maid:Destroy()
					end,
					"CONFIRM",
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
							maid:Destroy()
						end,
						"DECLINE",
						PseudoEnum.GuiColorPalette.Surface6,
						PseudoEnum.GuiDensityModifier.Default,
						PseudoEnum.GuiTypography.Button,
						1
					)
					else nil,
			},
		}),
		}, 
		PseudoEnum.GuiDensityModifier.High,
		1000000 - self._Index,
		"Prompt",
		PseudoEnum.GuiColorPalette.Surface6,
		true
	)
	container.Parent = self.Instance

	return nil
end

function PromptFrame:Destroy()
	if not self._IsAlive then
		return nil
	end
	self._Maid:Destroy()
	local t: any = self
	for k, v in pairs(t) do
		t[k] = nil
	end
	setmetatable(t, nil)
	return nil
end

function PromptFrame.new(): PromptFrame
	local self: PromptFrame = setmetatable({}, PromptFrame) :: any
	
	self._Maid = Maid.new()
	self._IsAlive = true
	self._OpenItems = {}
	self._Index = 0

	local _fuse = ColdFusion.fuse(self._Maid)
	local _new = _fuse.new
	local _library = GuiLibrary.new(self._Maid)

	local _bind = _fuse.bind
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	self.AnchorPoint = _Value(Vector2.new(0.5, 1))
	self.Size = _Value(UDim2.fromScale(0.35, 0.4))
	self.Position = _Value(UDim2.fromScale(0.5, 0.6))

	self.Instance = _new("Frame")({
		AnchorPoint = self.AnchorPoint,
		Size = self.Size,
		Position = self.Position,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 15,
		SizeConstraint = Enum.SizeConstraint.RelativeYY,
		Name = "PromptFrame",
		Children = {
			-- _library.Layout:GetUIPadding(PseudoEnum.GuiDensityModifier.Default) :: any,
			_library.Layout:GetVerticalList(
				PseudoEnum.GuiAlignmentType.Bottom,
				PseudoEnum.GuiDensityModifier.Default
			) :: any,
		},
	}) :: Frame

	self._Maid:GiveTask(self.Instance.Destroying:Connect(function()
		self:Destroy()
	end))

	return self
end

return PromptFrame
