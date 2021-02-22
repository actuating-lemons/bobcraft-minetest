-- Overworld blocks

local S = minetest.get_translator("bobcraft_blocks")

minetest.register_node("bobcraft_blocks:grass_block", {
	description = S("Grass Block"),
	tiles = {
		{name = "grass_block_top.png", color = "white"}, -- we do this to forcefully not colour it
		{name = "dirt.png", color = "white"}, -- we do this to forcefully not colour it
		{name = "grass_block_side.png", color = "white"}, -- we do this to forcefully not colour it
	},
	is_ground_content = true,
	sounds = bobcraft_sounds.node_sound_planty(),

	-- All of the colouring code
	paramtype2 = "color",
	palette = bobutil.foliage_palette,
	param2 = 0,
	on_construct = bobutil.foliage_block_figure,
	overlay_tiles = {"grass_block_top_overlay.png",
	"",
	"grass_block_side_overlay.png"},
	color = "#00ff00", -- HACK: make it green in the inventory

	-- foliage is a special group that we use to know if something needs biome colours
	groups = {hand=1, shovel=1, foliage=1, plantable=1},
	hardness = 0.6,
	stack_max = bobutil.stack_max,
})

minetest.register_node("bobcraft_blocks:dirt", {
	description = S("Dirt Block"),
	tiles = {"dirt.png"},
	is_ground_content = true,
	sounds = bobcraft_sounds.node_sound_earthy(),

	groups = {hand=1, shovel=1, plantable=1},
	hardness = 0.5,
	stack_max = bobutil.stack_max,
})

minetest.register_node("bobcraft_blocks:stone", {
	description = S("Stone"),
	tiles = {"stone.png"},
	is_ground_content = true,
	sounds = bobcraft_sounds.node_sound_stone(),

	hardness = 1.5,
	groups = {pickaxe=1, crafting_stone=1},
	drop = "bobcraft_blocks:cobblestone",
	stack_max = bobutil.stack_max,
})

minetest.register_node("bobcraft_blocks:sand", {
	description = S("Sand"),
	tiles = {"sand.png"},
	sounds = bobcraft_sounds.node_sound_sand(),

	groups = {hand=1, shovel=1, falling_node=1},
	hardness = 0.5,
	stack_max = bobutil.stack_max,
})
minetest.register_node("bobcraft_blocks:gravel", {
	description = S("Gravel"),
	tiles = {"gravel.png"},
	sounds = bobcraft_sounds.node_sound_gravel(),

	groups = {hand=1, shovel=1, falling_node=1},
	hardness = 0.6,
	stack_max = bobutil.stack_max,
	-- TODO: gravel/flint drops
})
minetest.register_node("bobcraft_blocks:sandstone", {
	description = S("Sandstone"),
	tiles = {"sandstone_top.png", "sandstone_bottom.png", "sandstone_side.png"},
	sounds = bobcraft_sounds.node_sound_sandstone(),

	groups = {pickaxe=1},
	hardness = 0.8,
	stack_max = bobutil.stack_max,
})

minetest.register_node("bobcraft_blocks:snow_layer", {
	description = S("Snow"),
	tiles = {"snow.png"},
	sounds = bobcraft_sounds.node_sound_snow(),
	paramtype = "light",
	sunlight_propagates = true,
	buildable_to = true,
	walkable = false, -- we fall through, wee!
	floodable = true,
	drawtype = "nodebox",
	node_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -0.375, 0.5},
		},
	},
	collision_box = {
		type = "fixed",
		fixed = {
			{-0.5, -0.5, -0.5, 0.5, -8 / 16, 0.5},
		},
	},

	groups = {shovel=1},
	hardness = 0.1,
	stack_max = bobutil.stack_max,
})
minetest.register_node("bobcraft_blocks:snowy_grass_block", {
	description = S("Snow Covered Grass Block"),
	tiles = {"grass_block_top_snow.png",
	"dirt.png",
	"grass_block_side_snow.png"},
	is_ground_content = true,
	sounds = bobcraft_sounds.node_sound_planty(),

	on_place = function(pos)
		local under = pos
		under.y = under.y - 1
		if minetest.get_node(under).name == "bobcraft_blocks:grass_block" then
			minetest.set_node(under, {name="bobcraft_blocks:snowy_grass_block"})
			minetest.remove_node(pos) -- we delete ourselves, as in bobtest, snowy grass is different to grass!
		end
	end,

	groups = {shovel=1, hand=1},
	hardness = 0.6,
	stack_max = bobutil.stack_max,
})

