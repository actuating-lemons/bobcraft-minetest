worldgen = {}

worldgen.overworld_top = 256
worldgen.overworld_bottom = 0
-- Doubles as the surface height too
worldgen.overworld_sealevel = 63


local mp = minetest.get_modpath("bobcraft_worldgen")
dofile(mp.."/biomes.lua")
dofile(mp.."/ores.lua")
dofile(mp.."/decorations.lua")

local c_wool = minetest.get_content_id("bobcraft_blocks:wool_green")

local c_air = minetest.get_content_id("air")
local c_grass = minetest.get_content_id("bobcraft_blocks:grass_block")
local c_dirt = minetest.get_content_id("bobcraft_blocks:dirt")
local c_stone = minetest.get_content_id("bobcraft_blocks:stone")
local c_water = minetest.get_content_id("bobcraft_blocks:water_source")

local function get_perlin_map(noiseparam, sidelen, minp)
	local pm = minetest.get_perlin_map(noiseparam, sidelen)
    return pm:get_2d_map_flat({x = minp.x, y = minp.z, z = 0})
end
local function get_perlin_map_3d(noiseparam, sidelen, minp)
	local pm = minetest.get_perlin_map(noiseparam, sidelen)
    return pm:get_3d_map_flat({x = minp.x, y = minp.z, z = 0})
end

-- Base - the meat of the y height
local np_base = {
	offset = 0,
	scale = 1,
	spread = {x=256, y=256, z=256},
	seed = 69420,
	octaves = 6,
	persist = 0.5,
}
-- Overlay - applies on-top of the already set y height from Base
local np_overlay = {
	offset = 0,
	scale = 1,
	spread = {x=512, y=512, z=512},
	seed = 69420,
	octaves = 6,
	persist = 0.5,
}

-- second layer - the shape of the dirt/stone mix, irrespective of surface
local np_second_layer = {
	offset = 0,
	scale = 1,
	spread = {x=256, y=256, z=256},
	seed = 42069,
	octaves = 6,
	persist = 0.5,
}

-- caves - we cut caves into the ground, 'nuff said
local np_caves = {
	offset = 0,
	scale = 2,
	spread = {x=32, y=32, z=32},
	octaves = 4,
	seed = 1867986957268147339, -- "cave!"
	persist = 0.5,
	lacunarity = 2,
}
local np_caves2 = {
	offset = 0,
	scale = 2,
	spread = {x=32, y=32, z=32},
	octaves = 4,
	seed = -6644799973611538138, -- "cave?"
	persist = 0.5,
	lacunarity = 2,
}
local np_caves3 = {
	offset = 0,
	scale = 2,
	spread = {x=32, y=32, z=32},
	octaves = 4,
	seed = -4674843423187234620, -- "cave..."
	persist = 0.5,
	lacunarity = 2,
}

-- Temperature - How we generate temperature values
local np_temperature = {
	offset = 0,
	scale = 2,
	spread = {x=256, y=256, z=256},
	seed = -5012447954499666283, -- python's hash() function returned this for "temperature"
	octaves = 6,
	persist = 0.5,
}
-- Rainfall - How we generate humidity values
local np_rainfall = {
	offset = 0,
	scale = 2,
	spread = {x=256, y=256, z=256},
	seed = -5394576791132434734, -- python's hash() function returned this for "rainfall"
	octaves = 2,
	persist = 0.5,
}

local function y_at_point(x, z, ni, biome, tempdiff, noise1, noise2)
	local y
	-- local y_effector = biome.y_effector * tempdiff
	local y_effector = 1.0 -- TODO: Y_EFFCTOR TO MAKE BIOMES HAVE UNIQUE-ER LAND SCAPES

	y = 32 * noise1[ni] / (4 * y_effector)
	y = y * noise2[ni] * (4 * y_effector)

	y = y + worldgen.overworld_sealevel

	return y
end

-- Returns the biome at the pos.
function worldgen.get_biome(pos)
	local noise_temperature = get_perlin_map(np_temperature, {x=1, y=1, z=1}, pos)
	local noise_rainfall = get_perlin_map(np_rainfall, {x=1, y=1, z=1}, pos)
	local temperature = noise_temperature[1]
	local rainfall = noise_rainfall[ni]

	return worldgen.get_biome_nearest(temperature, rainfall)
