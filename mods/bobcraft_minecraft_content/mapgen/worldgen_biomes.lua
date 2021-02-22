local SEA_FLOOR = worldgen.overworld_sea_level - 19
----
-- Plains
----
minetest.register_biome({
	name = "Plains",
	node_top = "bobcraft_blocks:grass_block",
	depth_top = 1,
	node_filler = "bobcraft_blocks:dirt",
	depth_filler = 2,
	node_stone = "bobcraft_blocks:stone",
	node_riverbed = "bobcraft_blocks:sand",
	y_min = 0,
	y_max = worldgen.overworld_top,
	heat_point = 50,
	humidity_point = 35,
	vertical_blend = 8,

	-- used for the sky
	_temperature = 0.8,
	-- used for the plants
	_palette_index = bobutil.foliage_palette_indices.plains,
})
minetest.register_decoration({
	deco_type = "simple",
	place_on = {"bobcraft_blocks:grass_block"},
	biomes = {"Plains"},
	sidelen = 16,
	noise_params = {
		offset = 0.01,
		scale = 0.001,
		spread = {x = 5, y = 5, z = 5},
		seed = 5,
		octaves = 3,
		persist = 0.66
	},
	y_min = 0,
	y_max = worldgen.overworld_top,
	decoration = "bobcraft_blocks:rose"
})

----
-- Forest
----
minetest.register_biome({
	name = "Forest",
	node_top = "bobcraft_blocks:grass_block",
	depth_top = 1,
	node_filler = "bobcraft_blocks:dirt",
	depth_filler = 2,
	node_stone = "bobcraft_blocks:stone",
	y_min = 0,
	y_max = worldgen.overworld_top,
	heat_point = 60,
	humidity_point = 68,
	vertical_blend = 8,

	-- used for the sky
	_temperature = 0.7,
	-- used for the plants
	_palette_index = bobutil.foliage_palette_indices.forest,
})

----
-- Swamp
----
minetest.register_biome({
	name = "Swampland",
	node_top = "bobcraft_blocks:grass_block",
	depth_top = 1,
	node_filler = "bobcraft_blocks:dirt",
	depth_filler = 2,
	node_stone = "bobcraft_blocks:stone",
	y_min = 0,
	y_max = 23,
	humidity_point = 60,
	heat_point = 50,
	vertical_blend = 8,

	-- used for the sky
	_temperature = 0.8,
	-- used for the plants
	_palette_index = bobutil.foliage_palette_indices.swamp,
})

----
-- Desert
----
minetest.register_biome({
	name = "Desert",
	node_top = "bobcraft_blocks:sand",
	depth_top = 1,
	node_filler = "bobcraft_blocks:sand",
	depth_filler = 2,
	node_stone = "bobcraft_blocks:sandstone",
	y_min = 0,
	y_max = worldgen.overworld_top,
	heat_point = 92,
	humidity_point = 16,
	vertical_blend = 8,

	-- used for the sky
	_temperature = 2.0,
	-- used for the plants
	_palette_index = bobutil.foliage_palette_indices.desert,
})
minetest.register_decoration({
    deco_type = "simple",
    place_on = {"bobcraft_blocks:sand"},
    sidelen = 16,
    fill_ratio = 0.002,
    biomes = {"Desert"},
    y_max = worldgen.overworld_top,
    y_min = 0,
	decoration = "bobcraft_blocks:cactus",
	height = 2,
	height_max = 5
})
minetest.register_decoration({ -- the mythical tall cactus
    deco_type = "simple",
    place_on = {"bobcraft_blocks:sand"},
    sidelen = 16,
    fill_ratio = 0.00000005,
    biomes = {"Desert"},
    y_max = worldgen.overworld_top,
    y_min = 0,
	decoration = "bobcraft_blocks:cactus",
	height = 10,
	height_max = 29
})
minetest.register_decoration({
	deco_type = "simple",
	place_on = {"bobcraft_blocks:sand"},
	biomes = {"Desert"},
	sidelen = 16,
	noise_params = {
		offset = 0.01,
		scale = 0.001,
		spread = {x = 5, y = 5, z = 5},
		seed = 5,
		octaves = 3,
		persist = 0.66
	},
	y_min = 0,
	y_max = worldgen.overworld_top,
	decoration = "bobcraft_blocks:deadbush"
})

