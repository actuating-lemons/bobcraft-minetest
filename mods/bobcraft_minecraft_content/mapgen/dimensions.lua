-- Dimensions API.
-- Specifies y top and bottom values, and a function to run on a generation step for the area

worldgen.registered_dimensions = {}
worldgen.named_dimensions = {} -- TODO: Better name, as this just stores a dimension name -> dimension def table

-- Commonly used content ids
local c_air = minetest.get_content_id("air")
local c_grass = minetest.get_content_id("bobcraft_blocks:grass_block")
local c_dirt = minetest.get_content_id("bobcraft_blocks:dirt")
local c_stone = minetest.get_content_id("bobcraft_blocks:stone")
local c_water = minetest.get_content_id("bobcraft_blocks:water_source")
local c_lava = minetest.get_content_id("bobcraft_blocks:lava_source")
local c_bedrock = minetest.get_content_id("bobcraft_blocks:bedrock")

local c_hellstone = minetest.get_content_id("bobcraft_blocks:hellstone")

function worldgen.register_dimension(def)
	-- y_min is where the dimension starts generating in y levels,
	-- y_max is where the dimension stops generating in y levels
	def.y_min = def.y_min or 0
	def.y_max = def.y_max or 256

	-- min_light is used to set the minimum light level for the dimension
	def.min_light = def.min_light or 0

	-- The function we run when we're told to generate for a given minp/maxp
	def.gen_func = def.gen_func or function(this, minp, maxp, blockseed, vm, area, data) return data end
	-- init
	def.init = def.init or function(this) end

	-- The sealing
	-- Done AFTER the gen_func is called
	if def.seal_bottom == nil then
		def.seal_bottom = true
	end
	if def.seal_top == nil then
		def.seal_top = true
	end
	def.seal_node = def.seal_node or "bobcraft_blocks:bedrock"
	def.seal_thickness = def.seal_thickness or 1 -- How many blocks the sealer will 'jitter'

	-- The biomes we are allowed to generate in this dimension
	-- Basically the table passed into worldgen.get_biome_nearest
	def.biome_list = def.biome_list

	-- The compression factor to apply when transporting in or out of the dimension
	-- ex. when entering, the coords are divided by the compression_factor
	-- and when leaving, the coords are multiplied by the compression_factor
	-- so at 8, when entering at {8,8,8} you end up at {1,1,1}
	-- and when leaving at {8,8,8} you end up at {64,64,64}
	def.compression_factor = def.compression_factor or 1

	-- Fix-up node ids
	def.seal_node = minetest.get_content_id(def.seal_node)

	table.insert(worldgen.registered_dimensions, def)
	worldgen.named_dimensions[def.name] = def
end

