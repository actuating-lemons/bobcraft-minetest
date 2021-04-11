local modpath = minetest.get_modpath(minetest.get_current_modname())

local function set_color(meta, color)
	meta:set_int("palette_index", color)
	meta:set_string("description", "Dye (color #" .. color .. ")")
end

local function change_variation(itemstack)
	local meta = itemstack:get_meta()
	local color = meta:get_int("palette_index")
	local variation
	local new_color
	if color >= 240 then
		if color == 255 then
			new_color = 240
		else
			new_color = color + 1
		end
	else
		variation = color % 10
		local hue = color - variation
		new_color = (variation+1) % 10 + hue
	end
	set_color(meta, new_color)
	return itemstack
end

local function change_hue(itemstack)
	local meta = itemstack:get_meta()
	local color = meta:get_int("palette_index")
	local new_color = color + 10
	if color >= 230 then
		if color == 255 then
			new_color = 0
		else
			new_color = math.max(color + 1, 240)
		end
	end
	set_color(meta, new_color)
	return itemstack
end

minetest.register_craftitem("256_dyes:dye", {
	description = "Dye",
	groups = {},
	inventory_image = "dye_white.png",
	wield_image = "dye_white.png",
	palette = "DYE.png",
	stack_max = 99,
	color = "#400000",
	on_use = change_variation,
	on_place = change_hue,
	on_secondary_use = change_hue,
})

local file = io.open(modpath .. "/colors.dat", "r")
local raw_colors = minetest.decompress(file:read("*all"))
file:close()

local colors = {}
for i=0, 255 do
	local pos = i * 3
	raw_color = raw_colors:sub(pos+1, pos+3)
	color = {raw_color:byte(1, 3)}
	colors[i] = color
end

local function mix(...)
	local list = {...}
	local n = #list
	local sum_c = 0
	local sum_m = 0
	local sum_y = 0
	for _, i in ipairs(list) do
		r, g, b = unpack(colors[i])
		local c, m, y = 255-r, 255-g, 255-b
		sum_c = sum_c + c^2
		sum_m = sum_m + m^2
		sum_y = sum_y + y^2
	end
	local true_color = {math.sqrt(sum_c/n), math.sqrt(sum_m/n), math.sqrt(sum_y/n)} -- I found that calculating the quadratic mean of CMY colors gives more realistic mixes because it makes the mix more sensitive to dark colors

	local min_diff = 765
	local nearest = 0

	for i=0, 255 do
		local color = colors[i]
		local c, m, y = 255-color[1], 255-color[2], 255-color[3]
		local diff = math.abs(c - true_color[1]) + math.abs(m - true_color[2]) + math.abs(y - true_color[3])
		if diff < min_diff then
			min_diff = diff
			nearest = i
		end
	end
	return nearest
end

for i=1, 9 do
	recipe = {}
	for j=1, i do
		table.insert(recipe, "256_dyes:dye")
	end

	minetest.register_craft({
		type = "shapeless",
		output = "256_dyes:dye",
		recipe = recipe,
	})
end

local function dye_craft(itemstack, player, old_craft_grid, craft_inv)
	if itemstack:get_name() ~= "256_dyes:dye" then
		return
	end
	local list_colors = {}
	for _, stack in ipairs(old_craft_grid) do
		if not stack:is_empty() then
			if stack:get_name() == "256_dyes:dye" then
				local meta = stack:get_meta()
				table.insert(list_colors, meta:get_int("palette_index"))
			else
				return
			end
		end
	end
	if #list_colors == 0 then
		return
	end
	itemstack = ItemStack("256_dyes:dye " .. #list_colors)
	local new_color = mix(unpack(list_colors))
	local meta = itemstack:get_meta()
	set_color(meta, new_color)
	return itemstack
end

minetest.register_craft_predict(dye_craft)
minetest.register_on_craft(dye_craft)
