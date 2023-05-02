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
local StyleGuide = GuiLibrary:GetStyleGuide()

-- Modules
local PseudoEnum = require(Package:WaitForChild("PseudoEnum"))

-- Types
type Maid = Maid.Maid
type Signal = Signal.Signal
type Fuse = ColdFusion.Fuse
type ValueState<T> = ColdFusion.ValueState<T>
type State<T> = ColdFusion.State<T>
type ParameterValue<T> = (State<T> | T)

export type MenuParameters = {
	Visible: ParameterValue<boolean>?,
	ForceHide: ParameterValue<boolean>?,
	CurrentPath: ParameterValue<string>?,
	Parent: ParameterValue<GuiObject>?,
}
export type Menu = {
	_Maid: Maid,
	__index: Menu,
	_Currencies: { [string]: ValueState<number> },
	new: (config: MenuParameters?) -> Menu,
	Destroy: (self: Menu) -> nil,
	Instance: Frame,
	_CurrencyFrame: Frame,
	CurrentPath: ValueState<string>,
	SetButton: (
		self: Menu,
		path: string,
		icon: string,
		hint: string,
		layoutOrder: number,
		signal: Signal,
		enabledState: State<boolean>?
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
			return FormatUtil.money(amount, false)
		end, Amount),
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		Parent = self._CurrencyFrame,
		TextColor3 = _Computed(function(background: Color3)
			return StyleGuide.getReadableColor(color, background)
		end, StyleGuide:GetColor(PseudoEnum.GuiColorPalette.Surface1)),
		TextSize = StyleGuide:GetTextSize(PseudoEnum.GuiTypography.Button),
		Font = StyleGuide:GetFont(PseudoEnum.GuiTypography.Button),
	})

	return
end

function Menu:GetCurrencyState(key: string): ValueState<number>
	return self._Currencies[key]
end

function Menu:SetButton(
	path: string,
	icon: string,
	hint: string,
	layoutOrder: number,
	signal: Signal,
	enabledState: State<boolean>?
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

	local IsSelected = _Computed(function(current: string): boolean
		return current == path
	end, self.CurrentPath)

	local BackgroundColor3 = _Computed(
		function(isSelected: boolean, default: Color3, goal: Color3): Color3
			if isSelected then
				return goal
			else
				return default
			end
		end,
		IsSelected,
		StyleGuide:GetColor(PseudoEnum.GuiColorPalette.Surface2),
		StyleGuide:GetColor(PseudoEnum.GuiColorPalette.Secondary1)
	)

	local TextColor3 = _Computed(function(back: Color3, goal: Color3): Color3
		return StyleGuide.getReadableColor(goal, back)
	end, BackgroundColor3, StyleGuide:GetContrastColor(PseudoEnum.GuiColorPalette.Surface1))

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
		TextSize = StyleGuide:GetTextSize(PseudoEnum.GuiTypography.Headline6),
		Padding = StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.Low),
		TextOnly = false,
		Text = nil,
		Visible = enabledState,
		LayoutOrder = layoutOrder,
		AnchorPoint = Vector2.new(0.5, 0.5),
		-- Size = UDim2.fromScale(1,1),
		-- SizeConstraint = Enum.SizeConstraint.RelativeYY,
		ClickSound = GuiLibrary.Sound.Click,
		CornerRadius = UDim.new(0, 0),
		Parent = self.Instance:WaitForChild("ButtonContainer"),
		LeftIcon = icon,
		RightIcon = nil,
	})
	if signal then
		local activated = button:WaitForChild("Activated") :: BindableEvent
		self._Maid:GiveTask(activated.Event:Connect(function()
			signal:Fire(path)
		end))
	end
	maid:GiveTask(button)
	maid:GiveTask(button.Destroying:Connect(function()
		maid:Destroy()
	end))
	return button
end

function Menu:Destroy()
	self._Maid:Destroy()
	local t: any = self
	for k, v in pairs(t) do
		t[k] = nil
	end
	setmetatable(t, nil)
	return nil
end

