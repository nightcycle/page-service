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
		module:SetButton(
			"home",
			"home",
			"where the heart is",
			1
		)
		module:SetButton(
			"shop",
			"shop",
			"where the wallet is",
			2
		)
		module:SetButton(
			"up",
			"accessibility",
			"where the wallet is",
			2
		)
		module:SetCurrency(	
			"db",
			"Dollah dollah bills y'all",
			nil,
			Color3.new(0,1, 0),
			1,
			0
		)
		task.delay(10, function()
			module.Visible:Set(false)
			task.wait(5)
			module.Visible:Set(true)
		end)

	end)

	return function()
		maid:Destroy()
	end
end
