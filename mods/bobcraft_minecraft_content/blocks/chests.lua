local S = minetest.get_translator("bobcraft_blocks")

local function chest_formspec(chest_pos)
	local pos = chest_pos.x .. "," .. chest_pos.y .. "," .. chest_pos.z
	local formspec =
		"size[9,9]" ..
		"list[nodemeta:" .. pos .. ";main;0,0.3;9,4;]" ..
		"list[current_player;main;0,4.5;9,3;9]" ..
		"list[current_player;main;0,7.85;9,1;]" ..
		"listring[nodemeta:" .. pos .. ";main]" ..
		"listring[current_player;main]"
	return formspec
end

minetest.register_node("bobcraft_blocks:chest", {
	description = S("Chest"),
	tiles = {
		"chest_top.png", "chest_top.png",
		"chest_side.png", "chest_side.png",
		"chest_side.png", "chest_front.png",
	},
	paramtype2 = "facedir",
	groups = {pickaxe=1},
	sounds = bobcraft_sounds.node_sound_wood(),
	is_ground_content = false,
	hardness = 2.5,

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		local inv = meta:get_inventory()
		inv:set_size('main', 9*4)
	end,

	on_rightclick = function(pos, node, player)
		minetest.sound_play({name="door_open", pos=pos})

		minetest.show_formspec(player:get_player_name(), "bobcraft_blocks:chest", chest_formspec(pos))
	end,

	after_dig_node = function(pos, oldnode, oldmeta, digger) -- we drop our inventory when broken
		for _, item in ipairs(oldmeta.inventory.main) do
			local item_drop = ItemStack(item)
			local item_count = item_drop:get_count()
			item_drop:set_count(1)
			for j=1, item_count do
				local dropped_item = minetest.add_item(table.copy(pos), item_drop)
				if dropped_item then
					dropped_item:get_luaentity().magnettime = break_flyto_time
				end
			end
		end
	end,
})