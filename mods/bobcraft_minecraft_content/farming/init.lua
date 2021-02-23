-- I decided to split this off because it's easiest that way.
-- We grow with timers, although we may change to ABM depending on what's less resource intensive/more accurate

local function tick_plant(pos)
	-- minetest.get_node_timer(pos):start(math.random(67,69)) -- 67 -> 69 seconds
	minetest.get_node_timer(pos):start(math.random(1,2)) -- for debugging, 1-2 seconds
end

local function plant_grow(pos, time)
	local plant = minetest.get_node(pos)
	local plantname = plant.name
	local plantdef = minetest.registered_nodes[plantname]
	
	if not plantdef.farming.next_plant then
		return -- we're fully grown
	end

	local lightlevel = minetest.get_node_light(pos)

	if lightlevel < 9 then
		tick_plant(pos)
		return -- can't grow below 9
	end

	-- Ok, right.
	-- https://minecraft.gamepedia.com/Tutorials/Crop_farming#Growth_rate
	-- Jesus. Christ.

	local below_us = table.copy(pos)
	below_us.y = pos.y-1

	local planted_on = minetest.get_node(below_us)

	local points = 1

	-- "The farmland block the crop is planted on gives 2 points if dry or 4 if hydrated."
	if minetest.get_item_group(planted_on.name, "farm_plantable") < 2 then
		points = points + 2
	else
		points = points + 4
	end

	-- "For each of the 8 blocks around the block on which the crop is planted, dry farmland gives 0.25 points, and hydrated farmland gives 0.75."
	local blocks_around = minetest.find_nodes_in_area({x=pos.x-1, y=pos.y-1, z=pos.z-1}, {x=pos.x+1, y=pos.y-1, z=pos.z}, "group:farm_plantable")

	for i=1, #blocks_around do
		if blocks_around[i] ~= below_us then -- don't count what we're planted on
			local blockpos = blocks_around[i]
			local block = minetest.get_node(blockpos)
			if block ~= nil then
				local blockname = block.name
				local farmquality = minetest.get_item_group(blockname, "farm_plantable")

				if farmquality == 1 then
					points = points + 0.25 -- dry
				elseif farmquality == 2 then
					points = points + 0.75 -- wet
				end
			end
		end
	end

	-- "having the same sort of plant either on a diagonal or in both north-south and east-west directions cuts the growth chance, 
	-- but having the same type of plant only north-south or east-west does not. The growth chance is only halved once no matter 
	-- how many plants surround the central one."
	-- I assume this to mean
	-- N/S && W/E will slow our growth
	--  |
	-- -@-
	--  |
	-- As will any diagonal, but
	-- \
	--  @
	--   \
	-- N/S or W/E on their own won't
	--  |
	--  @ -@-
	--  |

	local neighbours = {}
	local line = false

	for dx = -1, 1 do
		local d = {x=pos.x + dx, y=pos.y, z=pos.z}
		local node_there = minetest.get_node(d)
		local node_def = minetest.registered_nodes[node_there.name]
		if node_def and node_def.farming and node_def.farming.base_name == plantdef.base_name then
			table.insert(neighbours, d)
		end
	end

	if #neighbours == 3 then
		line = true
	end

	neighbours = {}

	for dz = -1, 1 do
		local d = {x=pos.x, y=pos.y, z=pos.z+dz}
		local node_there = minetest.get_node(d)
		local node_def = minetest.registered_nodes[node_there.name]
		if node_def and node_def.farming and node_def.farming.base_name == plantdef.base_name then
			table.insert(neighbours, d)
		end
	end

	-- TODO: DIAGONALS

	if #neighbours == 3 and line then
		points = points / 2
	end


	-- "The growth probability is 1/(floor(25/points) + 1)"
	-- We multiply it by 10 because math.random operates on integers
	-- I've probably mi-understood this last bit.
	local probability = ((math.floor(25 / points) + 1)) * 10
	local grow = math.random(0, probability)

	if grow == 0 then
		bobutil.replace_node(pos, plantdef.farming.next_plant)
	end

	-- must we continue to grow?
	if minetest.registered_nodes[plantdef.farming.next_plant].farming.next_plant then
		tick_plant(pos)
	end
	return
end

local function register_farm_plant(name, def)
	def.groups = def.groups or {}
	def.groups.farm_plant = 1

	minetest.register_craftitem(name .. "_seeds", {
		description = def.description,
		inventory_image = def.inventory_image,

		on_place = function(itemstack, placer, pointed_thing)
			if not pointed_thing.type == "node" then
				return itemstack
			end

			local pt = pointed_thing.above
			if
				not minetest.registered_nodes[minetest.get_node(pt).name].buildable_to or
				not minetest.get_item_group(minetest.get_node(pt).name, "farm_plantable") == 1 or
				not placer or
				not placer:is_player()
			then
				return itemstack
			end

			minetest.set_node(pt, {name = name.."_plant_1", param2 = 0})
			tick_plant(pt)

			if not minetest.setting_getbool("creative_mode") then
				itemstack:take_item()
			end
			return itemstack
		end
	})
	for i = 1, def.stages do
		minetest.register_node(name .. "_plant_" .. tostring(i), {
			description = def.description,
			tiles = {def.tiles[i]},
			drawtype = "plantlike",

			paramtype = "light",

			groups = def.groups,
			hardness = def.hardness,
			walkable = def.walkable,

			on_timer = plant_grow,

			farming = {
				next_plant = i+1<def.stages and (name .. "_plant_" .. tostring(i+1)),
				base_name = name,
			},
		})
	end
end

register_farm_plant("bobcraft_farming:wheat", {
	description = "Wheat",
	inventory_image = "seeds.png",
	groups = {hand=1, wheat=1},
	hardness = 0,
	walkable = false,

	tiles = {"wheat_plant_0.png","wheat_plant_1.png",
	"wheat_plant_2.png","wheat_plant_3.png",
	"wheat_plant_4.png","wheat_plant_5.png",
	"wheat_plant_6.png",},

	stages = 8, -- 8 stages, like mc
})