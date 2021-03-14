local S = minetest.get_translator("bobcraft_items")

local bucketable_liquids = {}
local bucketable_nodes = {} -- list of nodes -> bucketable def

minetest.register_craftitem("bobcraft_items:bucket", {
	-- empty bucket

	description = S("Bucket"),
	inventory_image = "bucket.png",
	liquids_pointable = true,

	max_stack = 1,

	on_use = function(itemstack, user, pointed_thing)
		local node = minetest.get_node(pointed_thing.under)
		local nodedef = minetest.registered_nodes[node.name]

		if bucketable_nodes[node.name] then
			minetest.remove_node(pointed_thing.under)
			return ItemStack(bucketable_nodes[node.name].bucket_name)
		end
	end,
})

local function register_bucketable_liquid(def)
	assert(def.nodes, "bucketable def without liquids!")

	table.insert(bucketable_liquids, def)

	for _, node in ipairs(def.nodes) do
		bucketable_nodes[node] = def
	end

	minetest.register_craftitem(def.bucket_name, {
		description = def.bucket_desc,

		inventory_image = "bucket.png^bucket_fill.png^[colorize:"..def.color,

		max_stack = 1,

		on_place = function (itemstack, user, pointed_thing)
			local pos = pointed_thing.above
			minetest.set_node(pos, {name = def.nodes[1]})
			
			return ItemStack("bobcraft_items:bucket")
		end
	})


end

register_bucketable_liquid({
	nodes = {"bobcraft_blocks:lava_source"}, -- we always place the first in our list
	color = "#ff0000", -- colour to tint the fill texture
	bucket_desc = S("Lava Bucket"), -- description in item def
	bucket_name = "bobcraft_items:lava_bucket", -- name
})

register_bucketable_liquid({
	nodes = {"bobcraft_blocks:water_source"}, -- we always place the first in our list
	color = "#000077", -- colour to tint the fill texture
	bucket_desc = S("Water Bucket"), -- description in item def
	bucket_name = "bobcraft_items:water_bucket", -- name
})