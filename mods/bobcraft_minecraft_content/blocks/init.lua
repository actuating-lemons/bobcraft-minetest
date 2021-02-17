local function register_block(nodename, nodedef)
	nodedef = tool_values.setup_group_values(nodename, nodedef)
	minetest.log(dump(nodedef))
	minetest.register_node(nodename, nodedef)
end

minetest.register_node("bobcraft_blocks:bedrock", {
		description = "Bedrock",
		tiles = {"bedrock.png"},
		groups = {},
		sounds = bobcraft_sounds.node_sound_stone()
})

register_block("bobcraft_blocks:stone", {
	description = "Stone",
	tiles = {"stone.png"},
	diggable = true,
	is_ground_content = true,
	sounds = bobcraft_sounds.node_sound_stone(),
	
	hardness = 1.5,
	groups = {pickaxe=1}
})


-- -- Overworld blocks

-- minetest.register_node("bobcraft_blocks:grass_block", {
-- 	description = "Grass Block",
-- 	tiles = {"grass_top.png",
-- 	"dirt.png",
-- 	"grass_side.png"},
-- 	is_ground_content = true,
-- 	groups = {hand=1, shovel=1},
-- 	sounds = bobcraft_sounds.node_sound_planty()
-- })

-- minetest.register_node("bobcraft_blocks:dirt", {
-- 	description = "Dirt Block",
-- 	tiles = {"dirt.png"},
-- 	is_ground_content = true,
-- 	groups = {hand=1, shovel=1},
-- 	hardness = 0.5,
-- 	sounds = bobcraft_sounds.node_sound_earthy()
-- })

-- minetest.register_node("bobcraft_blocks:stone", {
-- 	description = "Stone",
-- 	tiles = {"stone.png"},
-- 	is_ground_content = true,
-- 	groups = {tool_pickaxe=1},
-- 	hardness = 1,
-- 	sounds = bobcraft_sounds.node_sound_stone(),
-- 	drop = "bobcraft_blocks:cobblestone"
-- })

-- minetest.register_node("bobcraft_blocks:rose", {
-- 	description = "Singular Rose",
-- 	tiles = {"rose.png"},
-- 	wield_image = "rose.png",
-- 	is_ground_content = true,
-- 	groups = {oddly_breakable_by_hand=3},
-- 	sounds = bobcraft_sounds.node_sound_planty(),
-- 	drawtype = "plantlike",
-- 	walkable = false,
-- 	selection_box = {
-- 		type = "fixed",
-- 		fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}
-- 	},
-- 	paramtype = "light",
-- 	sunlight_propagates = true
-- })

-- minetest.register_node("bobcraft_blocks:cactus", {
-- 	description = "Cactus",
-- 	tiles = {"cactus_side.png"}, -- TODO: cactus model
-- 	groups = {oddly_breakable_by_hand=3},
-- 	sounds = bobcraft_sounds.node_sound_planty()
-- })

-- minetest.register_node("bobcraft_blocks:sand", {
-- 	description = "Sand",
-- 	tiles = {"sand.png"},
-- 	groups = {crumbly = 3, falling_node = 1, sand = 1},
-- 	sounds = bobcraft_sounds.node_sound_sand(),
-- })
-- minetest.register_node("bobcraft_blocks:gravel", {
-- 	description = "Gravel",
-- 	tiles = {"gravel.png"},
-- 	groups = {crumbly = 3, falling_node = 1},
-- 	sounds = bobcraft_sounds.node_sound_gravel(),
-- })
-- minetest.register_node("bobcraft_blocks:sandstone", {
-- 	description = "Sand",
-- 	tiles = {"sandstone_top.png", "sandstone_bottom.png", "sandstone_side.png"},
-- 	groups = {crumbly = 3, sand = 1},
-- 	sounds = bobcraft_sounds.node_sound_sandstone(),
-- })

-- minetest.register_node("bobcraft_blocks:snow_layer", {
-- 	description = "Snow",
-- 	tiles = {"snow.png"},
-- 	groups = {oddly_breakable_by_hand=2},
-- 	sounds = bobcraft_sounds.node_sound_snow(),
-- 	paramtype = "light",
-- 	buildable_to = true,
-- 	floodable = true,
-- 	drawtype = "nodebox",
-- 	node_box = {
-- 		type = "fixed",
-- 		fixed = {
-- 			{-0.5, -0.5, -0.5, 0.5, -0.375, 0.5},
-- 		},
-- 	},
-- 	collision_box = {
-- 		type = "fixed",
-- 		fixed = {
-- 			{-0.5, -0.5, -0.5, 0.5, -8 / 16, 0.5},
-- 		},
-- 	},
-- })
-- minetest.register_node("bobcraft_blocks:snowy_grass_block", {
-- 	description = "Snow Covered Grass Block",
-- 	tiles = {"grass_top_snow.png",
-- 	"dirt.png",
-- 	"grass_side_snow.png"},
-- 	is_ground_content = true,
-- 	groups = {soil = 1, crumbly = 1},
-- 	sounds = bobcraft_sounds.node_sound_planty(),

-- 	on_construct = function(pos)
-- 		pos.y = pos.y - 1
-- 		if minetest.get_node(pos).name == "bobcraft_blocks:grass_block" then
-- 			minetest.set_node(pos, {name="bobcraft_blocks:snowy_grass_block"})
-- 		end
-- 	end,
-- })

