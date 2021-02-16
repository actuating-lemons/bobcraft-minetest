-- Does the world gen stuff

-- variables
local bedrock = minetest.get_content_id("bobcraft_blocks:bedrock")

minetest.register_on_generated(function(minp, maxp, seed) -- the bedrock placer
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new({MinEdge=emin, MaxEdge=emax})
	local aream = VoxelArea:new({MinEdge={x=minp.x, y=worldgen.overworld_bottom, z=minp.z}, MaxEdge={x=maxp.x, y=worldgen.overworld_bottom, z=maxp.z}})

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
		end
	end

	-- bedrock
	set_layers(bedrock, worldgen.overworld_bottom, worldgen.overworld_bottom, minp, maxp)
	-- TODO: place something at the top of the overworld to curb it

	-- TODO: should we clear under bedrock? we use the v7 generator and it doesn't have a minimum....

	vm:set_data(data)
	vm:calc_lighting()
	vm:write_to_map()
	vm:update_liquids()

end)