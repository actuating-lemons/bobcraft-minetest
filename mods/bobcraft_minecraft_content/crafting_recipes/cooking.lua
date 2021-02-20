----
-- Blocks
----
minetest.register_craft({
	type = "cooking",
	output = "bobcraft_blocks:glass",
	recipe = "bobcraft_blocks:sand",
	cooktime = 3,
})

minetest.register_craft({
	type = "cooking",
	output = "bobcraft_items:iron_ingot",
	recipe = "bobcraft_blocks:iron_ore",
	cooktime = 3,
})

----
-- Food
----
minetest.register_craft({
	type = "cooking",
	output = "bobcraft_items:cooked_porkchop",
	recipe = "bobcraft_items:porkchop",
	cooktime = 3,
})
