greendust = {}

greendust.colour_from_power = function(pos, node, power)
	local palette = power
	minetest.swap_node(pos, {name=node.name, param1=node.param1, param2=palette})
end