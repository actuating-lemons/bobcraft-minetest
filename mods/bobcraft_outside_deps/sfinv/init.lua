-- sfinv/init.lua

dofile(minetest.get_modpath("sfinv") .. "/api.lua")

-- Load support for MT game translation.
local S = minetest.get_translator("sfinv")

sfinv.register_page("sfinv:crafting", {
	title = S("Crafting"),
	get = function(self, player, context)
		return sfinv.make_formspec(player, context, [[
				image[0.5,0.2;1.5,3;player.png]
				list[current_player;craft;4,0.5;2,2;]
				list[current_player;craftpreview;7,1;1,1;]
				image[6,1;1,1;arrow_fg.png^[transformR270]
			]], true)
	end
})