end

minetest.register_on_generated(function(minp, maxp, blockseed)
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new({MinEdge=emin, MaxEdge=emax})

	local sidelen = maxp.x - minp.x + 1
	local noise_base = get_perlin_map(np_base, {x=sidelen, y=sidelen, z=sidelen}, minp)
	local noise_overlay = get_perlin_map(np_overlay, {x=sidelen, y=sidelen, z=sidelen}, minp)

	local noise_top_layer = get_perlin_map(np_second_layer, {x=sidelen, y=sidelen, z=sidelen}, minp)
	local noise_second_layer = get_perlin_map(np_second_layer, {x=sidelen, y=sidelen, z=sidelen}, minp)

	local noise_temperature = get_perlin_map(np_temperature, {x=sidelen, y=sidelen, z=sidelen}, minp)
	local noise_rainfall = get_perlin_map(np_rainfall, {x=sidelen, y=sidelen, z=sidelen}, minp)
	

	local ni = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			local top_node, mid_node, bottom_node
			local temperature = noise_temperature[ni]
			local rainfall = noise_rainfall[ni]
			local biome = worldgen.get_biome_nearest(temperature, rainfall)
			local tempdiff = math.abs(biome.temperature - temperature)

			local y = math.floor(y_at_point(x, z, ni, biome, tempdiff, noise_base, noise_overlay))

			above_node = biome.above
			top_node = biome.top
			mid_node = biome.middle
			bottom_node = biome.bottom

			if y <= maxp.y and y >= minp.y then
				local vi = area:index(x, y, z)
				local via = area:index(x, y+1, z) -- vi-above
				if y < worldgen.overworld_sealevel then
					data[vi] = mid_node
				else
					data[vi] = top_node
					if above_node ~= c_air then
						data[via] = above_node
					end
				end
			end

			local tl = math.floor((noise_top_layer[ni] + 1))
			if y - tl - 1 <= maxp.y and y - 1 >= minp.y then
				for yy = math.max(y - tl - 1, minp.y), math.min(y - 1, maxp.y) do
					local vi = area:index(x, yy, z)
					data[vi] = mid_node
				end
			end

			local sl = math.floor((noise_second_layer[ni] + 1))
			if y - sl - 2 >= minp.y then
				for yy = minp.y, math.min(y - sl - 2, maxp.y) do
					local vi = area:index(x, yy, z)
					data[vi] = bottom_node
				end
			end

			for yy = minp.y, maxp.y do
				local vi = area:index(x, yy, z)
				-- the sea
				if yy <= worldgen.overworld_sealevel then
					if data[vi] == c_air then
						data[vi] = biome.liquid
						if yy == worldgen.overworld_sealevel then
							data[vi] = biome.liquid_top
						end
					end
				end
			end

			ni = ni + 1
		end
	end


	local noise_caves = get_perlin_map_3d(np_caves, {x=sidelen, y=sidelen, z=sidelen}, minp)
	local noise_caves2 = get_perlin_map_3d(np_caves2, {x=sidelen, y=sidelen, z=sidelen}, minp)
	local noise_caves3 = get_perlin_map_3d(np_caves2, {x=sidelen, y=sidelen, z=sidelen}, minp)
	local nixyz = 1
	for x = minp.x, maxp.x do
		for y = minp.y, maxp.y do
			for z = minp.z, maxp.z do
				local vi = area:index(x, y, z)

				local cave, cave2, cave3 = noise_caves[nixyz], noise_caves2[nixyz], noise_caves3[nixyz]

				if (cave ^ 2 + cave2 ^ 2 + cave3 ^ 2) < 0.04 then
					if data[vi] ~= air then
						-- If it's ground content, smash our way through it
						if data[vi] == c_stone or
						data[vi] == c_dirt or
						data[vi] == c_grass or
						data[vi] == c_sand or
						data[vi] == c_sandstone then
							data[vi] = c_air
						end
					end
				end

				nixyz = nixyz + 1
			end
		end
	end

	vm:set_data(data)

	-- Let minetest set the ores and decorations up
	minetest.generate_ores(vm)
	minetest.generate_decorations(vm)

	vm:set_lighting({day=0, night=0})
	vm:calc_lighting()
	vm:write_to_map()
	vm:update_liquids()
end)