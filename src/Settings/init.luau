--!strict
-- Services
local RunService = game:GetService("RunService")
-- Packages
local Package = script.Parent
local Packages = Package.Parent
local Maid = require(Packages:WaitForChild("Maid"))
local Signal = require(Packages:WaitForChild("Signal"))
local ColdFusion = require(Packages:WaitForChild("ColdFusion"))
local GuiLibrary = require(Packages:WaitForChild("GuiLibrary"))
local FormatUtil = require(Packages:WaitForChild("FormatUtil"))
local StyleGuide = GuiLibrary.getStyleGuide()

-- Modules
local PseudoEnum = require(Package:WaitForChild("PseudoEnum"))

-- Constants

-- Types
type Maid = Maid.Maid
type Signal = Signal.Signal
type Fuse = ColdFusion.Fuse
type ValueState<T> = ColdFusion.ValueState<T>
type State<T> = ColdFusion.State<T>
type CanBeState<T> = ColdFusion.CanBeState<T>

-- Remotes

-- Class
type Constructor = (maid: Maid) -> GuiObject
export type RowData = {
	Text: CanBeState<string>,
	InputConstructor: Constructor
}
export type SettingsConstructor = {
	__index: SettingsConstructor,
	_IsAlive: boolean,
	_Maid: Maid,
	_ContextFrame: Frame,
	_InputFrame: Frame,
	_Entries: {[number]: RowData},
	new: () -> SettingsConstructor,
	init: (maid: Maid) -> nil,
	Build: (self: SettingsConstructor) -> Frame,
	Destroy: (self: SettingsConstructor) -> nil,
	AddEntry: (self: SettingsConstructor, rowData: RowData) -> nil,
}

-- private functions
function buildInputRow(maid: Maid, order: number, rowData: RowData, inputFrame: Frame, contextFrame: Frame)
	local _fuse = ColdFusion.fuse(maid)
	local _library = GuiLibrary.new(maid)
	
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import
	
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed
	local input = rowData.InputConstructor(maid)	
	local HeightState = _Value(input.AbsoluteSize.Y)

	maid:GiveTask(RunService.RenderStepped:Connect(function()
		HeightState:Set(input.AbsoluteSize.Y)
	end))

	_new("Frame")({
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = _Computed(function(height: number)
			return UDim2.fromOffset(0, height)
		end, HeightState),
		Parent = contextFrame,
		LayoutOrder = order,
		Children = {
			_library.Layout:GetVerticalList(
				PseudoEnum.GuiAlignmentType.Center,
				PseudoEnum.GuiDensityModifier.High
			) :: any,
			_library.Media:GetTextLabel(
				rowData.Text,
				PseudoEnum.GuiTypography.Button,
				PseudoEnum.GuiColorPalette.Surface6,
				nil,
				"Context"
			)
		},
	})
	input.LayoutOrder = order
	input.Parent = inputFrame
end

-- Class
local SettingsConstructor: SettingsConstructor = {} :: any
SettingsConstructor.__index = SettingsConstructor

function SettingsConstructor:AddEntry(rowData: RowData)
	table.insert(self._Entries, rowData)
	return nil
end

function SettingsConstructor:Destroy()
	if not self._IsAlive then
		return
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

