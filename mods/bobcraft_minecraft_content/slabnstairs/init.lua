local function register_stair(name, blockdef)
	blockdef.paramtype = "light"
	blockdef.paramtype2 = "facedir"
	blockdef.drawtype = "nodebox"
	blockdef.node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, -0.5,
			  0.5, 0, 0.5 },
			{ -0.5, 0, 0,
			  0.5, 0.5, 0.5 } 
		}
	}

	for i, tile in ipairs(blockdef.tiles) do
		if type(tile) == "string" then
			blockdef.tiles[i] = {name = tile, align_style = "world"}			
		elseif type(tile) == "table" then
			blockdef.tiles[i].align_style = "world"
		end
	end

	blockdef.on_place = function(itemstack, placer, pointed_thing)
		return bobutil.rotate_and_place(itemstack, placer, pointed_thing)
	end

	minetest.register_node(name,blockdef)

end

local function register_slab(name, blockdef)
	blockdef.paramtype = "light"
	blockdef.paramtype2 = "wallmounted"
	blockdef.drawtype = "nodebox"
	blockdef.node_box = {
		type = "fixed",
		fixed = {
			{ -0.5, -0.5, -0.5,
			  0.5, 0, 0.5 },
		}
	}

	minetest.register_node(name,blockdef)

end

local function register_extra_variants(namespace, blockname, blockdesc)
	local namespaced_blockname = "bobcraft_blocks:" .. blockname
	local blockdef = minetest.registered_nodes[namespaced_blockname]
	if not blockdef then return end

	-- STAIR
	register_stair(namespace .. blockname .. "_stair", {
		description = blockdesc .. " Stair",
		tiles = blockdef.tiles,
		
		groups = blockdef.groups,
		sounds = blockdef.sounds,

		hardness = blockdef.hardness
	})
	bobcraft_crafting.register_stair_craft(namespace .. blockname .. "_stair", namespaced_blockname)

	-- SLAB
	register_slab(namespace .. blockname .. "_slab", {
		description = blockdesc .. " Slab",
		tiles = blockdef.tiles,

		groups = blockdef.groups,
		sounds = blockdef.sounds,

		hardness = blockdef.hardness
	})
	bobcraft_crafting.register_slab_craft(namespace .. blockname .. "_slab", namespaced_blockname)

end

register_extra_variants("bobcraft_blocks_xtra:","cobblestone", "Cobblestone")
register_extra_variants("bobcraft_blocks_xtra:","planks", "Wood")
register_extra_variants("bobcraft_blocks_xtra:","stone_bricks", "Stone Brick")

-- stone slab/stair
-- FIXME: these don't appear in the creative menu. Why?
local stonedef = minetest.registered_nodes["bobcraft_blocks:stone"]
register_stair("bobcraft_blocks_xtra:stone_stair",{
	description = "Stone Stairs",
	tiles = {"stone_slab_side.png","stone_slab_top.png",
	"stone_stair_side.png","stone_stair_side.png^[transformfx", "stone_slab_side.png"},
	sounds = stonedef.sounds,
	groups = stonedef.groups,
	hardness = stonedef.hardness,
})
bobcraft_crafting.register_stair_craft("bobcraft_blocks_xtra:stone_stair", "bobcraft_blocks:stone")
register_slab("bobcraft_blocks_xtra:stone_slab",{
	description = "Stone Slab",
	tiles = {"stone_slab_top.png","stone_slab_top.png","stone_slab_side.png"},
	sounds = stonedef.sounds,
	groups = stonedef.groups,
	hardness = stonedef.hardness,
})
bobcraft_crafting.register_slab_craft("bobcraft_blocks_xtra:stone_slab", "bobcraft_blocks:stone")