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
	spread = {x=32, y=16, z=32},
	octaves = 4,
	seed = -11842,
	persist = 0.6
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

			top_node = biome.top
			mid_node = biome.middle
			bottom_node = biome.bottom

			if y <= maxp.y and y >= minp.y then
				local vi = area:index(x, y, z)
				if y < worldgen.overworld_sealevel then
					data[vi] = mid_node
				else
					data[vi] = top_node
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
						data[vi] = c_water
					end
				end
			end

			ni = ni + 1
		end
	end


	local noise_caves = get_perlin_map_3d(np_caves, {x=sidelen, y=sidelen, z=sidelen}, minp)
	local nixyz = 1
	for z = minp.z, maxp.z do
		for y = minp.y, maxp.y do
			local vi = area:index(minp.x, y, z)
			for x = minp.x, maxp.x do
				local cave = noise_caves[nixyz]
				
				-- caves
				if cave > 0.9 then
					data[vi] = c_air
				end


				vi = vi + 1
				nixyz = nixyz + 1
			end
		end
	end

	vm:set_data(data)

	-- Let minetest set the ores and decorations up
	minetest.generate_ores(vm)
	minetest.generate_decorations(vm)

	vm:calc_lighting()
	vm:write_to_map()
	vm:update_liquids()
end)