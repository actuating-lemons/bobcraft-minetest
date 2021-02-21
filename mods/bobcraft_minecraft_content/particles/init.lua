bobticles = {}
bobticles.particle_spawns = {}

bobticles.presets = {
	lava = {
		amount = 1,
		time = 0,
		minsize = 3.0,
		maxsize = 4.0,
		minexptime = 2.0,
		maxexptime = 4.0,
		minpos = {x = -0.45, y = -0.45, z = -0.45},
		maxpos = {x = 0.45, y = 0.45, z = 0.45},
		minvel = { x = 0, y = 0.5, z = 0 },
		maxvel = { x = 0, y = 0.6, z = 0 },
		texture = "smoke_animated.png^[colorize:#000000:127",
		animation = {
			type = "vertical_frames",
			aspect_w = 8,
			aspect_h = 8,
			length = 2.1
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
