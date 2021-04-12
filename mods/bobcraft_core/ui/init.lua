minetest.register_on_joinplayer(function(player)
	player:set_formspec_prepend(
	-- background
	"background9[1,1;1,1;formspec_bg.png;true;7]" ..
	"listcolors[#0000;#fff4;#000f;#000f;#ffff]" ..
	-- Buttons
	"style_type[button;textcolor=#000000;border=false;bgimg=formspec_button_bg.png;bgimg_pressed=formspec_button_bg_pressed.png;bgimg_hovered=formspec_button_bg_hover.png;bgimg_middle=5,5]" ..
	-- Text
	"style_type[field;textcolor=#000000]" ..
	"style_type[label;textcolor=#000000]" ..
	"style_type[textarea;textcolor=#000000]" ..
	"style_type[checkbox;textcolor=#000000]"
	)
	player:hud_set_hotbar_image("hotbar_bg.png")
	player:hud_set_hotbar_selected_image("hotbar_fg.png")
	player:hud_set_hotbar_itemcount(9) -- NOTE: we set the hotbar item count here
end)