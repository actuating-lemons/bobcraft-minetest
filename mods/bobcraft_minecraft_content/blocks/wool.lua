local S = minetest.get_translator("bobcraft_blocks")

wools = {}

-- Because I'm lazy...
function register_wool_colour(colour)
	minetest.register_node("bobcraft_blocks:wool_"..colour, {
		description = S(bobutil.titleize(colour) .. " Wool"),
		tiles = {"wool_"..colour..".png"},
		sounds = bobcraft_sounds.node_sound_wool(),
		groups = {shears=1, hand=1, crafting_wool=1},
		hardness = 0.8,
	})

	wools[colour] = "bobcraft_blocks:wool_"..colour
end

-- TODO: currently not all of these are obtainable.
local colours = dyes.colour_names

for i, colour in ipairs(colours) do
	register_wool_colour(colour)
end