-- Does the world gen stuff

-- variables
local bedrock = minetest.get_content_id("bobcraft_blocks:bedrock")
local buffer = {}

minetest.register_on_generated(function(minp, maxp, seed) -- the bedrock placer
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new({MinEdge=emin, MaxEdge=emax})
	local aream = VoxelArea:new({MinEdge={x=minp.x, y=worldgen.overworld_bottom, z=minp.z}, MaxEdge={x=maxp.x, y=worldgen.overworld_bottom, z=maxp.z}})
	local param2_data = vm:get_param2_data(buffer)
	local write = false

	-- I'm gonna be honest, I copied the *idea* of using a function for this from somewhere.
	-- I don't know where.
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

	-- bedrock
	set_layers(bedrock, worldgen.overworld_bottom, worldgen.overworld_bottom, minp, maxp)
	-- TODO: place something at the top of the overworld to curb it

	-- TODO: should we clear under bedrock? we use the v7 generator and it doesn't have a minimum....

	-- And now we set the foliage colours!
	local foliage_blocks = minetest.find_nodes_in_area(minp, maxp, {"bobcraft_blocks:grass_block"})

	for i=1, #foliage_blocks do
		local foliage_block_pos = area:index(foliage_blocks[i].x, foliage_blocks[i].y, foliage_blocks[i].z)
				
		local biome = minetest.get_biome_data(
			{
				x= foliage_blocks[i].x,
				y= foliage_blocks[i].y,
				z= foliage_blocks[i].z
			})
		if biome then
			local biomedef = minetest.registered_biomes[minetest.get_biome_name(biome.biome)]
			if biomedef then
				if biomedef._palette_index then
					param2_data[foliage_block_pos] = biomedef._palette_index
					write = true
				end
			end
		end

	end

	if write then
		vm:set_data(data)
		vm:set_param2_data(param2_data)
		vm:calc_lighting(nil, nil)
		vm:write_to_map()
		vm:update_liquids()
	end

end)