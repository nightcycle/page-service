export type ObjectProperties = {}
export type InstanceProperties = ObjectProperties & {
	Archivable: boolean?,
	Name: string?,
	Parent: Instance?,
	children: { [string]: any }?,
}
export type UIBaseProperties = InstanceProperties
export type UIComponentProperties = UIBaseProperties
export type UIConstraintProperties = UIComponentProperties
export type UIAspectRatioConstraintProperties = UIConstraintProperties & {
	AspectRatio: number?,
	AspectType: Enum.AspectType?,
	DominantAxis: Enum.DominantAxis?,
}
export type UISizeConstraintProperties = UIConstraintProperties & {
	MaxSize: Vector2?,
	MinSize: Vector2?,
}
export type UITextSizeConstraintProperties = UIConstraintProperties & {
	MaxTextSize: number?,
	MinTextSize: number?,
}
export type UICornerProperties = UIComponentProperties & {
	CornerRadius: UDim?,
}
export type UIDragDetectorProperties = UIComponentProperties & {
	ActivatedCursorIcon: string?,
	BoundingBehavior: Enum.UIDragDetectorBoundingBehavior?,
	BoundingUI: GuiBase2d?,
	CursorIcon: string?,
	DragAxis: Vector2?,
	DragRelativity: Enum.UIDragDetectorDragRelativity?,
	DragRotation: number?,
	DragSpace: Enum.UIDragDetectorDragSpace?,
	DragStyle: Enum.UIDragDetectorDragStyle?,
	DragUDim2: UDim2?,
	Enabled: boolean?,
	MaxDragAngle: number?,
	MaxDragTranslation: UDim2?,
	MinDragAngle: number?,
	MinDragTranslation: UDim2?,
	ReferenceUIInstance: GuiObject?,
	ResponseStyle: Enum.UIDragDetectorResponseStyle?,
	SelectionModeDragSpeed: UDim2?,
	SelectionModeRotateSpeed: number?,
	UIDragSpeedAxisMapping: Enum.UIDragSpeedAxisMapping?,
}
export type UIFlexItemProperties = UIComponentProperties & {
	FlexMode: Enum.UIFlexMode?,
	GrowRatio: number?,
	ItemLineAlignment: Enum.ItemLineAlignment?,
	ShrinkRatio: number?,
}
export type UIGradientProperties = UIComponentProperties & {
	Color: ColorSequence?,
	Enabled: boolean?,
	Offset: Vector2?,
	Rotation: number?,
	Transparency: NumberSequence?,
}
export type UILayoutProperties = UIComponentProperties
export type UIGridStyleLayoutProperties = UILayoutProperties & {
	FillDirection: Enum.FillDirection?,
	HorizontalAlignment: Enum.HorizontalAlignment?,
	SortOrder: Enum.SortOrder?,
	VerticalAlignment: Enum.VerticalAlignment?,
}
export type UIGridLayoutProperties = UIGridStyleLayoutProperties & {
	CellPadding: UDim2?,
	CellSize: UDim2?,
	FillDirectionMaxCells: number?,
	StartCorner: Enum.StartCorner?,
}
export type UIListLayoutProperties = UIGridStyleLayoutProperties & {
	HorizontalFlex: Enum.UIFlexAlignment?,
	ItemLineAlignment: Enum.ItemLineAlignment?,
	Padding: UDim?,
	VerticalFlex: Enum.UIFlexAlignment?,
	Wraps: boolean?,
}
export type UIPageLayoutProperties = UIGridStyleLayoutProperties & {
	Animated: boolean?,
	Circular: boolean?,
	EasingDirection: Enum.EasingDirection?,
	EasingStyle: Enum.EasingStyle?,
	GamepadInputEnabled: boolean?,
	Padding: UDim?,
	ScrollWheelInputEnabled: boolean?,
	TouchInputEnabled: boolean?,
	TweenTime: number?,
}
export type UITableLayoutProperties = UIGridStyleLayoutProperties & {
	FillEmptySpaceColumns: boolean?,
	FillEmptySpaceRows: boolean?,
	MajorAxis: Enum.TableMajorAxis?,
	Padding: UDim2?,
}
export type UIPaddingProperties = UIComponentProperties & {
	PaddingBottom: UDim?,
	PaddingLeft: UDim?,
	PaddingRight: UDim?,
	PaddingTop: UDim?,
}
export type UIScaleProperties = UIComponentProperties & {
	Scale: number?,
}
export type UIStrokeProperties = UIComponentProperties & {
	ApplyStrokeMode: Enum.ApplyStrokeMode?,
	Color: Color3?,
	Enabled: boolean?,
	LineJoinMode: Enum.LineJoinMode?,
	Thickness: number?,
	Transparency: number?,
}
export type GuiBaseProperties = InstanceProperties
export type GuiBase2dProperties = GuiBaseProperties & {
	AutoLocalize: boolean?,
	RootLocalizationTable: LocalizationTable?,
	SelectionBehaviorDown: Enum.SelectionBehavior?,
	SelectionBehaviorLeft: Enum.SelectionBehavior?,
	SelectionBehaviorRight: Enum.SelectionBehavior?,
	SelectionBehaviorUp: Enum.SelectionBehavior?,
	SelectionGroup: boolean?,
}
export type GuiObjectProperties = GuiBase2dProperties & {
	Active: boolean?,
	AnchorPoint: Vector2?,
	AutomaticSize: Enum.AutomaticSize?,
	BackgroundColor3: Color3?,
	BackgroundTransparency: number?,
	BorderColor3: Color3?,
	BorderMode: Enum.BorderMode?,
	BorderSizePixel: number?,
	ClipsDescendants: boolean?,
	Interactable: boolean?,
	LayoutOrder: number?,
	NextSelectionDown: GuiObject?,
	NextSelectionLeft: GuiObject?,
	NextSelectionRight: GuiObject?,
	NextSelectionUp: GuiObject?,
	Position: UDim2?,
	Rotation: number?,
	Selectable: boolean?,
	SelectionImageObject: GuiObject?,
	SelectionOrder: number?,
	Size: UDim2?,
	SizeConstraint: Enum.SizeConstraint?,
	Transparency: number?,
	Visible: boolean?,
	ZIndex: number?,
}
export type CanvasGroupProperties = GuiObjectProperties & {
	GroupColor3: Color3?,
	GroupTransparency: number?,
}
export type FrameProperties = GuiObjectProperties & {
	Style: Enum.FrameStyle?,
}
export type GuiButtonProperties = GuiObjectProperties & {
	AutoButtonColor: boolean?,
	Modal: boolean?,
	Selected: boolean?,
	Style: Enum.ButtonStyle?,
}
export type ImageButtonProperties = GuiButtonProperties & {
	HoverImage: string?,
	Image: string?,
	ImageColor3: Color3?,
	ImageContent: Content?,
	ImageRectOffset: Vector2?,
	ImageRectSize: Vector2?,
	ImageTransparency: number?,
	PressedImage: string?,
	ResampleMode: Enum.ResamplerMode?,
	ScaleType: Enum.ScaleType?,
	SliceCenter: Rect?,
	SliceScale: number?,
	TileSize: UDim2?,
}
export type TextButtonProperties = GuiButtonProperties & {
	Font: Enum.Font?,
	FontFace: Font?,
	LineHeight: number?,
	MaxVisibleGraphemes: number?,
	OpenTypeFeatures: string?,
	RichText: boolean?,
	Text: string?,
	TextColor3: Color3?,
	TextDirection: Enum.TextDirection?,
	TextScaled: boolean?,
	TextSize: number?,
	TextStrokeColor3: Color3?,
	TextStrokeTransparency: number?,
	TextTransparency: number?,
	TextTruncate: Enum.TextTruncate?,
	TextWrapped: boolean?,
	TextXAlignment: Enum.TextXAlignment?,
	TextYAlignment: Enum.TextYAlignment?,
}
export type GuiLabelProperties = GuiObjectProperties
export type ImageLabelProperties = GuiLabelProperties & {
	Image: string?,
	ImageColor3: Color3?,
	ImageContent: Content?,
	ImageRectOffset: Vector2?,
	ImageRectSize: Vector2?,
	ImageTransparency: number?,
	ResampleMode: Enum.ResamplerMode?,
	ScaleType: Enum.ScaleType?,
	SliceCenter: Rect?,
	SliceScale: number?,
	TileSize: UDim2?,
}
export type TextLabelProperties = GuiLabelProperties & {
	Font: Enum.Font?,
	FontFace: Font?,
	LineHeight: number?,
	MaxVisibleGraphemes: number?,
	OpenTypeFeatures: string?,
	RichText: boolean?,
	Text: string?,
	TextColor3: Color3?,
	TextDirection: Enum.TextDirection?,
	TextScaled: boolean?,
	TextSize: number?,
	TextStrokeColor3: Color3?,
	TextStrokeTransparency: number?,
	TextTransparency: number?,
	TextTruncate: Enum.TextTruncate?,
	TextWrapped: boolean?,
	TextXAlignment: Enum.TextXAlignment?,
	TextYAlignment: Enum.TextYAlignment?,
}
export type ScrollingFrameProperties = GuiObjectProperties & {
	AutomaticCanvasSize: Enum.AutomaticSize?,
	BottomImage: string?,
	CanvasPosition: Vector2?,
	CanvasSize: UDim2?,
	ElasticBehavior: Enum.ElasticBehavior?,
	HorizontalScrollBarInset: Enum.ScrollBarInset?,
	MidImage: string?,
	ScrollBarImageColor3: Color3?,
	ScrollBarImageTransparency: number?,
	ScrollBarThickness: number?,
	ScrollingDirection: Enum.ScrollingDirection?,
	ScrollingEnabled: boolean?,
	TopImage: string?,
	VerticalScrollBarInset: Enum.ScrollBarInset?,
	VerticalScrollBarPosition: Enum.VerticalScrollBarPosition?,
}
export type TextBoxProperties = GuiObjectProperties & {
	ClearTextOnFocus: boolean?,
	CursorPosition: number?,
	Font: Enum.Font?,
	FontFace: Font?,
	LineHeight: number?,
	MaxVisibleGraphemes: number?,
	MultiLine: boolean?,
	OpenTypeFeatures: string?,
	PlaceholderColor3: Color3?,
	PlaceholderText: string?,
	RichText: boolean?,
	SelectionStart: number?,
	ShowNativeInput: boolean?,
	Text: string?,
	TextColor3: Color3?,
	TextDirection: Enum.TextDirection?,
	TextEditable: boolean?,
	TextScaled: boolean?,
	TextSize: number?,
	TextStrokeColor3: Color3?,
	TextStrokeTransparency: number?,
	TextTransparency: number?,
	TextTruncate: Enum.TextTruncate?,
	TextWrapped: boolean?,
	TextXAlignment: Enum.TextXAlignment?,
	TextYAlignment: Enum.TextYAlignment?,
}
export type VideoFrameProperties = GuiObjectProperties & {
	Looped: boolean?,
	Playing: boolean?,
	TimePosition: number?,
	Video: string?,
	Volume: number?,
}
export type ViewportFrameProperties = GuiObjectProperties & {
	Ambient: Color3?,
	CurrentCamera: Camera?,
	ImageColor3: Color3?,
	ImageTransparency: number?,
	LightColor: Color3?,
	LightDirection: Vector3?,
}
export type LayerCollectorProperties = GuiBase2dProperties & {
	Enabled: boolean?,
	ResetOnSpawn: boolean?,
	ZIndexBehavior: Enum.ZIndexBehavior?,
}
export type BillboardGuiProperties = LayerCollectorProperties & {
	Active: boolean?,
	Adornee: Instance?,
	AlwaysOnTop: boolean?,
	Brightness: number?,
	ClipsDescendants: boolean?,
	DistanceLowerLimit: number?,
	DistanceStep: number?,
	DistanceUpperLimit: number?,
	ExtentsOffset: Vector3?,
	ExtentsOffsetWorldSpace: Vector3?,
	LightInfluence: number?,
	MaxDistance: number?,
	PlayerToHideFrom: Instance?,
	Size: UDim2?,
	SizeOffset: Vector2?,
	StudsOffset: Vector3?,
	StudsOffsetWorldSpace: Vector3?,
}
export type PluginGuiProperties = LayerCollectorProperties & {
	Title: string?,
}
export type DockWidgetPluginGuiProperties = PluginGuiProperties
export type QWidgetPluginGuiProperties = PluginGuiProperties
export type ScreenGuiProperties = LayerCollectorProperties & {
	ClipToDeviceSafeArea: boolean?,
	DisplayOrder: number?,
	IgnoreGuiInset: boolean?,
	SafeAreaCompatibility: Enum.SafeAreaCompatibility?,
	ScreenInsets: Enum.ScreenInsets?,
}
export type GuiMainProperties = ScreenGuiProperties
export type SurfaceGuiBaseProperties = LayerCollectorProperties & {
	Active: boolean?,
	Adornee: Instance?,
	Face: Enum.NormalId?,
}
export type AdGuiProperties = SurfaceGuiBaseProperties & {
	AdShape: Enum.AdShape?,
	EnableVideoAds: boolean?,
	FallbackImage: string?,
}
export type SurfaceGuiProperties = SurfaceGuiBaseProperties & {
	AlwaysOnTop: boolean?,
	Brightness: number?,
	CanvasSize: Vector2?,
	ClipsDescendants: boolean?,
	LightInfluence: number?,
	MaxDistance: number?,
	PixelsPerStud: number?,
	SizingMode: Enum.SurfaceGuiSizingMode?,
	ToolPunchThroughDistance: number?,
	ZOffset: number?,
}
export type GuiBase3dProperties = GuiBaseProperties & {
	Color3: Color3?,
	Transparency: number?,
	Visible: boolean?,
}
export type FloorWireProperties = GuiBase3dProperties & {
	CycleOffset: number?,
	From: BasePart?,
	StudsBetweenTextures: number?,
	Texture: string?,
	TextureSize: Vector2?,
	To: BasePart?,
	Velocity: number?,
	WireRadius: number?,
}
export type InstanceAdornmentProperties = GuiBase3dProperties & {
	Adornee: Instance?,
}
export type SelectionBoxProperties = InstanceAdornmentProperties & {
	LineThickness: number?,
	SurfaceColor3: Color3?,
	SurfaceTransparency: number?,
}
export type PVAdornmentProperties = GuiBase3dProperties & {
	Adornee: PVInstance?,
}
export type HandleAdornmentProperties = PVAdornmentProperties & {
	AdornCullingMode: Enum.AdornCullingMode?,
	AlwaysOnTop: boolean?,
	CFrame: CFrame?,
	SizeRelativeOffset: Vector3?,
	ZIndex: number?,
}
export type BoxHandleAdornmentProperties = HandleAdornmentProperties & {
	Size: Vector3?,
}
export type ConeHandleAdornmentProperties = HandleAdornmentProperties & {
	Height: number?,
	Radius: number?,
}
export type CylinderHandleAdornmentProperties = HandleAdornmentProperties & {
	Angle: number?,
	Height: number?,
	InnerRadius: number?,
	Radius: number?,
}
export type ImageHandleAdornmentProperties = HandleAdornmentProperties & {
	Image: string?,
	Size: Vector2?,
}
export type LineHandleAdornmentProperties = HandleAdornmentProperties & {
	Length: number?,
	Thickness: number?,
}
export type SphereHandleAdornmentProperties = HandleAdornmentProperties & {
	Radius: number?,
}
export type WireframeHandleAdornmentProperties = HandleAdornmentProperties & {
	Scale: Vector3?,
}
export type ParabolaAdornmentProperties = PVAdornmentProperties
export type SelectionSphereProperties = PVAdornmentProperties & {
	SurfaceColor3: Color3?,
	SurfaceTransparency: number?,
}
export type PartAdornmentProperties = GuiBase3dProperties & {
	Adornee: BasePart?,
}
export type HandlesBaseProperties = PartAdornmentProperties
export type ArcHandlesProperties = HandlesBaseProperties & {
	Axes: Axes?,
}
export type HandlesProperties = HandlesBaseProperties & {
	Faces: Faces?,
	Style: Enum.HandlesStyle?,
}
export type SurfaceSelectionProperties = PartAdornmentProperties & {
	TargetSurface: Enum.NormalId?,
}
export type SelectionLassoProperties = GuiBase3dProperties & {
	Humanoid: Humanoid?,
}
export type SelectionPartLassoProperties = SelectionLassoProperties & {
	Part: BasePart?,
}
export type SelectionPointLassoProperties = SelectionLassoProperties & {
	Point: Vector3?,
}
export type Path2DProperties = GuiBaseProperties & {
	Closed: boolean?,
	Color3: Color3?,
	Thickness: number?,
	Visible: boolean?,
	ZIndex: number?,
}
-- Services
-- Packages
local React = require("@wally/React")
-- Modules
-- Types
-- Constants
-- Variables
-- References
-- Private Functions
local e = React.createElement
-- Class
local Util = {}

