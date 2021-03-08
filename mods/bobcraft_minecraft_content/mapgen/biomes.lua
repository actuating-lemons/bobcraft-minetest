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
	def.above = def.above or "air"

	def.liquid = def.liquid or "bobcraft_blocks:water_source"
	def.liquid_top = def.liquid_top or def.liquid

	def.palette_index = def.palette_index or bobutil.foliage_palette_indices.plains

	def.temperature = def.temperature or 0.8
	def.rainfall = def.rainfall or 0.4

	-- Values that we accept, but have no default value;
	-- H/S/V Sky Overriders
	-- def.h_override
	-- def.s_override
	-- def.v_override
	-- def.sky_force_underground -- If true, will force the sky to be the color, even indoors.

	-- How extreme the generated height variation is
	def.y_effector = def.y_effector or 1

	-- Translate values into IDs
	def.top = minetest.get_content_id(def.top)
	def.middle = minetest.get_content_id(def.middle)
	def.bottom = minetest.get_content_id(def.bottom)
	def.liquid = minetest.get_content_id(def.liquid)
	def.liquid_top = minetest.get_content_id(def.liquid_top)
	def.above = minetest.get_content_id(def.above)

	table.insert(worldgen.registered_biomes, def)
	worldgen.named_biomes[def.name] = def
end

-- I am a lazy typer.
-- Equivalent to worldgen.registered_biomes[name]
function worldgen.biome(name)
	return worldgen.named_biomes[name]
end

-- Returns the biome that is closest to the temperature and rainfall values
-- SO https://stackoverflow.com/questions/29987249/find-the-nearest-value
-- FIXME: Currently only cares about temperature, MC Cares about rainfall too!
function worldgen.get_biome_nearest(temperature, rainfall, biome_list)
	biome_list = biome_list or worldgen.registered_biomes

	local smallest_so_far
	local key = -1
	for biomeid, def in ipairs(biome_list) do
		if not smallest_so_far or (math.abs(temperature - def.temperature) < smallest_so_far) then
			smallest_so_far = math.abs(temperature - def.temperature)
			key = biomeid
		end
	end

	return biome_list[key], key
end

-- Returns the tempdiff that would've been needed to get to the nearest other biome...
-- Expects biome_list to not contain biome
function worldgen.tempdiff(temperature, biome, biome_list)
	biome_list = biome_list or worldgen.registered_biomes
	-- TODO: rainfall
	local otherbiome = worldgen.get_biome_nearest(temperature, 0, biome_list)

	local temp
	temp = math.abs(biome.temperature - otherbiome.temperature)

	return temp
end

-- API out of the way, register biomes
worldgen.register_biome({
	name = "worldgen:biome_plains"
})
worldgen.register_biome({
	name = "worldgen:biome_desert",
	temperature = 2.0,

	top = "bobcraft_blocks:sand",
	middle = "bobcraft_blocks:sand",
	bottom = "bobcraft_blocks:sandstone",

	y_effector = 0.75,
})
worldgen.register_biome({
	name = "worldgen:biome_tundra",
	temperature = 0.0,

	top = "bobcraft_blocks:snowy_grass_block",
	above = "bobcraft_blocks:snow_layer",
	liquid_top = "bobcraft_blocks:ice",

	y_effector = 2,
})

worldgen.register_biome({
	name = "worldgen:biome_hell_wastes",
	temperature = 1.0,
	h_override = 3.6,
	s_override = 1.0,
	v_override = 25,
	sky_force_underground = true,
})