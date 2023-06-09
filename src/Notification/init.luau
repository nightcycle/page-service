--!strict

-- Packages
local Package = script.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages ~= nil)
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

export type NotificationParameters = {
	AnchorPoint: ParameterValue<Vector2>?,
	Size: ParameterValue<UDim2>?,
	Position: ParameterValue<UDim2>?,
	Parent: ParameterValue<GuiObject>?,
}
export type NotificationFrame = {
	__index: NotificationFrame,
	_Maid: Maid,
	_IsAlive: boolean,
	Library: GuiLibrary.GuiLibrary,
	Index: number,
	Destroy: (self: NotificationFrame) -> nil,
	Instance: Frame,
	_OpenNotifications: { [string]: boolean },
	Fire: (
		self: NotificationFrame,
		text: string,
		lifetime: number?
	) -> nil,
	new: (config: NotificationParameters?) -> NotificationFrame,
}

local NotificationFrame: NotificationFrame = {} :: any
NotificationFrame.__index = NotificationFrame

function NotificationFrame:Fire(
	text: string,
	lifetime: number?
)
	if self._OpenNotifications[text] then
		return
	end
	self.Index += 1

	local maid =self._Maid:GiveTask(Maid.new())
	local _fuse = ColdFusion.fuse(maid)
	local _new = _fuse.new
	local _library = GuiLibrary.new(maid)
	local _bind = _fuse.bind
	local _import = _fuse.import

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	self._OpenNotifications[text] = true

	_new("Frame")({
		AnchorPoint = Vector2.new(0.5, 0.5),
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromScale(0, 0),
		BackgroundColor3 = StyleGuide:GetColor(PseudoEnum.GuiColorPalette.Secondary6),
		BackgroundTransparency = 0,
		LayoutOrder = 1000000 - self.Index,
		Parent = self.Instance,
		Children = {
			_new("TextLabel")({
				Name = "Text",
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				RichText = true,
				FontFace = StyleGuide:GetFont(PseudoEnum.GuiTypography.Body1),
				Text = text,
				TextTransparency = 0,
				TextSize = StyleGuide:GetTextSize(PseudoEnum.GuiTypography.Button),
				TextColor3 = StyleGuide:GetContrastColor(PseudoEnum.GuiColorPalette.Secondary6),
				TextScaled = false,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Center,
				Size = UDim2.fromScale(1, 0),
			}),
			_library.Effect:GetUICorner() :: any,
			_library.Layout:GetHorizontalList(PseudoEnum.GuiAlignmentType.Center, nil) :: any,
			_library.Layout:GetUIPadding(PseudoEnum.GuiDensityModifier.High),
		} :: { [number]: any },
	})

	task.delay(lifetime or string.len(text) / 5, function()
		pcall(function()
			self._OpenNotifications[text] = nil
			maid:Destroy()
		end)
	end)
	return nil
end

function NotificationFrame:Destroy()
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

function NotificationFrame.new(): NotificationFrame
	local maid = Maid.new()

	local _fuse = ColdFusion.fuse(maid)
	local _new = _fuse.new
	local _bind = _fuse.bind
	local _import = _fuse.import
	local _library = GuiLibrary.new(maid)

	local _Value = _fuse.Value
	local _Computed = _fuse.Computed

	local AnchorPoint = _Value(Vector2.new(0.5, 1))
	local Size = _Value(UDim2.fromScale(0.5, 1))
	local Position = _Value(UDim2.fromScale(0.5, 1))

	local self: NotificationFrame = setmetatable({}, NotificationFrame) :: any

	self._Maid = maid
	self._IsAlive = true
	self.Library = _library
	self.Index = 0
	self._OpenNotifications = {}
	self.Instance = _new("Frame")({
		AnchorPoint = AnchorPoint,
		Size = Size,
		Position = Position,
		BackgroundColor3 = StyleGuide:GetColor(PseudoEnum.GuiColorPalette.Secondary1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 15,
		Name = "NotificationFrame",
		Children = {
			_new("UIPadding")({
				PaddingTop = StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.Default),
				PaddingBottom = StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.Default),
				PaddingLeft = StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.Default),
				PaddingRight = StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.Default),
			}),
			_new("UIListLayout")({
				Padding = StyleGuide:GetPadding(PseudoEnum.GuiDensityModifier.Default),
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
			}),
		} :: { [number]: any },
	}) :: Frame

	self._Maid:GiveTask(self.Instance.Destroying:Connect(function()
		self:Destroy()
	end))

	return self
end

return NotificationFrame