-- Overworld
worldgen.register_dimension({
	name = "worldgen:dimension_overworld",
	y_min = worldgen.overworld_bottom,
	y_max = worldgen.overworld_top,
	seal_top = false,

	seal_thickness = 2,

	biome_list = {
		worldgen.biome("worldgen:biome_plains"),
		worldgen.biome("worldgen:biome_desert"),
		worldgen.biome("worldgen:biome_tundra"),
	},

	compression_factor = 1,
	
	init = function(this) 
		-- Create the noise map variables to optimise
		this.map_base = nil
		
		this.buffer_base = {}

		this.buffer_cave1 = {}
		this.buffer_cave2 = {}
		this.buffer_cave3 = {}
		this.buffer_structure = {}
	end,

	gen_func = function(this, minp, maxp, blockseed, vm, area, data)
		-- Insight taken from https://www.youtube.com/watch?v=FE5S2NeD7uU
		-- (Doing research and stumbled upon that)
		local sidelen = maxp.x - minp.x + 1
		-- local noise_base = worldgen.get_perlin_map_3d(worldgen.np_base, {x=sidelen, y=sidelen, z=sidelen}, minp)
		this.map_base = this.map_base or minetest.get_perlin_map(worldgen.np_base, {x=sidelen,y=sidelen,z=sidelen})
		local noise_base = this.map_base:get_3d_map(minp, this.buffer_base)


		-- The stone & water step
		local nixz = 1
		local nixyz = 1
		for x = minp.x, maxp.x do
			for y = minp.y, maxp.y do
				for z = minp.z, maxp.z do
					-- Stone && water step
					local vi = area:index(x,y,z)

					local percent = (y / worldgen.overworld_top)
					local value = noise_base[z-minp.z+1][y-minp.y+1][x-minp.x+1]

					if y <= worldgen.overworld_seafloor then
						value = 0 -- always place under the sea floor
					end

					if value*percent < 0.05 then
						data[vi] = c_stone
					elseif y <= worldgen.overworld_sealevel then
						data[vi] = c_water
					end

					nixyz = nixyz + 1
				end
				nixz = nixz + 1
			end
		end

		for z = minp.z, maxp.z do
			for x = minp.x, maxp.x do
				
				local ground = false
				local dirt_depth = 3 -- how many dirt blocks down
				local y_of_surface = nil -- the y value of the surface block

				for y = maxp.y, minp.y, -1 do
					local vi = area:index(x, y, z)
					local c = data[vi]

					if c == c_stone then
						if not y_of_surface then
							y_of_surface = y
							c = c_grass
						else
							if y > y_of_surface - dirt_depth then
								c = c_dirt
							end
						end
					end

					data[vi] = c
				end
			end
		end


		-- caves, structures
		local noise_caves = worldgen.get_perlin_map_3d(worldgen.np_caves, {x=sidelen, y=sidelen, z=sidelen}, minp, this.buffer_cave1)
		local noise_caves2 = worldgen.get_perlin_map_3d(worldgen.np_caves2, {x=sidelen, y=sidelen, z=sidelen}, minp, this.buffer_cave2)
		local noise_caves3 = worldgen.get_perlin_map_3d(worldgen.np_caves2, {x=sidelen, y=sidelen, z=sidelen}, minp, this.buffer_cave3)
		local noise_structure = worldgen.get_perlin_map(worldgen.np_caves, {x=sidelen, y=sidelen, z=sidelen}, minp, this.buffer_structure)
		local rand = PcgRandom(blockseed)
		local nixyz = 1
		nixz = 1

		-- whether we should try generating a certain structure, given the chance
		local gen_temple = true

		for x = minp.x, maxp.x do
			for z = minp.z, maxp.z do
				for y = minp.y, maxp.y do
					local vi = area:index(x, y, z)

					local cave, cave2, cave3 = noise_caves[nixyz], noise_caves2[nixyz], noise_caves3[nixyz]

					if (cave ^ 2 + cave2 ^ 2 + cave3 ^ 2) < 0.04 then
						if data[vi] ~= air then
							-- If it's ground content, smash our way through it
							if data[vi] == c_stone or
							data[vi] == c_dirt or
							data[vi] == c_grass or
							data[vi] == c_sand or
							data[vi] == c_sandstone then
								data[vi] = c_air
							end
						end
					end

					nixyz = nixyz + 1
				end

				local amount = math.floor(noise_structure[nixz] * 9)
				for i = 0, amount do
					if gen_temple and rand:next(0,50000) == 0 then
						worldgen.gen_struct({x=x,z=z, y=rand:next(worldgen.overworld_struct_min, worldgen.overworld_struct_max)}, "temple", "random", rand)
						gen_temple = false -- one per chunk
					end
				end

				nixz = nixz + 1
			end
		end

		return data
	end
})

