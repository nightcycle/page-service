--!strict
local ModuleInstance = script.Parent
assert(ModuleInstance)
local Package = ModuleInstance.Parent
assert(Package)
local Packages = Package.Parent
assert(Packages ~= nil)
local Maid = require(Packages:WaitForChild("Maid"))

return function(coreGui: ScreenGui)
	local maid = Maid.new()

	task.spawn(function()
		
		local GuiLibrary = require(Packages:WaitForChild("GuiLibrary"))
		GuiLibrary.init(maid)

		local Module = require(ModuleInstance)
		local module = maid:GiveTask(Module.new())
		module.Instance.Parent = coreGui
		module:Fire("Notification test! Do not be alarmed!", 5)
		task.wait(2.5)
		module:Fire("I lied! Be very alarmed!", 5)

	end)

	return function()
		maid:Destroy()
	end
end
