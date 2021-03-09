
local peak_digtime = 1 -- one second(?)

local function hoe_use(itemstack, placer, pointed_thing)
	if not pointed_thing.type == "node" then
		return itemstack
	end

	local pt = pointed_thing.under
	local ptnode = minetest.get_node(pt)
	local can_farmland = ptnode.name == "bobcraft_blocks:grass_block" or ptnode.name == "bobcraft_blocks:dirt"

	if not can_farmland then
		return itemstack	
	end

	minetest.set_node(pt, {name="bobcraft_blocks:farmland"})

	if not minetest.setting_getbool("creative_mode") then
		local toolname = itemstack:get_name()
		local toolmaterial = minetest.registered_tools[toolname]._material
		local max_uses = tool_values.material_max_uses[toolmaterial]
		itemstack:add_wear(
			65535 / (max_uses - 1)
		)
	end

	return itemstack
end

-- the hand
-- used the devgame for reference
-- TODO: CREATIVE HAND
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

-- registers the various tools for me based on tier so I don't have to type out like 50 different tool registrations.
-- material, if present, is the block/group to match against and do recipes for.
-- It just invokes bobcraft_crafting.do_tool_recipes()....
-- You can also use extragroups to add additional group values.
-- Such as for wooden tools, which have fuel=bobutil.fuel_times.small_wood.
local function register_tool_tier(tier, material, extragroups)
	extragroups = extragroups or {}

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
		groups = bobutil.merge_tables({axe=1}, extragroups),
		_material = tier
	})
	minetest.register_tool("bobcraft_tools:"..tier.."_hoe", {
		description = bobutil.titleize(tier).." Hoe",
		inventory_image = tier.."_hoe.png",
		tool_capabilities = {
			full_punch_interval = 1.0,
			max_drop_level=tool_values.material_mining_level[tier],
			groupcaps={
				["hoe_"..tier] = {
					times = tool_values.times["hoe_"..tier],
					uses = tool_values.material_max_uses[tier],
					maxlevel = tool_values.material_mining_level[tier]
				}
			},
			damage_groups = {fleshy=2},
		},
		groups = bobutil.merge_tables({hoe=1}, extragroups),
		on_place = hoe_use,
		_material = tier
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
		groups = bobutil.merge_tables({pickaxe=1}, extragroups),
		_material = tier
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
		groups = bobutil.merge_tables({shovel=1}, extragroups),
		_material = tier
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
		groups = bobutil.merge_tables({sword=1}, extragroups),
		_material = tier
	})
	
	if material then
		bobcraft_crafting.do_tool_recipes(tier, material)
	end
end

register_tool_tier("wood", "group:crafting_wood", {fuel=bobutil.fuel_times.medium_wood})
register_tool_tier("stone", "group:crafting_stone")
register_tool_tier("iron", "bobcraft_items:iron_ingot")
register_tool_tier("gold", "bobcraft_items:gold_ingot")
register_tool_tier("diamond", "bobcraft_items:diamond")

minetest.register_tool("bobcraft_tools:flint_and_steel", {
	inventory_image = "flint_and_steel.png",
	description = "flint and steel"
})
portals.register_portal_ignition_item(
	"bobcraft_tools:flint_and_steel",
	{name = "magic_fail", gain = 0.3}
)