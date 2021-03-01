-- Minetest doesn't really have that much versatility in its' biome system.
-- Because of this, we have to do it ourselves!
-- This file both registers biomes AND sets the biome api up.

worldgen.registered_biomes = {}
worldgen.named_biomes = {} -- TODO: Better name, as this just stores a biome name -> biome def table

function worldgen.register_biome(def)
	-- Default values
	-- Pretty much just minecraft's plains biome, it is *plain* after-all! *badum-tss*
	def.top = def.top or "bobcraft_blocks:grass_block"
	def.middle = def.middle or "bobcraft_blocks:dirt"
	def.bottom = def.bottom or "bobcraft_blocks:stone"

	def.liquid = def.liquid or "bobcraft_blocks:water_source"

	def.palette_index = def.palette_index or bobutil.foliage_palette_indices.plains

	def.temperature = def.temperature or 0.8
	def.rainfall = def.rainfall or 0.4

	-- Values will be clamped to n% of the surface height
	def.min_height_mult = def.min_height_mult or 0.1
	def.max_height_mult = def.max_height_mult or 0.3

	-- Translate values into IDs
	def.top = minetest.get_content_id(def.top)
	def.middle = minetest.get_content_id(def.middle)
	def.bottom = minetest.get_content_id(def.bottom)
	def.liquid = minetest.get_content_id(def.liquid)

	table.insert(worldgen.registered_biomes, def)
	worldgen.named_biomes[def.name] = def
end

-- Returns the biome that is closest to the temperature and rainfall values
-- SO https://stackoverflow.com/questions/29987249/find-the-nearest-value
-- FIXME: Currently only cares about temperature, MC Cares about rainfall too!
function worldgen.get_biome_nearest(temperature, rainfall)
	local smallest_so_far
	local key = -1
	for biomeid, def in ipairs(worldgen.registered_biomes) do
		if not smallest_so_far or (math.abs(temperature - def.temperature) < smallest_so_far) then
			smallest_so_far = math.abs(temperature - def.temperature)
			key = biomeid
		end
	end

	return worldgen.registered_biomes[key]
end

-- API out of the way, register biomes
worldgen.register_biome({
	name = "plains"
})
worldgen.register_biome({
	name = "desert",
	temperature = 2.0,

	top = "bobcraft_blocks:sand",
	middle = "bobcraft_blocks:sand",
	bottom = "bobcraft_blocks:sandstone",

	min_height_mult = 0.1,
	max_height_mult = 0.2,
})