-- -- liquids
-- minetest.register_node("bobcraft_blocks:water_source",{
-- 	description = "Water",
-- 	drawtype = "liquid",
-- 	waving = 3,
-- 	tiles= {"water_still.png"},
-- 	special_tiles = {
-- 		{
-- 			name = "water_still.png",
-- 			backface_culling = false,
-- 		},
-- 		{
-- 			name = "water_still.png",
-- 			backface_culling = true,
-- 		},
-- 	},
-- 	use_texture_alpha = "blend",
-- 	paramtype = "light",
-- 	walkable = false,
-- 	pointable = false,
-- 	diggable = false,
-- 	buildable_to = false,
-- 	is_ground_content = false,
-- 	drop = "",
-- 	drowning = 1,
-- 	liquidtype = "source",
-- 	liquid_alternative_flowing = "bobcraft_blocks:water_flowing",
-- 	liquid_alternative_source = "bobcraft_blocks:water_source",
-- 	liquid_viscosity = 1,
-- 	sounds = bobcraft_sounds.node_sound_water(),
-- 	groups = {not_in_creative_inventory=1}
-- })
-- minetest.register_node("bobcraft_blocks:water_flowing",{
-- 	description = "Water",
-- 	drawtype = "flowingliquid",
-- 	waving = 3,
-- 	tiles= {"water_still.png"},
-- 	special_tiles = {
-- 		{
-- 			name = "water_flow.png",
-- 			backface_culling = false,
-- 		},
-- 		{
-- 			name = "water_flow.png",
-- 			backface_culling = true,
-- 		},
-- 	},
-- 	use_texture_alpha = "blend",
-- 	paramtype = "light",
-- 	walkable = false,
-- 	pointable = false,
-- 	diggable = false,
-- 	buildable_to = true,
-- 	is_ground_content = false,
-- 	drop = "",
-- 	drowning = 1,
-- 	liquidtype = "flowing",
-- 	liquid_alternative_flowing = "bobcraft_blocks:water_flowing",
-- 	liquid_alternative_source = "bobcraft_blocks:water_source",
-- 	liquid_viscosity = 1,
-- 	sounds = bobcraft_sounds.node_sound_water(),
-- 	groups = {not_in_creative_inventory=1}
-- })

-- -- the token unbreakable block
-- -- we have some code here to make it breakable in CREATIVE only
-- local bedrock_groups
-- if minetest.settings:get_bool("creative_mode") then
-- 	bedrock_groups = {oddly_breakable_by_hand=1}
-- else
-- 	bedrock_groups = {}
-- end
-- minetest.register_node("bobcraft_blocks:bedrock", {
-- 	description = "Bedrock",
-- 	tiles = {"bedrock.png"},
-- 	is_ground_content = false, -- We *are* technically, but we also shouldn't be over-ridden
-- 	groups = bedrock_groups,
-- 	sounds = bobcraft_sounds.node_sound_stone()
-- })

-- -- Other blocks

-- minetest.register_node("bobcraft_blocks:planks", {
-- 	description = "Planks",
-- 	tiles = {"planks.png"},
-- 	is_ground_content = false,
-- 	groups = {tool_axe=1},
-- 	hardness = 2,
-- 	sounds = bobcraft_sounds.node_sound_wood()
-- })

-- minetest.register_node("bobcraft_blocks:glass", {
-- 	description = "Glass Block",
-- 	tiles = {"glass.png"},
-- 	is_ground_content = false,
-- 	groups = {cracky = 3, oddly_breakable_by_hand = 3},
-- 	sounds = bobcraft_sounds.node_sound_glass(),
-- 	drawtype = "glasslike",
-- 	paramtype = "light",
-- 	drop = {}, -- drop nothing
-- 	sunlight_propagates = true
-- })

-- minetest.register_node("bobcraft_blocks:log", {
-- 	description = "Log",
-- 	tiles = {"log_top.png", "log_top.png", "log_side.png"},
-- 	is_ground_content = false,
-- 	groups = {tool_axe=1},
-- 	sounds = bobcraft_sounds.node_sound_wood()
-- })
-- minetest.register_node("bobcraft_blocks:leaves", {
-- 	description = "Leaves",
-- 	drawtype = "allfaces_optional",
-- 	tiles = {"leaves.png"},
-- 	is_ground_content = false,
-- 	groups = {oddly_breakable_by_hand=1},
-- 	sounds = bobcraft_sounds.node_sound_planty()
-- })

-- minetest.register_node("bobcraft_blocks:cobblestone", {
-- 	description = "Cobblestone",
-- 	tiles = {"cobblestone.png"},
-- 	is_ground_content = true,
-- 	groups = {cracky=1},
-- 	sounds = bobcraft_sounds.node_sound_stone()
-- })

-- local modpath = minetest.get_modpath("bobcraft_blocks")
-- dofile(modpath .. "/interactions.lua")
-- dofile(modpath .. "/aliases.lua")