minetest.register_craft({
	output = "bobcraft_blocks:planks 4",
	recipe = {
		{"bobcraft_blocks:log"}
	}
})

minetest.register_craft({
	output = "bobcraft_items:sticks",
	recipe = {
		{"bobcraft_blocks:planks"},
		{"bobcraft_blocks:planks"}
	}
})

minetest.register_craft({
	output = "bobcraft_tools:wood_axe",
	recipe = {
		{"bobcraft_blocks:planks", "bobcraft_blocks:planks"},
		{"bobcraft_blocks:planks", "bobcraft_items:sticks"},
		{"", "bobcraft_items:sticks"}
	}
})