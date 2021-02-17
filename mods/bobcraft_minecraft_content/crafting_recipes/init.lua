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
	output = "bobcraft_tools:wood_axe",
	recipe = {
		{"group:crafting_wood", "group:crafting_wood"},
		{"group:crafting_wood", "bobcraft_items:sticks"},
		{"",                    "bobcraft_items:sticks"}
	}
})
minetest.register_craft({
	output = "bobcraft_tools:stone_axe",
	recipe = {
		{"group:crafting_stone", "group:crafting_stone"},
		{"group:crafting_stone", "bobcraft_items:sticks"},
		{"",                    "bobcraft_items:sticks"}
	}
})

minetest.register_craft({
	output = "bobcraft_tools:wood_pickaxe",
	recipe = {
		{"group:crafting_wood", "group:crafting_wood",  "group:crafting_wood"},
		{"",                    "bobcraft_items:sticks",""},
		{"",                    "bobcraft_items:sticks",""}
	}
})
minetest.register_craft({
	output = "bobcraft_tools:stone_pickaxe",
	recipe = {
		{"group:crafting_stone", "group:crafting_stone",  "group:crafting_stone"},
		{"",                    "bobcraft_items:sticks",  ""},
		{"",                    "bobcraft_items:sticks",  ""}
	}
})