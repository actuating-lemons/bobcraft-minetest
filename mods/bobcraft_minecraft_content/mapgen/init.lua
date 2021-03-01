worldgen = {}

worldgen.overworld_top = 256
worldgen.overworld_bottom = 0

np_base = {
	offset = 0,
	scale = 1,
	spread = {x = 192, y = 192, z = 192},
	octaves = 4,
	persist = 0.6,
	lacunarity = 2.0,
}

minetest.register_on_generated(function(minp, maxp, blockseed)
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new({MinEdge=emin, MaxEdge=emax})

	local x1 = maxp.x
	local y1 = maxp.y
	local z1 = maxp.z
	local x0 = minp.x
	local y0 = minp.y
	local z0 = minp.z

	local minpos = {x=x0, y=y0, z=z0}

	local sidelen = x1 - x0 + 1

	local noise_base = minetest.get_perlin_map(np_base, {x=sidelen,y=sidelen,z=sidelen})
	local noise_map = noise_base:get_3d_map_flat(minpos)

	local heightmap = {}
	

	local ni = 1
	for z = z0, z1 do
		for y = y0, y1 do
			local vi = area:index(x0, y, z)
			for x = x0, x1 do
				local base = noise_map[ni]

				if base < -1 then
					data[vi] = minetest.get_content_id("bobcraft_blocks:wool_red")
				end

				ni = ni + 1
				vi = vi + 1
			end
		end
	end

	vm:set_data(data)
	vm:calc_lighting()
	vm:write_to_map()
	vm:update_liquids()
end)