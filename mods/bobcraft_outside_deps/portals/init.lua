portals = {}

local S = minetest.get_translator("portal_api")
portals.get_translator = S

local mp = minetest.get_modpath("portal_api")
dofile(mp.."/api.lua")