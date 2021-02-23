-- Registers the doors with PilzAdam's Doors Mod.
-- We put it here for cleanliness of code.

doors.register_door("bobcraft_blocks:door", {
	description = "Wooden Door",
	inventory_image = "item_door.png",
	groups = {hand=1, axe=1, door=1, attached_node=1},
	tiles_top = {"door_top.png"},
	tiles_bottom = {"door_bottom.png"},
	sounds = bobcraft_sounds.node_sound_wood(),
	sunlight = false,
	
	sound_open_door = "door_open",
	sound_close_door = "door_close",
	
	hardness = 3
})

doors.register_trapdoor("bobcraft_blocks:trapdoor", {
	description = "Wooden Trapdoor",
	inventory_image = "trapdoor_item.png",
	groups = {hand=1, axe=1, door=1, attached_node=1},
	tiles = {"trapdoor.png"},
	sounds = bobcraft_sounds.node_sound_wood(),
	sunlight = false,
	
	sound_open_door = "door_open",
	sound_close_door = "door_close",

	hardness = 3,
})