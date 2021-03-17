local function brain(self)
	mobkit.vitals(self)

	if self.hp <= 0 then
		mobkit.clear_queue_high(self)
		mobkit.hq_die(self)
		return		
	end

	if mobkit.timer(self, 1) then
		local priority = mobkit.get_queue_priority(self)

		if mobkit.is_queue_empty_high(self) then
			mobkit.hq_roam(self, 0)
		end
	end
end
local function water_brain(self)
	mobkit.vitals(self)

	if self.hp <= 0 then
		mobkit.clear_queue_high(self)
		mobkit.hq_die(self)
		return
	end

	if mobkit.timer(self, 1) then
		local priority = mobkit.get_queue_priority(self)

		if mobkit.is_queue_empty_high(self) then
			mobkit.hq_aqua_roam(self, 0, 1)
		end
	end
end

-- Pigge ;D
minetest.register_entity("bobcraft_mobs:pig", {
	physical = true,
	stepheight = 0.6,
	collide_with_objects = true,
	collisionbox = {-0.45, 0.0, -0.45, 0.45, 0.9, 0.45,},
	visual = "mesh",
	mesh = "pig.b3d",
	textures = {"pig.png"},
	static_save = true,
	makes_footstep_sound = true,
	
	-- Required Mobkit
	on_step = mobkit.stepfunc,
	on_activate = mobkit.actfunc,
	get_staticdata = mobkit.statfunc,

	springiness = 0, -- TODO: Investigate
	buoyancy = 0.75,
	max_speed = 5,
	view_range = 16,
	lung_capacity = 10,
	max_hp = 10,
	timeout = 600, -- TODO: Investigate
	sounds = {
		idle = "pig_idle",
		hurt = "mob_hit",
		die = "pig_death"
	},

	jump_height = 1,

	brainfunc = brain,

	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		if mobkit.is_alive(self) then
			local hvel = vector.multiply(vector.normalize({x=dir.x,y=0,z=dir.z}),4)
			self.object:set_velocity({x=hvel.x,y=2,z=hvel.z})
			
			mobkit.hurt(self,tool_capabilities.damage_groups.fleshy or 1)
			mobkit.make_sound(self,'hurt')

			-- abandon ship, run away!
			mobkit.clear_queue_high(self)
			mobkit.hq_runfrom(self, 10, puncher)
		end
	end,
	
	-- animations
	animation = {
		stand = {
			range = {
				x = 0,
				y = 0,
			},
			speed = 15,
			loop = true,
		},
		walk = {
			range = {
				x = 15,
				y = 25,
			},
			speed = 15,
			loop = true,
		}
	}
})
mobkit.register_spawn_egg("bobcraft_mobs:pig", "#eb9592", "#623637")

-- Pigge ;D
minetest.register_entity("bobcraft_mobs:firefish", {
	physical = true,
	stepheight = 0.6,
	collide_with_objects = true,
	collisionbox = {-0.15, 0.0, -0.15, 0.15, 0.3, 0.15,},
	visual = "mesh",
	visual_size = {x=1, y=1},
	mesh = "firefish.b3d",
	textures = {"firefish.png"},
	static_save = true,
	makes_footstep_sound = false,
	
	-- Required Mobkit
	on_step = mobkit.stepfunc,
	on_activate = mobkit.actfunc,
	get_staticdata = mobkit.statfunc,

	springiness = 0, -- TODO: Investigate
	buoyancy = 1.0,
	max_speed = 3,
	view_range = 16,
	max_hp = 10,
	timeout = 100, -- TODO: Investigate
	sounds = {
		hurt = "mob_hit",
	},

	jump_height = 0.5,

	brainfunc = water_brain,

	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		if mobkit.is_alive(self) then
			local hvel = vector.multiply(vector.normalize({x=dir.x,y=0,z=dir.z}),4)
			self.object:set_velocity({x=hvel.x,y=2,z=hvel.z})
			
			mobkit.hurt(self,tool_capabilities.damage_groups.fleshy or 1)
			mobkit.make_sound(self,'hurt')

			-- -- abandon ship, run away!
			-- mobkit.clear_queue_high(self)
			-- mobkit.hq_swimt(self, 10, puncher)
		end
	end,
	
	-- animations
	animation = {
		idle = {
			range = {
				x = 0,
				y = 20,
			},
			speed = 15,
			loop = true,
		},
		def = {
			range = {
				x = 30,
				y = 50,
			},
			speed = 15,
			loop = true,
		},
		fast = {
			range = {
				x = 60,
				y = 80,
			},
			speed = 30,
			loop = true,
		}
	}
})
mobkit.register_spawn_egg("bobcraft_mobs:firefish", "#1e1d1d", "#eca000")