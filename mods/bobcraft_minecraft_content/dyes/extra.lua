--- extra colours!!!!!

local function register_dye_item(name, colour)
	minetest.register_craftitem("bobcraft_dyes:dye_"..name, {
		description = bobutil.titleize(name) .. " Dye",
		inventory_image = "dye_white.png^[colorize:"..colour,
		stack_max = bobutil.stack_max,
	})

	dyes.ext_items[name] = "bobcraft_dyes:dye_"..name
end

dyes.ext_items = {}

-- we use vectors for colours
dyes.ext_colours = {
	-- R, G, B
	vector.new(255,0,0),
	vector.new(0,255,0),
	vector.new(0,0,255),

	-- C, Y, M
	vector.new(0,255,255),
	vector.new(255,255,0),
	vector.new(255,0,255),
}

-- register base colours
for i, colour in ipairs(dyes.ext_colours) do
	register_dye_item("ext_"..i, bobutil.vector_to_colourstring(colour))
end