function Util.mergeInstance(
	element: InstanceProperties,
	props: InstanceProperties
): InstanceProperties
	local out = {
		Archivable = if element.Archivable ~= nil
			then element.Archivable
			else props.Archivable,
		Name = element.Name or props.Name,
		children = e(React.Fragment, {}, element.children or {}, props.children or {}),
	}
	for k, v in pairs(element) do
		if typeof(k) ~= "string" then
			out[k] = v
		end
	end
	for k, v in pairs(props) do
		if typeof(k) ~= "string" then
			out[k] = v
		end
	end

	return out
end

Util.mergeGuiBase = Util.mergeInstance

function Util.mergeGuiBase2D(
	element: GuiBase2dProperties,
	props: GuiBase2dProperties
): GuiBase2dProperties
	local out = Util.mergeGuiBase(element, props) :: GuiBase2dProperties
	out.AutoLocalize = if element.AutoLocalize ~= nil
		then element.AutoLocalize
		else props.AutoLocalize
	out.RootLocalizationTable = element.RootLocalizationTable
		or props.RootLocalizationTable
	out.SelectionBehaviorDown = element.SelectionBehaviorDown
		or props.SelectionBehaviorDown
	out.SelectionBehaviorLeft = element.SelectionBehaviorLeft
		or props.SelectionBehaviorLeft
	out.SelectionBehaviorRight = element.SelectionBehaviorRight
		or props.SelectionBehaviorRight
	out.SelectionBehaviorUp = element.SelectionBehaviorUp or props.SelectionBehaviorUp
	out.SelectionGroup = element.SelectionGroup or props.SelectionGroup
	return out
