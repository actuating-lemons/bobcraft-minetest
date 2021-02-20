-- Greendust is our equivalent of redstone.
-- We should probably move it to its' own mod, but right now, this does the ore and dust.
-- Of-course, we're going to need to do a LOT to get a proper redstone system

local greendust = {}

greendust.colour_from_power = function(pos, node, power)
	local palette = power
	minetest.swap_node(pos, {name=node.name, param1=node.param1, param2=palette})
end

local kinetic_energy_keep_time = 2.5 -- how many seconds to glow after being punched or walked on

minetest.register_node("bobcraft_blocks:greendust_ore", {
	description = "Green Dust Ore",
	tiles = {"greendust_ore_inactive.png"},
	is_ground_content = true,
	sounds = bobcraft_sounds.node_sound_stone(),

	hardness = 3,
	groups = {pickaxe=3,},
	drop = "bobcraft_blocks:greendust",
	stack_max = bobutil.stack_max,

	on_punch = function(pos, node, puncher, pointed_thing)
		bobutil.replace_node(pos, "bobcraft_blocks:activated_greendust_ore")
		minetest.get_node_timer(pos):start(kinetic_energy_keep_time)
	end
})

minetest.register_node("bobcraft_blocks:activated_greendust_ore", {
	description = "Green Dust Ore",
	tiles = {"greendust_ore_active.png"},
	is_ground_content = true,
	sounds = bobcraft_sounds.node_sound_stone(),

	light_source = 5,

	hardness = 3,
	groups = {pickaxe=3, not_in_creative_inventory = 1},
	drop = "bobcraft_blocks:greendust",
	stack_max = bobutil.stack_max,

	on_timer = function(pos, elapsed)
		-- TODO: is there some way to test here if the player is still hitting us? if so, we should reset the timer here.
		bobutil.replace_node(pos, "bobcraft_blocks:greendust_ore")
	end,
	on_punch = function(pos, node, digger)
		minetest.get_node_timer(pos):set(kinetic_energy_keep_time,0) -- reset the timer
	end,
})

minetest.register_node("bobcraft_blocks:greendust", {
	description = "Green Dust",
	wield_image = "greendust.png",
	inventory_image = "greendust.png",
	use_texture_alpha = "clip",

	walkable = false,
	paramtype = "light",
	sunlight_propagates = true,

	groups = {hand=1, greendust=1, greendust_conduit=1},

	paramtype2 = "color",
	palette = "magic.png",
	param2 = 0,

	drawtype = "raillike",
	tiles = {
		"greendust_floor_line.png", -- no way
		"greendust_floor_curve.png", -- two way
		"greendust_floor_t.png", -- three way
		"greendust_floor_plus.png", -- four way
	},
	selection_box = {
		type = "fixed",
		fixed = {-0.5, -0.5, -0.5, 0.5, -0.3, 0.5}
	},

	greendust = {
		on_power = function(pos, node)
			minetest.sound_play(pos, {name="greendust_active_loop"})
		end
	},

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		-- Power is 0-15
		meta:set_int("power", 0)
	end,
})

minetest.register_node("bobcraft_blocks:greendust_source", {
	description = "Greendust Source",
	tiles = {"lava_still.png"},

	groups = {greendust=1, greendust_source=1},

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_int("power", 15)
		greendust.colour_from_power(pos, minetest.get_node(pos), 15)
	end,

	paramtype2 = "color",
	palette = "magic.png",
	param2 = 0,

})

-- TODO: this is *really* slow, cumbersome, and probably resource intensive.
--		 Is there any way for us to do it in a 'node_update' function, like minecraft?
minetest.register_abm({
	label = "Greendust Update",

	nodenames = {"group:greendust"},

	interval = 1,
	chance = 1,

	action = function(pos, node)

		local our_meta = minetest.get_meta(pos)
		local our_power = our_meta:get_int("power")

		local we_are_conduit = minetest.get_node_group(node.name, "greendust_conduit")

		-- Copied from minetest_game's tnt mod's gunpowder.
		-- Activates in all the four cardinal directions
		for dx = -1, 1 do
			for dz = -1, 1 do
				if math.abs(dx) + math.abs(dz) == 1 then
					for dy = -1, 1 do
						local neighbour_pos = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
						local neighbour_name = minetest.get_node(neighbour_pos).name
						local neighbour_def = minetest.registered_nodes[neighbour_name]

						if minetest.get_node_group(neighbour_name,"greendust") ~= 0 then
							local neighbour_meta = minetest.get_meta(neighbour_pos)
							local neighbour_power = neighbour_meta:get_int("power")

							if we_are_conduit ~= 0 then
								our_power = 0
								if neighbour_power ~= 0 and neighbour_power > our_power then
									our_power = neighbour_power - 1
								end
							end

							if our_power > 0 then
								if neighbour_def.greendust then
									if neighbour_def.greendust.on_power then
										neighbour_def.greendust.on_power(neighbour_pos, minetest.get_node(neighbour_pos))
									end
								end
							else
								if neighbour_def.greendust then
									if neighbour_def.greendust.on_unpower then
										neighbour_def.greendust.on_unpower(neighbour_pos, minetest.get_node(neighbour_pos))
									end
								end
							end
						end
					end
				end
			end
		end

		greendust.colour_from_power(pos, node, our_power)
		our_meta:set_int("power", our_power)
	end,

})
