bobcraft_crafting = {}

bobcraft_crafting.do_tool_recipes = function(tier, material)
	-- ##
	-- #:
	--  :
	minetest.register_craft({
		output = "bobcraft_tools:"..tier.."_axe",
		recipe = {
			{material, material},
			{material, "bobcraft_items:stick"},
			{"",       "bobcraft_items:stick"}
		}
	})
	--  ##
	--  :#
	--  :
	minetest.register_craft({
		output = "bobcraft_tools:"..tier.."_axe",
		recipe = {
			{material, material},
			{"bobcraft_items:stick", material},
			{"bobcraft_items:stick", ""}
		}
	})
	-- ##
	--  :
	--  :
	minetest.register_craft({
		output = "bobcraft_tools:"..tier.."_hoe",
		recipe = {
			{material, material},
			{"", "bobcraft_items:stick"},
			{"",       "bobcraft_items:stick"}
		}
	})
	--  ##
	--  :
	--  :
	minetest.register_craft({
		output = "bobcraft_tools:"..tier.."_hoe",
		recipe = {
			{material, material},
			{"bobcraft_items:stick", ""},
			{"bobcraft_items:stick", ""}
		}
	})
	-- ###
	--  :
	--  :
	minetest.register_craft({
		output = "bobcraft_tools:"..tier.."_pickaxe",
		recipe = {
			{material, material, material},
			{"",       "bobcraft_items:stick", ""},
			{"",       "bobcraft_items:stick", ""}
		}
	})
	--  #
	--  :
	--  :
	minetest.register_craft({
		output = "bobcraft_tools:"..tier.."_shovel",
		recipe = {
			{material},
			{"bobcraft_items:stick"},
			{"bobcraft_items:stick"}
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
			{"bobcraft_items:stick"}
		}
	})
end

function bobcraft_crafting.register_stair_craft(stair, material)
	-- #
	-- ##
	-- ###
	minetest.register_craft({
		output = stair .. " 4",
		recipe = {
			{material, "", ""},
			{material, material, ""},
			{material, material, material}
		}
	})
	-- Not sure if MC does this, but we do!
	--   #
	--  ##
	-- ###
	minetest.register_craft({
		output = stair .. " 4",
		recipe = {
			{"", "", material},
			{"", material, material},
			{material, material, material}
		}
	})
end

function bobcraft_crafting.register_slab_craft(slab, material)

	-- ###
	minetest.register_craft({
		output = slab .. " 6",
		recipe = {
			{material, material, material}
		}
	})
end

-- # = log
-----
-- #
minetest.register_craft({
	output = "bobcraft_blocks:planks 4",
	recipe = {
		{"bobcraft_blocks:log"}
	}
})

-- # = wood
-----
-- #
-- #
minetest.register_craft({
	output = "bobcraft_items:stick 4",
	recipe = {
		{"group:crafting_wood"},
		{"group:crafting_wood"}
	}
})

-- # = coal, : = stick
-----
-- #
-- :
minetest.register_craft({
	output = "bobcraft_blocks:torch 4",
	recipe = {
		{"group:crafting_coal_like"},
		{"bobcraft_items:stick"}
	}
})

-- # = stone
-----
-- ###
-- # #
-- ###
minetest.register_craft({
	output = "bobcraft_blocks:furnace",
	recipe = {
		{"group:crafting_stone", "group:crafting_stone", "group:crafting_stone"},
		{"group:crafting_stone", "", "group:crafting_stone"},
		{"group:crafting_stone", "group:crafting_stone", "group:crafting_stone"},
	}
})

-- paper
-- # = sugarcane
-----
-- ###
minetest.register_craft({
	output = "bobcraft_items:paper 3",
	recipe = {
		{"bobcraft_blocks:sugarcane","bobcraft_blocks:sugarcane","bobcraft_blocks:sugarcane",},
	}
})

-- book
-- # = paper
-----
-- #
-- #
-- #
minetest.register_craft({
	output = "bobcraft_items:book", -- No leather = suitable for vegans!
	recipe = {
		{"bobcraft_items:paper",},
		{"bobcraft_items:paper",},
		{"bobcraft_items:paper",}
	}
})

