
local peak_digtime = 1 -- one second(?)

-- the hand
-- used the devgame for reference
if minetest.settings:get_bool("creative_mode") then

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
				crumbly = caps,
				cracky = caps,
				snappy = caps,
				choppy = caps,
				oddly_breakable_by_hand = caps,
				dig_immediate = {
					times = {[2] = digtime, [3] = 0},
					uses = 0, maxlevel = 256
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
				crumbly = caps,
				cracky = caps,
				snappy = caps,
				choppy = caps,
				oddly_breakable_by_hand = {times = {[1] = peak_digtime, [2] = peak_digtime*0.5, [3] = peak_digtime*0.25}, uses = 0},
			},
			damage_groups = {fleshy = 1}
		}
	})
end

minetest.register_tool("bobcraft_tools:wood_axe", {
	description = "Wooden Axe",
	inventory_image = "wood_axe.png",
	tool_capabilities = {
		full_punch_interval = 1.0,
		max_drop_level=0,
		groupcaps={
			choppy = {times={[2]=1.00, [3]=0.60}, uses=10, maxlevel=1},
			axey = {[1] = peak_digtime*3, [2] = peak_digtime*3, [3] = peak_digtime*2}
		},
		damage_groups = {fleshy=2},
	},
	groups = {axe = 1, flammable = 2}
})