-- help functions

local function remove_top(pos)
	local n = minetest.get_node_or_nil(pos)
	if not n then return end
	local dir = minetest.facedir_to_dir(n.param2)
	local p = {x=pos.x+dir.x,y=pos.y,z=pos.z+dir.z}
	local n2 = minetest.get_node(p)
	if minetest.get_item_group(n2.name, "bed") == 2 and n.param2 == n2.param2 then
		minetest.remove_node(p)
	end
end

local function add_top(pos)
	local n = minetest.get_node_or_nil(pos)
	if not n or not n.param2 then
		minetest.remove_node(pos)
		return true
	end
	local dir = minetest.facedir_to_dir(n.param2)
	local p = {x=pos.x+dir.x,y=pos.y,z=pos.z+dir.z}
	local n2 = minetest.get_node_or_nil(p)
	local def = minetest.registered_items[n2.name] or nil
	if not n2 or not def or not def.buildable_to then
		minetest.remove_node(pos)
		return true
	end
	minetest.set_node(p, {name = n.name:gsub("%_bottom", "_top"), param2 = n.param2})
	return false
end


-- register nodes
function beds.register_bed(name, def)
	minetest.register_node(name .. "_bottom", {
		description = def.description,
		inventory_image = def.inventory_image,
		wield_image = def.wield_image,
		drawtype = "nodebox",
		tiles = def.tiles.bottom,
		paramtype = "light",
		paramtype2 = "facedir",
		stack_max = 1,
		groups = {snappy = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 1},
		sounds = bobcraft_sounds.node_sound_wood(),
		node_box = {
			type = "fixed",
			fixed = def.nodebox.bottom,
		},
		selection_box = {
			type = "fixed",
			fixed = def.selectionbox,
				
		},
		after_place_node = function(pos, placer, itemstack)
			return add_top(pos)
		end,	
		on_destruct = function(pos)
			remove_top(pos)
		end,
		on_rightclick = function(pos, node, clicker)
			beds.on_rightclick(pos, clicker)
		end,
		hardness = 0.2,
	})

	minetest.register_node(name .. "_top", {
		drawtype = "nodebox",
		tiles = def.tiles.top,
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy = 1, choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 2},
		sounds = bobcraft_sounds.node_sound_wood(),
		node_box = {
			type = "fixed",
			fixed = def.nodebox.top,
		},
		selection_box = {
			type = "fixed",
			fixed = {0, 0, 0, 0, 0, 0},
		},
		hardness = 0.2,
	})

	minetest.register_alias(name, name .. "_bottom")
end

-- simple (default)
beds.register_bed("bobcraft_beds:bed", {
	description = "Simple Bed",
	inventory_image = "beds_bed.png",
	wield_image = "beds_bed.png",
	tiles = {
	    bottom = {
		"bed_top_bottom.png^[transformR90",
		"planks.png",
		"bed_side_bottom.png",
		"bed_side_bottom.png^[transformfx",
		"blank.png",
		"bed_end_bottom.png"
	    },
	    top = {
		"bed_top_top.png^[transformR90",
		"planks.png", 
		"bed_side_top.png",
		"bed_side_top.png^[transformfx",
		"bed_end_top.png",
		"blank.png",
	    }
	},
	nodebox = {
	    bottom = {-0.5, -0.5, -0.5, 0.5, 0.06, 0.5},
	    top = {-0.5, -0.5, -0.5, 0.5, 0.06, 0.5},
	},
	selectionbox = {-0.5, -0.5, -0.5, 0.5, 0.06, 1.5}
})