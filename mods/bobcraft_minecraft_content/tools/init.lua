
local peak_digtime = 1 -- one second(?)

-- the hand
-- used the devgame for reference
minetest.register_item(":", {
	type = "none",
	wield_image = "wieldhand.png",
	wield_scale = {x=1.0,y=1.0,z=2.0},
	range = 4,
	tool_capabilities = {
		max_drop_level = 0,
		groupcaps={
			tool_pickaxe_wood = {times=tool_values.times.pickaxe_wood, uses=tool_values.material_max_uses.wood, maxlevel=tool_values.material_mining_level.wood},
		},
		damage_groups = {fleshy=1},
	},
	groups = hand_groups,
})

minetest.register_tool("bobcraft_tools:wood_pickaxe", {
	description = "Wood Pickaxe",
	inventory_image = "wood_pickaxe.png",
	groups = {pickaxe_wood=1},
	tool_capabilities = {
		full_punch_interval = 0,
		max_drop_level=1,
		groupcaps={
			pickaxe_wood = {times=tool_values.times.pickaxe_wood, uses=tool_values.material_max_uses.wood, maxlevel=tool_values.material_mining_level.wood},
		},
		damage_groups = {fleshy=2},
		punch_attack_uses = 30,
	},
})
minetest.register_tool("bobcraft_tools:stone_pickaxe", {
	description = "Stone Pickaxe",
	inventory_image = "stone_pickaxe.png",
	groups = {pickaxe_wood=1},
	tool_capabilities = {
		full_punch_interval = 0,
		max_drop_level=1,
		groupcaps={
			pickaxe_wood = {times=tool_values.times.pickaxe_stone, uses=tool_values.material_max_uses.stone, maxlevel=tool_values.material_mining_level.stone},
		},
		damage_groups = {fleshy=2},
		punch_attack_uses = 30,
	},
})
minetest.register_tool("bobcraft_tools:iron_pickaxe", {
	description = "Stone Pickaxe",
	inventory_image = "stone_pickaxe.png",
	groups = {pickaxe_wood=1},
	tool_capabilities = {
		full_punch_interval = 0,
		max_drop_level=1,
		groupcaps={
			pickaxe_wood = {times=tool_values.times.pickaxe_iron, uses=tool_values.material_max_uses.iron, maxlevel=tool_values.material_mining_level.iron},
		},
		damage_groups = {fleshy=2},
		punch_attack_uses = 30,
	},
})

