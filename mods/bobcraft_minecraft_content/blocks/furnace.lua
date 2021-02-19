--[[
	Referenced from the default:furnace in minetest_game
]]

local function get_furnace_formspec()
	return "size[8,8.5]"..
		"list[context;src;2.75,0.5;1,1;]"..
		"list[context;fuel;2.75,2.5;1,1;]"..
		"image[2.75,1.5;1,1;furnace_fire_bg.png]"..
		"image[3.75,1.5;1,1;arrow_bg.png^[transformR270]"..
		"list[context;dst;5,1.5;1,1;]"..
		"list[current_player;main;0,4.25;8,1;]"..
		"list[current_player;main;0,5.5;8,3;8]"..
		"listring[context;dst]"..
		"listring[current_player;main]"..
		"listring[context;src]"..
		"listring[current_player;main]"..
		"listring[context;fuel]"..
		"listring[current_player;main]"
end

--[[ 
	The allow_metadata_functions are all copied from minetest_game.
	May change in future.
]]
local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	if listname == "fuel" then
		if minetest.get_craft_result({method="fuel", width=1, items={stack}}).time ~= 0 then
			if inv:is_empty("src") then
				meta:set_string("infotext", S("Furnace is empty"))
			end
			return stack:get_count()
		else
			return 0
		end
	elseif listname == "src" then
		return stack:get_count()
	elseif listname == "dst" then
		return 0
	end
end

local function allow_metadata_inventory_move(pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack(from_list, from_index)
	return allow_metadata_inventory_put(pos, to_list, to_index, stack, player)
end

local function allow_metadata_inventory_take(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	return stack:get_count()
end

local furnace_timer = function(pos, elapsed)
	-- I don't understand what default:furnace does, so because I want to release this *before* next month,
	-- I've disabled furnace times.

	-- TODO: time for smelting

	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	local srclist, fuellist
	local cookable, cooked
	local aftercooked

	local fuel_time = meta:get_float("fuel_time") or 0
	local src_time = meta:get_float("src_time") or 0

	local update = true
	while update do
		update = false

		srclist = inv:get_list("src")
		fuellist = inv:get_list("fuel")
		
		cooked, aftercooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
		cookable = cooked.time ~= 0
		
		if cookable then
			if inv:room_for_item("dst", cooked.item) then
				inv:add_item("dst",cooked.item)
				inv:set_stack("src", 1, aftercooked.items[1])
				update = true
			end
		end
	end

	local formspec = get_furnace_formspec()

	meta:set_string("formspec", formspec)
	meta:set_float("fuel_time", fuel_time)
	meta:set_float("src_time", src_time)

	return true
end

minetest.register_node("bobcraft_blocks:furnace", {
	description = "Furnace",
	tiles = {
		"furnace_top.png", "furnace_bottom.png",
		"furnace_side.png", "furnace_side.png",
		"furnace_side.png", "furnace_front.png",
	},
	paramtype2 = "facedir",
	groups = {pickaxe=1},
	sounds = bobcraft_sounds.node_sound_stone(),
	is_ground_content = false,
	hardness = 3.5,

	on_timer = furnace_timer,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size('src', 1)
		inv:set_size('fuel', 1)
		inv:set_size('dst', 1)
		furnace_timer(pos, 0)
	end,
	on_metadata_inventory_move = function(pos)
		minetest.get_node_timer(pos):start(1.0)
	end,
	on_metadata_inventory_put = function(pos)
		-- start timer function, it will sort out whether furnace can burn or not.
		minetest.get_node_timer(pos):start(1.0)
	end,
	on_metadata_inventory_take = function(pos)
		-- check whether the furnace is empty or not.
		minetest.get_node_timer(pos):start(1.0)
	end,
	on_blast = function(pos)
		local drops = {}
		minetest.remove_node(pos)
		return drops
	end,

	allow_metadata_inventory_put = allow_metadata_inventory_put,
	allow_metadata_inventory_move = allow_metadata_inventory_move,
	allow_metadata_inventory_take = allow_metadata_inventory_take,
})