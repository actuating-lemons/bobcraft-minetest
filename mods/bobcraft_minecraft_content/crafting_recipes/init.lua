bobcraft_crafting = {}

bobcraft_crafting.do_tool_recipes = function(tier, material)
	-- ##
	-- #:
	--  :
	minetest.register_craft({
		output = "bobcraft_tools:"..tier.."_axe",
		recipe = {
			{material, material},
			{material, "bobcraft_items:sticks"},
			{"",       "bobcraft_items:sticks"}
		}
	})
	--  ##
	--  :#
	--  :
	minetest.register_craft({
		output = "bobcraft_tools:"..tier.."_axe",
		recipe = {
			{material, material},
			{"bobcraft_items:sticks", material},
			{"bobcraft_items:sticks", ""}
		}
	})
	-- ###
	--  :
	--  :
	minetest.register_craft({
		output = "bobcraft_tools:"..tier.."_pickaxe",
		recipe = {
			{material, material, material},
			{"",       "bobcraft_items:sticks", ""},
			{"",       "bobcraft_items:sticks", ""}
		}
	})
	--  #
	--  :
	--  :
	minetest.register_craft({
		output = "bobcraft_tools:"..tier.."_shovel",
		recipe = {
			{material},
			{"bobcraft_items:sticks"},
			{"bobcraft_items:sticks"}
		}
	})
	--  #
	--  #
	--  :
	minetest.register_craft({
		output = "bobcraft_tools:"..tier.."_sword",
		recipe = {
			{material},
			{material},
			{"bobcraft_items:sticks"}
		}
	})
end

minetest.register_craft({
	output = "bobcraft_blocks:planks 4",
	recipe = {
		{"bobcraft_blocks:log"}
	}
})

minetest.register_craft({
	output = "bobcraft_items:sticks 4",
	recipe = {
		{"group:crafting_wood"},
		{"group:crafting_wood"}
	}
})

minetest.register_craft({
	output = "bobcraft_blocks:torch 4",
	recipe = {
		{"group:crafting_coal_like"},
		{"bobcraft_items:sticks"}
	}
})

local modpath = minetest.get_modpath("bobcraft_crafting")
dofile(modpath.."/cooking.lua")