end

function Util.mergeLayerCollector(
	element: LayerCollectorProperties,
	props: LayerCollectorProperties
): LayerCollectorProperties
	local out = Util.mergeGuiBase2D(element, props) :: LayerCollectorProperties
	out.Enabled = if element.Enabled ~= nil then element.Enabled else props.Enabled
	out.ResetOnSpawn = if element.ResetOnSpawn ~= nil
		then element.ResetOnSpawn
		else props.ResetOnSpawn
	out.ZIndexBehavior = element.ZIndexBehavior or props.ZIndexBehavior
	return out
end

function Util.mergeScreenGui(
	element: ScreenGuiProperties,
	props: ScreenGuiProperties
)
	local out = Util.mergeLayerCollector(element, props) :: ScreenGuiProperties
	out.ClipToDeviceSafeArea = if element.ClipToDeviceSafeArea ~= nil
		then element.ClipToDeviceSafeArea
		else props.ClipToDeviceSafeArea
	out.DisplayOrder = element.DisplayOrder or props.DisplayOrder
	out.IgnoreGuiInset = if element.IgnoreGuiInset ~= nil
		then element.IgnoreGuiInset
		else props.IgnoreGuiInset
	out.SafeAreaCompatibility = element.SafeAreaCompatibility
		or props.SafeAreaCompatibility
	out.ScreenInsets = element.ScreenInsets or props.ScreenInsets
	return out
