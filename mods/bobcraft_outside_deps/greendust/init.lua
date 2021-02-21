--[[
	Using mesecons as a base of reference, it seems that they use an action queue.
	This action queue gets added to by the various mese*.
	The actions are then called in order of importance.

	That seems to work for them, and I'd be using mesecons, but it doesn't have a concept of power.
	Makes sense, I suppose.
	...Oh yeah, and I don't want microcontrollers, LCD screens, etc. in my fantasy magic world!

	For greendust, we don't care about connections, we just search in the 4 lateral directions around the dust piece.
	And we use param2 for both colour *and* power!

	So yeah, we search in these four directions, up *and* down.
	  |
	 ~@~
	  |
	From that, we power wires.
	The wires then get powered, yadda yadda, and any greendust activateables will be triggered with on_power and on_unpower events.
	All with an event queue.

	TODO: I'm *really* not sure where I stand legally when it comes to this.
		  Mesecons is under the LGPL, and I potentially use enough parts of it (function names, concepts) that I should put this under LPGL, and claim
		  to be a fork of mesecons.
]]

greendust = {}

greendust.event_queue = {}
greendust.event_queue.actions = {}
greendust.event_queue.functions = {}
greendust.now = 0

function greendust.event_queue:add_action(pos, func, params, time, overwrite_check, priority)
	time = time or 0
	priority = priority or 1
	local action = {
		pos = pos,
		func = func,
		params = table.copy(params),
		at = time,
		overwrite = overwrite_check or nil,
		priority = priority
	}

	table.insert(greendust.event_queue.actions, action)
end

greendust.colour_from_power = function(pos, node, power)
	 -- Colours a node based on its' power value. Also sets its' power in the first place.
	local palette = power
	minetest.swap_node(pos, {name=node.name, param1=node.param1, param2=palette})
end

local function is_wire(pos)
	local node = minetest.get_node(pos)
	if node then
		if minetest.get_item_group(node.name, "greendust_conduit") ~= 0 then
			return true
		end
	end

	return false
end

local function update_conduit(pos)
	local connections = {}
	for dx = -1, 1 do
		for dz = -1, 1 do
			if math.abs(dx) + math.abs(dz) == 1 then
				for dy = -1, 1 do
					local pos_here = {x=pos.x+dx, y=pos.y+dy, z=pos.z+dz}
					if is_wire(pos_here) then
						if is_wire(pos) then
							table.insert(connections, pos_here)
						else
							-- we wanna tell the wire we just found that we're no longer a wire.
							update_conduit(pos_here)
						end
					end
				end
			end
		end
	end

	-- we should now have all the connections

	if is_wire(pos) then
		-- now we can set our meta
		local meta = minetest.get_meta(pos)
		meta:from_table({
			connections = connections
		})
	end
end

-- Give the position some energy, recursively!
local function empower(pos, energy, handled_pos)
	local handled_pos = handled_pos or {}

	if handled_pos[dump(pos)] then
		return -- we've handled this place, don't do it again
	end

	handled_pos[dump(pos)] = true

	if is_wire(pos) then
		local node_meta = minetest.get_meta(node)

		minetest.log(node_meta:to_table())
	end
end
function greendust.event_queue.functions:empower(pos, power, handled_pos)
	empower(pos, power, handled_pos)
end

function greendust.conduit_change(pos, node)
	-- Called whenever a conduit is changed.
	-- If you want to register your own conduit, make sure to point on_place and on_dug here.
	local new_node = minetest.get_node(pos)
	if minetest.registered_nodes[new_node.name] and
	   is_wire(pos) then
		-- if the new node is registered, and it's a conduit
		update_conduit(pos)
	end

end

-- Pulses some energy into the network.
function greendust.impulse(pos, energy)
	local energy = energy or 0

	if energy > 15 then
		energy = 15
	end

	empower(pos, energy)
end

-- Urban dictionary claims this is a word.
function greendust.event_queue:actionate(action)
	minetest.log(dump(action))
	greendust.event_queue.functions[action.func](action.pos, unpack(action.params))
end

-- The meat & tatties of the whole operation.
-- Executes the various events/actions.
minetest.register_globalstep(function(dtime)
	greendust.now = greendust.now + dtime

	-- Mesecons does this, But I'm not sure why. Who am I to question the ways of the gods?
	local work_on_actions = table.copy(greendust.event_queue.actions)
	greendust.event_queue.actions = {}

	local do_now = {}

	for i, action in ipairs(work_on_actions) do
		if action.at > 0 then
			action.at = action.at - dtime
			table.insert(greendust.event_queue.actions) -- re-insert it, to be handled *later*
		else
			table.insert(do_now, action) -- Do the action NOW!
		end
	end

	for i = 1, #do_now do
		local this = do_now[i]
		greendust.event_queue:actionate(table.copy(this))
		table.remove(do_now, i)
	end
end)