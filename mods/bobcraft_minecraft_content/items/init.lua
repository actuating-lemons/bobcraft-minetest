-- Crafty/Naturaley
minetest.register_craftitem("bobcraft_items:sticks", {
	description = "Stick",
	inventory_image = "sticks.png"
})

-- Smelty/Orey
minetest.register_craftitem("bobcraft_items:coal", {
	description = "Coal",
	inventory_image = "coal.png"
})
minetest.register_craftitem("bobcraft_items:iron_ingot", {
	description = "Iron Ingot",
	inventory_image = "iron_ingot.png"
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