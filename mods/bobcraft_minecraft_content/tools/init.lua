
local peak_digtime = 1 -- one second(?)

-- the hand
-- used the devgame for reference
if minetest.settings:get_bool("creative_mode") then -- TODO: creative hand

	local digtime = 50
	local caps = {times = {digtime, digtime, digtime}, uses = 0, maxlevel = 256}

	minetest.register_item(":", {
		type = "none",
		wield_image = "hand.png",
		wield_scale = {x=1,y=1,z=4},
		range = 10,
		tool_capabilities = {
			full_punch_interval = 0.5,
			max_drop_level = 3,
			groupcaps = {
				hand = {
					times = tool_values.times.creative_hand,
					uses = 0
				}
			},
			damage_groups = {fleshy = 10}
		}
	})
else
	local caps = {
		times = {[1] = peak_digtime*3, [2] = peak_digtime*3, [3] = peak_digtime*2},
		uses = 0,
		maxlevel = 1
	}
	minetest.register_item(":", {
		type = "none",
		wield_image = "hand.png",
		wield_scale = {x=1,y=1,z=4},
		tool_capabilities = {
			full_punch_interval = 1,
			max_drop_level = 0,
			groupcaps = {
				hand = {
					times = tool_values.times.hand,
					uses = 0
				}
			},
			damage_groups = {fleshy = 1}
		}
	})
end

----
-- Axes
----
minetest.register_tool("bobcraft_tools:wood_axe", {
	description = "Wooden Axe",
	inventory_image = "wood_axe.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=tool_values.material_mining_level.wood,
		groupcaps={
			axe_wood = {
				times = tool_values.times.axe_wood,
				uses = tool_values.material_max_uses.wood,
				maxlevel = tool_values.material_mining_level.wood 
			}
		},
		damage_groups = {fleshy=2},
	},
	groups = {axe = 1, flammable = 2}
})
minetest.register_tool("bobcraft_tools:stone_axe", {
	description = "Stone Axe",
	inventory_image = "stone_axe.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=tool_values.material_mining_level.stone,
		groupcaps={
			axe_stone = {
				times = tool_values.times.axe_stone,
				uses = tool_values.material_max_uses.stone,
				maxlevel = tool_values.material_mining_level.stone 
			}
		},
		damage_groups = {fleshy=2},
	},
	groups = {axe = 1}
})
minetest.register_tool("bobcraft_tools:iron_axe", {
	description = "Iron Axe",
	inventory_image = "iron_axe.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=tool_values.material_mining_level.iron,
		groupcaps={
			axe_iron = {
				times = tool_values.times.axe_iron,
				uses = tool_values.material_max_uses.iron,
				maxlevel = tool_values.material_mining_level.iron
			}
		},
		damage_groups = {fleshy=2},
	},
	groups = {axe = 1,}
})

----
-- Pickaxes
----
minetest.register_tool("bobcraft_tools:wood_pickaxe", {
	description = "Wooden Pickaxe",
	inventory_image = "wood_pickaxe.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=tool_values.material_mining_level.wood,
		groupcaps={
			pickaxe_wood = {
				times = tool_values.times.pickaxe_wood,
				uses = tool_values.material_max_uses.wood,
				maxlevel = tool_values.material_mining_level.wood 
			}
		},
		damage_groups = {fleshy=2},
	},
	groups = {pickaxe = 1, flammable = 2}
})
minetest.register_tool("bobcraft_tools:stone_pickaxe", {
	description = "Stone Pickaxe",
	inventory_image = "stone_pickaxe.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=tool_values.material_mining_level.stone,
		groupcaps={
			pickaxe_stone = {
				times = tool_values.times.pickaxe_stone,
				uses = tool_values.material_max_uses.stone,
				maxlevel = tool_values.material_mining_level.stone 
			}
		},
		damage_groups = {fleshy=2},
	},
	groups = {pickaxe = 1}
})
minetest.register_tool("bobcraft_tools:iron_pickaxe", {
	description = "Iron Pickaxe",
	inventory_image = "iron_pickaxe.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=tool_values.material_mining_level.iron,
		groupcaps={
			pickaxe_iron = {
				times = tool_values.times.pickaxe_iron,
				uses = tool_values.material_max_uses.iron,
				maxlevel = tool_values.material_mining_level.iron
			}
		},
		damage_groups = {fleshy=2},
	},
	groups = {pickaxe = 1}
})