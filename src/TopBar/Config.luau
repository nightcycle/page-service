--!strict
-- source for official constants: https://github.com/MaximumADHD/Roblox-Client-Tracker/blob/roblox/scripts/CoreScripts/Modules/TopBar/Constants.lua
-- Services
local UserInputService = game:GetService("UserInputService")
-- Packages
-- Modules
-- Types
-- Constants
local IS_CHROME_ENABLED = true
local IS_NEW_TILT_ICON_ENABLED = true
local IS_DYNAMIC_TOP_BAR_HEIGHT = true
local IS_TEN_FOOT_MODE = false

local DEFAULT_TOPBAR_HEIGHT = 36
local DEFAULT_TOPBAR_BUTTON_HEIGHT = DEFAULT_TOPBAR_HEIGHT - 4
local DEFAULT_CHROME_TOPBAR_HEIGHT = 58
local DEFAULT_CHROME_TOPBAR_BUTTON_HEIGHT = 44
local DEFAULT_CHROME_MOBILE_TOPBAR_HEIGHT = 52

local TOP_BAR_HEIGHT = if IS_CHROME_ENABLED then 48 else 36
local TOP_BAR_BUTTON_HEIGHT = if IS_CHROME_ENABLED then DEFAULT_CHROME_TOPBAR_BUTTON_HEIGHT else DEFAULT_TOPBAR_BUTTON_HEIGHT
local TOP_BAR_BUTTON_PADDING = 2

if IS_DYNAMIC_TOP_BAR_HEIGHT then
	local function getChromeTopbarHeight()
		if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then --platform == Enum.Platform.IOS or platform == Enum.Platform.Android then
			return DEFAULT_CHROME_MOBILE_TOPBAR_HEIGHT
		end
		return DEFAULT_CHROME_TOPBAR_HEIGHT
	end
	
	local function getTopbarHeight()
		if not IS_NEW_TILT_ICON_ENABLED then
			return DEFAULT_TOPBAR_HEIGHT
		end
	
		if IS_CHROME_ENABLED then
			return getChromeTopbarHeight()
		end
	
		return DEFAULT_TOPBAR_HEIGHT
	end
	
	TOP_BAR_HEIGHT = getTopbarHeight()
	if IS_TEN_FOOT_MODE then
		TOP_BAR_HEIGHT = 72
	end
end
local THEME_COLORS = {
	-- https://github.com/MaximumADHD/Roblox-Client-Tracker/blob/8ef5688266cc0d8f613388db109b35400dbf7051/LuaPackages/Packages/_Index/UIBlox/UIBlox/App/Style/Colors.lua
	--Common colors
	BLACK = Color3.fromRGB(0, 0, 0),
	WHITE = Color3.fromRGB(255, 255, 255),
	GREEN = Color3.fromRGB(0, 176, 111),
	RED = Color3.fromRGB(247, 75, 82),
	BLUE = Color3.fromRGB(82, 173, 244),
	LIGHT_GREY = Color3.fromRGB(212, 212, 212),

	--Dark theme colors
	CARBON = Color3.fromRGB(25, 27, 29),
	FLINT = Color3.fromRGB(57, 59, 61),
	GRAPHITE = Color3.fromRGB(101, 102, 104),
	OBSIDIAN = Color3.fromRGB(17, 18, 20),
	PUMICE = Color3.fromRGB(189, 190, 190),
	SLATE = Color3.fromRGB(35, 37, 39),

	--Light theme colors
	ALABASTER = Color3.fromRGB(242, 244, 245),
	ASH = Color3.fromRGB(222, 225, 227),
	CHALK = Color3.fromRGB(199, 203, 206),
	SMOKE = Color3.fromRGB(96, 97, 98),
	XBOX_BLUE = Color3.fromRGB(17, 139, 211),
}
--[[
	Implementation of the Unified Color System.
	See: https://www.figma.com/file/afPf1YESNBS6BWiyzgPdlM/Color-System-(Core)?node-id=945%3A1
 ]]

-- Variables
-- References
-- Private Functions
-- Class

