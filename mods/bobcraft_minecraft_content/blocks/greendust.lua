-- Greendust is our equivalent of redstone.
-- We should probably move it to its' own mod, but right now, this does the ore and dust.
-- Of-course, we're going to need to do a LOT to get a proper redstone system

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

	on_construct = greendust.conduit_change
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

	on_construct = function(pos)
		pos = {x=pos.x+1, y=pos.y, z=pos.z}
		greendust.event_queue:add_action(pos, "empower", {15})
	end,

})

-- Absorbs energy and doesn't do anything with it
minetest.register_node("bobcraft_blocks:greendust_energy_sink", {
	description = "Greendust Energy Sink",
	tiles = {"stone.png"},

	groups = {greendust=1, greendust_user=1},

	on_construct = function(pos)
		greendust.event_queue:add_action(pos, "pull", {5})
	end,
	on_greendust_use = function(pos, node, energy_used)
		minetest.sound_play({
			name = "greendust_use"
		},
		{pos=pos, max_hear_distance = 100})
		minetest.log("used " .. tostring(energy_used) .. " greendust")
	end,
})