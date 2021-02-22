-- Registers the doors with PilzAdam's Doors Mod.
-- We put it here for cleanliness of code.

doors.register_door("bobcraft_blocks:door", {
	description = "Wooden Door",
	inventory_image = "item_door.png",
	groups = {snappy=1,choppy=2,oddly_breakable_by_hand=2,flammable=2,door=1},
	tiles_top = {"door_top.png"},
	tiles_bottom = {"door_bottom.png"},
	sounds = bobcraft_sounds.node_sound_wood(),
	sunlight = false,
})