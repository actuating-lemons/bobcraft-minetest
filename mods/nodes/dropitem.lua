-- Override the default node dropping function to create an item instead


local gravity = tonumber(core.settings:get("movement_gravity"))

local item_scale = 0.25
local item_grab_radius = 0.1 -- one tenth block?
local item_flyto_radius = 2 -- two blocks?
local break_flyto_time = 20 -- In MC 1.2.5 it's 10 update calls when a block breaks, we do 20
local drop_flyto_time = 80 -- In MC 1.2.5, it's 40 update calls. We do 80.

local disable_physics = function(object, luaentity)
	if luaentity.physical_state then
		luaentity.physical_state = false
		object:set_properties({physical = true})
		object:set_velocity({x=0, y=0, z=0})
		object:set_acceleration({x=0, y=0, z=0})
	end
end

local enable_physics = function(object, luaentity)
	if not luaentity.physical_state then
		luaentity.physical_state = true
		object:set_properties({physical = true})
		object:set_velocity({x=0, y=0, z=0})
		object:set_acceleration({x=0, y=-gravity, z=0})
	end
end

-- register the item entity
local item_entity = { -- reference https://rubenwardy.com/minetest_modding_book/en/map/objects.html & builtin item, + some mineclone 2
	initial_properties = {
		hp_max = 1,
		physical = true,
		collide_with_objects = false,
		collisionbox = {-item_scale, -item_scale, -item_scale, item_scale, item_scale, item_scale},
		visual = "wielditem",
		visual_size = {x = item_scale, y = item_scale},
		textures = {""},
		is_visible = false,
	},
	itemstring = "",
	moving_state = true,
	physical_state = true,
	
	magnetting = false,
	magnettime = 0,

	set_item = function(self, item)
		local stack = ItemStack(item or self.itemstring)
		self.itemstring = stack:to_string()
		if self.itemstring == "" then return end

		local name = stack:is_known() and stack:get_name() or "unknown"

		self.object:set_properties({
			is_visible = true,
			visual = "wielditem",
			textures = {name},
			visual_size = {x = item_scale, y = item_scale},
			collisionbox = {-item_scale, -item_scale, -item_scale, item_scale, item_scale, item_scale},
			automatic_rotate = math.pi * 0.5,
			wield_item = self.itemstring,
			glow = 0
		})
	end,

	get_staticdata = function(self)
		return core.serialize({
			itemstring = self.itemstring,
			age = self.age,
			dropped_by = self.dropped_by
		})
	end,

	enable_physics = function(self)
		enable_physics(self.object, self)
	end,

	disable_physics = function(self)
		disable_physics(self.object, self)
	end,


	on_activate = function(self, staticdata, dtime_s) -- WHATWHATWHAT: COPIED DIRECTLY FROM __BUILTIN, WHAT IS OUR LEGAL STANDING THERE?
		if string.sub(staticdata, 1, string.len("return")) == "return" then
			local data = core.deserialize(staticdata)
			if data and type(data) == "table" then
				self.itemstring = data.itemstring
				self.age = (data.age or 0) + dtime_s
				self.dropped_by = data.dropped_by
			end
		else
			self.itemstring = staticdata
		end
		self.object:set_armor_groups({immortal = 1})
		self.object:set_velocity({x = 0, y = 2, z = 0})
		self.object:set_acceleration({x = 0, y = -(gravity or 9.81), z = 0})
		self:set_item()
	end,

	on_step = function(self, dtime, moveresult)
		local our_pos = self.object:get_pos()
		
		local node = nil
		if moveresult.touching_ground then
			for i, info in ipairs(moveresult.collisions) do
				if info.axis == "y" then
					node = minetest.get_node(info.node_pos)
					break
				end
			end
		end

		local def = node and minetest.registered_nodes[node.name]
		local dont_stop = false
		if def then
			local slippy = minetest.get_item_group(node.name, "slippery")
			local vel = self.object:get_velocity()
			if slippy ~= 0 and (math.abs(vel.x) > 0.1 or math.abs(vel.z) > 0.1) then
				local factor = math.min(4 / (slippery + 4) * dtime, 1)
				self.object:set_velocity({
					x = vel.x * (1 - factor),
					y = 0,
					z = vel.z * (1 - factor)
				})
				dont_stop = true
			end

			if not dont_stop then -- we've also probably landed
				self.disable_physics(self)
			end
		end

	end
}

-- item magnet
minetest.register_globalstep(function(dtime)
	for i, player in ipairs(minetest.get_connected_players()) do
		local pos = player:get_pos()
		local inv = player:get_inventory()

		for j, object in ipairs(minetest.get_objects_inside_radius(pos, 16)) do
			if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
				if object:get_luaentity().magnetting and vector.distance(pos, object:get_pos()) <= item_flyto_radius and
					inv:room_for_item("main", ItemStack(object:get_luaentity().itemstring)) then -- we pretend to not be in the radius if the player doesn't have space
				disable_physics(object, object:get_luaentity())

				local old_pos = object:get_pos()
				local vec = vector.subtract(pos, old_pos)
				vec = vector.add(old_pos, vector.divide(vec, 2))
				object:move_to(vec)

				-- we also use magnetting as a rite of passage to picking up
				if vector.distance(pos, object:get_pos()) <= item_grab_radius then
					if object:get_luaentity().itemstring then
						local left_itemstack = inv:add_item("main", ItemStack(object:get_luaentity().itemstring))
						if left_itemstack and left_itemstack:get_count() == 0 then
							minetest.sound_play("item_pickup", {
								pos = pos,
								max_hear_distance = 5,
								gain = 1.0
							}, true)

							object:remove()
						end
					end
				end
				elseif object:get_luaentity().magnetting then
					-- we're magnetting, but  we're not in the magnet radius
					enable_physics(object, object:get_luaentity())
				elseif object:get_luaentity().magnettime <= 0 then
					object:get_luaentity().magnetting = true
				else
					object:get_luaentity().magnettime = object:get_luaentity().magnettime - 1
				end
			end
		end
	end
end)

-- register entity
minetest.register_entity(":__builtin:item", item_entity)

-- register the function
function minetest.handle_node_drops(pos, drops, digger)
	if digger and digger:is_player() and minetest.is_creative_enabled(digger:get_player_name() or "") then
		return -- don't do it for creative players
	end
	for i, drop in ipairs(drops) do
		local item_drop = ItemStack(drop)
		local item_count = item_drop:get_count()
		item_drop:set_count(1)
		for j=1, item_count do
			local dropped_item = minetest.add_item(table.copy(pos), item_drop)
			if dropped_item then
				dropped_item:get_luaentity().magnettime = break_flyto_time
			end
		end 
	end
end

-- for player dropping
function minetest.item_drop(itemstack, dropper, pos)
	if dropper and dropper:is_player() then
		
		local dir = dropper:get_look_dir()
		local position = {x=pos.x, y=pos.y+1.2, z=pos.z}
		local count = 1 -- TODO: stack dropping
		local item = itemstack:take_item(count)
		local obj = minetest.add_item(position, item)
		if obj then
			dir.x = dir.x*4
			dir.y = dir.y*4 + 2
			dir.z = dir.z*4
			obj:set_velocity(dir)
			obj:get_luaentity().magnettime = drop_flyto_time
			return itemstack
		end
	end
end