-- Extended mobkit functions, Bobcraft

function mobkit.register_spawn_egg(mob, bg, fg)
	minetest.register_craftitem(mob.."_egg", {
		description = "Spawn "..mob,
		inventory_image = "egg.png^[multiply:"..bg.."^(egg_bits.png^[multiply:"..fg..")",

		on_place = function(itemstack, placer, pointedthing)
			minetest.add_entity(pointedthing.above, mob)
		end,
	})
end