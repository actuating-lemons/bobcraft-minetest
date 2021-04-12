-- Sets up a 3d hand

minetest.register_node("3dplayer:3dhand", {
	description = "",
	tiles = {"tib.png"},
	inventory_image = "",

	visual_scale = 1,
	wield_scale = {x=1,y=1,z=1},
	paramtype = "light",
	drawtype = "mesh",
	mesh = "playerhand.b3d"
})

-- Give the player the hand
-- TODO: security implications? (https://github.com/minetest/minetest/issues/8559)
minetest.register_on_joinplayer(function(player)
	player:get_inventory():set_size("hand", 1)
	player:get_inventory():set_stack("hand", 1, "3dplayer:3dhand")
end)