-- liquids
minetest.register_node("bobcraft_blocks:water_source",{
	description = S("Water"),
	drawtype = "liquid",
	waving = 3,
	tiles= {"water_still.png"},
	special_tiles = {
		{
			name = "water_still.png",
			backface_culling = false,
		},
		{
			name = "water_still.png",
			backface_culling = true,
		},
	},
	use_texture_alpha = "blend",
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "bobcraft_blocks:water_flowing",
	liquid_alternative_source = "bobcraft_blocks:water_source",
	liquid_viscosity = 1,
	sounds = bobcraft_sounds.node_sound_water(),
	groups = {not_in_creative_inventory=1, water=1},

	hardness = 100 -- minecraft sets this, why?
})
minetest.register_node("bobcraft_blocks:water_flowing",{
	description = S("Flowing Water"),
	drawtype = "flowingliquid",
	waving = 3,
	tiles= {"water_still.png"},
	special_tiles = {
		{
			name = "water_flow.png",
			backface_culling = false,
		},
		{
			name = "water_flow.png",
			backface_culling = true,
		},
	},
	use_texture_alpha = "blend",
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "bobcraft_blocks:water_flowing",
	liquid_alternative_source = "bobcraft_blocks:water_source",
	liquid_viscosity = 1,
	sounds = bobcraft_sounds.node_sound_water(),
	groups = {not_in_creative_inventory=1, water=1},

	hardness = 100 -- minecraft sets this, why?
})


minetest.register_node("bobcraft_blocks:lava_source",{
	description = S("Lava"),
	drawtype = "liquid",
	tiles = {
		{
			name = "lava_still.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2,
			},
		},
		{
			name = "lava_still.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2,
			},
		},
	},
	light_source = 13,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	liquidtype = "source",
	liquid_alternative_flowing = "bobcraft_blocks:lava_flowing",
	liquid_alternative_source = "bobcraft_blocks:lava_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	sounds = bobcraft_sounds.node_sound_lava(),
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {not_in_creative_inventory=1, lava=1},

	on_construct = function(pos)
		bobticles.register_node_particle_spawn(pos, bobticles.get_preset("lava"))
	end,
	on_destruct = function(pos)
		bobticles.clear_node_particle_spawn(pos)
	end,

	hardness = 100 -- minecraft sets this, why?
})

minetest.register_node("bobcraft_blocks:lava_flowing",{
	description = S("Lava"),
	drawtype = "flowingliquid",
	tiles = {"lava_flow.png"},
	special_tiles = {
		{
			name = "lava_flow.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2,
			},
		},
		{
			name = "lava_flow.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 2,
			},
		},
	},
	light_source = 13,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	liquidtype = "flowing",
	liquid_alternative_flowing = "bobcraft_blocks:lava_flowing",
	liquid_alternative_source = "bobcraft_blocks:lava_source",
	liquid_viscosity = 7,
	liquid_renewable = false,
	sounds = bobcraft_sounds.node_sound_lava(),
	damage_per_second = 4 * 2,
	post_effect_color = {a = 191, r = 255, g = 64, b = 0},
	groups = {not_in_creative_inventory=1, lava=1},

	on_construct = function(pos)
		bobticles.register_node_particle_spawn(pos, bobticles.get_preset("lava"))
	end,
	on_destruct = function(pos)
		bobticles.clear_node_particle_spawn(pos)
	end,

	hardness = 100 -- minecraft sets this, why?
})



-- the token unbreakable block
-- we have some code here to make it breakable in CREATIVE only
local bedrock_groups
if minetest.settings:get_bool("creative_mode") then
	bedrock_groups = {hand=1}
else
	bedrock_groups = {}
end
minetest.register_node("bobcraft_blocks:bedrock", {
	description = S("Bedrock"),
	tiles = {"bedrock.png"},
	is_ground_content = false, -- We *are* technically, but we also shouldn't be over-ridden
	groups = bedrock_groups,
	sounds = bobcraft_sounds.node_sound_stone(),
	hardness = -1,
	stack_max = bobutil.stack_max,
})

-- Other blocks