end

function Util.mergeGuiObject(
	element: GuiObjectProperties,
	props: GuiObjectProperties
): GuiObjectProperties
	local out = Util.mergeGuiBase2D(element, props) :: GuiObjectProperties
	out.Active = if element.Active ~= nil then element.Active else props.Active
	out.AnchorPoint = element.AnchorPoint or props.AnchorPoint
	out.AutomaticSize = element.AutomaticSize or props.AutomaticSize
	out.BackgroundColor3 = element.BackgroundColor3 or props.BackgroundColor3
	out.BackgroundTransparency = element.BackgroundTransparency
		or props.BackgroundTransparency
	out.BorderColor3 = element.BorderColor3 or props.BorderColor3
	out.BorderMode = element.BorderMode or props.BorderMode
	out.BorderSizePixel = element.BorderSizePixel or props.BorderSizePixel
	out.ClipsDescendants = if element.ClipsDescendants ~= nil
		then element.ClipsDescendants
		else props.ClipsDescendants
	out.Interactable = if element.Interactable ~= nil
		then element.Interactable
		else props.Interactable
	out.LayoutOrder = element.LayoutOrder or props.LayoutOrder
	out.NextSelectionDown = element.NextSelectionDown or props.NextSelectionDown
	out.NextSelectionLeft = element.NextSelectionLeft or props.NextSelectionLeft
	out.NextSelectionRight = element.NextSelectionRight or props.NextSelectionRight
	out.NextSelectionUp = element.NextSelectionUp or props.NextSelectionUp
	out.Position = element.Position or props.Position
	out.Rotation = element.Rotation or props.Rotation
	out.Selectable = if element.Selectable ~= nil
		then element.Selectable
		else props.Selectable
	out.SelectionImageObject = element.SelectionImageObject or props.SelectionImageObject
	out.SelectionOrder = element.SelectionOrder or props.SelectionOrder
	out.Size = element.Size or props.Size
	out.SizeConstraint = element.SizeConstraint or props.SizeConstraint
	out.Transparency = element.Transparency or props.Transparency
	out.Visible = if element.Visible ~= nil then element.Visible else props.Visible
	out.ZIndex = element.ZIndex or props.ZIndex

	return out
