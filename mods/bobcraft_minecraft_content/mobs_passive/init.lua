mobs:register_mob("bobcraft_passivemobs:pig", {
	type = "animal",
	collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	visual = "mesh",
	mesh = "pig.b3d",
	textures = {"pig.png"},
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

	drops = "bobcraft_items:porkchop",

	sounds = {
		idle = {name = "pig_idle", gain = 0.2},
		die = {name = "pig_death", gain = 0.2},
		damage = {name = "pig_hurt", gain = 0.2}
	},

	animation = {
		speed_normal = 15,
		stand_start = 0,
		stand_end = 10, -- 10 dummy frames incase I wanna add anything
		walk_start = 15,
		walk_end = 25,
	}
})

mobs:register_spawn("bobcraft_passivemobs:pig", {"bobcraft_blocks:grass_block"}, 15, 7.5, 25, 5, worldgen.overworld_top)

mobs:register_mob("bobcraft_passivemobs:cow", {
	type = "animal",
	collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	visual = "mesh",
	mesh = "cow.b3d",
	textures = {"cow.png"},
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
	on_rightclick = nil, -- TODO: breeding, etc.

	sounds = {
		idle = {name = "cow_idle", gain = 0.2},
		die = {name = "cow_death", gain = 0.2},
		damage = {name = "cow_hurt", gain = 0.2}
	},

	animation = {
		speed_normal = 15,
		stand_start = 0,
		stand_end = 10, -- 10 dummy frames incase I wanna add anything
		walk_start = 15,
		walk_end = 25,
	}
})

mobs:register_spawn("bobcraft_passivemobs:cow", {"bobcraft_blocks:grass_block"}, 15, 7.5, 25, 5, worldgen.overworld_top)

mobs:register_mob("bobcraft_passivemobs:sheep", {
	type = "animal",
	collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	visual = "mesh",
	mesh = "sheep.b3d",
	textures = {"sheep.png"},
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
	on_rightclick = nil, -- TODO: breeding, etc.

	drops = "bobcraft_blocks:wool",

	animation = {
		speed_normal = 15,
		stand_start = 0,
		stand_end = 10, -- 10 dummy frames incase I wanna add anything
		walk_start = 15,
		walk_end = 25,
	}
})

mobs:register_spawn("bobcraft_passivemobs:cow", {"bobcraft_blocks:grass_block"}, 15, 7.5, 25, 5, worldgen.overworld_top)