minetest.register_node("bobcraft_blocks:planks", {
	description = S("Planks"),
	tiles = {"planks.png"},
	is_ground_content = false,
	sounds = bobcraft_sounds.node_sound_wood(),

	groups = {hand=1, axe=1, crafting_wood=1, fuel=bobutil.fuel_times.wood},
	hardness = 2,
	stack_max = bobutil.stack_max,
})

minetest.register_node("bobcraft_blocks:glass", {
	description = S("Glass Block"),
	tiles = {"glass.png"},
	is_ground_content = false,
	sounds = bobcraft_sounds.node_sound_glass(),
	drawtype = "glasslike",
	paramtype = "light",
	drop = {}, -- drop nothing
	sunlight_propagates = true,

	hardness = 0.3,
	groups = {pickaxe=1, hand=1, shovel=1, axe=1}, -- TODO: I'm not sure what MC does here, but i mean, it's glass. Smashy smashy!
	stack_max = bobutil.stack_max,
})

minetest.register_node("bobcraft_blocks:log", {
	description = S("Log"),
	tiles = {"log_top.png", "log_top.png", "log_side.png"},
	is_ground_content = false,
	sounds = bobcraft_sounds.node_sound_wood(),

	hardness = 2,
	groups = {hand=1, axe=1},
	stack_max = bobutil.stack_max,
})
minetest.register_node("bobcraft_blocks:leaves", {
	description = S("Leaves"),
	drawtype = "allfaces_optional",
	tiles = {"leaves.png"},
	is_ground_content = false,
	sounds = bobcraft_sounds.node_sound_planty(),

	-- All of the colouring code
	paramtype2 = "color",
	palette = bobutil.foliage_palette,
	param2 = 0,
	on_construct = bobutil.foliage_block_figure,

	drop = {
		items = {
			max_items = 1,
			{ items = {"bobcraft_items:stick"}, rarity = 7},
			{ items = {"bobcraft_blocks:sapling"}, rarity = 5},
		}
	},

	hardness = 0.2,
	groups = {hand=1, fuel=bobutil.fuel_times.small_wood}, -- TODO: shears?
	stack_max = bobutil.stack_max,
})

minetest.register_node("bobcraft_blocks:cobblestone", {
	description = S("Cobblestone"),
	tiles = {"cobblestone.png"},
	is_ground_content = true,
	sounds = bobcraft_sounds.node_sound_stone(),

	hardness = 2, -- that's more than stone. interesting.
	groups = {pickaxe=1, crafting_stone=1},
	stack_max = bobutil.stack_max,
})

minetest.register_node("bobcraft_blocks:bookshelf", {
	description = S("Bookshelves"),
	tiles = {"planks.png", "planks.png", "bookshelf.png"},
	is_ground_content = false,
	sounds = bobcraft_sounds.node_sound_wood(),

	hardness = 1.5,
	groups = {axe=1},
	stack_max = bobutil.stack_max,
})

minetest.register_node("bobcraft_blocks:obsidian", {
	description = S("Obsidian"),
	tiles = {"obsidian.png"},
	is_ground_content = true,
	sounds = bobcraft_sounds.node_sound_stone(),

	hardness = 50,
	groups = {pickaxe=4},
	stack_max = bobutil.stack_max,
})

minetest.register_node("bobcraft_blocks:watermelon", {
	description = S("Watermelon"),
	tiles = {"watermelon_top.png", "watermelon_top.png", "watermelon_side.png"},
	is_ground_content = false,
	sounds = bobcraft_sounds.node_sound_planty(),

	hardness = 1,
	groups = {hand=1},
	stack_max = bobutil.stack_max,
})

minetest.register_node("bobcraft_blocks:clay", {
	description = S("Clay"),
	tiles = {"clay.png"},
	is_ground_content = true,
	sounds = bobcraft_sounds.node_sound_sand(),

	drop = "bobcraft_items:clay 4",

	hardness = 0.6,
	groups = {hand=1, shovel=1},
	stack_max = bobutil.stack_max,
})

minetest.register_node("bobcraft_blocks:ice", {
	description = S("Ice"),
	tiles = {"ice.png"},
	is_ground_content = true,
	sounds = bobcraft_sounds.node_sound_glass(),
	drawtype = "glasslike",
	use_texture_alpha = "blend",

	drop = "",

	hardness = 0.5,
	groups = {hand=1, slippery=5},
	stack_max = bobutil.stack_max,

	after_dig_node = function(pos)
		pos.y = pos.y -1
		local node = minetest.get_node(pos)
		if node then
			local nodedef = minetest.registered_nodes[node.name]
			if nodedef and nodedef.walkable then
				-- place some water
				pos.y = pos.y + 1
				minetest.set_node(pos, {name="bobcraft_blocks:water_source"})
			end
		end
	end
})

