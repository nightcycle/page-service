--!strict
local ModuleInstance = script.Parent
local Package = ModuleInstance.Parent
local Packages = Package.Parent
local Maid = require(Packages:WaitForChild("Maid"))

return function(coreGui: ScreenGui)
	local maid = Maid.new()

	task.spawn(function()
		
		local GuiLibrary = require(Packages:WaitForChild("GuiLibrary"))
		GuiLibrary.init(maid)
		
		local Module = require(ModuleInstance)
		local module = maid:GiveTask(Module.new())
		module.Instance.Parent = coreGui

	end)

	return function()
		maid:Destroy()
	end
end
