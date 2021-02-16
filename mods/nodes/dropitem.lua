-- Override the default node dropping function to create an item instead


local gravity = tonumber(core.settings:get("movement_gravity"))

local item_scale = 0.25
local item_grab_radius = 0.1 -- one tenth block?
local break_flyto_time = 20 -- In MC 1.2.5 it's 10 update calls when a block breaks, we do 20

local disable_physics = function(object, luanetity)
	if luanetity.physical_state then
		luanetity.physical_state = false
		object:set_properties({physical = false})
		object:set_velocity({x=0, y=0, z=0})
		object:set_acceleration({x=0, y=0, z=0})
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
		if not self.physical_state then
			self.physical_state = true
			self.object:set_properties({physical = true})
			self.object:set_velocity({x=0, y=0, z=0})
			self.object:set_acceleration({x=0, y=-gravity, z=0})
		end
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
}

-- item magnet
minetest.register_globalstep(function(dtime)
	for i, player in ipairs(minetest.get_connected_players()) do
		local pos = player:get_pos()
		local inv = player:get_inventory()

		for j, object in ipairs(minetest.get_objects_inside_radius(pos, 16)) do
			if not object:is_player() and object:get_luaentity() and object:get_luaentity().name == "__builtin:item" then
				if object:get_luaentity().magnetting then
					disable_physics(object, object:get_luaentity())

					local old_pos = object:get_pos()
					local vec = vector.subtract(pos, old_pos)
					vec = vector.add(old_pos, vector.divide(vec, 2))
					object:move_to(vec)

					-- we also use magnetting as a rite of passage to picking up
					if vector.distance(pos, object:get_pos()) <= item_grab_radius then
						if object:get_luaentity().itemstring then
							inv:add_item("main", ItemStack(object:get_luaentity().itemstring))
							minetest.sound_play("item_pickup", {
								pos = pos,
								max_hear_distance = 5,
								gain = 1.0
							}, true)

							object:remove()
						end
					end
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