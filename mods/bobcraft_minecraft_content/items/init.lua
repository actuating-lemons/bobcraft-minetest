local S = minetest.get_translator("bobcraft_items")

-- Crafty/Naturaley
minetest.register_craftitem("bobcraft_items:stick", {
	description = S("Stick"),
	inventory_image = "sticks.png",
	groups = {fuel=bobutil.fuel_times.small_wood},
	stack_max = bobutil.stack_max,
	wield_scale = bobutil.wield_scale,
})
minetest.register_craftitem("bobcraft_items:paper", {
	description = S("Sugar Paper"),
	inventory_image = "paper.png",
	-- groups = {fuel=bobutil.fuel_times.small_wood}, -- I don't know if sugar paper/construction paper burns.
	stack_max = bobutil.stack_max,
	wield_scale = bobutil.wield_scale,
})
minetest.register_craftitem("bobcraft_items:book", {
	description = S("Book"),
	inventory_image = "book.png",
	-- groups = {fuel=bobutil.fuel_times.small_wood}, -- I don't know if sugar paper/construction paper burns.
	stack_max = bobutil.stack_max,
	wield_scale = bobutil.wield_scale,
})
minetest.register_craftitem("bobcraft_items:flint", {
	description = S("Flint"),
	inventory_image = "flint.png",
	stack_max = bobutil.stack_max,
	wield_scale = bobutil.wield_scale,
})
minetest.register_craftitem("bobcraft_items:silk", {
	description = S("Silk"),
	inventory_image = "string.png",
	stack_max = bobutil.stack_max,
	wield_scale = bobutil.wield_scale,
})

-- Smelty/Orey
minetest.register_craftitem("bobcraft_items:coal", {
	description = S("Coal"),
	inventory_image = "coal.png",
	groups = {crafting_coal_like = 1, fuel=bobutil.fuel_times.coal},
	stack_max = bobutil.stack_max,
	wield_scale = bobutil.wield_scale,
})
minetest.register_craftitem("bobcraft_items:iron_ingot", {
	description = S("Iron Ingot"),
	inventory_image = "iron_ingot.png",
	stack_max = bobutil.stack_max,
	wield_scale = bobutil.wield_scale,
})
minetest.register_craftitem("bobcraft_items:gold_ingot", {
	description = S("Gold Ingot"),
	inventory_image = "gold_ingot.png",
	stack_max = bobutil.stack_max,
	wield_scale = bobutil.wield_scale,
})
minetest.register_craftitem("bobcraft_items:diamond", {
	description = S("Diamond"),
	inventory_image = "diamond.png",
	stack_max = bobutil.stack_max,
	wield_scale = bobutil.wield_scale,
})
minetest.register_craftitem("bobcraft_items:clay", {
	description = S("Clay"),
	inventory_image = "clay_item.png",
	stack_max = bobutil.stack_max,
	wield_scale = bobutil.wield_scale,
})

-- Cooky
minetest.register_craftitem("bobcraft_items:porkchop", {
	description = S("Raw Meat"),
	inventory_image = "porkchop.png",
	on_use = minetest.item_eat(1.8),
	stack_max = bobutil.stack_max,
	wield_scale = bobutil.wield_scale,
})
minetest.register_craftitem("bobcraft_items:cooked_porkchop", {
	description = S("Cooked Meat"),
	inventory_image = "cooked_porkchop.png",
	on_use = minetest.item_eat(12.8),
	stack_max = bobutil.stack_max,
	wield_scale = bobutil.wield_scale,
})
minetest.register_craftitem("bobcraft_items:lemon", {
	description = S("Lemon"),
	inventory_image = "lemon.png",
	on_use = minetest.item_eat(2),
	stack_max = bobutil.stack_max,
	wield_scale = bobutil.wield_scale,
})
minetest.register_craftitem("bobcraft_items:apple", {
	description = S("Green Apple"),
	inventory_image = "apple.png",
	on_use = minetest.item_eat(2),
	stack_max = bobutil.stack_max,
	wield_scale = bobutil.wield_scale,
})
minetest.register_craftitem("bobcraft_items:bread", {
	description = S("Bread"),
	inventory_image = "bread.png",
	on_use = minetest.item_eat(5),
	stack_max = bobutil.stack_max,
	wield_scale = bobutil.wield_scale,
})
minetest.register_craftitem("bobcraft_items:bread_dough", {
	description = S("Bread Dough"),
	inventory_image = "bread_dough.png",
	on_use = minetest.item_eat(1),
	stack_max = bobutil.stack_max,
	wield_scale = bobutil.wield_scale,
})
minetest.register_craftitem("bobcraft_items:melon_slice", {
	description = S("Watermelon Slice"),
	inventory_image = "melon_slice.png",
	on_use = minetest.item_eat(1),
	stack_max = bobutil.stack_max,
	wield_scale = bobutil.wield_scale,
})