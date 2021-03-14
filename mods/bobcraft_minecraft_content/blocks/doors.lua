-- Registers the doors with PilzAdam's Doors Mod.
-- We put it here for cleanliness of code.

doors.register_door("bobcraft_blocks:door", {
	description = "Wooden Door",
	inventory_image = "item_door.png",
	groups = {hand=1, axe=1, door=1, attached_node=1},
	tiles = {"door_wood.png"},
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

-- A special, un-craftable door that appears in temples.
doors.register_door("bobcraft_blocks:temple_door", {
	description = "Temple Door",
	inventory_image = "item_door_temple.png",
	groups = {pickaxe=1, door=1, attached_node=1},
	tiles = {"door_temple.png"},
	sounds = bobcraft_sounds.node_sound_stone(),
	sunlight = false,
	
	sound_open_door = "door_open",
	sound_close_door = "door_close",
	
	hardness = 3
})