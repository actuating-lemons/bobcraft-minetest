worldgen = {}

worldgen.overworld_top = 256
worldgen.overworld_bottom = 0
-- Doubles as the surface height too
worldgen.overworld_sealevel = worldgen.overworld_bottom + 63
worldgen.overworld_seafloor = worldgen.overworld_bottom + 31
-- sets where we will randomly plot a sturcture
worldgen.overworld_struct_min = worldgen.overworld_bottom + 25
worldgen.overworld_struct_max = worldgen.overworld_sealevel - 5

worldgen.hell_top = worldgen.overworld_bottom - 128 -- 128 block seperation between biomes
worldgen.hell_bottom = worldgen.hell_top - 192 -- 192 blocks tall hell
worldgen.hell_sealevel = worldgen.hell_bottom + 63
worldgen.hell_pillarlevel = (worldgen.hell_bottom + worldgen.hell_top) / 2 -- HACK: don't touch, we do this to make sure only one y level gets tested for pillars.

local c_wool = minetest.get_content_id("bobcraft_blocks:wool_green")

-- Commonly used content ids
local c_air = minetest.get_content_id("air")
local c_grass = minetest.get_content_id("bobcraft_blocks:grass_block")
local c_dirt = minetest.get_content_id("bobcraft_blocks:dirt")
local c_stone = minetest.get_content_id("bobcraft_blocks:stone")
local c_water = minetest.get_content_id("bobcraft_blocks:water_source")
local c_bedrock = minetest.get_content_id("bobcraft_blocks:bedrock")

function worldgen.get_perlin_map(noiseparam, sidelen, minp, buffer)
	local pm = minetest.get_perlin_map(noiseparam, sidelen)
    return pm:get_2d_map_flat({x = minp.x, y = minp.z, z = 0}, buffer)
end
function worldgen.get_perlin_map_3d(noiseparam, sidelen, minp, buffer)
	local pm = minetest.get_perlin_map(noiseparam, sidelen)
    return pm:get_3d_map_flat({x = minp.x, y = minp.y, z = minp.z}, buffer)
end

-- Used for smittering the bedrock
worldgen.np_bedrock = {
	offset = 0,
	scale = 10,
	spread = {x=1, y=1, z=1},
	seed = -minetest.get_mapgen_setting("seed"), -- we get the inverse of the map's seed, to make the bedrock ALWAYS generate with seed 0. A quirk (bug?) minecraft has that is pretty neat.
	octaves = 1,
	persist = 0.5,
}

-- TODO: the following nose parameters are ALL for the overworld.
-- This doesn't seem right with the concept of dimensions, so we need to move them to dimension specific areas.

-- Base - the meat of the y height
worldgen.np_base = {
	offset = 0,
	scale = 5,
	spread = {x=256, y=256, z=256},
	seed = 69420,
	octaves = 4,
	persist = 0.6,
	lacunarity = 2.0,
	flags = "defaults",
}
-- Overlay - multiplies on-top of the already set y height from Base
worldgen.np_overlay = {
	offset = 0,
	scale = 1,
	spread = {x=512, y=512, z=512},
	seed = 42078,
	octaves = 6,
	persist = 0.5,
}
-- Overlay2 - removes from the base + overlay1
worldgen.np_overlay2 = {
	offset = 0,
	scale = 1,
	spread = {x=512, y=512, z=512},
	seed = 47238239, -- key mash
	octaves = 6,
	persist = 0.5,
}

-- second layer - the shape of the dirt/stone mix, irrespective of surface
worldgen.np_second_layer = {
	offset = 0,
	scale = 1,
	spread = {x=256, y=256, z=256},
	seed = 42069,
	octaves = 6,
	persist = 0.5,
}

-- caves - we cut caves into the ground, 'nuff said
worldgen.np_caves = {
	offset = 0,
	scale = 2,
	spread = {x=32, y=32, z=32},
	octaves = 4,
	seed = 1867986957268147339, -- "cave!"
	persist = 0.5,
	lacunarity = 2,
}
worldgen.np_caves2 = {
	offset = 0,
	scale = 2,
	spread = {x=32, y=32, z=32},
	octaves = 4,
	seed = -6644799973611538138, -- "cave?"
	persist = 0.5,
	lacunarity = 2,
}
worldgen.np_caves3 = {
	offset = 0,
	scale = 2,
	spread = {x=32, y=32, z=32},
	octaves = 4,
	seed = -4674843423187234620, -- "cave..."
	persist = 0.5,
	lacunarity = 2,
}
-- The main hell cavern.
worldgen.np_hell_cavern = {
	offset = 1.2,
	scale = 1,
	spread = {x=256, y=128, z=256},
	octaves = 5,
	seed = 410430084494322969, -- "SATANSATANSATAN"
	persist = 0.6,
	lacunarity = 2,
	flags = "eased",
}
-- Pillars!
worldgen.np_hell_pillar = {
	offset = 0,
	scale = 1,
	spread = {x=256, y=256, z=256},
	octaves = 3,
	seed = 446846456165165, -- Keymash
	persist = 0.6,
	lacunarity = 2
}

