----
-- Blocks
----
minetest.register_craft({
	type = "cooking",
	output = "bobcraft_blocks:glass",
	recipe = "bobcraft_blocks:sand",
})

minetest.register_craft({
	type = "cooking",
	output = "bobcraft_items:iron_ingot",
	recipe = "bobcraft_blocks:iron_ore",
})

----
-- Food
----
minetest.register_craft({
	type = "cooking",
	output = "bobcraft_items:cooked_porkchop",
	recipe = "bobcraft_items:porkchop",
})