return {
	THEME = {
		-- Backgrounds
		BACKGROUND = {
			DEFAULT = {
				COLOR = THEME_COLORS.SLATE, -- COLOR_SYSTEM.GRAY[130],
				TRANSPARENCY = 0,
			},
			CONTRAST = {
				COLOR = THEME_COLORS.CARBON, -- COLOR_SYSTEM.GRAY[110],
				TRANSPARENCY = 0,
			},
			MUTED = {
				COLOR = THEME_COLORS.OBSIDIAN, -- COLOR_SYSTEM.GRAY[90],
				TRANSPARENCY = 0,
			},
			UI = {
				DEFAULT = {
					COLOR = THEME_COLORS.FLINT, -- COLOR_SYSTEM.GRAY[90],
					TRANSPARENCY = 0,
				},
				CONTRAST = {
					COLOR = THEME_COLORS.BLACK, -- COLOR_SYSTEM.GRAY[100],
					TRANSPARENCY = 0.3, --0,
				},
			},
			EVENT = {
				ON_HOVER = {
					COLOR = THEME_COLORS.WHITE,-- COLOR_SYSTEM.WHITE,
					TRANSPARENCY = 0.9, -- 0.1 alpha
				},
				ON_PRESS = {
					COLOR = THEME_COLORS.BLACK,-- COLOR_SYSTEM.BLACK,
					TRANSPARENCY = 0.7, -- 0.3 alpha
				},
			},
		},
		-- CELL = {
		-- 	EVENT = {
		-- 		ON_HOVER = {
		-- 			COLOR = COLOR_SYSTEM.GRAY[110],
		-- 			TRANSPARENCY = 0,
		-- 		},
		
		-- 	},
		-- },

		-- UI
		UI = {
			DEFAULT = {
				COLOR = THEME_COLORS.GRAPHITE, -- COLOR_SYSTEM.GRAY[70],
				TRANSPARENCY = 0,
			},
			MUTED = {
				COLOR = THEME_COLORS.OBSIDIAN, -- COLOR_SYSTEM.GRAY[100],
				TRANSPARENCY = 0.2,
			},
			EMPHASIS = {
				COLOR = THEME_COLORS.WHITE, -- COLOR_SYSTEM.GRAY[80],
				TRANSPARENCY = 0.7,
			},
		},
		-- Text
		TEXT = {
			DEFAULT = {
				COLOR = THEME_COLORS.PUMICE, --COLOR_SYSTEM.GRAY[50],
				TRANSPARENCY = 0,
			},
			MUTED = {
				COLOR = THEME_COLORS.WHITE, --COLOR_SYSTEM.GRAY[60],
				TRANSPARENCY = 0.3,-- 0,
			},
			EMPHASIS = {
				COLOR = THEME_COLORS.WHITE, --COLOR_SYSTEM.GRAY[0],
				TRANSPARENCY = 0,
			},
			-- ON_HOVER = {
			-- 	COLOR = COLOR_SYSTEM.GRAY[10],
			-- 	TRANSPARENCY = 0,
			-- },
			LINK = {
				COLOR = THEME_COLORS.BLUE, --COLOR_SYSTEM.BLUE[50],
				TRANSPARENCY = 0,
			},
		},
	
		-- Icons
		ICON = {
			DEFAULT = {
				COLOR = THEME_COLORS.WHITE,
				TRANSPARENCY = 0.3, --0,
			},
			EMPHASIS = { -- To be deprecated
				COLOR = THEME_COLORS.WHITE,
				TRANSPARENCY = 0,
			},
			ON_HOVER = { -- To be deprecated
				COLOR = THEME_COLORS.WHITE,
				TRANSPARENCY = 0,
			},
		},

		-- Buttons
		CONTEXTUAL_PRIMARY = {
			DEFAULT = {
				COLOR = THEME_COLORS.GREEN, --COLOR_SYSTEM.GREEN[50],
				TRANSPARENCY = 0,
			},
			ON_HOVER = {
				COLOR = THEME_COLORS.GREEN, --COLOR_SYSTEM.GREEN[40],
				TRANSPARENCY = 0,
			},
			CONTENT = {
				COLOR = THEME_COLORS.WHITE, --COLOR_SYSTEM.GRAY[130],
				TRANSPARENCY = 0,
			},
		},

		SYSTEM_PRIMARY = {
			DEFAULT = {
				COLOR = THEME_COLORS.WHITE,-- COLOR_SYSTEM.GRAY[0],
				TRANSPARENCY = 0,
			},
			ON_HOVER = {
				COLOR = THEME_COLORS.WHITE,-- COLOR_SYSTEM.GRAY[40],
				TRANSPARENCY = 0,
			},
			CONTENT = {
				COLOR = THEME_COLORS.FLINT,-- COLOR_SYSTEM.GRAY[130],
				TRANSPARENCY = 0,
			},
		},
		SECONDARY = {
			DEFAULT = {
				COLOR = THEME_COLORS.WHITE, -- COLOR_SYSTEM.GRAY[0],
				TRANSPARENCY = 0.3, -- 0,
			},
			ON_HOVER = {
				COLOR = THEME_COLORS.WHITE, -- COLOR_SYSTEM.GRAY[40],
				TRANSPARENCY = 0,
			},
			CONTENT = {
				COLOR = THEME_COLORS.WHITE, -- COLOR_SYSTEM.GRAY[0],
				TRANSPARENCY = 0.3, -- 0,
			},
		},

		-- Styles / States
		DIVIDER = {
			COLOR = THEME_COLORS.WHITE, --COLOR_SYSTEM.WHITE,
			TRANSPARENCY = 0.8, -- 0.92, -- 0.08 alpha
		},
		OVERLAY = {
			COLOR = THEME_COLORS.BLACK, --COLOR_SYSTEM.BLACK,
			TRANSPARENCY = 0.5, -- 0.6, -- 0.4 Alpha
		},
		NAVIGATION_BAR = {
			COLOR = THEME_COLORS.CARBON, -- COLOR_SYSTEM.GRAY[110],
			TRANSPARENCY = 0,
		},
		BADGE = {
			Default = {
				COLOR = THEME_COLORS.WHITE, -- COLOR_SYSTEM.GRAY[0],
				TRANSPARENCY = 0,
			},
			Content = {
				COLOR = THEME_COLORS.FLINT, -- COLOR_SYSTEM.GRAY[130],
				TRANSPARENCY = 0,
			},
		},
		-- LOADING = {
		-- 	COLOR = ColorSequence.new({
		-- 		ColorSequenceKeypoint.new(0, COLOR_SYSTEM.GRAY[0]),
		-- 		ColorSequenceKeypoint.new(0.5, COLOR_SYSTEM.GRAY[0]),
		-- 		ColorSequenceKeypoint.new(1, COLOR_SYSTEM.GRAY[0]),
		-- 	}),
		-- 	TRANSPARENCY = NumberSequence.new({
		-- 		NumberSequenceKeypoint.new(0, 1), -- 0 Alpha
		-- 		NumberSequenceKeypoint.new(0.5, 0.7), -- 0.3 Alpha
		-- 		NumberSequenceKeypoint.new(1, 1), -- 0 Alpha
		-- 	}),
		-- 	ROTATION = 45, -- 135 deg in CSS
		-- },
		PLACE_HOLDER = {
			COLOR = THEME_COLORS.FLINT, --COLOR_SYSTEM.GRAY[100],
			TRANSPARENCY = 0.5,-- 0,
		},
		STATUS = {
			ONLINE = {
				COLOR = THEME_COLORS.GREEN, -- COLOR_SYSTEM.GREEN[50],
				TRANSPARENCY = 0,
			},
			OFFLINE = {
				COLOR = THEME_COLORS.WHITE, --COLOR_SYSTEM.GRAY[50],
				TRANSPARENCY = 0.3, --0,
			},
		},

		SELECTION_CURSOR = { -- Gamepad
			COLOR = THEME_COLORS.WHITE, --COLOR_SYSTEM.GRAY[0],
			TRANSPARENCY = 0,
			ANIMATED_COLOR = THEME_COLORS.WHITE, -- COLOR_SYSTEM.WHITE, -- For animated cursors, we use GradientColorSequence * AnimatedColor
			GRADIENT = {
				ROTATION_SPEED = 2,
				SEQUENCE = {
					COLOR = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
						ColorSequenceKeypoint.new(1, Color3.new(0.336, 0.336, 0.336)), -- Color is #565656
					}),
					--  = ColorSequence.new({
					-- 	ColorSequenceKeypoint.new(0, COLOR_SYSTEM.GRAY[0]),
					-- 	ColorSequenceKeypoint.new(1, COLOR_SYSTEM.GRAY[70]),
					-- }),
					TRANSPARENCY= NumberSequence.new({
						NumberSequenceKeypoint.new(0, 0),
						NumberSequenceKeypoint.new(1, 0),
					}),
					--  = NumberSequence.new({
					-- 	NumberSequenceKeypoint.new(0, 0),
					-- 	NumberSequenceKeypoint.new(1, 0),
					-- }),
				},
			},
			ROTATION = 45, -- 135 deg in CSS
		},
		ALERT = {
			COLOR = THEME_COLORS.RED, --COLOR_SYSTEM.RED[50],
			TRANSPARENCY = 0,
		},
		SUCCESS = {
			COLOR = THEME_COLORS.GREEN, --COLOR_SYSTEM.GREEN[50],
			TRANSPARENCY = 0,
		},
		-- CAUTION = {
		-- 	COLOR = COLOR_SYSTEM.YELLOW[50],
		-- 	TRANSPARENCY = 0,
		-- },
		DROP_SHADOW = {
			COLOR = THEME_COLORS.BLACK, --COLOR_SYSTEM.BLACK,
			TRANSPARENCY = 0.5, --0.2, -- 0.8 Alpha
		},

		-- Others
		PLAYER = {
			BACKGROUND = {
				DEFAULT = {
					COLOR = THEME_COLORS.WHITE, --COLOR_SYSTEM.GRAY[0],
					TRANSPARENCY = 0,
					IMAGE = "component_assets/avatarBG_dark",
				},

			},
		},
		ITEM = {
			BACKGROUND = {
				DEFAULT = {
					COLOR = THEME_COLORS.BLACK, --COLOR_SYSTEM.GRAY[130],
					TRANSPARENCY = 0,
					IMAGE = "component_assets/itemBG_dark",
				},
			},
		},
	},
	UNIBAR = {
		ICON_CELL_WIDTH = 44,
		DIVIDER_CELL_WIDTH = 5,
		ICON_SIZE = 36,
		MENU_ANIMATION_SPRING = {
			DAMPING_RATIO = 1.1,
			FREQUENCY = 1 / 0.15, -- @150ms size anim
			RESTING_LIMIT = {
				POSITION = 0.1,
				VELOCITY = 0.05,
			},
		},
		-- WindowHost constants
		CLOSE_BUTTON_FRAME = UDim2.fromOffset(44, 44),
		CLOSE_BUTTON_SIZE = UDim2.fromOffset(22, 22),
		CLOSE_ICON_SIZE = 23,-- IconSize.Small,
		CORNER_RADIUS = UDim.new(0, 8),
	
		WINDOW_ACTIVE_SECONDS = 2,
	
		-- the amount of travel to activate a WindowHost from dragging an icon
		DRAG_MAGNITUDE_THRESHOLD = 10,
	
		DEFAULT_HEIGHT_LARGE = 324,
		DEFAULT_WIDTH_LARGE = 150,
		DEFAULT_HEIGHT = 185,
		DEFAULT_WIDTH = 86,
	
		MAX_HEIGHT_PORTRAIT = 324,
		MAX_WIDTH_PORTRAIT = 150,
		MAX_HEIGHT_LANDSCAPE = 240,
		MAX_WIDTH_LANDSCAPE = 112,
	},
	HEIGHT = TOP_BAR_HEIGHT,
	HIGHLIGHT_CIRCLE_HEIGHT = 36,
	BUTTON = {
		HEIGHT = TOP_BAR_BUTTON_HEIGHT,
		PADDING = TOP_BAR_BUTTON_PADDING,
	},
	MARGIN = {
		TOP = TOP_BAR_HEIGHT - TOP_BAR_BUTTON_HEIGHT - 2 * TOP_BAR_BUTTON_PADDING,
	},
	SCREEN_SIDE_OFFSET = if IS_TEN_FOOT_MODE then 48 else 16,
	PADDING = 12,

}
