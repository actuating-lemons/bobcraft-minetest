local function brain_violent(self)
	mobkit.vitals(self)

	if self.hp <= 0 then
		mobkit.clear_queue_high(self)
		mobkit.hq_die(self)
		return		
	end

	if mobkit.timer(self, 1) then
		local priority = mobkit.get_queue_priority(self)

		if priority < 10 then
			local prey = mobkit.get_nearby_player(self)
			if prey then
				mobkit.hq_hunt(self, 10, prey)
			end
		end

		if mobkit.is_queue_empty_high(self) then
			mobkit.hq_roam(self, 0)
		end
	end
end

minetest.register_entity("bobcraft_mobs:zombie", {
	physical = true,
	stepheight = 0.6,
	collide_with_objects = true,
	collisionbox = {-0.3, 0.0, -0.3, 0.3, 2, 0.3},
	visual = "mesh",
	mesh = "zombie.b3d",
	textures = {"zombie.png"},
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
	max_hp = 8,
	timeout = 600, -- TODO: Investigate
	sounds = {
		idle = "zombie_idle",
		hurt = "zombie_hurt",
		die = "zombie_die",
		attack = "zombie_attack",
	},

	jump_height = 1,

	brainfunc = brain_violent,

	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		if mobkit.is_alive(self) then
			local hvel = vector.multiply(vector.normalize({x=dir.x,y=0,z=dir.z}),4)
			self.object:set_velocity({x=hvel.x,y=2,z=hvel.z})
			
			mobkit.hurt(self,tool_capabilities.damage_groups.fleshy or 1)
			mobkit.make_sound(self,'hurt')
		end
	end,

	attack={range=0.5,damage_groups={fleshy=7}},
	
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
		},
		attack = {
			range = {
				x = 34,
				y = 40,
			},
			speed = 15,
			loop = true,
		}
	}
})