-- fence
-- # = stick
-----
-- ###
-- ###
minetest.register_craft({
	output = "bobcraft_blocks:fence",
	recipe = {
		{"bobcraft_items:stick","bobcraft_items:stick","bobcraft_items:stick",},
		{"bobcraft_items:stick","bobcraft_items:stick","bobcraft_items:stick",},
	}
})

-- netherfence
-- # = nether brick
-----
-- ###
-- ###

-- fence gate
-- # = stick, w = wood
-----
-- #w#
-- #w#

-- jukebox
-- # = wood, x = diamond
-----
-- ###
-- #x#
-- ###

-- noteblock
-- # = wood, x = redstone
-----
-- ###
-- #x#
-- ###

-- bookshelf
-- # = wood, x = book
-----
-- ###
-- xxx
-- ###
minetest.register_craft({
	output = "bobcraft_blocks:bookshelf",
	recipe = {
		{"group:crafting_wood","group:crafting_wood","group:crafting_wood",},
		{"bobcraft_items:book","bobcraft_items:book","bobcraft_items:book",},
		{"group:crafting_wood","group:crafting_wood","group:crafting_wood",},
	}
})

-- snow block
-- # = snowball
-----
-- ##
-- ##

-- clay block
-- # = clay
-----
-- ##
-- ##
minetest.register_craft({
	output = "bobcraft_blocks:clay",
	recipe = {
		{"bobcraft_items:clay","bobcraft_items:clay",},
		{"bobcraft_items:clay","bobcraft_items:clay",},
	}
})

-- brick block
-- # = brick
-----
-- ##
-- ##
minetest.register_craft({
	output = "bobcraft_blocks:bricks",
	recipe = {
		{"bobcraft_items:brick","bobcraft_items:brick",},
		{"bobcraft_items:brick","bobcraft_items:brick",},
	}
})

-- stone brick
-- # = stone
-----
-- ##
-- ##
minetest.register_craft({
	output = "bobcraft_blocks:stone_bricks",
	recipe = {
		{"bobcraft_blocks:stone","bobcraft_blocks:stone",},
		{"bobcraft_blocks:stone","bobcraft_blocks:stone",},
	}
})

-- chiseled stone brick
-- # = stone brick slab
-----
-- #
-- #
minetest.register_craft({
	output = "bobcraft_blocks:chiseled_stone_bricks",
	recipe = {
		{"bobcraft_blocks_xrta:stone_bricks_slab",},
		{"bobcraft_blocks_xrta:stone_bricks_slab",},
	}
})

-- glowstone
-- # = glowstone dust
-----
-- ##
-- ##

-- wool (white) block
-- # = wool
-----
-- ##
-- ##

-- tnt
-- # = sand, x = gunpowder
-----
-- x#x
-- #x#
-- x#x

-- ladder
-- # = stick
-----
-- # #
-- ###
-- # #
minetest.register_craft({
	output = "bobcraft_blocks:door",
	recipe = {
		{"bobcraft_items:stick", "", "bobcraft_items:stick"},
		{"bobcraft_items:stick","bobcraft_items:stick", "bobcraft_items:stick"},
		{"bobcraft_items:stick", "", "bobcraft_items:stick"},
	}
})

-- wooden door
-- # = wood
-----
-- ##
-- ##
-- ##
minetest.register_craft({
	output = "bobcraft_blocks:door",
	recipe = {
		{"group:crafting_wood","group:crafting_wood"},
		{"group:crafting_wood","group:crafting_wood"},
		{"group:crafting_wood","group:crafting_wood"},
	}
})

-- trapdoor
-- # = wood
-----
-- ###
-- ###
minetest.register_craft({
	output = "bobcraft_blocks:trapdoor",
	recipe = {
		{"group:crafting_wood","group:crafting_wood","group:crafting_wood",},
		{"group:crafting_wood","group:crafting_wood","group:crafting_wood",},
	}
})

-- iron door
-- # = iron
-----
-- ##
-- ##
-- ##

-- sign
-- # = wood, x = stick
-----
-- ###
-- ###
--  x
minetest.register_craft({
	output = "bobcraft_blocks:trapdoor",
	recipe = {
		{"group:crafting_wood","group:crafting_wood","group:crafting_wood",},
		{"group:crafting_wood","group:crafting_wood","group:crafting_wood",},
		{"","bobcraft_items:stick","",},
	}
})

