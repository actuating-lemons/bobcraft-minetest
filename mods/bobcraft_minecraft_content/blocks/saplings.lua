local function can_grow_sapling(pos)
	local lightlevel = minetest.get_node_light(pos)
	minetest.log(dump(lightlevel))
	if not lightlevel or lightlevel < 9 then
		return true --HACK: this forces trees to grow. For some reason, the light level is always 0!
	end

	return true
end

-- Copied from minetest_game
local function grow_tree(pos)
	minetest.remove_node(pos)
	local path = minetest.get_modpath("bobcraft_worldgen")
	minetest.place_schematic(pos, path.."/schematic/tree.mts", "random", nil, false, "place_center_x, place_center_z")
end

local function grow_sapling(pos)
	if not can_grow_sapling(pos) then
		-- try again in 5 minutes
		minetest.get_node_timer(pos):start(300)
		return
	end

	local node = minetest.get_node(pos)

	if node.name == "bobcraft_blocks:sapling" then
		grow_tree(pos)
	end
end

minetest.register_node("bobcraft_blocks:sapling", {
	description = "Sapling",
	tiles = {"oak_sapling.png"},
	wield_image = "oak_sapling.png",
	inventory_image = "oak_sapling.png",
	drawtype = "plantlike",
	walkable = false,
	sounds = bobcraft_sounds.node_sound_planty(),

	groups = {hand=1},
	hardness = 0,
	stack_max = bobutil.stack_max,

	on_timer = grow_sapling,
	on_construct = function(pos)
		-- 5 to 25 minutes
		minetest.get_node_timer(pos):start(math.random(300, 1500))
		-- minetest.get_node_timer(pos):start(math.random(3, 15))
	end,

	on_place = function(itemstack, placer, pointed_thing)
		return bobutil.on_plant(itemstack, placer, pointed_thing)
	end,
})