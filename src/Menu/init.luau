--!strict
-- Services
-- Packages
local Package = script.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages ~= nil)
local Maid = require(Packages:WaitForChild("Maid"))
local Signal = require(Packages:WaitForChild("Signal"))
local Synthetic = require(Packages:WaitForChild("Synthetic"))
local ColdFusion = require(Packages:WaitForChild("ColdFusion"))
local FormatUtil = require(Packages:WaitForChild("FormatUtil"))
local GuiLibrary = require(Packages:WaitForChild("GuiLibrary"))
local StyleGuide = GuiLibrary.getStyleGuide()

-- Modules
local PseudoEnum = require(Package:WaitForChild("PseudoEnum"))

-- Types
type Maid = Maid.Maid
type Signal = Signal.Signal
type Fuse = ColdFusion.Fuse
type ValueState<T> = ColdFusion.ValueState<T>
type State<T> = ColdFusion.State<T>
type CanBeState<T> = ColdFusion.CanBeState<T>

export type ButtonData = {
	Path: string?,
	Icon: string,
	Hint: string,
	LayoutOrder: number,
	OnClick: Signal?,
	IsSelected: State<boolean>?
}
export type Menu = {
	_Maid: Maid,
	_IsAlive: boolean,
	__index: Menu,
	_Currencies: { [string]: ValueState<number> },
	_CurrencyFrameVisible: ValueState<boolean>,
	Buttons: {[string]: ValueState<ButtonData>},
	new: () -> Menu,
	Destroy: (self: Menu) -> nil,
	Instance: Frame,
	_CurrencyFrame: Frame,
	_ButtonFrame: Frame,
	Visible: ValueState<boolean>,
	SetButton: (
		self: Menu,
		buttonData: ButtonData,
		IsVisible: State<boolean>?
	) -> GuiObject,
	SetCurrency: (
		self: Menu,
		key: string,
		name: string,
		icon: string?,
		color: Color3,
		layoutOrder: number,
		initialValue: number
	) -> nil,
	GetCurrencyState: (self: Menu, key: string) -> ValueState<number>,
}

-- Constant
local TOP_BAR_INSET = 30

-- Class
local Menu: Menu = {} :: any
Menu.__index = Menu

function Menu:SetCurrency(
	key: string,
	name: string,
	icon: string?,
	color: Color3,
	layoutOrder: number,
	initialValue: number
): nil
	local _synth = Synthetic(self._Maid)
	local _fuse = ColdFusion.fuse(self._Maid)
	local _library = GuiLibrary.new(self._Maid)
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local Amount = _Value(initialValue)

	self._Currencies[key] = Amount
	_synth("TextLabel")({
		LeftIcon = icon,
		Text = _Computed(function(amount: number)
			return FormatUtil.money(amount, false):gsub("%$", "")
		end, Amount),
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		Parent = self._CurrencyFrame,
		TextColor3 = _Computed(function(background: Color3)
			return StyleGuide.getReadableColor(color, background)
		end, StyleGuide:GetColor(PseudoEnum.GuiColorPalette.Surface5)),
		TextSize = StyleGuide:GetTextSize(PseudoEnum.GuiTypography.Button),
		FontFace = StyleGuide:GetFont(PseudoEnum.GuiTypography.Button),
	})
	self._CurrencyFrameVisible:Set(true)
	return
end

function Menu:GetCurrencyState(key: string): ValueState<number>
	return self._Currencies[key]
end

