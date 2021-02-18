--[[
	Oh my god was this a headache.
	I delved into minecraft's code, and found how the sky is determined.

	First, it gets the temperature of the biome, and generates it from HUE, SATURATION AND VALUE
	sO WE HAVE TO CONVERT THAT TO RGB!
	ARGH!
	And AFTER that, we need to dETERMINE THE ANGLE OF THE SKY!
	It's all a  massive headache. but hey, if I got it working, I got it working.
]]

local function hsv_rgb(hsv_colour)
	-- wow this is turning out to be an expensive operation.

	local r,g,b = 0,0,0

	local H = hsv_colour[1]
	local S = hsv_colour[2]
	local V = hsv_colour[3]

	local c = (V) * (S)
	local x = c*(1 - ((H/60) % 2) - 1)
	local m = (V) - c

	minetest.log(H)

	if(H >= 0 and H < 0.6) then
		r = c
		g = x
		b = 0    
    elseif(H >= 0.6 and H < 1.2) then
		r = x
		g = c
		b = 0    
    elseif(H >= 1.2 and H < 1.8) then
		r = 0
		g = c
		b = x
    
    elseif(H >= 1.8 and H < 2.4) then
		r = 0
		g = x
		b = c
    elseif(H >= 2.4 and H < 3) then
		r = x
		g = 0
		b = c
    else
		r = c
		g = 0
		b = x
	end


	return {
		r=r+m,
		g=g+m,
		b=b+m,
	}

end

local function get_sky_color(temp)
	-- Temperature
	temp = temp / 3
	if temp < -1 then
		temp = -1
	end

	if temp > 1.0 then
		temp = 1
	end

	local color = hsv_rgb({
		0.62 - temp * 0.05,
		0.5 + temp * 0.1,
		1.0,
	})

	minetest.log(dump(color))
	
	-- Time of day
	local whatever_this_is = minetest.get_timeofday()

	if whatever_this_is < 0 then
		whatever_this_is = 0
	elseif whatever_this_is > 1 then
		whatever_this_is = 1
	end

	color.r = (color.r * whatever_this_is) * 255
	color.g = (color.g * whatever_this_is) * 255
	color.b = (color.b * whatever_this_is) * 255

	return color

end

local function set_player_skies()
	for _, player in ipairs(minetest.get_connected_players()) do
		local player_pos = player:get_pos()
		local player_biome = minetest.get_biome_data(player_pos)

		if player_biome then
			local player_biome_name = minetest.get_biome_name(player_biome.biome)
			local player_biome_data = minetest.registered_biomes[player_biome_name]
			local player_biome_temp = player_biome_data._temperature or 0.5

			player:set_sky({
				base_color=get_sky_color(player_biome_temp), 
				type="plain"
			})
		end
	end
end

minetest.register_globalstep(function(dtime)
	set_player_skies()
end)