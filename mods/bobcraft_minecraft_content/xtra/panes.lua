local function register_pane(name, blockdef)
	blockdef.paramtype = "light"
	blockdef.sunlight_propagates = true
	blockdef.drawtype = "nodebox"
	blockdef.node_box = {
		type = "connected",
		disconnected_sides = -- ROD
		{
			-1/16, -0.5, -1/16,
			1/16, 0.5, 1/16,
		},

		connect_front =
		{
			-1/16, -0.5, -0.5,
			1/16, 0.5, 1/16,
		},
		connect_back =
		{
			-1/16, -0.5, -1/16,
			1/16, 0.5, 0.5,
		},

		connect_left =
		{
			-0.5, -0.5, -1/16,
			1/16, 0.5, 1/16,
		},

		connect_right =
		{
			-1/16, -0.5, -1/16,
			0.5, 0.5, 1/16,
		},
	}

	-- We care about connecting everywhere except up.
	blockdef.connect_sides = {
		"front",
		"left",
		"back",
		"right",
	}
	-- NOTE: Despite what the documentation says, it MUST be a table.
	-- Thanks, Documen
	blockdef.connects_to = {name} -- connect to ourselves

	minetest.register_node(name,blockdef)
end

register_pane("bobcraft_blocks_xtra:iron_bars", {
	description = "Iron Bars",
	tiles = {"iron_bars_top.png", "iron_bars_top.png", "iron_bars.png"},
	sounds = bobcraft_sounds.node_sound_metal(),

	paramtype = "light",
	paramtype2 = "facedir", -- TODO: until we have panes, this is good enough.

	hardness = 3,
	groups = {pickaxe=1},
	stack_max = bobutil.stack_max,
})