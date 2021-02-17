--[[
	While reading the source code for MineClone 2,
	I found out they have a mod called '_mcl_autogroup.'
	In it, they do various things.
	However, they also set their tool values there.
	I think that's a good idea. I'm doing it.

	of-course I'm not using their terminology.

	I also consolidated all the tool values here.

	The way I've added the hand means that there are
	pickaxe_hand, hand_gold, etc.
	it's fine though, I use hand_hand.
	
	Holy.... wow....
	I have respect further respect for mineclone now.
	This was a bitch to get working.
]]

local materials = {
	"wood",
	"stone",
	"gold",
	"iron",
	"diamond"
}
local tool_types = {
	"pickaxe",
	"axe",
	"shovel"
}

tool_values = {}
tool_values.times = {}

tool_values.material_mining_level =  {
	wood = 0,
	stone = 1,
	iron = 2,
	diamond = 3,
	gold = 0
}
tool_values.material_max_uses = {
	wood = 59,
	stone = 131,
	iron = 150,
	diamond = 1561,
	gold = 32
}
tool_values.correct_material_efficiency = {
	wood = 2,
	stone = 4,
	iron = 6,
	diamond = 8,
	gold = 12 -- wow!
}

for i=1, #materials do
	for j=1, #tool_types do
		tool_values.times[tool_types[j].."_"..materials[i]] = {}
	end
end

-- Called as the last step in blocks/init.lua
tool_values.setup_values = function()
	local function calculate_tool(newgroups, hardness, material, tool, actual_rating, expected_rating)
		-- Minecraft 1.2.5 has validity based on a list of blocks.
		-- Sad!
		-- I'm using MineClone 2's solution here, which seems to be basing it on the actual_rating of the tool vs. the expected_rating.
		-- If it works, it works.
		
		local time = 1

		if actual_rating >= expected_rating then
			validity_factor = 1
		else
			validity_factor = 5
		end

		local speed_multiplier = tool_values.correct_material_efficiency[material]
		if time <= 0.05 then
			time = 0
		else
			time = math.ceil(time * 20) / 20
		end

		table.insert(tool_values.times[tool .. "_" .. material], time)
		newgroups[tool .. "_" .. material] = #tool_values.times[tool .. "_" .. material]
		return newgroups
	end

	for nodename, nodedef in pairs(minetest.registered_nodes) do
		local changed = false
		local newgroups = table.copy(nodedef.groups)
		local hardness = nodedef.hardness or 0
		for i, tool in pairs(tool_types) do
			if nodedef.groups[tool] then
				for j=1, #materials do
					newgroups = calculate_tool(newgroups, hardness, materials[j], tool, j, nodedef.groups[tool])
					changed = true
				end
			end
		end

		if changed then
			minetest.override_item(
				nodename, {
					groups = newgroups
				}
			)
		end
	end
end