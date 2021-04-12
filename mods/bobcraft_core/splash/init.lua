-- Small mod to display a warning that bobcraft isn't finished

if minetest.settings:get("bobcraft_nag_screen") then

	minetest.register_on_joinplayer(function(player)

		local text = [[
			Thank you for downloading Bobcraft!
			Please note that Bobcraft is in active development, and has not yet reached an alpha state.
			If you find a significant bug, or indeed a bug at all, please feel free to report it on GitHub.

			You're also free to suggest features on GitHub! Bobcraft is intended to be a community effort, so any and all help is appreciated.
			If you want to contribute directly, feel free to fork the repository and create a pull request!

			You can disable this nag screen by changing the "bobcraft_nag_screen" game setting.
		]]

		minetest.show_formspec(player:get_player_name(),
		"splash:warning_splash",
		[[
			size[9,9]
			label[0,0;Here be dragons!]
		]] ..
			"textarea[0,0.5;9,8;;" .. minetest.formspec_escape(text) .. ";]" ..
			"button_exit[0,8;9,1;;OK]"
		)

	end)
	
end