----
-- Ores
----
minetest.register_node("bobcraft_blocks:coal_ore", {
	description = S("Coal Ore"),
	tiles = {"coal_ore.png"},
	is_ground_content = true,
	sounds = bobcraft_sounds.node_sound_stone(),

	drop = "bobcraft_items:coal",

	hardness = 3,
	groups = {pickaxe=1},
	stack_max = bobutil.stack_max,
})
minetest.register_node("bobcraft_blocks:iron_ore", {
	description = S("Iron Ore"),
	tiles = {"iron_ore.png"},
	is_ground_content = true,
	sounds = bobcraft_sounds.node_sound_stone(),

	hardness = 3,
	groups = {pickaxe=3},
	stack_max = bobutil.stack_max,
})
minetest.register_node("bobcraft_blocks:gold_ore", {
	description = S("Gold Ore"),
	tiles = {"gold_ore.png"},
	is_ground_content = true,
	sounds = bobcraft_sounds.node_sound_stone(),

	hardness = 3,
	groups = {pickaxe=4},
	stack_max = bobutil.stack_max,
})
minetest.register_node("bobcraft_blocks:diamond_ore", {
	description = S("Diamond Ore"),
	tiles = {"diamond_ore.png"},
	is_ground_content = true,
	sounds = bobcraft_sounds.node_sound_stone(),

	drop = "bobcraft_items:diamond",

	hardness = 3,
	groups = {pickaxe=4},
	stack_max = bobutil.stack_max,
})

----
-- Etc.
----
minetest.register_node("bobcraft_blocks:torch", {
	description = S("Torch"),
	tiles = {"torch.png"},
	is_ground_content = false,
	sounds = bobcraft_sounds.node_sound_wood(), -- TODO: torch sounds
	drawtype = "mesh", -- We can't change the UV of nodeboxes sadly.
	mesh = "torch_floor.obj",
	selection_box = { -- But they make a good selection box!
		type = "fixed",
		fixed = {
			-0.0625, -0.5, -0.0625,
			0.0625, 0.125, 0.0625
		}
	},

	groups = {hand=1, attached_node = 1},

	paramtype = "light",
	sunlight_propagates = true,
	inventory_image = "torch.png",
	wield_image = "torch.png",
	light_source = 14,

	walkable = false,

	-- so we can become the wall torch
	on_place = function (itemstack, placer, pointed_node)
		local under_pointed_node = pointed_node.under
		local above_pointed_node = pointed_node.above

		local fakestack = itemstack
		local wall_dir = minetest.dir_to_wallmounted(vector.subtract(under_pointed_node, above_pointed_node))
		if wall_dir == 1 then
			fakestack:set_name("bobcraft_blocks:torch")
		elseif wall_dir ~= 0 then
			fakestack:set_name("bobcraft_blocks:torch_wall")
		else
			return itemstack
		end

		itemstack = minetest.item_place(fakestack, placer, pointed_node, wall_dir)
		itemstack:set_name("bobcraft_blocks:torch")

		return itemstack
	end,
	stack_max = bobutil.stack_max,



	on_construct = function(pos)
		bobticles.register_node_particle_spawn(pos, bobticles.get_preset("torch_floor"))
		bobticles.register_node_particle_spawn(pos, bobticles.get_preset("torch_floor_smoke"))
	end,
	on_destruct = function(pos)
		bobticles.clear_node_particle_spawn(pos)
	end,
})

minetest.register_node("bobcraft_blocks:torch_wall", {
	description = S("Wall Torch"),
	tiles = {"torch.png"},
	is_ground_content = false,
	sounds = bobcraft_sounds.node_sound_wood(), -- TODO: torch sounds
	drawtype = "mesh",
	mesh = "torch_wall.obj", -- Unfortunately we need a mesh here.... pah!
	selection_box = {
		type = "wallmounted",
		wall_side = {
			-0.5, -0.3125, -0.0625,
			-0.0625, 0.3125, 0.0625
		}
	},

	groups = {hand=1, not_in_creative_inventory=1, attached_node = 1},
	drop = "bobcraft_blocks:torch",

	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	light_source = 14,

	walkable = false,
	stack_max = bobutil.stack_max,



	on_construct = function(pos)
		bobticles.register_node_particle_spawn(pos, bobticles.get_preset("torch_wall"))
		bobticles.register_node_particle_spawn(pos, bobticles.get_preset("torch_wall_smoke"))
	end,
	on_destruct = function(pos)
		bobticles.clear_node_particle_spawn(pos)
	end,
})


