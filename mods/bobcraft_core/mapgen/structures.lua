worldgen.structures = {}

function worldgen.gen_struct(pos, name, rotation, rand)
	return worldgen.structures[name](pos, rotation, rand)
end

function worldgen.register_structure(name, schematic_file, on_generate)
	worldgen.structures[name] = function(pos, rotation, rand)
		local p = schematic_file
		worldgen.place_schematic(pos, p, rotation)

		if on_generate ~= nil then
			on_generate(pos)
		end
	end
end

function worldgen.place_schematic(pos, file, rotation)
	minetest.place_schematic(
		pos,
		file,
		rotation,
		nil,
		true
	)
end


worldgen.register_structure("temple", 
minetest.get_modpath("bobcraft_worldgen").."/schematic/structure/temple.mts")