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
local c_sanf = minetest.get_content_id("bobcraft_blocks:sand")
local c_sandstone = minetest.get_content_id("bobcraft_blocks:sandstone")

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
		this.np_base = {
			offset = 1.2,
			scale = 16,
			spread = {x=256, y=128, z=256},
			octaves = 16,
			seed = 69420,
			persist = 0.6,
			lacunarity = 2,
			flags = "eased",
		}
		this.np_base1 = table.copy(this.np_base)
		this.np_base1.seed = 42069
		this.np_base2 = table.copy(this.np_base)
		this.np_base2.seed = 92839
		this.np_erosion = table.copy(this.np_base)
		this.np_erosion.seed = 238392
		this.np_erosion1 = table.copy(this.np_base)
		this.np_erosion1.seed = 213342
	end,

	sample_heightmap = function (this, x, z, ni, noise_base, noise_base1, noise_base2, noise_erosion, noise_erosion1)
		-- snap to these to create farlands-like things.
		-- Just for that extra bit of spice!
		x = math.min(29000, math.max(x, -29000))
		z = math.min(29000, math.max(z, -29000))

		-- Raising!

		local heightlow = noise_base:get_2d({x = x * 1.3, y = z * 1.3}) / 6 - 4
		local heighthigh = noise_base1:get_2d({x = x * 1.3, y = z * 1.3}) / 5 + 10 - 4

		local heightselector = noise_base2:get_2d({x = x, y = z}) / 8
		if heightselector > 0.0 then
			heighthigh = heightlow	
		end

		local y = math.max(heightlow, heighthigh) / 2

		if y < 0.0 then
			y = y * 0.8
		end

		y = y + worldgen.overworld_sealevel

		-- Eroding!
		local erosion = noise_erosion:get_2d({x = bobutil.lshift(x, 1), y = bobutil.lshift(z, 1)}) / 8
		local erosionselector = (noise_erosion:get_2d({x = bobutil.lshift(x, 1), y = bobutil.lshift(z, 1)}) > 0) and 1 or 0
		if erosion > 2 then
			y = bobutil.lshift((y - erosionselector) / 2, 1)
		end

		return y
	end,

	gen_func = function(this, minp, maxp, blockseed, vm, area, data)
		local sidelen = maxp.x - minp.x + 1
		local ni = 1

		local noise_base = minetest.get_perlin(this.np_base)
		local noise_base1 = minetest.get_perlin(this.np_base1)
		local noise_base2 = minetest.get_perlin(this.np_base2)
		local noise_erosion = minetest.get_perlin(this.np_erosion)
		local noise_erosion1 = minetest.get_perlin(this.np_erosion1)


		local noise_temperature = worldgen.get_perlin_map(worldgen.np_temperature, {x=sidelen, y=sidelen, z=sidelen}, minp)
		local noise_rainfall = worldgen.get_perlin_map(worldgen.np_rainfall, {x=sidelen, y=sidelen, z=sidelen}, minp)

		for z = minp.z, maxp.z do
			for x = minp.x, maxp.x do
				if maxp.y >= worldgen.overworld_bottom then 
					local top_node, mid_node, bottom_node, above_node, liquid_node, liquid_top_node

					local temperature = noise_temperature[ni]
					local rainfall = noise_rainfall[ni]

					local biome = worldgen.get_biome_nearest(temperature, rainfall, this.biome_list)

					local y = this.sample_heightmap(this, x, z, ni, noise_base, noise_base1, noise_base2, noise_erosion, noise_erosion1)

					above_node = biome.above
					top_node = biome.top
					mid_node = biome.middle
					bottom_node = biome.bottom
					liquid_node = biome.liquid
					liquid_top_node = biome.liquid_top

					--------------------------------------------------------
					--                               _                    --
					--	 _ __ ___  _ __ ___      ___| |_ ___  _ __   ___  --
					--	| '_ ` _ \| '_ ` _ \    / __| __/ _ \| '_ \ / _ \ --
					--	| | | | | | | | | | |_  \__ \ || (_) | | | |  __/ --
					--	|_| |_| |_|_| |_| |_( ) |___/\__\___/|_| |_|\___| --
					--						|/                            --
					--------------------------------------------------------

					if y >= minp.y then
						for yy = minp.y, math.min(y, maxp.y) do
							local vi = area:index(x, yy, z)
							if yy >= worldgen.overworld_bottom then
								data[vi] = bottom_node
								if yy > y + 1 then
									if yy > worldgen.overworld_sealevel then
										data[vi] = above_node
									end
								elseif yy > y - 1 then
									if yy >= worldgen.overworld_sealevel then
										data[vi] = top_node
									else
										data[vi] = mid_node
									end
								elseif yy >= y - 3 then
									data[vi] = mid_node
								end
							end
						end
					end

					for yy = minp.y, maxp.y do
						local vi = area:index(x, yy, z)
						-- the sea
						if yy <= worldgen.overworld_sealevel and yy >= worldgen.overworld_bottom then
							if data[vi] == c_air then
								data[vi] = liquid_node
								if yy == worldgen.overworld_sealevel then
									data[vi] = liquid_top_node
								end
							end
						end
					end
					
				end
				ni = ni + 1
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
		minetest.log("warn", "Hell is disabled!")
		this.map_caves = nil
		this.map_pillars = nil

		this.buffer_caves = {}
		this.buffer_pillars = {}
	end,

	gen_func = function(this, minp, maxp, blockseed, vm, area, data)
		return data
		-- local sidelen = maxp.x - minp.x + 1
		-- this.map_caves = this.map_caves or minetest.get_perlin_map(worldgen.np_hell_cavern, {x=sidelen,y=sidelen,z=sidelen})
		-- local noise_caves = this.map_caves:get_3d_map(minp, this.buffer_caves)

		-- -- will this chunk have a pillar?
		-- local gen_pillar = false
		-- -- Middle of the chunk
		-- local pillarx = (minp.x + maxp.x) /2
		-- local pillarz = (minp.z + maxp.z) /2

		-- this.map_pillars = this.map_pillars or minetest.get_perlin(worldgen.np_hell_pillar)
		-- local noise_pillars = this.map_pillars:get_3d({x=pillarx,y=pillarz})

		-- local pillar_variator = 0

		-- if noise_pillars > 0.9 then
		-- 	gen_pillar = true
		-- 	pillar_variator = math.max(0,this.map_pillars:get_3d({x=pillarx,y=pillarz}))
		-- end

		-- local nixyz = 1
		-- for y = minp.y, maxp.y do -- do y first to calculate the percent the least amount of times possible

		-- 	-- Given x as a percentage of how close we are to the bottom,
		-- 	-- the percentage is
		-- 	-- 2 (1-2x)^2 + 0.2

		-- 	-- first work out x
		-- 	-- to get the % of a number between 0 and, say, +20
		-- 	-- x = y / 20
		-- 	-- But for between +5 and +20, we'd do
		-- 	-- x = y / (20 - 5)
		-- 	-- and we don't care about decimals so we just get the absolute value as that removes negatives
		-- 	local n = math.abs(y-worldgen.hell_top) / (math.abs(worldgen.hell_bottom)-math.abs(worldgen.hell_top))

		-- 	-- we now plug that into our caluclation
		-- 	local mult =  2 * ( 1 - n * 2 ) ^ 2 + 0.2

		-- 	for x = minp.x, maxp.x do
		-- 		for z = minp.z, maxp.z do
		-- 			local vi = area:index(x, y, z)

		-- 			local cave = noise_caves[z-minp.z+1][y-minp.y+1][x-minp.x+1]

		-- 			if cave*mult > 0.7 then
		-- 				if y > worldgen.hell_bottom and y < worldgen.hell_top then
		-- 					data[vi] = c_hellstone
		-- 				end
		-- 			end

		-- 			if y <= worldgen.hell_sealevel and y >= worldgen.hell_bottom then
		-- 				if data[vi] == c_air then
		-- 					data[vi] = c_lava
		-- 					if y == worldgen.overworld_sealevel then
		-- 						data[vi] = c_lava
		-- 					end
		-- 				end
		-- 			end

		-- 			if gen_pillar and y > worldgen.hell_bottom and y < worldgen.hell_top then
		-- 				local dist = vector.distance({x=pillarx,y=pillarz,z=0}, {x=x,y=z,z=0})

		-- 				if dist < 15*pillar_variator/(2-mult) then
		-- 					local vi = area:index(x,y,z)
		-- 					data[vi] = c_hellstone
		-- 				end
		-- 			end

		-- 			-- One final check, to make sure that certain y levels always have hellstone
		-- 			-- (Looking at you, bedrock layer!)
		
		-- 			if y > worldgen.hell_top-10 and y < worldgen.hell_top then
		-- 				data[vi] = c_hellstone
		-- 			elseif y < worldgen.hell_bottom+10 and y > worldgen.hell_bottom then
		-- 				data[vi] = c_hellstone
		-- 			end
		

		-- 			nixyz = nixyz + 1
		-- 		end
		-- 	end
		-- end

		-- return data
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