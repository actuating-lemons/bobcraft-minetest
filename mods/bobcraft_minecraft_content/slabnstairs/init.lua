local function register_extra_variants(namespace, blockname, blockdesc)
	local namespaced_blockname = "bobcraft_blocks:" .. blockname
	local blockdef = minetest.registered_nodes[namespaced_blockname]
	if not blockdef then return end

	-- STAIR
	minetest.register_node(namespace .. blockname .. "_stair", {
		description = blockdesc .. " Stair",
		tiles = blockdef.tiles,

		paramtype = "light",
		paramtype2 = "facedir",

		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.5,
				  0.5, 0, 0.5 },
				{ -0.5, 0, 0,
				  0.5, 0.5, 0.5 } 
			}
		},
		
		groups = blockdef.groups,

		hardness = blockdef.hardness
	})
	bobcraft_crafting.register_stair_craft(namespace .. blockname .. "_stair", namespaced_blockname)

	-- SLAB
	minetest.register_node(namespace .. blockname .. "_slab", {
		description = blockdesc .. " Slab",
		tiles = blockdef.tiles,

		paramtype = "light",
		paramtype2 = "facedir",

		drawtype = "nodebox",
		node_box = {
			type = "fixed",
			fixed = {
				{ -0.5, -0.5, -0.5,
				  0.5, 0, 0.5 }
			}
		},
		
		groups = blockdef.groups,

		hardness = blockdef.hardness
	})
	bobcraft_crafting.register_slab_craft(namespace .. blockname .. "_stair", namespaced_blockname)


end

register_extra_variants("bobcraft_blocks_xtra:","cobblestone", "Cobblestone")
register_extra_variants("bobcraft_blocks_xtra:","planks", "Wood")