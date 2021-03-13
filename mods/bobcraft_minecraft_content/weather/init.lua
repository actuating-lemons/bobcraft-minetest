-- weather!

weather = {}
weather.weather = {}

local np_precipitation = {
	offset = 0,
	scale = 1,
	spread = {x = 64, y = 64, z = 64},
	seed = 900,
	octaves = 1,
	persist = 0,
	lacunarity = 2.0,
	flags = "defaults"
}

minetest.register_globalstep(function (dtime)

	for _, player in ipairs(minetest.get_connected_players()) do
		
		local pname = player:get_player_name()
		local ppos = player:get_pos()

		local nobj_precipitation = nobj_precipitation or minetest.get_perlin(np_precipitation)

		local nval_precipitation = nval_precipitation or nobj_precipitation:get2d({x=ppos.x, y=ppos.z})

		if nval_precipitation > 0 then
			weather.weather[pname] = "rain"
		else
			weather.weather[pname] = "clear"
		end
	end
	
end)

minetest.register_on_joinplayer(function(player)
	local pname = player:get_player_name()

	weather.weather[pname] = "clear"
end)