if minetest.settings:get_bool("creative_mode") then

	minetest.register_on_joinplayer(function(player)
		local player_name = player:get_player_name()
		local player_privs = minetest.get_player_privs(player_name)
		-- enable these by default in creative mode
		player_privs.fly = true
		player_privs.fast = true

		minetest.set_player_privs(player_name, player_privs)
	end)

	minetest.register_on_newplayer(function(player)
	
		local inv = player:get_inventory()
		inv:add_item("main", "bobcraft_blocks:stone")
		inv:add_item("main", "bobcraft_blocks:cobblestone")
		inv:add_item("main", "bobcraft_blocks:dirt")
		inv:add_item("main", "bobcraft_blocks:planks")
		inv:add_item("main", "bobcraft_blocks:log")
		inv:add_item("main", "bobcraft_blocks:leaves")

	end)

	dofile(minetest.get_modpath("bobcraft_gamemodes") .. "/inventory.lua")


	-- Unlimited node placement
	minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack)
		if placer and placer:is_player() then
			return true
		end
	end)
else -- Survival
end

-- Default
minetest.register_on_joinplayer(function(player)
	-- Set the main inventory size
	player:get_inventory():set_size("main", 9*4)
end)