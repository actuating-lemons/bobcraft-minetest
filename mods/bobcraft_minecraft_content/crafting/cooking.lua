-- NOTE: Recipes should *pretty much* always have a cooktime of 10.
-- Cooktime is measured in seconds, and minecraft uses 10 seconds to cook ALL items.

-- input sand
-- get glass
minetest.register_craft({
	type = "cooking",
	output = "bobcraft_blocks:glass",
	recipe = "bobcraft_blocks:sand",
	cooktime = 10,
})

-- input iron ore
-- get iron
minetest.register_craft({
	type = "cooking",
	output = "bobcraft_items:iron_ingot",
	recipe = "bobcraft_blocks:iron_ore",
	cooktime = 10,
})

-- input gold ore
-- get gold
minetest.register_craft({
	type = "cooking",
	output = "bobcraft_items:gold_ingot",
	recipe = "bobcraft_blocks:gold_ore",
	cooktime = 10,
})

-- input diamond ore
-- get diamond
minetest.register_craft({
	type = "cooking",
	output = "bobcraft_items:diamond",
	recipe = "bobcraft_blocks:diamond_ore",
	cooktime = 10,
})

-- input coal ore
-- get coal
minetest.register_craft({
	type = "cooking",
	output = "bobcraft_items:coal_ore",
	recipe = "bobcraft_blocks:coal",
	cooktime = 10,
})

-- input greendust ore
-- get exploded on
-- TODO: we'll need to do this seperately, AND after we have explosions.

-- input lapis ore
-- get lapis
minetest.register_craft({
	type = "cooking",
	output = "bobcraft_items:lapis",
	recipe = "bobcraft_blocks:lapis_ore",
	cooktime = 10,
})

-- input cobblestone
-- get stone
minetest.register_craft({
	type = "cooking",
	output = "bobcraft_blocks:stone",
	recipe = "bobcraft_blocks:cobblestone",
	cooktime = 10,
})

-- input clay lump
-- get brick
minetest.register_craft({
	type = "cooking",
	output = "bobcraft_items:clay",
	recipe = "bobcraft_items:brick",
	cooktime = 10,
})

-- input cactus
-- get green dye
minetest.register_craft({
	type = "cooking",
	output = dyes.items.green,
	recipe = "bobcraft_blocks:cactus",
	cooktime = 10,
})

-- input log
-- get coal (TODO: CHARCOAL)
minetest.register_craft({
	type = "cooking",
	output = "bobcraft_items:coal",
	recipe = "bobcraft_blocks:log",
	cooktime = 10,
})


----
-- Food
----

-- input raw porkchop
-- get cooked porkchop
minetest.register_craft({
	type = "cooking",
	output = "bobcraft_items:cooked_porkchop",
	recipe = "bobcraft_items:porkchop",
	cooktime = 10,
})


-- input bread dough
-- get bread
minetest.register_craft({
	type = "cooking",
	output = "bobcraft_items:bread",
	recipe = "bobcraft_items:bread_dough",
	cooktime = 10,
})
