-- ""inspiration""" taken from the minetest_game's creative_mode mod
local creative = {}

local inventories = {}
local creative_cache = {}

function creative.init_inventory(player)
	local name = player:get_player_name()
	inventories[name] = {
		size = 0,
		filter = "",
		start_i = 0
	}

	minetest.create_detached_inventory("creative_"..name, 
	{ 
	allow_move = function(inv, from_list, from_index, to_list, to_index, count, player_) 
		local name = player_:get_player_name() or ""
		if not minetest.is_creative_enabled(player_) or to_list == "main" then
			return 0
		end
		return count
	end,
	allow_put = function(inv, listname, index, stack, player_)
		return -1
	end,
	allow_take = function(inv, listname, index, stack, player_)
		local name = player_:get_player_name() or ""
		if not minetest.is_creative_enabled(player_) or to_list == "main" then
			return 0
		end
		return -1
	end,
	on_move = function(inv, from_list, from_index, to_list, to_index, count, player_) end,
	},
	name)

	return inventories[name]
end

function creative.init_cache(items)
	creative_cache[items] = {}
	local cache = {}
	
	for name, def in pairs(items) do
		if def.groups.not_in_creative_inventory ~= 1 and def.description and def.description ~= "" then
			cache[name] = def
		end
	end

	table.sort(cache)
	return cache
end

function creative.get_creative_list(content)
	local items = creative_cache[content] or creative.init_cache(content)
	local creative_list = {}

	for name, def in pairs(items) do
		creative_list[#creative_list+1] = name
	end
	
	table.sort(creative_list)
	return creative_list
end

function creative.update_inventory(playername, content)
	local inventory = inventories[playername] or creative.init_inventory(minetest.get_player_by_name(playername))
	local player_inventory = minetest.get_inventory({type = "detached", name = "creative_"..playername})

	local creative_list = creative.get_creative_list(content)

	player_inventory:set_size("main",#creative_list)
	player_inventory:set_list("main",creative_list)
	inventory.size = #creative_list
end

function creative.register_tab(name, title, items)
	brpdinv.register_page("creative:" .. name, {
		title = title,
		is_in_nav = function(self, player, context)
			return minetest.is_creative_enabled(player:get_player_name())
		end,
		get = function(self, player, context)
			local player_name = player:get_player_name()
			creative.update_inventory(player_name, items)
			local inv = inventories[player_name]
			return brpdinv.make_formspec(player, context,
				"list[current_player;main;0,5;9,4;]" ..
				"listring[detached:creative_" .. player_name .. ";main]" ..
				"scrollbar[7,0;1,4;vertical;creative_scroll;]" ..
				"scroll_container[0,0;9,5;creative_scroll;vertical;]" ..
				"list[detached:creative_" .. player_name .. ";main;0,0;7,20;]" .. -- TODO: 20? what if we go past that?
				"scroll_container_end[]" ..
				"", true)
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
		end
	})
end

creative.register_tab("inventory", "All", minetest.registered_items)

function brpdinv.get_homepage_name(player)
	return "creative:inventory"
end