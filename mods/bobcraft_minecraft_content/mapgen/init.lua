worldgen = {}

-- we always put the bedrock layer at overworld_bottom
-- We need to do something about overworld_top (maybe the ignore block?)
worldgen.overworld_top = 256
worldgen.overworld_bottom = -64 -- Because moving the sea level fucked with v7's generation
-- The water level seems to be 63 in 1.2.5
-- We can assume the overworld_bottom is the relative 0 point
worldgen.overworld_sea_level = worldgen.overworld_bottom+63

minetest.register_alias("mapgen_water_source", "bobcraft_blocks:water_source")
minetest.register_alias("mapgen_stone", "bobcraft_blocks:stone")
minetest.register_alias("mapgen_dirt", "bobcraft_blocks:dirt")

local path = minetest.get_modpath("bobcraft_worldgen")

minetest.set_mapgen_setting("water_level", worldgen.overworld_sea_level, true)

dofile(path .. "/worldgen_biomes.lua")
dofile(path .. "/worldgen.lua")
dofile(path .. "/ores.lua")