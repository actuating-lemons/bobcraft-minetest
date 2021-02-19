
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

-- registers the various tools for me based on tier so I don't have to type out like 50 different tool registrations
local function register_tool_tier(tier)
	minetest.register_tool("bobcraft_tools:"..tier.."_axe", {
		description = bobutil.titleize(tier).." Axe",
		inventory_image = tier.."_axe.png",
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=tool_values.material_mining_level[tier],
			groupcaps={
				["axe_"..tier] = {
					times = tool_values.times["axe_"..tier],
					uses = tool_values.material_max_uses[tier],
					maxlevel = tool_values.material_mining_level[tier]
				}
			},
			damage_groups = {fleshy=2},
		},
		groups = {axe = 1}
	})
	minetest.register_tool("bobcraft_tools:"..tier.."_pickaxe", {
		description = bobutil.titleize(tier).." Pickaxe",
		inventory_image = tier.."_pickaxe.png",
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=tool_values.material_mining_level[tier],
			groupcaps={
				["pickaxe_"..tier] = {
					times = tool_values.times["pickaxe_"..tier],
					uses = tool_values.material_max_uses[tier],
					maxlevel = tool_values.material_mining_level[tier]
				}
			},
			damage_groups = {fleshy=2},
		},
		groups = {pickaxe = 1}
	})
	minetest.register_tool("bobcraft_tools:"..tier.."_shovel", {
		description = bobutil.titleize(tier).." Shovel",
		inventory_image = tier.."_shovel.png",
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=tool_values.material_mining_level[tier],
			groupcaps={
				["shovel_"..tier] = {
					times = tool_values.times["shovel_"..tier],
					uses = tool_values.material_max_uses[tier],
					maxlevel = tool_values.material_mining_level[tier]
				}
			},
			damage_groups = {fleshy=2},
		},
		groups = {shovel = 1}
	})
	minetest.register_tool("bobcraft_tools:"..tier.."_sword", {
		description = bobutil.titleize(tier).." Sword",
		inventory_image = tier.."_sword.png",
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=tool_values.material_mining_level[tier],
			groupcaps={
				["sword_"..tier] = {
					times = tool_values.times["sword_"..tier],
					uses = tool_values.material_max_uses[tier],
					maxlevel = tool_values.material_mining_level[tier]
				}
			},
			damage_groups = {fleshy=2},
		},
		groups = {sword = 1}
	})
end

register_tool_tier("wood")
register_tool_tier("stone")
register_tool_tier("iron")
register_tool_tier("gold")
register_tool_tier("diamond")