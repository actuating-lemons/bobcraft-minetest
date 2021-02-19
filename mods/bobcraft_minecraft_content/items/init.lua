minetest.register_craftitem("bobcraft_items:sticks", {
	description = "Stick",
	inventory_image = "sticks.png"
})

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