worldgen.register_dimension({
	name = "worldgen:dimension_hell",
	y_min = worldgen.hell_bottom,
	y_max = worldgen.hell_top,

	seal_thickness = 4,
	
	min_light = 4,

	biome_list = {
		worldgen.biome("worldgen:biome_hell_wastes"),
	},

	-- We are *more* compressed than the nether, as it makes sense in the minetest world, chunks being 5x5x5.
	-- It also means that working out distances can be done in your head!
	compression_factor = 10,
	
	init = function (this)
		this.map_caves = nil

		this.buffer_caves = {}
	end,

	gen_func = function(this, minp, maxp, blockseed, vm, area, data)
		local sidelen = maxp.x - minp.x + 1
		this.map_caves = this.map_caves or minetest.get_perlin_map(worldgen.np_caves_hell, {x=sidelen,y=sidelen,z=sidelen})
		local noise_caves = this.map_caves:get_3d_map(minp, this.buffer_caves)

		local nixyz = 1
		for y = minp.y, maxp.y do -- do y first to calculate the percent the least amount of times possible

			-- Given x as a percentage of how close we are to the bottom,
			-- the percentage is
			-- min(((1 - x)^2)^2, 1)

			-- first work out x
			-- to get the % of a number between 0 and, say, +20
			-- x = y / 20
			-- But for between +5 and +20, we'd do
			-- x = y / (20 - 5)
			-- and we don't care about decimals so we just get the absolute value as that removes negatives
			local n = math.abs(y-worldgen.hell_top) / (math.abs(worldgen.hell_bottom)-math.abs(worldgen.hell_top))

			-- we now plug that into our caluclation
			local mult = ( ( 1 - n ) ^ 2) ^ 2
			mult = 1 - mult

			for x = minp.x, maxp.x do
				for z = minp.z, maxp.z do
					local vi = area:index(x, y, z)

					local cave = noise_caves[z-minp.z+1][y-minp.y+1][x-minp.x+1]

					if cave*mult < 0.1 then
						if y > worldgen.hell_bottom and y < worldgen.hell_top then
							data[vi] = c_hellstone
						end
					end

					if y <= worldgen.hell_sealevel and y >= worldgen.hell_bottom then
						if data[vi] == c_air then
							data[vi] = c_lava
							if y == worldgen.overworld_sealevel then
								data[vi] = c_lava
							end
						end
					end

					nixyz = nixyz + 1
				end
			end
		end

		return data
	end
})

-- Respawning on the surface
minetest.register_on_respawnplayer(function(player)
	local name = player:get_player_name()
	local has = beds.spawn[name] or nil
	if has then
		return true
	end

	local pos = bobutil.search_for_spawn({x=0, y=70, z=0}, {x=0,y=60,z=0})
	player:set_pos(pos)

	return true

end)
-- Spawning at all on the surface
minetest.register_on_newplayer(function(player)
	local pos = bobutil.search_for_spawn({x=0, y=70, z=0}, {x=0,y=60,z=0})
	player:set_pos(pos)
end)

