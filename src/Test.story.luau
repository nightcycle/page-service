--!strict
local Package = script.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages ~= nil)
local Maid = require(Packages:WaitForChild("Maid"))

return function(coreGui: ScreenGui)
	local maid = Maid.new()

	task.spawn(function()
		local PageService = require(Package)
		PageService.init(maid)
		PageService.Instance.Parent = coreGui
	end)

	return function()
		maid:Destroy()
	end
end
