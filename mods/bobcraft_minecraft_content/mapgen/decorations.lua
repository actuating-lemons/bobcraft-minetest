minetest.register_decoration({
	deco_type = "schematic",
	place_on = {"bobcraft_blocks:grass_block"},
	sidelen = 16,
	noise_params = {
		offset = 0.001,
		scale = 0.015,
		spread = {x = 250, y = 250, z = 250},
		seed = 2,
		octaves = 3,
		persist = 0.66
	},
	y_min = worldgen.overworld_bottom,
	y_max = worldgen.overworld_top,
	schematic = "schematic/tree.mts",
	flags = "place_center_x, place_center_z"
})