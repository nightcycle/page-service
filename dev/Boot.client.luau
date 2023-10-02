--!strict
local _Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")

-- Services
-- Packages
local PageService = require(_Packages:WaitForChild("package"))
local Maid = require(_Packages:WaitForChild("Maid"))
local ColdFusion = require(_Packages:WaitForChild("ColdFusion"))

-- Modules
-- Types
type Maid = Maid.Maid
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
local maid = Maid.new()
PageService.init(maid)

local _fuse = ColdFusion.fuse(maid)

local _new = _fuse.new
local _bind = _fuse.bind
local _clone = _fuse.clone
local _import = _fuse.import

local _Value = _fuse.Value
local _Computed = _fuse.Computed

local topBarContainer = PageService.TopBar:CreateContainer()

local initialButton = topBarContainer:CreateButton()
initialButton.Instance.LayoutOrder = 5
initialButton.IconImage.Default:Set("http://www.roblox.com/asset/?id=11889177340")
initialButton.IconScale.Selection:Set(1)
initialButton.IconScale.Default:Set(0.7)

do
	local button = topBarContainer:CreateButton()
	button.Instance.LayoutOrder = 3
	button.IconScale.Default:Set(0.7)
	button.IconImage.Default:Set("rbxassetid://10885637246")
	button:SetOnClickInvoke(function()  
		topBarContainer:ToggleExclusiveSelect(button)
	end)
end

do
	local button = topBarContainer:CreateButton()
	button.Instance.LayoutOrder = 6
	button.IconScale.Default:Set(0.7)
	button.IconImage.Default:Set("rbxassetid://9149338928")
	button.IconImage.Selection:Set("rbxassetid://11560341132")
	button.IconScale.Selection:Set(0.6)

	button:SetOnClickInvoke(function()  
		topBarContainer:ToggleExclusiveSelect(button)
	end)
end


do
	local button = topBarContainer:CreateButton()
	button.Instance.LayoutOrder = 4
	button.IconScale.Default:Set(0.7)
	button.IconImage.Default:Set("rbxassetid://13732884875")
	button:SetOnClickInvoke(function()  
		topBarContainer:ToggleExclusiveSelect(button)
	end)
end
topBarContainer:SetUnlockButton(initialButton)
topBarContainer.IsOpen:Set(false)