----
-- Plants
----
minetest.register_node("bobcraft_blocks:rose", {
	description = S("Singular Rose"),
	tiles = {"rose.png"},
	wield_image = "rose.png",
	inventory_image = "rose.png",
	is_ground_content = true,
	sounds = bobcraft_sounds.node_sound_planty(),
	drawtype = "plantlike",
	walkable = false,
	selection_box = {
		type = "fixed",
		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
	},
	paramtype = "light",
	sunlight_propagates = true,

	groups = {hand=1, attached_node=1},
	hardness = 0,
	stack_max = bobutil.stack_max,

	on_place = function(itemstack, placer, pointed_thing)
		return bobutil.on_plant(itemstack, placer, pointed_thing)
	end,
})

minetest.register_node("bobcraft_blocks:cactus", {
	description = S("Cactus"),
	tiles = {"cactus_side.png"}, -- TODO: cactus model
	sounds = bobcraft_sounds.node_sound_planty(),

	groups = {hand=1, attached_node=1},
	hardness = 0.4,
	stack_max = bobutil.stack_max,
})

minetest.register_node("bobcraft_blocks:grass", {
	description = S("Grass"),
	tiles = {"grass.png"},
	wield_image = "grass.png",
	inventory_image = "grass.png",
	is_ground_content = true,
	sounds = bobcraft_sounds.node_sound_planty(),
	drawtype = "plantlike",
	walkable = false,
	paramtype = "light",
	sunlight_propagates = true,

	-- All of the colouring code
	paramtype2 = "color",
	palette = bobutil.foliage_palette,
	palette_index = 0,
	color = "#00ff00", -- HACK: make it green in the inventory
	on_construct = bobutil.foliage_block_figure,

	groups = {hand=1, foliage=1, attached_node=1},
	hardness = 0,
	stack_max = bobutil.stack_max,

	on_place = function(itemstack, placer, pointed_thing)
		return bobutil.on_plant(itemstack, placer, pointed_thing)
	end,
})

minetest.register_node("bobcraft_blocks:deadbush", {
	description = S("Deadbush"),
	tiles = {"deadbush.png"},
	drawtype = "plantlike",
	inventory_image = "deadbush.png",
	wield_image = "deadbush.png",
	walkable = false,
	sounds = bobcraft_sounds.node_sound_planty(),

	drop = {
		items = {
			max_items = 4,
			items = {
				{ items = "bobcraft_items:stick", rarity = 2},
				{ items = "bobcraft_items:stick", rarity = 5},
			}
		}
	},

	drop = "bobcraft_items:stick", -- TODO: random drops

	groups = {hand=1, attached_node=1},
	hardness = 0,
	stack_max = bobutil.stack_max,
})

minetest.register_node("bobcraft_blocks:sugarcane", {
	description = S("Sugar-cane"),
	tiles = {"sugarcane.png"},
	drawtype = "plantlike",
	walkable = false,
	sounds = bobcraft_sounds.node_sound_planty(),
	groups = {hand=1},

	wield_image = "sugarcane_item.png",
	inventory_image = "sugarcane_item.png",

	hardness = 0,
	stack_max = bobutil.stack_max
})

local modpath = minetest.get_modpath("bobcraft_blocks")
dofile(modpath .. "/interactions.lua")
dofile(modpath .. "/aliases.lua")
dofile(modpath .. "/furnace.lua")
dofile(modpath .. "/wool.lua")
dofile(modpath .. "/greendust.lua")
dofile(modpath .. "/saplings.lua")
dofile(modpath .. "/signs.lua")
dofile(modpath .. "/doors.lua")

-- Now that that's over, we ask tool_globals to setup the values for all blocks.
-- If you're making an expansion, make sure your mod depends on bobcraft_blocks & also calls it.
-- It'll introduce an unnecessary redefinition of groups, but hey, it works! 
tool_values.setup_values()