end

function Util.mergeFrame(
	element: FrameProperties,
	props: FrameProperties
): FrameProperties
	local out = Util.mergeGuiObject(element, props) :: FrameProperties
	out.Style = element.Style or props.Style
	return out
end

function Util.mergeImageLabel(
	element: ImageLabelProperties,
	props: ImageLabelProperties
): ImageLabelProperties
	local out = Util.mergeGuiObject(element, props) :: ImageLabelProperties
	out.Image = element.Image or props.Image
	out.ImageContent = element.ImageContent or props.ImageContent
	out.ImageColor3 = element.ImageColor3 or props.ImageColor3
	out.ImageRectOffset = element.ImageRectOffset or props.ImageRectOffset
	out.ImageRectSize = element.ImageRectSize or props.ImageRectSize
	out.ImageTransparency = element.ImageTransparency or props.ImageTransparency
	out.ResampleMode = element.ResampleMode or props.ResampleMode
	out.ScaleType = element.ScaleType or props.ScaleType
	out.SliceCenter = element.SliceCenter or props.SliceCenter
	out.SliceScale = element.SliceScale or props.SliceScale
	out.TileSize = element.TileSize or props.TileSize
	return out
end

function Util.mergeGuiButton(
	element: GuiButtonProperties,
	props: GuiButtonProperties
): GuiButtonProperties
	local out = Util.mergeGuiObject(element, props) :: GuiButtonProperties
	out.AutoButtonColor = if element.AutoButtonColor ~= nil
		then element.AutoButtonColor
		else props.AutoButtonColor
	out.Modal = if element.Modal ~= nil then element.Modal else props.Modal
	out.Selected = if element.Selected ~= nil then element.Selected else props.Selected
	out.Style = element.Style or props.Style
	return out
