--!strict
-- Services
-- Packages
-- Modules
local Types = require(script:WaitForChild('Types'))
local Style = require(script:WaitForChild('Style'))
local Enums = require(script:WaitForChild('Enums'))
-- Components

local Button = require(script:WaitForChild('Component'):WaitForChild('Button'))
local ButtonContainer = require(script:WaitForChild('Component'):WaitForChild('ButtonContainer'))
local Checkbox = require(script:WaitForChild('Component'):WaitForChild('Checkbox'))
local Container = require(script:WaitForChild('Component'):WaitForChild('Container'))
local IconDisplay = require(script:WaitForChild('Component'):WaitForChild('IconDisplay'))
local Menu = require(script:WaitForChild('Component'):WaitForChild('Menu'))
local Padding = require(script:WaitForChild('Component'):WaitForChild('Padding'))
local PopUp = require(script:WaitForChild('Component'):WaitForChild('PopUp'))
local PopUpContainer = require(script:WaitForChild('Component'):WaitForChild('PopUpContainer'))
local ProgressIndicatorCircular = require(script:WaitForChild('Component'):WaitForChild('ProgressIndicator'):WaitForChild('Circular'))
local ScrollingContainer = require(script:WaitForChild('Component'):WaitForChild('ScrollingContainer'))
local ShadowFrame = require(script:WaitForChild('Component'):WaitForChild('ShadowFrame'))
local Slider = require(script:WaitForChild('Component'):WaitForChild('Slider'))
local Switch = require(script:WaitForChild('Component'):WaitForChild('Switch'))
local RadioButton = require(script:WaitForChild('Component'):WaitForChild('RadioButton'))
local TextDisplay = require(script:WaitForChild('Component'):WaitForChild('TextDisplay'))
local TextField = require(script:WaitForChild('Component'):WaitForChild('TextField'))
-- Types

export type ImageData = Types.ImageData
export type ButtonData = Types.ButtonData
export type FontData = Types.FontData
export type Style = Style.Style
export type Typography = Style.Typography
export type Theme = Style.Theme
export type SoundType = Enums.SoundType
export type FontType = Enums.FontType
export type ButtonStateType = Enums.ButtonStateType
export type SchemeType = Enums.SchemeType
export type CustomColorType = Enums.CustomColorType
export type SelectionState = Enums.SelectionState
export type ColorRoleType = Enums.ColorRoleType
export type PaletteType = Enums.PaletteType
export type TransitionType = Enums.TransitionType
export type ButtonProperties = Button.ButtonProperties
export type StyleButtonProperties = Button.StyleButtonProperties
export type ButtonContainerContentProperties =
	ButtonContainer.ButtonContainerContentProperties
export type ButtonContainerProperties = ButtonContainer.ButtonContainerProperties
export type CheckboxProperties = Checkbox.CheckboxProperties
export type StyleCheckboxProperties = Checkbox.StyleCheckboxProperties
export type IconDisplayProperties = IconDisplay.IconDisplayProperties
export type MenuProperties = Menu.MenuProperties
export type StylePaddingProperties = Padding.StylePaddingProperties
export type StylePaddingSimpleProperties = Padding.StylePaddingSimpleProperties
export type PopUpProperties = PopUp.PopUpProperties
export type PopUpContainerProperties = PopUpContainer.PopUpContainerProperties
export type ProgressIndicatorCircularProperties =
	ProgressIndicatorCircular.ProgressIndicatorCircularProperties
export type ShadowFrameProperties = ShadowFrame.ShadowFrameProperties
export type SliderProperties = Slider.SliderProperties
export type StyleSliderProperties = Slider.StyleSliderProperties
export type SwitchProperties = Switch.SwitchProperties
export type StyleSwitchProperties = Switch.StyleSwitchProperties
export type RadioButtonProperties = RadioButton.RadioButtonProperties
export type StyleRadioButtonProperties = RadioButton.StyleRadioButtonProperties
export type TextDisplayProperties = TextDisplay.TextDisplayProperties
export type StyleTextDisplayProperties = TextDisplay.StyleTextDisplayProperties
export type TextFieldProperties = TextField.TextFieldProperties
export type StyleTextFieldProperties = TextField.StyleTextFieldProperties
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local Synthetic = {}

Synthetic.Enums = Enums
Synthetic.Sounds = require(script:WaitForChild('Sounds'))

Synthetic.Transition = require(script:WaitForChild('Transition'))
Synthetic.Types = Types
Synthetic.Style = Style
Synthetic.Theme = require(script:WaitForChild('Theme'))
Synthetic.Typography = require(script:WaitForChild('Typography'))
Synthetic.Hook = require(script:WaitForChild('Hook'))
Synthetic.Component = {
	Button = Button,
	ButtonContainer = ButtonContainer,
	Checkbox = Checkbox,
	Container = Container,
	IconDisplay = IconDisplay,
	Menu = Menu,
	Padding = Padding,
	PopUp = PopUp,
	PopUpContainer = PopUpContainer,
	ProgressIndicator = {
		Circular = ProgressIndicatorCircular,
	},
	ScrollingContainer = ScrollingContainer,
	ShadowFrame = ShadowFrame,
	Slider = Slider,
	Switch = Switch,
	RadioButton = RadioButton,
	TextDisplay = TextDisplay,
	TextField = TextField,
}

return Synthetic
