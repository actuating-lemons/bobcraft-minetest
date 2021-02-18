--[[
	Oh my god was this a headache.
	I delved into minecraft's code, and found how the sky is determined.

	First, it gets the temperature of the biome, and generates it from HUE, SATURATION AND VALUE
	sO WE HAVE TO CONVERT THAT TO RGB!
	ARGH!
	And AFTER that, we need to dETERMINE THE ANGLE OF THE SKY!
	It's all a  massive headache. but hey, if I got it working, I got it working.
]]

local function hsv_rgb(H,S,V)
	-- wow this is turning out to be an expensive operation.

	local r,g,b = 0,0,0

	local c = (V/100) * (S/100)
	local x = c*(1 - math.abs((H/60) % 2 - 1))
	local m = (V/100) - c

	if(H >= 0 and H < 60) then
		r = c
		g = x
		b = 0    
    elseif(H >= 60 and H < 120) then
		r = x
		g = c
		b = 0    
    elseif(H >= 120 and H < 180) then
		r = 0
		g = c
		b = x
    
    elseif(H >= 180 and H < 240) then
		r = 0
		g = x
		b = c
    elseif(H >= 240 and H < 300) then
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

	local color = hsv_rgb(
		(2.2 - temp * 0.05)*100, -- Minecraft uses 0.62 here, but that was wrong and made the sky shit colour. So we use 2.2, because that's the rough hue i sampled from a screenshot. Wee!
		(0.5 + temp * 0.1)*100,
		100.0
	)
	
	-- Time of day
	-- I don't understand the math here fully, I just threw things at a graph plotter until I was happy.
	-- But the sky should start to lighten up at ~4am, and darken at 6pm.
	local whatever_this_is = 0 - minetest.get_timeofday() * math.pi * 1.9 - 0.25
	whatever_this_is = -math.cos(whatever_this_is) * 2 + 0.5

	if whatever_this_is < 0 then
		whatever_this_is = 0
	elseif whatever_this_is > 1 then
		whatever_this_is = 1
	end

	color.r = ((color.r * whatever_this_is) * 255)
	color.g = ((color.g * whatever_this_is) * 255)
	color.b = ((color.b * whatever_this_is) * 255)

	if color.r < 0 then
		color.r = 0
	end
	if color.r > 255 then
		color.r = 255
	end
	if color.g < 0 then
		color.g = 0
	end
	if color.g > 255 then
		color.g = 255
	end
	if color.b < 0 then
		color.b = 0
	end
	if color.b > 255 then
		color.b = 255
	end

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
				type="skybox"
			})
		end
	end
end

minetest.register_globalstep(function(dtime)
	set_player_skies()
end)