-- Portal to hell
portals.register_portal("hell_portal", {
	shape = portals.PortalShape_Traditional,
	frame_node_name = "bobcraft_blocks:obsidian",
	wormhole_node_color = 0,
	title = "Hell Portal",

	is_within_realm = function(pos)
		return pos.y > worldgen.hell_bottom and pos.y < worldgen.hell_top
	end,

	find_realm_anchorPos = function(surface_anchorPos, player_name)
		-- divide x and z by hell's shrink factor
		local factor = worldgen.named_dimensions["worldgen:dimension_hell"].compression_factor

		local dest = vector.divide(surface_anchorPos, factor)

		dest.x = math.floor(dest.x)
		dest.z = math.floor(dest.z)
		-- Get the middle of the dimension
		dest.y = math.floor((worldgen.hell_top+worldgen.hell_bottom)/2)
		
		-- search for existing portals
		local existing_portal_location, existing_portal_orientation = portals.find_nearest_working_portal("hell_portal", dest, factor, 0)

		if existing_portal_location ~= nil then
			return existing_portal_location, existing_portal_orientation
		else
			-- Do it from the sea level up, so we don't ever spawn in the lava (OOPS!)
			local y = math.random(worldgen.hell_sealevel, worldgen.hell_top-25)
			dest.y = y
			return dest
		end
	end,

	find_surface_anchorPos = function (realm_anchorPos, player_name)
		local factor = worldgen.named_dimensions["worldgen:dimension_hell"].compression_factor

		local dest = vector.multiply(realm_anchorPos, factor)

		-- TODO: Clip to world
		dest.y = math.floor((worldgen.overworld_top+worldgen.overworld_bottom)/2)

		local existing_portal_location, existing_portal_orientation = portals.find_nearest_working_portal("hell_portal", dest, factor, 0)

		if existing_portal_location ~= nil then
			return existing_portal_location, existing_portal_orientation
		else
			-- TODO: actually find surface
			dest.y = 100
			return dest
		end
	end,

	on_ignite = function(portal_def, anchor_pos, orientation)
		local p1, p2 = portal_def.shape:get_p1_and_p2_from_anchorPos(anchor_pos, orientation)
			local pos = vector.divide(vector.add(p1, p2), 2)

			local textureName = portal_def.particle_texture
			if type(textureName) == "table" then textureName = textureName.name end

			minetest.add_particlespawner({
				amount = 110,
				time   = 0.1,
				minpos = {x = pos.x - 0.5, y = pos.y - 1.2, z = pos.z - 0.5},
				maxpos = {x = pos.x + 0.5, y = pos.y + 1.2, z = pos.z + 0.5},
				minvel = {x = -5, y = -1, z = -5},
				maxvel = {x =  5, y =  1, z =  5},
				minacc = {x =  0, y =  0, z =  0},
				maxacc = {x =  0, y =  0, z =  0},
				minexptime = 0.1,
				maxexptime = 0.5,
				minsize = 0.2 * portal_def.particle_texture_scale,
				maxsize = 0.8 * portal_def.particle_texture_scale,
				collisiondetection = false,
				texture = textureName .. "^[colorize:#0F4:alpha",
				animation = portal_def.particle_texture_animation,
				glow = 8
			})
	end,

})

--[[
! WHEN THE
	⠀⠀⠀⠀⠀⠀⠀⠀⣠⣤⣤⣤⣤⣤⣶⣦⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⡿⠛⠉⠙⠛⠛⠛⠛⠻⢿⣿⣷⣤⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⠋⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⠈⢻⣿⣿⡄⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣸⣿⡏⠀⠀⠀⣠⣶⣾⣿⣿⣿⠿⠿⠿⢿⣿⣿⣿⣄⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣿⣿⠁⠀⠀⢰⣿⣿⣯⠁⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣷⡄⠀
⠀⠀⣀⣤⣴⣶⣶⣿⡟⠀⠀⠀⢸⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣷⠀
⠀⢰⣿⡟⠋⠉⣹⣿⡇⠀⠀⠀⠘⣿⣿⣿⣿⣷⣦⣤⣤⣤⣶⣶⣶⣶⣿⣿⣿⠀
⠀⢸⣿⡇⠀⠀⣿⣿⡇⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠀
⠀⣸⣿⡇⠀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠉⠻⠿⣿⣿⣿⣿⡿⠿⠿⠛⢻⣿⡇⠀⠀
⠀⠸⣿⣧⡀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⠃⠀⠀
⠀⠀⠛⢿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⣰⣿⣿⣷⣶⣶⣶⣶⠶⠀⢠⣿⣿⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⣿⣿⡇⠀⣽⣿⡏⠁⠀⠀⢸⣿⡇⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⣿⣿⡇⠀⢹⣿⡆⠀⠀⠀⣸⣿⠇⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢿⣿⣦⣄⣀⣠⣴⣿⣿⠁⠀⠈⠻⣿⣿⣿⣿⡿⠏⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠈⠛⠻⠿⠿⠿⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
! BOTTOM TEXT⠀⠀ 
]]