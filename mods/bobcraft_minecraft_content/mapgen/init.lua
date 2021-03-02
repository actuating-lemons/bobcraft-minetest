worldgen = {}

worldgen.overworld_top = 256
worldgen.overworld_bottom = 0
-- Doubles as the surface height too
worldgen.overworld_sealevel = 63

worldgen.hell_top = worldgen.overworld_bottom - 128 -- 128 block seperation between biomes
worldgen.hell_bottom = worldgen.hell_top - 128 -- 128 blocks tall hell

local c_wool = minetest.get_content_id("bobcraft_blocks:wool_green")

-- Commonly used content ids
local c_air = minetest.get_content_id("air")
local c_grass = minetest.get_content_id("bobcraft_blocks:grass_block")
local c_dirt = minetest.get_content_id("bobcraft_blocks:dirt")
local c_stone = minetest.get_content_id("bobcraft_blocks:stone")
local c_water = minetest.get_content_id("bobcraft_blocks:water_source")
local c_bedrock = minetest.get_content_id("bobcraft_blocks:bedrock")

function worldgen.get_perlin_map(noiseparam, sidelen, minp)
	local pm = minetest.get_perlin_map(noiseparam, sidelen)
    return pm:get_2d_map_flat({x = minp.x, y = minp.z, z = 0})
end
function worldgen.get_perlin_map_3d(noiseparam, sidelen, minp)
	local pm = minetest.get_perlin_map(noiseparam, sidelen)
    return pm:get_3d_map_flat({x = minp.x, y = minp.z, z = 0})
end

-- Base - the meat of the y height
worldgen.np_base = {
	offset = 0,
	scale = 1,
	spread = {x=256, y=256, z=256},
	seed = 69420,
	octaves = 6,
	persist = 0.5,
}
-- Overlay - applies on-top of the already set y height from Base
worldgen.np_overlay = {
	offset = 0,
	scale = 1,
	spread = {x=512, y=512, z=512},
	seed = 69420,
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
dofile(mp.."/biomes.lua")
dofile(mp.."/dimensions.lua")
dofile(mp.."/ores.lua")
dofile(mp.."/decorations.lua")

function worldgen.y_at_point(x, z, ni, biome, tempdiff, noise1, noise2)
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
	local noise_temperature = worldgen.get_perlin_map(worldgen.np_temperature, {x=1, y=1, z=1}, pos)
	local noise_rainfall = worldgen.get_perlin_map(worldgen.np_rainfall, {x=1, y=1, z=1}, pos)
	local temperature = noise_temperature[1]
	local rainfall = noise_rainfall[ni]

	return worldgen.get_biome_nearest(temperature, rainfall)
end

minetest.register_on_generated(function(minp, maxp, blockseed)
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new({MinEdge=emin, MaxEdge=emax})

	local function set_layers(block, min, max, minp, maxp)
		if (maxp.y >= min and minp.y <= max) then
			for y = min, max do
				for x = minp.x, maxp.x do
					for z = minp.z, maxp.z do
						local pos = area:index(x,y,z)
						data[pos] = block
					end
				end
			end
			write = true
		end
	end
	
	for i = 1, #worldgen.registered_dimensions do
		local dim = worldgen.registered_dimensions[i]
		if maxp.y >= dim.y_min and minp.y <= dim.y_max then
			data = dim.gen_func(minp, maxp, blockseed, vm, area, data)
		end

		-- The very last step is to set the bedrock up
		-- TODO: jittery bedrock
		if dim.seal_top then
			set_layers(dim.seal_node, dim.y_max, dim.y_max, minp, maxp)
		end
		if dim.seal_bottom then
			set_layers(dim.seal_node, dim.y_min, dim.y_min, minp, maxp)
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