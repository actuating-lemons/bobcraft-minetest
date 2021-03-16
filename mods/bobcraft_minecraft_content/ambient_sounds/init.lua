-- Plays ambient sounds. Such as cave sounds, water, lava, music, etc.
-- Reference taken from PilzAdam's ambient mod https://github.com/PilzAdam/MinetestAmbience/blob/master/init.lua
-- And minetest_game's env_sounds mod

-- The range we can hear ambient sounds from their source
local audio_range = {x=16, y=16, z=16}

local music = {
	-- CAVE MUSIC, OVERWORLD
	{name="mineral", length = 5*60 + 1, gain = 0.3, y_max = worldgen.overworld_seafloor, y_min = worldgen.overworld_bottom},
	{name="caves2", length = 4*60 + 49, gain = 0.3, y_max = worldgen.overworld_seafloor, y_min = worldgen.overworld_bottom},

	-- SURFACE MUSIC, OVERWORLD
	{name="beachcomber", length = 5*60 + 21, gain = 0.3, y_min = worldgen.overworld_seafloor},
}
local music_handler = {}
local music_frequency = 25

local hell_ambience = {
	{name="hell_bells", length = 1*60 + 41, gain = 0.4, frequency = 100}, -- the bells ring loud.
	{name="hell_wind", length = 3*60 + 20, gain = 0.25, frequency = 950},
	{name="hell_children", length = 41, gain = 0.45, frequency = 50}, -- children aren't quiet, let alone hell children!
}
local dimension_handler = {}

local lava_sounds = {
	handler = {},
	frequency = 900,
	positioned = true,
	{name="lava_pops", length=3, gain = 0.5}
}
local water_sounds = {
	handler = {},
	frequency = 750,
	positioned = true,
	{name="water_ambience", length=3, gain = 0.25}
}
local waterfall_sounds = {
	handler = {},
	frequency = 1000,
	positioned = true,
	{name="waterfall_ambience", length=2, gain = 0.25}
}

local function get_ambience(player)
	local sndtable = {}

	local ppos = player:get_pos()

	-- Music
	sndtable.music = {
		frequency = music_frequency,
		handler = music_handler
	}
	for i, musicdef in ipairs(music) do
		local ymin = musicdef.y_min or -31000
		local ymax = musicdef.y_max or 31000
		if ppos.y > ymin and ppos.y < ymax then
			table.insert(sndtable.music, musicdef)
		end
	end

	-- Ambient Sounds
	local ppos = player:get_pos()
	ppos = vector.add(ppos, player:get_properties().eye_height)
	local areamin = vector.subtract(ppos, audio_range)
	local areamax = vector.add(ppos, audio_range)

	local lava = minetest.find_nodes_in_area(areamin, areamax, {"group:lava"}, true)
	if next(lava) ~= nil then
		sndtable.lava = lava_sounds
		-- calculate avg. position
		local avges = {}
		for blocks, _ in pairs(lava) do
			for _, pos in pairs(lava[blocks]) do
				avges[#avges+1] = pos
			end
		end
		sndtable.lava.position = bobutil.avg_pos(avges) -- the averages of the averages
	end

	local water = minetest.find_nodes_in_area(areamin, areamax, {"group:water_source"}, true)
	if next(water) ~= nil then
		sndtable.water = water_sounds
		-- calculate avg. position
		local avges = {}
		for blocks, _ in pairs(water) do
			for _, pos in pairs(water[blocks]) do
				avges[#avges+1] = pos
			end
		end
		sndtable.water.position = bobutil.avg_pos(avges) -- the averages of the averages
	end

	local waterfall = minetest.find_nodes_in_area(areamin, areamax, {"group:water_flow"}, true)
	if next(waterfall) ~= nil then
		sndtable.waterfall = waterfall_sounds
		-- calculate avg. position
		local avges = {}
		for blocks, _ in pairs(waterfall) do
			for _, pos in pairs(waterfall[blocks]) do
				avges[#avges+1] = pos
			end
		end
		sndtable.waterfall.position = bobutil.avg_pos(avges) -- the averages of the averages
	end

	-- dimensional ambient sounds, that which can always play in a dimension
	local in_hell = ppos.y > worldgen.hell_bottom and ppos.y < worldgen.hell_top

	if in_hell then
		sndtable.hell = {
			frequency = 1000,
			handler = dimension_handler,
		}

		local snd = bobutil.weighted_random(hell_ambience, "frequency")

		table.insert(sndtable.hell, snd)
	else -- HACK; we also disable the hell ambience if we're not in hell!
		local player_name = player:get_player_name()
		if dimension_handler[player_name] then
			minetest.sound_stop(dimension_handler[player_name])
			dimension_handler[player_name] = nil
		end
	end

	return sndtable
end

local function play_sound(player, list, number, pos)
	local player_name = player:get_player_name()

	if list.handler[player_name] == nil then
		local gain = 1.0
		if list[number].gain ~= nil then
			gain = list[number].gain
		end

		local handler = minetest.sound_play(list[number].name, {to_player=player_name, gain=gain,
		pos = list.position})

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
			if math.random(1, 1000) <= ambience.frequency and #ambience > 0 then
				play_sound(player, ambience, math.random(1, #ambience), ambience.position)
			end
		end
	end
end)