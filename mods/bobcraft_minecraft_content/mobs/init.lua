-- debugging
minetest.register_on_chat_message(function(name, message)
	local player = minetest.get_player_by_name(name)
	local pos = player:get_pos()
	if message == "baa" then
		minetest.add_entity(pos, "bobcraft_mobs:sheep")
	elseif message == "oink" then
		minetest.add_entity(pos, "bobcraft_mobs:pig")
	elseif message == "brains" then
		minetest.add_entity(pos, "bobcraft_mobs:zombie")
	end
end)

local mp = minetest.get_modpath("bobcraft_mobs")
dofile(mp.."/passive.lua")
dofile(mp.."/hostile.lua")