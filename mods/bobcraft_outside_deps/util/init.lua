bobutil = {}

bobutil.titleize = function(str)
	str = str:gsub("_", " ")
	return str:gsub("^%l", string.upper)
end

bobutil.merge_tables = function(a,b)
	for key, value in pairs(b) do
		a[key] = value
	end
	return a
end

-- like minetest.swap_node, but only swaps if the name doesn't match
bobutil.replace_node = function(pos, new_node)
	local node = minetest.get_node(pos)
	if node.name == new_node then
		return
	end
	node.name = new_node
	minetest.swap_node(pos, node)
end

-- Returns the average of all positions
bobutil.avg_pos = function(list_of_pos)
	local posav = {0, 0, 0}
	local count = 0
	for i=1, #list_of_pos do
		local p = list_of_pos[i]
		posav[1] = posav[1] + p.x
		posav[2] = posav[2] + p.y
		posav[3] = posav[3] + p.z
		count = count + 1
	end

	if count > 0 then
		posav = vector.new(posav[1] / count, posav[2] / count,
			posav[3] / count)
	end

	return posav
end

-- Arguabely this falls under the jurisdiction of an inside dependency, but you can fight me on that.
bobutil.foliage_palette = "foliage_palette.png"
bobutil.foliage_palette_indices = {
	-- Unique
	plains = 0,
	desert = 1,
	swamp = 2,
	forest = 3,
	extreme_hills = 4,
	ocean = 5,

	-- Duplicates
}

bobutil.get_new_biome_coloured_block = function(pos, block)
	local biome_data = minetest.get_biome_data(pos)
	local palette_index = bobutil.foliage_palette_indices.plains
	if biome_data then
		local biome_name = minetest.get_biome_name(biome_data.biome)
		local biome_def = minetest.registered_biomes[biome_name]
		if biome_def then
			palette_index = biome_def._palette_index
		end
	end

	return {name = block.name, param2 = palette_index}
end

bobutil.foliage_block_figure = function(pos)
	local self = minetest.get_node(pos)
	if self.param2 == 0 then -- no colour set
		local new_node = bobutil.get_new_biome_coloured_block(pos, self)
		minetest.swap_node(pos, new_node)
	end
	return
end

-- Fuel time
-- Converted from minecraft ticks to seconds, as that's what the furnace uses.
bobutil.fuel_times = {
	wood = 15,
	medium_wood = 10, -- like wooden tools, bowls, etc.
	small_wood = 5, -- like sticks, saplings
	coal = 80,
	magma = 1000, -- truly impressive
	firey = 120, -- such as blaze rods
}

bobutil.stack_max = 64 -- We do this here so If I wanna change it, it wouldn't be too difficult.

-- Handles all the planting for us
-- Doesn't let us place on non-plantable surfaces
bobutil.on_plant = function(itemstack, placer, pointed_thing)
	local pos = pointed_thing.under
	local node = minetest.get_node_or_nil(pos)
	if not node then
		return itemstack
	end
	local nodedef = minetest.registered_nodes[node.name]
	local plantable = minetest.get_node_group(node.name, "plantable")

	-- we do the tricky stuff with the () to keep our default value of buildable_to as true
	if not nodedef or not (nodedef.buildable_to or true) then
		return itemstack
	end

	if plantable and plantable ~= 0 then
		itemstack:take_item()
		return itemstack
	end
end

-- Moves the items out of the inventory, into main.
-- Also drops them if there's no room!
function bobutil.move_item_outta(stack, player, inv)

	if inv:room_for_item("main", stack) then
		inv:add_item("main", stack)
	else
		minetest.add_item(player:get_pos(), stack)
	end

end
function bobutil.move_items_outta(player, inventory)
	local inv = player:get_inventory()
	local list = inv:get_list(inventory)
	if list ~= nil then
		for i, stack in ipairs(list) do
			bobutil.move_item_outta(stack, player, inv)
			stack:clear()
			inv:set_stack(inventory, i, stack)
		end
	end
end

function bobutil.vector_to_colourstring(vector)
	local str = "#"
	str = str .. string.format("%02x", vector.x)
	str = str .. string.format("%02x", vector.y)
	str = str .. string.format("%02x", vector.z)

	return str
end

-- matches two strings
function bobutil.match(str, filter)
	if filter == "" then return 0 end
	if str:lower():find(filter, 1, true) then
		return #str - #filter
	end
	return bobutil.MATCH_NONE
end
-- returned when there's no match in the match function
bobutil.MATCH_NONE = 999

function bobutil.rotate_and_place(itemstack, placer, pointed_thing)
	local p0 = pointed_thing.under
	local p1 = pointed_thing.above
	local param2 = 0

	if placer then
		local placer_pos = placer:get_pos()
		if placer_pos then
			param2 = minetest.dir_to_facedir(vector.subtract(p1, placer_pos))
		end

		local finepos = minetest.pointed_thing_to_face_pos(placer, pointed_thing)
		local fpos = finepos.y % 1

		if p0.y - 1 == p1.y or (fpos > 0 and fpos < 0.5)
				or (fpos < -0.5 and fpos > -0.999999999) then
			param2 = param2 + 20
			if param2 == 21 then
				param2 = 23
			elseif param2 == 23 then
				param2 = 21
			end
		end
	end
	return minetest.item_place(itemstack, placer, pointed_thing, param2)
end