end

function Util.mergeImageButton(
	element: ImageButtonProperties,
	props: ImageButtonProperties
): ImageButtonProperties
	local out = Util.mergeGuiButton(element, props) :: ImageButtonProperties
	out.Image = element.Image or props.Image
	out.ImageContent = element.ImageContent or props.ImageContent
	out.ImageColor3 = element.ImageColor3 or props.ImageColor3
	out.ImageRectOffset = element.ImageRectOffset or props.ImageRectOffset
	out.ImageRectSize = element.ImageRectSize or props.ImageRectSize
	out.ImageTransparency = element.ImageTransparency or props.ImageTransparency
	out.ScaleType = element.ScaleType or props.ScaleType
	out.SliceCenter = element.SliceCenter or props.SliceCenter
	out.SliceScale = element.SliceScale or props.SliceScale
	out.TileSize = element.TileSize or props.TileSize
	return out
end

function Util.mergeScrollingFrame(
	element: ScrollingFrameProperties,
	props: ScrollingFrameProperties
): ScrollingFrameProperties
	local out =
		Util.mergeGuiObject(element, props) :: ScrollingFrameProperties
	out.AutomaticCanvasSize = element.AutomaticCanvasSize or props.AutomaticCanvasSize
	out.BottomImage = element.BottomImage or props.BottomImage
	out.CanvasPosition = element.CanvasPosition or props.CanvasPosition
	out.CanvasSize = element.CanvasSize or props.CanvasSize
	out.ElasticBehavior = element.ElasticBehavior or props.ElasticBehavior
	out.HorizontalScrollBarInset = element.HorizontalScrollBarInset
		or props.HorizontalScrollBarInset
	out.MidImage = element.MidImage or props.MidImage
	out.ScrollBarImageColor3 = element.ScrollBarImageColor3 or props.ScrollBarImageColor3
	out.ScrollBarImageTransparency = element.ScrollBarImageTransparency
		or props.ScrollBarImageTransparency
	out.ScrollBarThickness = element.ScrollBarThickness or props.ScrollBarThickness
	out.ScrollingDirection = element.ScrollingDirection or props.ScrollingDirection
	out.ScrollingEnabled = element.ScrollingEnabled or props.ScrollingEnabled
	out.TopImage = element.TopImage or props.TopImage
	out.VerticalScrollBarInset = element.VerticalScrollBarInset
		or props.VerticalScrollBarInset
	out.VerticalScrollBarPosition = element.VerticalScrollBarPosition
		or props.VerticalScrollBarPosition
	return out