-- cake
-- # = milk, x = sugar, e = egg, w = wheat
-----
-- ###
-- xex
-- www

-- sugar
-- # = sugarcane
-----
-- #

-- bowl
-- # = wood
-----
-- # #
--  #

-- glass bottle
-- # = glass
-----
-- # #
--  #

-- rail
-- # = stick, x = iron
-----
-- x x
-- x#x
-- x x

-- powered rail
-- # = stick, x = iron, r = greendust
-----
-- x x
-- x#x
-- xrx

-- detector rail
-- # = stick, x = iron, r = plate
-----
-- x x
-- x#x
-- xrx

-- minecart
-- # = iron
-----
-- # #
-- ###

-- cauldron
-- # = stick, x = iron
-----
-- # #
-- # #
-- ###

-- brewing stand
-- # = stone, b = blaze rod
-----
--  b
-- ###

-- jack-o-lantern
-- (shapeless)
-- # = pumpkin, a = torch
-----

-- minecart with chest
-- (shapeless)
-- # = minecart, a = chest
-----

-- minecart with furnace
-- (shapeless)
-- # = minecart, a = furnace
-----

-- boat
-- # = planks
-----
-- # #
-- ###

-- bucket
-- # = iron
-----
-- # #
--  #

-- flint and steel
-- (shapeless)
-- # = iron, x = flint
-----

-- bread
-- # = wheat
-----
-- ###
minetest.register_craft({
	output = "bobcraft_items:bread_dough",
	recipe = {
		{"bobcraft_farming:wheat","bobcraft_farming:wheat","bobcraft_farming:wheat",},
	}
})

-- fishing rod
-- # = sticks, ~ = string
-----
--   #
--  #~
-- # ~

-- painting
-- # = stick, x = wool
-----
-- ###
-- #x#
-- ###

-- gold apple
-- # = gold nugget, a = apple
-----
-- ###
-- #a#
-- ###

-- lever
-- # = stone, / = stick
-----
-- /
-- #

-- greendust torch
-- # = greendust, : = stick
-----
-- #
-- :

-- greendust repeater
-- # = stone, / = greendust, : = greendust torch
-----
-- :::
-- #/#

-- clock
-- # = gold ingot, r = greendust
-----
--  #
-- #r#
--  #

-- compass
-- # = iron, r = greendust
-----
--  #
-- #r#
--  #

-- map
-- # = paper, x = compass
-----
-- ###
-- #x#
-- ###

-- button
-- # = stone
-----
-- #

-- pressure plate, stone
-- # = stone
-----
-- ##

-- pressure plate, wood
-- # = wood
-----
-- ##

-- dispenser
-- # = stone, b = bow, r = greendust
-----
-- ###
-- #b#
-- #r#

-- piston
-- # = stone, i = iron, r = greendust, p = planks
-----
-- ppp
-- #i#
-- #r#

-- sticky piston
-- # = piston, s = slimeball
-----
-- s
-- #

-- bed
-- # = wood, w = wool (any colour)
-----
-- www
-- ###

-- chest
-- # = wood
-----
-- ###
-- # #
-- ###
minetest.register_craft({
	output = "bobcraft_blocks:chest",
	recipe = {
		{"group:crafting_wood", "group:crafting_wood", "group:crafting_wood"},
		{"group:crafting_wood", "", "group:crafting_wood"},
		{"group:crafting_wood", "group:crafting_wood", "group:crafting_wood"},
	}
})

-- all-seeing eye (eye of ender)
-- (shapeless)
-- a = eye, b = blazepowder
-----

-- fireball
-- (shapeless)
-- a = gunpowder, b = blazepowder, c = coal
-----

-- Shapeless wool dying
-- TODO: should we move this to wool.lua?
for i, colour in ipairs(dyes.colour_names) do
	minetest.register_craft({
		type = "shapeless",
		output = "bobcraft_blocks:wool_"..colour,
		recipe = {
			dyes.items[colour],
			"bobcraft_blocks:wool_white"
		}
	})
end

local modpath = minetest.get_modpath("bobcraft_crafting")
dofile(modpath.."/cooking.lua")