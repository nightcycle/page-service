--!strict
local Package = script.Parent
local Packages = Package.Parent
local Maid = require(Packages:WaitForChild("Maid"))

return function(coreGui: ScreenGui)
	local maid = Maid.new()

	task.spawn(function()
		local PageService = require(Package)
		PageService.init(maid)
		PageService.VersionText:Set("1.0.0")
		PageService.Instance.Parent = coreGui

		-- PageService.Prompt:Fire("Hello!", function()
		-- 	print("click")
		-- end)

	end)

	return function()
		maid:Destroy()
	end
end
