bobcraft_sounds = {}

function bobcraft_sounds.node_sound_default(table)
	table = table or {}

	table.footstep = table.footstep or {name = "step_default", gain=0.2}
	table.dig = table.dig or {name = "dig_default", gain = 0.2}
	table.dug = table.dug or {name = "break_default", gain = 0.3}
	table.place = table.place or {name = "place_default", gain = 1.0}

	return table
end


function bobcraft_sounds.node_sound_stone(table)
	table = table or {}
	return bobcraft_sounds.node_sound_default(table)
end

function bobcraft_sounds.node_sound_wood(table)
	table = table or {}
	table.footstep = table.footstep or {name = "step_wood", gain = 0.2}
	table.dig = table.dig or {name = "dig_wood", gain = 0.3}
	table.dug = table.dug or {name = "break_wood", gain = 0.3}
	table.place = table.place or {name = "place_wood", gain = 1.0}
	return bobcraft_sounds.node_sound_default(table)
end

function bobcraft_sounds.node_sound_metal(table)
	table = table or {}
	table.footstep = table.footstep or {name = "step_metal", gain = 0.2}
	table.dig = table.dig or {name = "dig_metal", gain = 0.3}
	table.dug = table.dug or {name = "break_metal", gain = 0.3}
	table.place = table.place or {name = "place_metal", gain = 1.0}
	return bobcraft_sounds.node_sound_default(table)
end


function bobcraft_sounds.node_sound_earthy(table)
	table = table or {}
	table.footstep = table.footstep or {name = "step_dirt", gain = 0.2}
	table.dig = table.dig or {name = "dig_dirt", gain = 0.3}
	table.dug = table.dug or {name = "break_dirt", gain = 0.3}
	table.place = table.place or {name = "place_dirt", gain = 1.0}
	return bobcraft_sounds.node_sound_default(table)
end

function bobcraft_sounds.node_sound_planty(table)
	table = table or {}
	table.footstep = table.footstep or {name = "step_grass", gain = 0.2}
	table.dig = table.dig or {name = "dig_plant", gain = 0.3}
	table.dug = table.dug or {name = "break_plant", gain = 0.3}
	return bobcraft_sounds.node_sound_default(table)
end


function bobcraft_sounds.node_sound_glass(table)
	table = table or {}
	table.footstep = table.footstep or {name = "step_glass", gain = 0.2}
	table.dug = table.dug or {name = "break_glass", gain = 0.3}
	return bobcraft_sounds.node_sound_default(table)
end

function bobcraft_sounds.node_sound_water(table)
	table = table or {}
	--table.footstep = table.footstep or {name = "splash_water", gain = 0.2}
	table.footstep = "" -- Unfortunately this is a swimming sound
	-- TODO: any way to have seperate water sounds? maybe some splashin'?
	return bobcraft_sounds.node_sound_default(table)
end

function bobcraft_sounds.node_sound_lava(table)
	table = table or {}
	return bobcraft_sounds.node_sound_default(table)
end

function bobcraft_sounds.node_sound_sand(table)
	table = table or {}
	table.footstep = table.footstep or {name = "step_sand", gain = 0.2}
	table.dig = table.dig or {name = "dig_loose", gain = 0.3}
	table.dug = table.dug or {name = "break_sand", gain = 0.3}
	table.place = table.place or {name = "place_sand", gain = 1.0}
	return bobcraft_sounds.node_sound_default(table)
end

function bobcraft_sounds.node_sound_sandstone(table)
	table = table or {}
	table.footstep = table.footstep or {name = "step_sandstone", gain = 0.2}
	table.dug = table.dug or {name = "break_sand", gain = 0.3}
	return bobcraft_sounds.node_sound_default(table)
end

function bobcraft_sounds.node_sound_gravel(table)
	table = table or {}
	table.footstep = table.footstep or {name = "step_gravel", gain = 0.2}
	table.dig = table.dig or {name = "dig_loose", gain = 0.3}
	return bobcraft_sounds.node_sound_default(table)
end

-- TODO: snow sounds
function bobcraft_sounds.node_sound_snow(table)
	table = table or {}
	return bobcraft_sounds.node_sound_default(table)
end

-- TODO: wool sounds
function bobcraft_sounds.node_sound_wool(table)
	table = table or {}
	return bobcraft_sounds.node_sound_default(table)
end

-- Death sounds
minetest.register_on_dieplayer(function(player, reason)
	minetest.sound_play({name="player_death", gain=0.5, pos=player:get_pos()})
end)