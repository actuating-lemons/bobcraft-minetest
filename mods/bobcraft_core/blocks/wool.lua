local S = minetest.get_translator("bobcraft_blocks")

minetest.register_node("bobcraft_blocks:wool", {
	description = "White Wool",
	tiles = {"wool_white.png"},


	paramtype2 = "color",
	palette = "dyepalette.png",
	param2 = 255, -- NOTE: we assume the last colour to be "undyed"

	sounds = bobcraft_sounds.node_sound_wool(),
	groups = {shears=1, hand=1, crafting_wool=1},
	hardness = 0.8,

	on_place = function(itemstack, placer, pointed_thing)		
		local meta = itemstack:get_meta()
		local index = meta:get_int("palette_index")

		return minetest.item_place_node(itemstack, placer, pointed_thing, index)
	end
})

-- Compatability, dying is handled by 256_dyes
for _, color in ipairs(dyes.colour_names) do
	minetest.register_alias("bobcraft_blocks:wool_"..color, "bobcraft_blocks:wool")
	-- TODO: Possibly convert to closest default dyepalette?
end