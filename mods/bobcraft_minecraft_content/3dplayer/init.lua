-- Influence taken from minetest_game

player_model = {}
player_model.models = {}

function player_model.register_model(name, def) 
	player_model.models[name] = def
end

function player_model.set_model(player, modelname)
	local playername = player:get_player_name()
	local model = player_model.models[modelname]
	if model then
		player:set_properties({
			mesh = modelname,
			textures = model.textures,
			visual = "mesh",
			visual_size = {x=-1, y=1},
			collisionbox = {-0.3, 0.0, -0.3, 0.3, 1.7, 0.3},
			stepheight = 0.55,
			eye_height = 1.7,
		})
	end
end

----
-- Default stuff
----
player_model.register_model("player.b3d", {
	animation_speed = 30,
	textures = {"aeternitas.png"},
	animations = {
		stand = {
			s = 0,
			e = 10
		},
		walk = {
			s = 15,
			e = 25
		}
	}
})

minetest.register_on_joinplayer(function(player)
	player_model.set_model(player, "player.b3d")
	player:set_local_animation(
		{x = 0, y = 10}, -- Idle/stand
		{x = 15, y = 25}, -- Walk
		{x = 65, y = 70}, -- Dig
		{x = 0, y = 10}, -- WalkDig
		15 -- FPS
	)
end)