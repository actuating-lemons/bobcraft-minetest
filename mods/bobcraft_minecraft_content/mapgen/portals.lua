-- Portals!
-- Not neccesarily a worldgen feature, but this helps tie it in with dimensions.
-- A basic portal looks like this:
--  xx
-- x  x
-- x  x
-- x  x
--  xx
-- And is (usually) activated with a greendust igniter.
-- This will produce portal blocks, that when standing in, will teleport you to the dimension for the portal.
-- Your coords will be translated by the compression factor of said dimension.

-- The implementation of finding the portal frame for minetest game's both deprecated - https://github.com/PilzAdam/nether
-- and maintained - https://github.com/minetest-mods/nether - nether mods are complex.
-- I could just use the portal api of the nether mod, but then I'd be just as well using the whole mod!
-- I'll do it myself, harrumph harrumph.

-- Used for schematics, which is what we use to place a portal on the other side!
local air = {name = "air", prob = 0}
local nul = {name = "air", prob = 255, force_place = true} -- we *cut* with this.
local frm = {name = "bobcraft_blocks:obsidian", prob = 255, force_place = true} -- TODO: hardcoding obsidian? we want to be flexible!
local prl = {name = "bobcraft_worldgen:portal", prob = 255, force_place = true}

-- The usual portal shape.
local portal_shape = {
	air, frm, frm, air,
	frm, prl, prl, frm,
	frm, prl, prl, frm,
	frm, prl, prl, frm,
	air, frm, frm, air,
}

minetest.register_node("bobcraft_worldgen:portal", {
	description = "Portal",
	tiles = {
		"portal.png", -- TODO: transparency && animation
	},
	
	paramtype = "light",
	sunlight_propagates = true,

	paramtype2 = "color", -- We get coloured by the magic palette.
	palette = "magic.png",


	walkable = false,
	diggable = false,
	pointable = false,
	buildable_to = false,
	is_ground_content = false,
	drop = "",

	groups = {not_in_creative_menu = 1},
})

