--!strict
local _Packages = game:GetService("ReplicatedStorage"):WaitForChild("Packages")

-- Services
-- Packages
local Package = require(_Packages:WaitForChild("package"))
local Maid = require(_Packages:WaitForChild("Maid"))

-- Modules
-- Types
type Maid = Maid.Maid
-- Constants
-- Variables
-- References
-- Private Functions
-- Class
Package.init(Maid.new())
