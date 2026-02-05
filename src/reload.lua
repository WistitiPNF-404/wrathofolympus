---@meta _
-- globals we define are private to our plugin!
---@diagnostic disable: lowercase-global

-- this file will be reloaded if it changes during gameplay,
-- 	so only assign to values or define things here.


-- These functions are part of the example code snippets from ready.lua

function prefix_SetupMap()
	print('Map is loading, here we might load some packages.')
    LoadPackages({ Name = "BiomeP" })
	LoadPackages({ Name = "Fx" })
	mod.LoadBoonFramesPackage()
	mod.LoadBoonIconsPackage()
end

--[[function trigger_Gift()
	-- modutil.mod.Hades.PrintOverhead(config.message)
	modutil.mod.Hades.PrintOverhead("Comme les 5 doigts de la main")
end]]--


-------------------------------------------------------------------
-- This function is part of the mod creation guide from the wiki --
-------------------------------------------------------------------
function mod.LoadBoonFramesPackage()
	local packageName = _PLUGIN.guid .. "BoonFrames"
	print("Wistiti-WrathOfOlympus - Loading package: " .. packageName)
	LoadPackages({ Name = packageName })
end

function mod.LoadBoonIconsPackage()
	local packageName = _PLUGIN.guid .. "BoonIcons"
	print("Wistiti-WrathOfOlympus - Loading package: " .. packageName)
	LoadPackages({ Name = packageName })
end