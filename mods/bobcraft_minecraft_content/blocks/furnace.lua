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
local function get_active_furnace_formspec(fuel_percent, item_percent)
	return "size[8,8.5]"..
		"list[context;src;2.75,0.5;1,1;]"..
		"list[context;fuel;2.75,2.5;1,1;]"..
		"image[2.75,1.5;1,1;furnace_fire_bg.png^[lowpart:"..
		(fuel_percent)..":furnace_fire_fg.png]"..
		"image[3.75,1.5;1,1;arrow_bg.png^[lowpart:"..
		(item_percent)..":arrow_fg.png^[transformR270]"..
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
	The allow_metadata_functions are all based on minetest_game.
]]
local function allow_metadata_inventory_put(pos, listname, index, stack, player)
	if minetest.is_protected(pos, player:get_player_name()) then
		return 0
	end
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	if listname == "fuel" then
		local fuel_time = minetest.get_item_group(stack:get_name(), "fuel")
		if fuel_time ~= 0 then
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
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()

	local srclist, fuellist
	local cookable, cooked
	local fueltime

	local fuel_time = meta:get_float("fuel_time") or 0
	local src_time = meta:get_float("src_time") or 0
	local fuel_totaltime = meta:get_float("fuel_totaltime") or 0

	local timer_elapsed = meta:get_int("timer_elapsed") or 0
	meta:set_int("timer_elapsed", timer_elapsed + 1)

	local update = true
	while elapsed > 0 and update do
		update = false

		srclist = inv:get_list("src")
		fuellist = inv:get_list("fuel")

		local aftercooked		
		cooked, aftercooked = minetest.get_craft_result({method = "cooking", width = 1, items = srclist})
		cookable = cooked.time ~= 0
		
		local elapse = math.min(elapsed, fuel_totaltime - fuel_time)
		if cookable then -- fuel should last long enough
			elapse = math.min(elapse, cooked.time - src_time)
		end

		-- Can we burn with that fuel?
		if fuel_time < fuel_totaltime then
			-- start burning!
			fuel_time = fuel_time + elapse

			-- there's a cookable item, is it ready?
			if cookable then
				src_time = src_time + elapse
				if src_time >= cooked.time then
					-- can we jam it in?
					if inv:room_for_item("dst", cooked.item) then
						inv:add_item("dst",cooked.item)
						inv:set_stack("src", 1, aftercooked.items[1])
						minetest.log("We should've cooked")
						update = true
					end
				else
					-- can't cook, did we have fuel?
					minetest.log("can't cook, need fuel")
					update = true
				end
			end
		else
			-- ran out of fuel
			if cookable then
				-- we need more fuel
				local fuelstack = fuellist[1]
				fueltime = minetest.get_item_group(fuelstack:get_name(), "fuel")

				if fueltime == 0 then
					-- no valid fuel was found
					fuel_totaltime = 0
					src_time = 0
				else
					-- take a fuel
					fuelstack:take_item(1)
					inv:set_stack("fuel", 1, fuelstack)

					update = true
					fuel_totaltime = fuel_totaltime + fueltime
				end
			else
				-- but we don't care we ran out
				fuel_totaltime = 0
				src_time = 0
			end
			fuel_time = 0
		end

		elapsed = elapsed - elapse
	end

	if fueltime and fuel_totaltime > fueltime then
		fuel_totaltime = fueltime.time
	end

	if srclist and srclist[1]:is_empty() then
		src_time = 0
	end

	local active = false

	local formspec = get_furnace_formspec()

	if fuel_totaltime ~= 0 then
		active = true
		local fuel_percent = 100 - math.floor(fuel_time / fuel_totaltime * 100)
		local item_percent = math.floor(src_time / cooked.time * 100)
		formspec = get_active_furnace_formspec(fuel_percent, item_percent)

		--minetest.swap_node(pos, "bobcraft_blocks:active_furnace")
	else
		--minetest.swap_node(pos, "bobcraft_blocks:furnace")
	end

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

minetest.register_node("bobcraft_blocks:active_furnace", {
	description = "Active Furnace",
	tiles = {
		"furnace_top.png", "furnace_bottom.png",
		"furnace_side.png", "furnace_side.png",
		"furnace_side.png", "furnace_front_active.png",
	},
	paramtype2 = "facedir",
	groups = {pickaxe=1},
	sounds = bobcraft_sounds.node_sound_stone(),
	is_ground_content = false,
	hardness = 3.5,

	on_timer = furnace_timer,

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