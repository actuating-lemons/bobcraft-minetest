bobticles = {}
bobticles.particle_spawns = {}

bobticles.presets = {
	lava = {
		amount = 0.01,
		time = 0,
		minsize = 3.0,
		maxsize = 4.0,
		minexptime = 1.0,
		maxexptime = 2.5,
		minpos = {x = -0.45, y = -0.45, z = -0.45},
		maxpos = {x = 0.45, y = 0.45, z = 0.45},
		minvel = { x = 0, y = 0.5, z = 0 },
		maxvel = { x = 0, y = 0.6, z = 0 },
		texture = "smoke_animated.png^[colorize:#000000:200",
		animation = {
			type = "vertical_frames",
			aspect_w = 8,
			aspect_h = 8,
			length = 1.5
		}
	},
	-- the torch_* particles would look nicer if we could tell particles to shrink over time.
	torch_floor = {
		amount = 2,
		time = 0,
		minsize = 2.0,
		maxsize = 4.0,
		minexptime = 1,
		maxexptime = 1.2,
		minpos = {x = 0, y = 0.15, z = 0},
		maxpos = {x = 0, y = 0.15, z = 0},
		minvel = { x = 0, y = 0, z = 0 },
		maxvel = { x = 0, y = 0, z = 0 },
		texture = "flame_a.png",
		glow = 14
	},
	torch_floor_smoke = {
		amount = 2,
		time = 0,
		minsize = 0.5,
		maxsize = 2.0,
		minexptime = 0.5,
		maxexptime = 1,
		minpos = {x = 0, y = 0.15, z = 0},
		maxpos = {x = 0, y = 0.15, z = 0},
		minvel = { x = -0.1, y = 0.2, z = -0.1 },
		maxvel = { x = 0.1, y = 0.2, z = 0.1 },
		texture = "smoke_animated.png^[colorize:#000000:255",
		animation = {
			type = "vertical_frames",
			aspect_w = 8,
			aspect_h = 8,
			length = 1.5
		}
	},
	-- Same as their _floor brethren, but do it for the wall.
	-- TODO: Their positions will be relative to their wall rotation, how the hell do we do that?
	torch_wall = {
		amount = 2,
		time = 0,
		minsize = 2.0,
		maxsize = 4.0,
		minexptime = 1,
		maxexptime = 1.2,
		minpos = {x = 0, y = 0.15, z = 0},
		maxpos = {x = 0, y = 0.15, z = 0},
		minvel = { x = 0, y = 0, z = 0 },
		maxvel = { x = 0, y = 0, z = 0 },
		texture = "flame_a.png",
		glow = 14
	},
	torch_wall_smoke = {
		amount = 2,
		time = 0,
		minsize = 0.5,
		maxsize = 2.0,
		minexptime = 0.5,
		maxexptime = 1,
		minpos = {x = 0, y = 0.15, z = 0},
		maxpos = {x = 0, y = 0.15, z = 0},
		minvel = { x = -0.1, y = 0.2, z = -0.1 },
		maxvel = { x = 0.1, y = 0.2, z = 0.1 },
		texture = "smoke_animated.png^[colorize:#000000:255",
		animation = {
			type = "vertical_frames",
			aspect_w = 8,
			aspect_h = 8,
			length = 1.5
		}
	}
}

bobticles.register_node_particle_spawn = function(pos, particledef)
	local poshash = minetest.hash_node_position(pos)
	if not poshash then
		return
	end

	local minpos = particledef.minpos or {x=0,y=0,z=0}
	local maxpos = particledef.maxpos or {x=0,y=0,z=0}

	particledef.minpos = vector.add(pos, minpos)
	particledef.maxpos = vector.add(pos, maxpos)

	local particle_id = minetest.add_particlespawner(particledef)
	if particle_id == -1 then
		return
	end

	if not bobticles.particle_spawns[poshash] then
		bobticles.particle_spawns[poshash] = {}
	end

	table.insert(bobticles.particle_spawns[poshash], particle_id)
	return particle_id
end

bobticles.clear_node_particle_spawn = function(pos)
	local poshash = minetest.hash_node_position(pos)
	local ids = bobticles.particle_spawns[poshash]

	if ids then
		for i=1, #ids do
			minetest.delete_particlespawner(ids[i])
		end
		bobticles.particle_spawns[poshash] = nil
	end
end

function bobticles.get_preset(presetname)
	return table.copy(bobticles.presets[presetname])
end