-- stuff like "abm", which I don't know what stands for.
-- EDIT: ActiveBlockModifier

-- Grass growing
minetest.register_abm(
	{
		label = "Grass Spread",
		nodenames = {"bobcraft_blocks:grass_block", "bobcraft_blocks:snowy_grass_block"},

		-- Not sure if minecraft makes the distinction,
		-- But we don't care about the snow.
		neighbours = {"bobcraft_blocks:dirt"},

		-- Minecraft does this strangely.
		-- Every random tick, it gets a grass block to check a few things.
		-- Is it well-lit? if it is, it then gets a random coordinate in a certain radius
		-- If that block is a dirt block, AND it's well lit, AND there's nothing on top of it, it will grow grass.
		-- That explains why it can take *quite* a while to grow grass. But we can't do that in minetest (I don't think).
		-- So I calculated that on a flat plane, 2 blocks to each side, 3 up & down -
		-- a 64 block radius (ignoring the uneven vertical growth)
		-- with 15 of those blocks being dirt
		-- ~23% chance of it happening (given a flat plane of just grass)
		-- And the time there then depends on random tick speed!
		-- Which takes a random 3 blocks in a given chunk and tells them to random tick. How the hell would we do that?
		-- But I've admit defeat and got "close-enough" with it trying every 5 seconds, and a 23% chance of it happening.
		-- that's going to be considerabley faster than minecraft on a bad day, but hey, only I care about getting it 100% accurate.
		interval = 5.0,
		chance = 4.5, -- 23% is already rounded, 0.222...% is close enough!

		action = function(pos, node)
			-- When I wrote that whole spheal, I didn't realise I could put a function here.
			-- However, I still feel smart for doing all that math.
			-- So this searches for dirt in a 4*4*4 radius and sets a random one of them (that matches criteria) to grass.

			local above = {x = pos.x, y = pos.y + 1, z = pos.z}
			if (minetest.get_node_light((above)) or 0) < 9 then -- 9 is the light level MC uses.
				return
			end
			-- Minecraft then checks four times. We already know we're going to grow.
			-- Find all dirt blocks in the immediate 4*4*4 area.
			-- TODO: this seems really expensive to do every second.
			local bounds_low = {x = pos.x - 4, y = pos.y - 4, z = pos.z - 4}
			local bounds_high = {x = pos.x + 4, y = pos.y + 4, z = pos.z + 4}
			local dirt_block_pos, _ = minetest.find_nodes_in_area(bounds_low, bounds_high, "bobcraft_blocks:dirt")
			if dirt_block_pos == nil then
				return -- No dirt blocks? no business!
			end

			local candidates = {}

			-- we now weed out any that aren't bright enough/are obscured (by a block)
			-- TODO: maybe minetest has some functions for this?
			for i = 1, #dirt_block_pos do
				local pos2 = dirt_block_pos[i]
				local above_block = {pos2.x, pos2.y + 1, pos2.z}
				if (minetest.get_node_light(above_block) or 0) >= 4 then -- 4 is the light level MC uses.
					local name = minetest.get_node(above_block).name

					-- Grow under air or snow
					if name == "air" or 
					name == "bobcraft_blocks:snow_layer" then
						table.insert(candidates, pos2)
					end
				end
			end

			if #candidates == 0 then
				return
			end
			local the_one_block = candidates[math.random(1, #candidates)] -- to rule them all

			if the_one_block then
				minetest.set_node(the_one_block, {name=node.name})
			end			
		end
	}
)

-- Grass dieing
-- I've made it, now i kill it
-- I only care about being accurate enough that it dies.
minetest.register_abm({
	label = "Grass Death",

	interval = 2.5,
	nodenames = {"bobcraft_blocks:grass_block", "bobcraft_blocks:snowy_grass_block"},
	chance = 2, -- I don't get these chance values.
	action = function(pos, node)
		local above = {x=pos.x, y=pos.y+1, z=pos.z}

		local node_above = minetest.get_node(above).name
		local node_def = minetest.registered_nodes[node_above]
		if node_def and 
		(not node_def.sunlight_propagates or
		node_def.walkable) then -- If sunlight doesn't propagate, or we can walk on it
			minetest.set_node(pos, {name="bobcraft_blocks:dirt"})
		end
	end
})

-- Leaf decay
minetest.register_abm({
	label = "Leaf Decay",

	-- ...Yeah I have no clue how MC does it.

	interval = 1,
	nodenames = {"bobcraft_blocks:leaves"},
	chance = 10,
	action = function(pos, node)
		if minetest.find_node_near(pos, 4, "bobcraft_blocks:log") then
			return
		end
		minetest.remove_node(pos)
		local plant_sounds = bobcraft_sounds.node_sound_planty()
		minetest.sound_play(plant_sounds.dug.name, {
			pos = pos,
			max_hear_distance = 16,
			gain = plant_sounds.dug.gain
		})
		-- TODO: random drops
	end

})

minetest.register_abm({
	label = "Lava & Water Interaction",

	interval = 1,
	chance = 1,

	nodenames = {"group:lava"},
	neighbours = {"group:water"},

	action = function(pos, node)
		local search_low = {x=pos.x-1,y=pos.y-1,z=pos.z-1}
		local search_high = {x=pos.x+1,y=pos.y+1,z=pos.z+1}
		local waters = minetest.find_nodes_in_area(search_low, search_high, "group:water") -- search high & low for water

		local lavastate = minetest.registered_nodes[node.name].liquidtype

		for i=1, #waters do
			local waternode = minetest.get_node(waters[i])
			local waterstate = minetest.registered_nodes[waternode.name]
			local done_a_thing = false

			if waters[i].y < pos.y and waters[i].x == pos.x and waters[i].z == pos.z then
				-- If the water is below us directly
				-- Turn the water into stone
				minetest.set_node(waters[i], {name="bobcraft_blocks:stone"})
				done_a_thing = true
			elseif lavastate == "flowing" and waters[i].y == pos.y and (waters[i].x == pos.x or waters[i].z == pos.z) then
				-- If we're flowing, and the water is next to us
				-- Turn the lava into cobblestone
				minetest.set_node(pos, {name="bobcraft_blocks:cobblestone"})
				done_a_thing = true
			elseif lavastate == "source" and
				(waters[i].x == pos.x and waters[i].y > pos.y and waters[i].z == pos.z) then
				-- If we're a source block, and there's water above us
				--turn the lava into obsidian
				minetest.set_node(pos, {name="bobcraft_blocks:obsidian"})
				done_a_thing = true
			elseif lavastate == "flowing" and waters[i].y > pos.y and waters[i].x == pos.x and waters[i].z == pos.z then
				-- If there's water above flowing lava, turn the lava into cobblestone
				minetest.set_node(pos, {name="bobcraft_blocks:cobblestone"})
			end


			if done_a_thing then
				minetest.sound_play({name="fire_extinguish"}, {pos=pos, gain=0.1, max_hear_distance=16}, true)
			end
		end
	end,
})