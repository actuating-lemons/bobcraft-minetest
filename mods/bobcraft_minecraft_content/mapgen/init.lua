worldgen = {}

worldgen.overworld_top = 256
worldgen.overworld_bottom = 0

local c_wool = minetest.get_content_id("bobcraft_blocks:wool_green")

local function get_perlin_map(noiseparam, sidelen, minp)
	local pm = minetest.get_perlin_map(noiseparam, sidelen)
    return pm:get_2d_map_flat({x = minp.x, y = minp.z, z = 0})
end

local np_base = {
	offset = 0,
	scale = 1,
	spread = {x=256, y=256, z=256},
	seed = 69420,
	octaves = 6,
	persist = 0.5,
}

local function y_at_point(x, z, ni, noise1)
	local y

	y = 25 * noise1[ni] / 3

	return y
end

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

	local noise1 = get_perlin_map(np_base, {x=sidelen, y=sidelen, z=sidelen}, minp)

	local heightmap = {}
	

	local ni = 1
	for z = z0, z1 do
		for x = x0, x1 do
			y = math.floor(y_at_point(x, z, ni, noise1))

			local vi = area:index(x, y, z)
			data[vi] = c_wool

			ni = ni + 1
		end
	end

	vm:set_data(data)
	vm:calc_lighting()
	vm:write_to_map()
	vm:update_liquids()
end)