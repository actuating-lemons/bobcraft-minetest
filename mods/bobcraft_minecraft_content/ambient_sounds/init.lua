-- Plays ambient sounds. Such as cave sounds, water, lava, music, etc.
-- Reference taken from PilzAdam's ambient mod https://github.com/PilzAdam/MinetestAmbience/blob/master/init.lua

local music = {
	handler = {},
	frequency = 1,
	{name="plainsong", length = 1*60 + 14, gain = 0.3}
}

local function get_ambience(player)
	local table = {}

	table.music = music

	return table
end

local function play_sound(player, list, number)
	local player_name = player:get_player_name()

	if list.handler[player_name] == nil then
		local gain = 1.0
		if list[number].gain ~= nil then
			gain = list[number].gain
		end

		local handler = minetest.sound_play(list[number].name, {to_player=player_name, gain=gain})

		if handler ~= nil then
			list.handler[player_name] = handler
			minetest.after(list[number].length, function(args)
				local list = args[1]
				local player_name = args[2]
				if list.handler[player_name] ~= nil then
					minetest.sound_stop(list.handler[player_name])
					list.handler[player_name] = nil
				end
			end, {list, player_name})
		end
	end
end

local timer = 0
minetest.register_globalstep(function(dtime)
	timer = timer+dtime
	if timer < 1 then
		return
	end
	timer = 0
	
	for _,player in ipairs(minetest.get_connected_players()) do
		local ambiences = get_ambience(player)
		for _,ambience in pairs(ambiences) do
			if math.random(1, 100) <= ambience.frequency then
				play_sound(player, ambience, math.random(1, #ambience))
			end
		end
	end
end)