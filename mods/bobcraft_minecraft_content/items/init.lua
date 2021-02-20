-- Crafty/Naturaley
minetest.register_craftitem("bobcraft_items:sticks", {
	description = "Stick",
	inventory_image = "sticks.png"
	groups = {
		fuel=bobutil.fuel_times.small_wood
	}
})

-- Smelty/Orey
minetest.register_craftitem("bobcraft_items:coal", {
	description = "Coal",
	inventory_image = "coal.png",
	groups = {crafting_coal_like = 1, fuel=bobutil.fuel_times.coal}
})
minetest.register_craftitem("bobcraft_items:iron_ingot", {
	description = "Iron Ingot",
	inventory_image = "iron_ingot.png"
})
minetest.register_craftitem("bobcraft_items:gold_ingot", {
	description = "Gold Ingot",
	inventory_image = "gold_ingot.png"
})
minetest.register_craftitem("bobcraft_items:diamond", {
	description = "Diamond",
	inventory_image = "diamond.png"
})

-- Cooky
minetest.register_craftitem("bobcraft_items:porkchop", {
	description = "Raw Meat",
	inventory_image = "porkchop.png",
	on_use = minetest.item_eat(1.8)
})
minetest.register_craftitem("bobcraft_items:cooked_porkchop", {
	description = "Cooked Meat",
	inventory_image = "cooked_porkchop.png",
	on_use = minetest.item_eat(12.8)
})
minetest.register_craftitem("bobcraft_items:lemon", {
	description = "Lemon",
	inventory_image = "lemon.png",
	on_use = minetest.item_eat(2)
})
minetest.register_craftitem("bobcraft_items:apple", {
	description = "Green Apple",
	inventory_image = "apple.png",
	on_use = minetest.item_eat(2)
})