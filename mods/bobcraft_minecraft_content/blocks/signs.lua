-- oh. my. god.
-- There's an issue open FROM 2014 (https://github.com/minetest/minetest/issues/1367)! that talks about adding a surface-text api.
-- A pull request towards implementing it in 2020 (https://github.com/minetest/minetest/pull/9999), that was CANCELLED AFTER NO-ONE TESTED IT.
-- Open-source is great, but sometimes, shit like that happens.
-- It's understandable, however, as the mobile project for minetest is also the same code-base, and must be compatbile, yadda yadda...
-- For that reason, the signs are just very basic blocks that attach to a wall and display text on hover-over.
-- As signs_lib doesn't match the licensing I want the mods to be under, (Our CC-BY vs. signs_lib's LGPL)
-- It's also a bit hacky, and while I've done hacky things (see foliage colouring), entities for signs is a bit much.
-- How the hell is this issue not solved, it's got a $550 bounty for crying out loud.

-- These are random messages that have a 1 in 1000 chance to appear on a sign when you place it.
-- If you want to keep the mystery, skip to line #
local random_messages = {
	"Help, I'm trapped in a sign!",
	"-From God",
	"help how did I get here I'm not good with computer",
	"I was looking for po-... illicit material!",
	"Hang on, isn't this just the splash text but on signs?",
	"Hello, World!",
	"Goodbye, World!",
	"Excuse me, do you have the time?",
	
}

local S = minetest.get_translator("bobcraft_blocks")

minetest.register_node("bobcraft_blocks:sign", {
	description = S("Sign"),
	tiles = {"planks.png"},
	sounds = bobcraft_sounds.node_sound_wood(),
	drawtype = "nodebox",
	node_box = { -- the way of the future!
		type = "fixed",
		fixed = {
			-- The face
			{-0.5, -1/16, -1/16,
			0.5, 0.5, 1/16,},
			-- handle
			{-1/16, -0.5, -1/16,
			 1/16, -1/16 , 1/16,}
		}
	},

	walkable = false,

	paramtype = "light",
	sunlight_propagates = true,

	paramtype2 = "facedir",

	wield_image = "sign.png",
	inventory_image = "sign.png",

	groups = {hand=1, attached_node=1},

	on_construct = function(pos)
		local meta = minetest.get_meta(pos)
		meta:set_string("formspec", "field[text;;${text}]")

		-- Set the random text
		if math.random(0,1000) == 0 then
			meta:set_string("infotext", random_messages[math.random(#random_messages)])
		end
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local text = fields.text
		local meta = minetest.get_meta(pos)

		if text and #text > 0 then
			meta:set_string("infotext", S('"@1"', text))
		else
			meta:set_string("infotext", '')
		end
	end,
})