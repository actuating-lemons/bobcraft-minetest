bobutil = {}

bobutil.titleize = function(str)
	str = str:gsub("_", " ")
	return str:gsub("^%l", string.upper)
end

-- Arguabely this falls under the jurisdiction of an inside dependency, but you can fight me on that.
bobutil.foliage_palette = "foliage_palette.png"
bobutil.foliage_palette_indices = {
	-- Unique
	plains = 0,
	desert = 1,
	swamp = 2,
	forest = 3,
	extreme_hills = 4,
	ocean = 5,

	-- Duplicates
}

bobutil.get_new_biome_coloured_block = function(pos, block)
	local biome_data = minetest.get_biome_data(pos)
	local palette_index = 0
	if biome_data then
		local biome_name = minetest.get_biome_name(biome_data.biome)
		local biome_def = minetest.registered_biomes[biome_name]
		if biome_def then
			palette_index = biome_def._palette_index
		end
	end

	return {name = block.name, param2 = palette_index}
end