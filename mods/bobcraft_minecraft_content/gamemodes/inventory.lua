-- ""inspiration""" taken from the minetest_game's creative_mode mod
local creative = {}

local inventories = {}
local creative_cache = {}

function creative.cache(items)
	creative_cache[items] = {}
	local i_cache = creative_cache[items]

	for name, def in pairs(items) do
		if def.groups.not_in_creative_inventory ~= 1 and
				def.description and def.description ~= "" then
			i_cache[name] = def
		end
	end
	table.sort(i_cache)
	return i_cache
end

function creative.init_inventory(player)
	local player_name = player:get_player_name()
	inventories[player_name] = {
		size = 0,
		start_i = 0,
	}

	minetest.create_detached_inventory("creative_"..player_name, {
		allow_move = function(inv, from_list, from_index, to_list, to_index, count, player_)
			if to_list == "main" then
				return 0
			end
			return count
		end,
		allow_put = function(inv, listname, index, stack, player_)
			return 0
		end,
	}
	, player_name)

	return inventories[player_name]
end

function creative.update_inventory(player_name, content)

	local inv = inventories[player_name] or
				creative.init_inventory(minetest.get_player_by_name(player_name))
	local player_inv = minetest.get_inventory({type = "detached", name = "creative_" .. player_name})
	
	local items = creative_cache[content] or creative.cache(content)

	local list = {}
	for name, def in pairs(items) do
		table.insert(list, name)
	end

	table.sort(list)
	
	player_inv:set_size("main", #list)
	player_inv:set_list("main", list)
	inv.size = #list

end

function creative.register_tab(name, title, items)
	sfinv.register_page("creative:" .. name, {
		title = title,
		is_in_nav = function(self, player, context)
			return minetest.is_creative_enabled(player:get_player_name())
		end,
		get = function(self, player, context)
			local player_name = player:get_player_name()
			
			creative.update_inventory(player_name, items)

			local inv = inventories[player_name]

			return sfinv.make_formspec(player, context,
			"list[detached:creative_" .. player_name .. ";main;0,0;8,8;" .. tostring(inv.start_i) .. "]" ..
			"field[0.25,8.5;8,1;search;;]" ..
			"button[8,0;1,1;go_up;^]" ..
			"button[8,1;1,1;go_down;v]" ..
			"", false)
		end,
		on_enter = function(self, player, context)
			local player_name = player:get_player_name()
			local inv = inventories[player_name]
			if inv then
				inv.start_i = 0
			end
		end,
		on_player_receive_fields = function(self, player, context, fields)
			local player_name = player:get_player_name()
			local inv = inventories[player_name]
			assert(inv)
			
			local start_i = inv.start_i or 0
			if fields.go_up then
				start_i = start_i - 8 * 8

				if start_i < 0 then
					start_i = inv.size - (inv.size % (8*8))
					if inv.size == start_i then
						start_i = math.max(0, inv.size - (8*8))
					end
				end
			end
			if fields.go_down then
				start_i = start_i + 8 * 8
				
				if start_i >= inv.size then
					start_i = 0
				end
			end

			inv.start_i = start_i
			sfinv.set_player_inventory_formspec(player, context)
		end
	})
end

creative.register_tab("list", "Creative List", minetest.registered_items)

function sfinv.get_homepage_name(player)
	return "creative:list"
end