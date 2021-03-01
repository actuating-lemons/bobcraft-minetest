worldgen = {}

worldgen.overworld_top = 256
worldgen.overworld_bottom = 0

local c_wool = minetest.get_content_id("bobcraft_blocks:wool_green")

local c_air = minetest.get_content_id("air")
local c_grass = minetest.get_content_id("bobcraft_blocks:grass_block")
local c_dirt = minetest.get_content_id("bobcraft_blocks:dirt")
local c_stone = minetest.get_content_id("bobcraft_blocks:stone")

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

local np_second_layer = {
	offset = 0,
	scale = 1,
	spread = {x=256, y=256, z=256},
	seed = 42069,
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

	local sidelen = maxp.x - minp.x + 1
	local noise_base = get_perlin_map(np_base, {x=sidelen, y=sidelen, z=sidelen}, minp)

	local noise_top_layer = get_perlin_map(np_second_layer, {x=sidelen, y=sidelen, z=sidelen}, minp)
	local noise_second_layer = get_perlin_map(np_second_layer, {x=sidelen, y=sidelen, z=sidelen}, minp)
	

	local ni = 1
	for z = minp.z, maxp.z do
		for x = minp.x, maxp.x do
			y = math.floor(y_at_point(x, z, ni, noise_base))

			local top_node, mid_node, bottom_node

			top_node = c_grass
			mid_node = c_dirt
			bottom_node = c_stone

			if y <= maxp.y and y >= minp.y then
				local vi = area:index(x, y, z)
				if y < 0 then
					data[vi] = top_node
				end
			end

			local tl = math.floor((noise_top_layer[ni] + 5) * 3)
			if y - tl - 1 <= maxp.y and y - 1 >= minp.y then
				for yy = math.max(y - tl - 1, minp.y), math.min(y - 1, maxp.y) do
					local vi = area:index(x, yy, z)
					data[vi] = mid_node
				end
			end

			local sl = math.floor((noise_second_layer[ni] + 5) * 3)
			if y - sl - 2 >= minp.y then
				for yy = minp.y, math.min(y - sl - 2, maxp.y) do
					local vi = area:index(x, yy, z)
					data[vi] = bottom_node
				end
			end

			ni = ni + 1
		end
	end

	vm:set_data(data)
	vm:calc_lighting()
	vm:write_to_map()
	vm:update_liquids()
end)