function Menu:SetButton(
	buttonData: ButtonData,
	IsVisible: State<boolean>?
)
	local maid = self._Maid:GiveTask(Maid.new())

	local _fuse = ColdFusion.fuse(maid)
	local _library = GuiLibrary.new(maid)
	local _synth = Synthetic(maid)
	
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _clone = _fuse.clone
	local _import = _fuse.import
	
	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local IsSelected: State<boolean> = buttonData.IsSelected or _Value(false)

	local BackgroundColor3 = _Computed(
		function(isSelected: boolean, default: Color3, goal: Color3): Color3
			if isSelected then
				return goal
			else
				return default
			end
		end,
		IsSelected,
		StyleGuide:GetColor(PseudoEnum.GuiColorPalette.Surface6),
		StyleGuide:GetColor(PseudoEnum.GuiColorPalette.Secondary1)
	)

	local TextColor3 = _Computed(function(back: Color3, goal: Color3): Color3
		return StyleGuide.getReadableColor(goal, back)
	end, BackgroundColor3, StyleGuide:GetContrastColor(PseudoEnum.GuiColorPalette.Surface5))

	local button = _synth("Button")({
		TextColor3 = TextColor3,
		HoverTextColor3 = StyleGuide:GetContrastColor(PseudoEnum.GuiColorPalette.Tertiary1),
		SelectedTextColor3 = StyleGuide:GetContrastColor(PseudoEnum.GuiColorPalette.Secondary1),

		BackgroundColor3 = BackgroundColor3,
		HoverBackgroundColor3 = StyleGuide:GetColor(PseudoEnum.GuiColorPalette.Tertiary1),
		SelectedBackgroundColor3 = StyleGuide:GetColor(PseudoEnum.GuiColorPalette.Secondary1),

		TextTransparency = 0,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,

		BackgroundTransparency = 0,
		BorderTransparency = 1,
		TextSize = StyleGuide:GetTextSize(PseudoEnum.GuiTypography.Button),
		Padding = StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.Default),
		TextOnly = false,
		Text = nil,
		Visible = IsVisible,
		LayoutOrder = buttonData.LayoutOrder,
		AnchorPoint = Vector2.new(0.5, 0.5),
		ClickSound = GuiLibrary.Sound.Click,
		CornerRadius = UDim.new(0, 0),
		Parent = self._ButtonFrame,
		LeftIcon = buttonData.Icon,
		RightIcon = nil,
	})

	if buttonData.OnClick then
		local signalMaid = Maid.new()
		maid._signal = signalMaid

		local activated = button:WaitForChild("Activated") :: BindableEvent
		signalMaid:GiveTask(activated.Event:Connect(function()
			buttonData.OnClick:Fire(buttonData.Path)
		end))
	end

	maid:GiveTask(button.Destroying:Connect(function()
		maid:Destroy()
	end))
	return button
end

function Menu:Destroy()
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

function Menu.new(): Menu

	local self: Menu = setmetatable({}, Menu) :: any
	self._IsAlive = true
	self._Maid = Maid.new()

	local _fuse = ColdFusion.fuse(self._Maid)
	local _library = GuiLibrary.new(self._Maid)
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	self.Visible = _Value(true)
	local BarHeight = _Computed(
		function(textSize: number, padding: UDim)
			return textSize + padding.Offset * 2
		end,
		StyleGuide:GetTextSize(PseudoEnum.GuiTypography.Headline5),
		StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.Default)
	)
	self._ButtonFrame = _library.Layout:GetContainer(
		{
			_library.Layout:GetHorizontalList(PseudoEnum.GuiAlignmentType.Bottom),
		},
		nil,
		2,
		"ButtonContainer",
		nil,
		false
	) :: Frame


	self._Currencies = {}
	self._CurrencyFrameVisible = _Value(false)
	self._CurrencyFrame = _bind(_library.Layout:GetContainer(
		{
			_library.Effect:GetUICorner() :: any,

			_library.Layout:GetHorizontalList(PseudoEnum.GuiAlignmentType.Bottom),
			
		},
		PseudoEnum.GuiDensityModifier.Default,
		0,
		"CurrencyFrame",
		PseudoEnum.GuiColorPalette.Surface5,
		false
	))({
		Visible = self._CurrencyFrameVisible,
	}) :: Frame



	self.Instance = _bind(_library.Layout:GetContainer(
		{
			_library.Layout:GetVerticalList(PseudoEnum.GuiAlignmentType.Bottom, PseudoEnum.GuiDensityModifier.Low),
			_library.Layout:GetContainer(
				{
					_library.Effect:GetUICorner() :: any,
					_library.Layout:GetHorizontalList(PseudoEnum.GuiAlignmentType.Bottom, "High"),
					self._ButtonFrame,
					self._CurrencyFrame,
				},
				nil,
				2,
				"Content",
				nil,
				false
			),
			_new("Frame")({
				Name = "Filler",
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = _Computed(function(height)
					return UDim2.fromOffset(0, height)
				end, BarHeight),
			}),
		},
		PseudoEnum.GuiDensityModifier.High,
		nil,
		"Menu",
		PseudoEnum.GuiColorPalette.Surface6,
		false
	))({
		AnchorPoint = _Computed(function(vis: boolean)
			if vis then
				return Vector2.new(0.5, 0.5)
			else
				return Vector2.new(0.5, 1)
			end
		end, self.Visible):Tween(0.2),
		Position = _Computed(function(vis: boolean)
			return UDim2.new(0.5, 0, 0, if vis then 0 else -TOP_BAR_INSET)
		end, self.Visible):Tween(0.2),
		ZIndex = 10,
	}) :: Frame

	return self
end

return Menu
