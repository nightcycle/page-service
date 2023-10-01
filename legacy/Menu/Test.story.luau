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
		module:SetButton(
			{
				Path = "home",
				Icon = "home",
				Hint = "where the heart is",
				LayoutOrder = 1,
			}
		)
		module:SetButton(
			{
				Path = "shop",
				Icon = "shop",
				Hint = "where the wallet is",
				LayoutOrder = 2,
			}
		)
		module:SetButton(
			{
				Path = "up",
				Icon = "accessibility",
				Hint = "where the wallet is",
				LayoutOrder = 3,
			}
		)
		module:SetCurrency(	
			"db",
			"Dollah dollah bills y'all",
			"accessibility",
			Color3.new(0,1, 0),
			1,
			0
		)
		-- task.delay(10, function()
		-- 	module.Visible:Set(false)
		-- 	task.wait(5)
		-- 	module.Visible:Set(true)
		-- end)

	end)

	return function()
		maid:Destroy()
	end
end