function Menu.new(): Menu

	local _maid = Maid.new()
	local _buildMaid = Maid.new()
	_maid:GiveTask(_buildMaid)

	local _synth = Synthetic(_maid)
	local _fuse = ColdFusion.fuse(_maid)
	local _library = GuiLibrary.new(_maid)
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	-- Parameter states
	-- Private states
	local Visible = _Value(true)
	local BarHeight = _Computed(
		function(textSize: number, padding: UDim)
			return textSize + padding.Offset
		end,
		StyleGuide:GetTextSize(PseudoEnum.GuiTypography.Headline5),
		StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.Default)
	)
	local CurrencyFrameVisible = _Value(false)

	local CurrencyFrame: Frame = _new("Frame")({
		BackgroundColor3 = StyleGuide:GetColor(PseudoEnum.GuiColorPalette.Surface1),
		AutomaticSize = Enum.AutomaticSize.XY,
		LayoutOrder = 0,
		Visible = CurrencyFrameVisible,
		Children = {
			_library.Effect:GetUICorner() :: any,
			_library.Layout:GetHorizontalList(PseudoEnum.GuiAlignmentType.Center, PseudoEnum.GuiDensityModifier.High),
			_new("UIPadding")({
				PaddingLeft = _Computed(function(txtSize: number)
					return UDim.new(0, txtSize)
				end, StyleGuide:GetTextSize(PseudoEnum.GuiTypography.Body1)),
				PaddingRight = _Computed(function(txtSize: number)
					return UDim.new(0, txtSize)
				end, StyleGuide:GetTextSize(PseudoEnum.GuiTypography.Body1)),
				PaddingTop = StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.Default),
				PaddingBottom = StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.High),
			}),
		},
	}) :: any

	local inst: Frame = _new("Frame")({
		AutomaticSize = Enum.AutomaticSize.XY,
		AnchorPoint = _Computed(function(vis: boolean)
			if vis then
				return Vector2.new(0.5, 0.5)
			else
				return Vector2.new(0.5, 1)
			end
		end, Visible):Tween(0.2),
		Size = UDim2.fromOffset(0, 0),
		Position = _Computed(function(vis: boolean)
			return UDim2.new(0.5, 0, 0, if vis then 0 else -TOP_BAR_INSET)
		end, Visible):Tween(0.2),
		BackgroundTransparency = 1,
		ZIndex = 100,
		BorderSizePixel = 0,
		Name = "Menu",
		Children = {
			_new("UIPadding")({
				PaddingTop = StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.Default),
				PaddingBottom = UDim.new(0, 0), --StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.Default),
				PaddingLeft = UDim.new(0, 0), --StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.Default),
				PaddingRight = UDim.new(0, 0), --StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.Default),
			}),
			_new("UIListLayout")({
				Padding = UDim.new(0, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
			}),

			_new("Frame")({
				Name = "ButtonContainer",
				LayoutOrder = 2,
				BackgroundTransparency = 0,
				AutomaticSize = Enum.AutomaticSize.XY,
				ClipsDescendants = true,
				Size = UDim2.fromOffset(0, 0),
				BackgroundColor3 = StyleGuide:GetColor(PseudoEnum.GuiColorPalette.Surface2),
				AnchorPoint = Vector2.new(0, 1),
				Children = {
					_new("UICorner")({
						CornerRadius = StyleGuide.CornerRadius,
					}) :: any,
					-- _new("UIListLayout")({
					-- 	Padding = UDim.new(0,0),
					-- 	SortOrder = Enum.SortOrder.LayoutOrder,
					-- 	FillDirection = Enum.FillDirection.Horizontal,
					-- 	HorizontalAlignment = Enum.HorizontalAlignment.Center,
					-- 	VerticalAlignment = Enum.VerticalAlignment.Center,
					-- }),
					_library.Layout:GetHorizontalList(PseudoEnum.GuiAlignmentType.Top),
					-- CurrencyFrame
					_new("Frame")({
						BackgroundTransparency = 1,
						AutomaticSize = Enum.AutomaticSize.X,
						Size = _Computed(
							function(txtSize: number, pad: UDim)
								return UDim2.fromOffset(0, txtSize + pad.Offset * 2)
							end,
							StyleGuide:GetTextSize(PseudoEnum.GuiTypography.Headline6),
							StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.Low)
						),
						Children = {
							_library.Layout:GetVerticalList(PseudoEnum.GuiAlignmentType.Center) :: any,
							-- _library.Layout:GetUIPadding(PseudoEnum.GuiDensityModifier.High)
							_new("UIPadding")({
								PaddingTop = StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.Default),
								PaddingBottom = UDim.new(0, 0), --StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.Default),
								PaddingLeft = UDim.new(0, 0), --StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.Default),
								PaddingRight = StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.High), --StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.Default),
							}),
							CurrencyFrame,
						},
					}),
				},
			}),
			_new("Frame")({
				Name = "Filler",
				LayoutOrder = 1,
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.X,
				Size = _Computed(function(height)
					return UDim2.fromOffset(0, height)
				end, BarHeight),
			}),
		} :: { [number]: any },
	}) :: any

	local self: Menu = setmetatable({}, Menu) :: any
	self._Maid = _maid
	self.Instance = inst
	self._Currencies = {}
	self._CurrencyFrame = CurrencyFrame

	local OnHomeClick = Signal.new()
	_maid:GiveTask(OnHomeClick)

	local OnBackClick = Signal.new()
	_maid:GiveTask(OnBackClick)

	local OnSettingsClick = Signal.new()
	_maid:GiveTask(OnSettingsClick)

	return self
end

return Menu
