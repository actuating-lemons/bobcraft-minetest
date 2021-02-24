-- Sets the crafting grid

minetest.register_on_joinplayer(function(player)
	local inv = player:get_inventory()
	inv:set_width("craft", 2)
	inv:set_size("craft", 4)
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if fields.quit and formname == "bobcraft_blocks:crafting_table" then -- we've had our grid modified
		local inv = player:get_inventory()
		inv:set_width("craft", 2)
		inv:set_size("craft", 4)
	end
end)