-- Temperature - How we generate temperature values
worldgen.np_temperature = {
	offset = 0,
	scale = 2,
	spread = {x=256, y=256, z=256},
	seed = -5012447954499666283, -- python's hash() function returned this for "temperature"
	octaves = 6,
	persist = 0.5,
}
-- Rainfall - How we generate humidity values
worldgen.np_rainfall = {
	offset = 0,
	scale = 2,
	spread = {x=256, y=256, z=256},
	seed = -5394576791132434734, -- python's hash() function returned this for "rainfall"
	octaves = 2,
	persist = 0.5,
}

local mp = minetest.get_modpath("bobcraft_worldgen")
dofile(mp.."/structures.lua")
dofile(mp.."/biomes.lua")
dofile(mp.."/dimensions.lua")
dofile(mp.."/ores.lua")
dofile(mp.."/decorations.lua")

worldgen.get_nearest_dimension = bobutil.get_nearest_dimension

-- Returns the biome at the pos.
function worldgen.get_biome(pos)
	local noise_temperature = worldgen.get_perlin_map(worldgen.np_temperature, {x=1, y=1, z=1}, pos)
	local noise_rainfall = worldgen.get_perlin_map(worldgen.np_rainfall, {x=1, y=1, z=1}, pos)
	local temperature = noise_temperature[1]
	local rainfall = noise_rainfall[ni]
	local dimension = worldgen.get_nearest_dimension(pos)
	local biome = worldgen.get_biome_nearest(temperature, rainfall, dimension.biome_list)

	return biome
end

-- call the dimension's init
for i = 1, #worldgen.registered_dimensions do
	local dim = worldgen.registered_dimensions[i]
	if dim.init ~= nil then
		dim.init(dim)
	end
end

local world_data_buffer = {}
function worldgen.get_temperature(pos)
	local noise_temperature = worldgen.get_perlin_map(worldgen.np_temperature, {x=1, y=1, z=1}, pos)

	return noise_temperature[1]
end

minetest.register_on_generated(function(minp, maxp, blockseed)
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data(world_data_buffer)
	local area = VoxelArea:new({MinEdge=emin, MaxEdge=emax})

	local function set_layers(block, noise, min, max, minp, maxp)
		local nixyz = 1
		if noise ~= nil then
			local h = maxp.x - minp.x + 1
			noise = worldgen.get_perlin_map_3d(noise, {x=h,y=h,z=h}, minp)
		end
		if (maxp.y >= min and minp.y <= max) then
			for y = min, max do
				for x = minp.x, maxp.x do
					for z = minp.z, maxp.z do
						local vi = area:index(x,y,z)

						if noise == nil then
							data[vi] = block
						else
							if noise[nixyz] > 0.5 then
								data[vi] = block
							end
						end

						nixyz = nixyz + 1
					end
				end
			end
		end
	end

	local light = 0
	
	for i = 1, #worldgen.registered_dimensions do
		local dim = worldgen.registered_dimensions[i]
		if maxp.y >= dim.y_min and minp.y <= dim.y_max then
			data = dim.gen_func(dim, minp, maxp, blockseed, vm, area, data)
			light = dim.min_light
		end

		-- The very last step is to set the bedrock up
		-- TODO: jittery bedrock
		if dim.seal_top then
			set_layers(dim.seal_node, nil, dim.y_max, dim.y_max, minp, maxp)
			set_layers(dim.seal_node, worldgen.np_bedrock, dim.y_max-dim.seal_thickness, dim.y_max, minp, maxp)
		end
		if dim.seal_bottom then
			set_layers(dim.seal_node, nil, dim.y_min, dim.y_min, minp, maxp)
			set_layers(dim.seal_node, worldgen.np_bedrock, dim.y_min, dim.y_min+dim.seal_thickness, minp, maxp)
		end

	end

	vm:set_data(data)

	-- Let minetest set the ores and decorations up
	minetest.generate_ores(vm)
	minetest.generate_decorations(vm)
	
	vm:set_lighting({day=light, night=light}, false)
	vm:calc_lighting()

	vm:write_to_map()
	vm:update_liquids()
end)