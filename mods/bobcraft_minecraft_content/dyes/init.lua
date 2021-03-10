-- dye system
-- 16 colours only, although colour mixing is a wish (see doc/wishes.md)

local function register_dye_item(colourname)
	minetest.register_craftitem("bobcraft_dyes:dye_"..colourname, {
		description = bobutil.titleize(colourname) .. " Dye",
		inventory_image = "dye_"..colourname..".png",
		stack_max = bobutil.stack_max
	})

	dyes.items[colourname] = "bobcraft_dyes:dye_"..colourname
end

dyes = {}

dyes.colour_names = {
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
dyes.colours = { -- I *did* have the colours, but as it is, I'm stupid and lost them - so these are averages of the wool textures for now.
	black = "#090909",
	dark_grey = "#656565",
	grey = "#afafaf",
	white = "#ffffff", -- except this, I know the base colour's white
	
	blue = "#002ebb",
	cyan = "#5aa4aa",
	picton = "#4293b4", -- Would make a nice plain colour for a desktop background, going well with a creamy colour.

	green = "#0f8a0a",
	lime = "#11aa09",

	purple = "#741282",
	pink = "#ae6b64",
	red = "#a90b19",
	magenta = "#894a8c",
	
	yellow = "#a68600",
	orange = "#d29839",
	brown = "#5d470e",
}
dyes.items = {}

for i, colour in ipairs(dyes.colour_names) do
	register_dye_item(colour)
end

local mp = minetest.get_modpath("bobcraft_dyes")
dofile(mp.."/extra.lua")