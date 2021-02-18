minetest.register_ore({
	ore_type       = "scatter",
	ore            = "bobcraft_blocks:coal_ore",
	wherein        = "bobcraft_blocks:stone",
	clust_scarcity = 8 * 8 * 8, -- Minecraft generates a set amount of ores per chunk. We can't do this. is 8*8*8 too common?
	clust_num_ores = 16, -- Minecraft generates 16 blocks of coal ore.
	clust_size     = 3, -- Not sure how I'd apply minecraft to this. It's the maximum number of blocks per side in the bounding box.
	-- coal generates from y=0, 128 in minecraft 1.2.5
	y_max = worldgen.overworld_bottom+128,
	y_min = worldgen.overworld_bottom,
})