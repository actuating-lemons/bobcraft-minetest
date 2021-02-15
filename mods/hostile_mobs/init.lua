mobs:register_mob("bobcraft_hostilemobs:climber", {
	type = "monster",
	collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	visual = "mesh",
	mesh = "climber.b3d",
	textures = {"climber.png"},
	visual_size = {x=1, y=1},
	makes_footstep_sound = true,
	view_range = 15,
	walk_velocity = 1,
	run_velocity = 2,
	-- armor seems to be health
	armor = 100,
	drawtype = "front",
	water_damage = 1,
	lava_damage = 5,
	light_damage = 0,
	on_rightclick = nil, -- TODO: breeding, riding, etc.

	-- sounds = {
	-- 	idle = {name = "pig_idle", gain = 0.2},
	-- 	die = {name = "pig_death", gain = 0.2},
	-- 	damage = {name = "pig_hurt", gain = 0.2}
	-- },

	animation = {
		speed_normal = 15,
		stand_start = 0,
		stand_end = 10, -- 10 dummy frames incase I wanna add anything
		walk_start = 15,
		walk_end = 25,
	},

	attack_type = "dogfight",
})