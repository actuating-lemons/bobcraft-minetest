local S = minetest.get_translator("bobcraft_blocks")

minetest.register_node("bobcraft_blocks:wool", {
	description = "Wool",
	tiles = {"wool_white.png"},
	palette = "dyepalette.png",
	param2 = 0,
	palette_index = 0,
	sounds = bobcraft_sounds.node_sound_wool(),
	groups = {shears=1, hand=1, crafting_wool=1},
	hardness = 0.8,
})

-- Compatability
for _, color in ipairs(dyes.colour_names) do
	minetest.register_alias("bobcraft_blocks:wool_"..color, "bobcraft_blocks:wool")
end