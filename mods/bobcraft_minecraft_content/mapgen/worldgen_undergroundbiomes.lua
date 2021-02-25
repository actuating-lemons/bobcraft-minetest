-- We have a series of underground biomes for decorating the underground.
-- Take that, 1.2.5!
-- TODO: we should probably do the biomes ourselves for this.
-- See https://gitlab.com/h2mm/underch/-/blob/master/worldgen.lua#L572 for reference

----
-- Caves
-- The standard middle ground, like the ocean of the surface.
----
minetest.register_biome({
	name = "Cave",
	y_min = worldgen.overworld_bottom,
	y_max = 0,
	heat_point = 70,
	humidity_point = 50,
	vertical_blend = 8,

	-- used for the sky
	_temperature = 0.5,
	-- used for the plants
	_palette_index = bobutil.foliage_palette_indices.plains,
})

----
-- Spidery Caves
-- Caves with a disposition towards spiders
----
minetest.register_biome({
	name = "SpideryCave",
	y_min = worldgen.overworld_bottom,
	y_max = 0,
	heat_point = 80,
	humidity_point = 50,
	vertical_blend = 8,

	-- used for the sky
	_temperature = 1.0,
	-- used for the plants
	_palette_index = bobutil.foliage_palette_indices.plains,
})
minetest.register_decoration({
	deco_type = "simple",
	place_on = {"bobcraft_blocks:stone"},
	biomes = {"SpideryCave"},
	sidelen = 16,
	fill_ratio = 0.05,
	y_min = worldgen.overworld_bottom,
	y_max = 0,
	decoration = "bobcraft_blocks:cobweb"
})