-- Because I'm lazy...

local function titleize(str)
	str = str:gsub("_", " ")
	return str:gsub("^%l", string.upper)
end

function register_wool_colour(colour)
	minetest.register_node("bobcraft_blocks:wool_"..colour, {
		description = titleize(colour) .. " Wool",
		tiles = {"wool_"..colour..".png"},
		sounds = bobcraft_sounds.node_sound_wool(),
		groups = {shears=1, hand=1},
		hardness = 0.8,
	})
end

-- TODO: currently not all of these are obtainable.
local colours = {
	"black",
	"dark_grey",
	"grey",
	"white",

	"blue",
	"cyan",
	"picton", -- fancy blue

	"green",
	"lime",

	"purple",
	"pink",
	"red",
	"magenta",

	"yellow",
	"orange",
	"brown",
}

for i, colour in ipairs(colours) do
	register_wool_colour(colour)
end