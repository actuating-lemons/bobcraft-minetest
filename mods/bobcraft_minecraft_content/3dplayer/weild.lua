--[[
    Adapted from stu's weild3d mod. https://content.minetest.net/packages/stu/wield3d/
]]

wield3d = {}

dofile(minetest.get_modpath(minetest.get_current_modname()).."/weild3dlocation.lua")

local timer = 0
local player_wielding = {}
local location = {
	"arm_r",          -- default bone
	{x=2, y=6, z=0},    -- default position
	{x=0, y=0, z=-70}, -- default rotation
	{x=0.25, y=0.25},     -- default scale
}

local function add_wield_entity(player)
	local name = player:get_player_name()
	local pos = player:get_pos()
	if name and pos then
		pos.y = pos.y + 0.5
		local object = minetest.add_entity(pos, "3dplayer:wield_entity")
		if object then
			object:set_attach(player, location[1], location[2], location[3])
			object:set_properties({
				textures = {"aeternitas"},
				visual_size = location[4],
			})
			player_wielding[name] = {}
			player_wielding[name].item = ""
			player_wielding[name].object = object
			player_wielding[name].location = location
		end
	end
end

minetest.register_entity("3dplayer:wield_entity", {
	physical = false,
	pointable= false,

	visual = "wielditem",
	on_activate = function(self, staticdata)
		if staticdata == "expired" then
			self.object:remove()
		end
	end,
	on_punch = function(self)
		self.object:remove()
	end,
	get_staticdata = function(self)
		return "expired"
	end,
})

minetest.register_globalstep(function(dtime)
	local active_players = {}
	for _, player in pairs(minetest.get_connected_players()) do
		local name = player:get_player_name()
		local wield = player_wielding[name]
		if wield and wield.object then
			local stack = player:get_wielded_item()
			local item = stack:get_name() or ""
			if item ~= wield.item then
				wield.item = item
				if item == "" then
					item = "3dplayer:hidden_hand"
				end
				local loc = wield3d.location[item] or location
				wield.object:set_properties({
					textures = {item},
					visual_size = loc[4],
				})
			end
		else
			add_wield_entity(player)
		end
		active_players[name] = true
	end
	for name, wield in pairs(player_wielding) do
		if not active_players[name] then
			if wield.object then
				wield.object:remove()
			end
			player_wielding[name] = nil
		end
	end
	timer = 0
end)

minetest.register_item("3dplayer:hidden_hand", {
	type = "none",
	wield_image = "blank.png",
})

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	if name then
		local wield = player_wielding[name] or {}
		if wield.object then
			wield.object:remove()
		end
		player_wielding[name] = nil
	end
end)