function SettingsConstructor:Build(): Frame
	local maid = self._Maid:GiveTask(Maid.new())

	local _fuse = ColdFusion.fuse(maid)
	local _library = GuiLibrary.new(maid)
	
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import
	
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local contextFrame = _library.Layout:GetContainer(
		{
			_library.Layout:GetVerticalList(
				PseudoEnum.GuiAlignmentType.Center, 
				nil--PseudoEnum.GuiDensityModifier.High
			) :: any,
		}, 
		PseudoEnum.GuiDensityModifier.Default, 
		1, 
		"ContextFrame", 
		PseudoEnum.GuiColorPalette.Surface6, 
		nil
	)

	local inputFrame = _library.Layout:GetContainer(
		{
			_library.Layout:GetVerticalList(
				PseudoEnum.GuiAlignmentType.Center, 
				nil--PseudoEnum.GuiDensityModifier.High
			) :: any,
		}, 
		PseudoEnum.GuiDensityModifier.Default, 
		2, 
		"InputFrame", 
		PseudoEnum.GuiColorPalette.Surface6, 
		nil
	)

	local inst = _bind(_library.Layout:GetContainer(
		{
			_library.Layout:GetVerticalList(
				PseudoEnum.GuiAlignmentType.Center, 
				PseudoEnum.GuiDensityModifier.High
			) :: any,
			_new("UICorner")({
				CornerRadius = StyleGuide.CornerRadius,
			}),
			_library.Layout:GetContainer(
				{
					_library.Layout:GetHorizontalList(
						PseudoEnum.GuiAlignmentType.Center, 
						nil --PseudoEnum.GuiDensityModifier.High
					) :: any,
					contextFrame,
					inputFrame
				}, 
				PseudoEnum.GuiDensityModifier.Default, 
				2, 
				"Content", 
				PseudoEnum.GuiColorPalette.Surface6, 
				nil
			),
			_library.Media:GetTextLabel(
				FormatUtil.bold("SETTINGS"),
				PseudoEnum.GuiTypography.Headline3,
				PseudoEnum.GuiColorPalette.Surface6,
				1,
				"Title"
			),
		},
		PseudoEnum.GuiDensityModifier.Low, 
		nil, 
		"Settings", 
		PseudoEnum.GuiColorPalette.Surface6, 
		nil
	))({
		Position = UDim2.fromScale(0.5,0.5),
		AnchorPoint = Vector2.new(0.5,0.5),
	}) :: Frame

	for i, rowData in ipairs(self._Entries) do
		buildInputRow(maid, i, rowData, inputFrame, contextFrame)
	end

	maid:GiveTask(inst.Destroying:Connect(function()
		maid:Destroy()
	end))

	return inst
end

function SettingsConstructor.new(): SettingsConstructor

	local self: SettingsConstructor = setmetatable({}, SettingsConstructor) :: any	
	self._IsAlive = true
	self._Maid = Maid.new()
	self._Entries = {}

	self:AddEntry({
		Text = "Dark Mode",
		InputConstructor = function(maid: Maid): GuiObject
			local _fuse = ColdFusion.fuse(maid)
			local _library = GuiLibrary.new(maid)
			
			local _new = _fuse.new
			local _bind = _fuse.bind
			local _clone = _fuse.clone
			local _import = _fuse.import
			
			local _Value = _fuse.Value
			local _Computed = _fuse.Computed
		
			local IsDarkMode = StyleGuide.IsDarkMode
			return _library.Input.Checkbox:GetState(
				IsDarkMode,
				PseudoEnum.GuiColorPalette.Primary6,
				PseudoEnum.GuiColorPalette.Surface6,
				PseudoEnum.GuiTypography.Button
			) :: GuiObject
		end
	})
	self:AddEntry({
		Text = "Large Text",
		InputConstructor = function(maid: Maid): GuiObject
			local _fuse = ColdFusion.fuse(maid)
			local _library = GuiLibrary.new(maid)
			
			local _new = _fuse.new
			local _bind = _fuse.bind
			local _clone = _fuse.clone
			local _import = _fuse.import
			
			local _Value = _fuse.Value
			local _Computed = _fuse.Computed
		
			local Scale = StyleGuide.Scale
			local defaultTextScale = Scale:Get()
		
			local IsLargeText = _Computed(function(textScale: number)
				return textScale > defaultTextScale
			end, Scale)
		
			return _library.Input.Checkbox:Get(
				function()
					if IsLargeText:Get() then
						Scale:Set(defaultTextScale)
					else
						Scale:Set(defaultTextScale * 1.6)
					end
				end,
				IsLargeText:Get(),
				PseudoEnum.GuiColorPalette.Primary6,
				PseudoEnum.GuiColorPalette.Surface6,
				PseudoEnum.GuiTypography.Button
			) :: GuiObject
		end
	})

	return self
end

return SettingsConstructor