end

Util.mergeUIBase = Util.mergeInstance

Util.mergeUIComponent = Util.mergeUIBase

function Util.mergeUIGradient(
	element: UIGradientProperties,
	props: UIGradientProperties
): UIGradientProperties
	local out = Util.mergeUIComponent(element, props) :: UIGradientProperties
	out.Color = element.Color or props.Color
	out.Rotation = element.Rotation or props.Rotation
	out.Transparency = element.Transparency or props.Transparency
	out.Offset = element.Offset or props.Offset
	out.Enabled = element.Enabled or props.Enabled

	return out
end

Util.mergeGuiLabel = Util.mergeGuiObject

function Util.mergeTextLabel(
	element: TextLabelProperties,
	props: TextLabelProperties
): TextLabelProperties
	local out = Util.mergeGuiLabel(element, props) :: TextLabelProperties
	out.Font = element.Font or props.Font
	out.LineHeight = element.LineHeight or props.LineHeight
	out.RichText = if element.RichText ~= nil then element.RichText else props.RichText
	out.Text = element.Text or props.Text
	out.TextColor3 = element.TextColor3 or props.TextColor3
	out.TextScaled = if element.TextScaled ~= nil
		then element.TextScaled
		else props.TextScaled
	out.TextSize = element.TextSize or props.TextSize
	out.TextStrokeColor3 = element.TextStrokeColor3 or props.TextStrokeColor3
	out.TextStrokeTransparency = element.TextStrokeTransparency
		or props.TextStrokeTransparency
	out.TextTransparency = element.TextTransparency or props.TextTransparency
	out.TextWrapped = if element.TextWrapped ~= nil
		then element.TextWrapped
		else props.TextWrapped
	out.TextXAlignment = element.TextXAlignment or props.TextXAlignment
	out.TextYAlignment = element.TextYAlignment or props.TextYAlignment

	out.FontFace = element.FontFace or props.FontFace
	out.MaxVisibleGraphemes = element.MaxVisibleGraphemes or props.MaxVisibleGraphemes
	out.OpenTypeFeatures = element.OpenTypeFeatures or props.OpenTypeFeatures
	out.TextDirection = element.TextDirection or props.TextDirection
	out.TextTruncate = element.TextTruncate or props.TextTruncate

	return out
end

return Util