----
-- Tundra
----
minetest.register_biome({
	name = "Tundra",
	node_top = "bobcraft_blocks:snowy_grass_block",
	depth_top = 1,
	node_filler = "bobcraft_blocks:dirt",
	depth_filler = 2,
	node_stone = "bobcraft_blocks:stone",
	node_water_top = "bobcraft_blocks:ice",
	depth_water_top = 1,
	node_dust = "bobcraft_blocks:snow_layer",
	y_min = 0,
	y_max = worldgen.overworld_top,
	heat_point = 12,
	humidity_point = 45,
	vertical_blend = 8,

	-- used for the sky
	_temperature = 0.0,
	-- used for the plants
	_palette_index = bobutil.foliage_palette_indices.tundra,
})
----
-- Taiga
----
minetest.register_biome({
	name = "Taiga",
	node_top = "bobcraft_blocks:grass_block",
	depth_top = 1,
	node_filler = "bobcraft_blocks:dirt",
	depth_filler = 2,
	node_stone = "bobcraft_blocks:stone",
	node_water_top = "bobcraft_blocks:ice",
	depth_water_top = 1,
	y_min = 0,
	y_max = worldgen.overworld_top,
	heat_point = 12,
	humidity_point = 55,
	vertical_blend = 8,

	-- used for the sky
	_temperature = 0.05,
	-- used for the plants
	_palette_index = bobutil.foliage_palette_indices.taiga,
})
----
-- Extreme Hills
----
minetest.register_biome({
	name = "ExtremeHills",
	node_top = "bobcraft_blocks:grass_block",
	depth_top = 1,
	node_filler = "bobcraft_blocks:dirt",
	depth_filler = 2,
	node_stone = "bobcraft_blocks:stone",
	y_min = 40,
	y_max = worldgen.overworld_top,
	heat_point = 50,
	humidity_point = 45,
	vertical_blend = 8,

	-- used for the sky
	_temperature = 0.2,
	-- used for the plants
	_palette_index = bobutil.foliage_palette_indices.extreme_hills,
})
-- Extreme Hill peaks, to get snow on 'em
minetest.register_biome({
	name = "ExtremeHills",
	node_top = "bobcraft_blocks:snowy_grass_block",
	depth_top = 1,
	node_filler = "bobcraft_blocks:dirt",
	depth_filler = 2,
	node_stone = "bobcraft_blocks:stone",
	node_dust = "bobcraft_blocks:snow_layer",
	y_min = 60,
	y_max = worldgen.overworld_top,
	heat_point = 35,
	humidity_point = 45,
	vertical_blend = 8,

	-- used for the sky
	_temperature = 0.2,
	-- used for the plants
	_palette_index = bobutil.foliage_palette_indices.extreme_hills,
})

----
-- Ocean(s)
----
minetest.register_biome({
	name = "Ocean",
	node_top = "bobcraft_blocks:gravel",
	depth_top = 1,
	node_filler = "bobcraft_blocks:gravel",
	depth_filler = 2,
	node_stone = "bobcraft_blocks:stone",
	y_min = SEA_FLOOR,
	y_max = worldgen.overworld_sea_level,
	-- The ocean is the mid point
	heat_point = 50,
	humidity_point = 50,
	vertical_blend = 8,

	-- used for the sky
	_temperature = 0.5,
	-- used for the plants
	_palette_index = bobutil.foliage_palette_indices.ocean,
})
minetest.register_biome({
	name = "FrozenOcean",
	node_top = "bobcraft_blocks:gravel",
	depth_top = 1,
	node_filler = "bobcraft_blocks:gravel",
	depth_filler = 2,
	node_stone = "bobcraft_blocks:stone",
	node_water_top = "bobcraft_blocks:ice",
	depth_water_top = 1,
	y_min = SEA_FLOOR,
	y_max = worldgen.overworld_sea_level,
	-- The ocean is the mid point
	heat_point = 12,
	humidity_point = 50,
	vertical_blend = 8,

	-- used for the sky
	_temperature = 0.0,
	-- used for the plants
	_palette_index = bobutil.foliage_palette_indices.ocean,
})



 -- Tree generation
 -- In Forest
minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"bobcraft_blocks:grass_block"},
	biomes = {"Forest"},
	sidelen = 16,
	noise_params = {
		offset = 0.001,
		scale = 0.015,
		spread = {x = 250, y = 250, z = 250},
		seed = 2,
		octaves = 3,
		persist = 0.66
	},
	y_min = 3,
	y_max = worldgen.overworld_top,
	schematic = "schematic/tree.mts",
	flags = "place_center_x, place_center_z"
})
 -- In plains
minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"bobcraft_blocks:grass_block"},
	biomes = {"Plains"},
	sidelen = 16,
	fill_ratio = 0.0025,
	y_min = 3,
	y_max = worldgen.overworld_top,
	schematic = "schematic/tree.mts",
	flags = "place_center_x, place_center_z"
})
-- In tundra
minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"bobcraft_blocks:snowy_grass_block"},
	biomes = {"Tundra"},
	sidelen = 16,
	fill_ratio = 0.0025,
	y_min = 3,
	y_max = worldgen.overworld_top,
	schematic = "schematic/tree_spruce.mts",
	flags = "place_center_x, place_center_z"
})
 -- In Taiga
 minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"bobcraft_blocks:grass_block"},
	biomes = {"Taiga"},
	sidelen = 16,
	noise_params = {
		offset = 0.001,
		scale = 0.015,
		spread = {x = 250, y = 250, z = 250},
		seed = 2,
		octaves = 3,
		persist = 0.66
	},
	y_min = 3,
	y_max = worldgen.overworld_top,
	schematic = "schematic/tree.mts",
	flags = "place_center_x, place_center_z"
})

----
-- Etc.
----

-- Let's dot some grass around
minetest.register_decoration({
	deco_type = "simple",
	place_on = {"bobcraft_blocks:grass_block"},
	biomes = {"Plains", "Taiga", "ExtremeHills", "Forest"},
	sidelen = 16,
	noise_params = {
		offset = 0.01,
		scale = 0.04,
		spread = {x = 10, y = 10, z = 10},
		seed = 5,
		octaves = 3,
		persist = 0.66
	},
	y_min = 0,
	y_max = worldgen.overworld_top,
	decoration = "bobcraft_blocks:grass"
})

-- Sugarcane!
minetest.register_decoration({
	deco_type = "simple",
	place_on = {"bobcraft_blocks:dirt", "bobcraft_blocks:sand"},
	sidelen = 16,
	fill_ratio = 0.2, -- Average per chunk in MC is 0.8, 256 blocks on a flat chunk, on average it can cover 204 of those, 52 is the difference, which is 0.2% of 256.
	y_min = 0,
	y_max = worldgen.overworld_top,
	height = 1,
	height_max = 3,
	decoration = "bobcraft_blocks:sugarcane",
	spawn_by = {"bobcraft_blocks:water_source"},
	num_spawn_by = 1,
})