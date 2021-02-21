minetest.register_ore({
	ore_type       = "blob",
	ore            = "bobcraft_blocks:coal_ore",
	wherein        = "bobcraft_blocks:stone",
	clust_scarcity = 8 * 8 * 8, -- Minecraft generates a set amount of ores per chunk. We can't do this. is 8*8*8 too common?
	clust_num_ores = 16, -- Minecraft generates 16 blocks of coal ore.
	clust_size     = 3, -- Not sure how I'd apply minecraft to this. It's the maximum number of blocks per side in the bounding box.
	-- coal generates from y=0, 128 in minecraft 1.2.5
	y_max = worldgen.overworld_bottom+128,
	y_min = worldgen.overworld_bottom,
})

minetest.register_ore({
	ore_type       = "blob",
	ore            = "bobcraft_blocks:iron_ore",
	wherein        = "bobcraft_blocks:stone",
	clust_scarcity = 16 * 8 * 16, -- Minecraft generates a set amount of ores per chunk. We can't do this. is 16*16*8 too common?
	clust_num_ores = 8, -- Minecraft generates 16 blocks of coal ore.
	clust_size     = 3, -- Not sure how I'd apply minecraft to this. It's the maximum number of blocks per side in the bounding box.
	-- iron generates from y=0, 64 in minecraft 1.2.5
	y_max = worldgen.overworld_bottom+64,
	y_min = worldgen.overworld_bottom,
})

minetest.register_ore({
	ore_type       = "blob",
	ore            = "bobcraft_blocks:gold_ore",
	wherein        = "bobcraft_blocks:stone",
	clust_scarcity = 16 * 8 * 16, -- Minecraft generates a set amount of ores per chunk. We can't do this. is 16*16*8 too common?
	clust_num_ores = 8, -- Minecraft generates 16 blocks of coal ore.
	clust_size     = 3, -- Not sure how I'd apply minecraft to this. It's the maximum number of blocks per side in the bounding box.
	-- gold generates from y=0, 32 in minecraft 1.2.5
	y_max = worldgen.overworld_bottom+32,
	y_min = worldgen.overworld_bottom,
})

minetest.register_ore({
	ore_type       = "blob",
	ore            = "bobcraft_blocks:greendust_ore",
	wherein        = "bobcraft_blocks:stone",
	clust_scarcity = 16 * 8 * 16, -- Minecraft generates a set amount of ores per chunk. We can't do this. is 16*16*8 too common?
	clust_num_ores = 7, -- Minecraft generates 16 blocks of coal ore.
	clust_size     = 3, -- Not sure how I'd apply minecraft to this. It's the maximum number of blocks per side in the bounding box.
	-- redstone generates from y=0, 16 in minecraft 1.2.5
	y_max = worldgen.overworld_bottom+16,
	y_min = worldgen.overworld_bottom,
})

minetest.register_ore({
	ore_type       = "blob",
	ore            = "bobcraft_blocks:diamond_ore",
	wherein        = "bobcraft_blocks:stone",
	clust_scarcity = 16 * 16 * 16, -- Minecraft generates a set amount of ores per chunk. We can't do this. is 16*16*16 too common?
	clust_num_ores = 7, -- Minecraft generates 16 blocks of coal ore.
	clust_size     = 3, -- Not sure how I'd apply minecraft to this. It's the maximum number of blocks per side in the bounding box.
	-- diamond generates from y=0, 64 in minecraft 1.2.5
	y_max = worldgen.overworld_bottom+16,
	y_min = worldgen.overworld_bottom,
})

----
-- We generate these like ores,
-- But they're not technically ores.
----

-- Make pockets of lava
minetest.register_ore({
	ore_type       = "blob",
	ore            = "bobcraft_blocks:lava_source",
	wherein        = "bobcraft_blocks:stone",
	clust_scarcity = 16*16*16,
	clust_num_ores = 1,
	clust_size     = 1,
	y_max = worldgen.overworld_bottom+16,
	y_min = worldgen.overworld_bottom,
})