portals = {}

local S = minetest.get_translator("portal_api")
portals.get_translator = S

-- Required things for the API to not misbehave, will be removed as the API becomes mutated.
portals.PORTAL_BOOK_LOOT_WEIGHTING = 0.9

portals.debug = function(m, ...) end


local mp = minetest.get_modpath("portal_api")
dofile(mp.."/api.lua")

-- the default wormhole
portals.register_wormhole_node("portal_api:portal", {
	description = "portal"
})