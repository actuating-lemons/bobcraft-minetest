-- NOTE: Recipes should *pretty much* always have a cooktime of 10.
-- Cooktime is measured in seconds, and minecraft uses 10 seconds to cook ALL items.

----
-- Blocks
----
minetest.register_craft({
	type = "cooking",
	output = "bobcraft_blocks:glass",
	recipe = "bobcraft_blocks:sand",
	cooktime = 10,
})

minetest.register_craft({
	type = "cooking",
	output = "bobcraft_items:iron_ingot",
	recipe = "bobcraft_blocks:iron_ore",
	cooktime = 10,
})

----
-- Food
----
minetest.register_craft({
	type = "cooking",
	output = "bobcraft_items:cooked_porkchop",
	recipe = "bobcraft_items:porkchop",
	cooktime = 10,
})
