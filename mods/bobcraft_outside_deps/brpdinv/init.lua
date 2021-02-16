-- Note; while the original is in the MIT license, that's not public domain.
-- So I used 0 code (haven't even read it), but used the game_api.txt as the spec I had to qualify against.
-- If you see any issues, or want to extend functionality, feel free to make an issue on GH!
-- ...Or you could just use this to make your own. Works too.
-- Although please be nice and atleast credit me for the initial implementation!

brpdinv = {}

brpdinv.pages = {} -- name = def
brpdinv.pages_unordered = {} -- in order of addition
brpdinv.contexts = {} -- playername = context
brpdinv.enabled = true -- allow you to disable this

-- contexts are
-- page,
-- nav,
-- nav_titles,
-- nav_idx,
-- other etc. data
--[[ -- Lua doesn't let us copy this. of-course it doesn't.
local blank_context = {
	page = "error",
	nav = {"error"},
	nav_titles = {"Error"},
	nav_idx = 0
}]]

local inventory_theme = "" -- TODO: inventory theme

-- Pages

function brpdinv.set_page(player, pagename)
	local context = brpdinv.get_or_create_context(player)
	context.page = pagename
end

function brpdinv.get_page(player, pagename)
	return brpdinv.pages[pagename] or brpdinv.pages["error"]
end

function brpdinv.register_page(name, def)
	-- Defs are
	-- title,
	-- get(self, player, context),
	-- is_in_nav(self, player, context, fields),
	-- on_player_recieve_fields(self, player, context, fields),
	-- on_enter(self, player, context)
	-- on_leave(self, player, context)

	def.title = def.title or "Unnamed"
	def.get = def.get or function(self, player, context) return {} end
	def.is_in_nav = def.is_in_nav or function(self, player, context, fields) return true end
	def.on_player_recieve_fields = def.on_player_recieve_fields or function(self,player,context,fields) end
	def.on_enter = def.on_enter or function(self, player, context) end
	def.on_leave = def.on_leave or function(self, player, context) end

	brpdinv.pages[name] = def
	table.insert(brpdinv.pages_unordered, def)
end

function brpdinv.override_page(name, def)

end

-- Contexts

function brpdinv.get_or_create_context(player)
	local playername = player:get_player_name()
	if not brpdinv.contexts[playername] then
		brpdinv.contexts[playername] = {
			page = brpdinv.get_homepage_name()
		}
	end
	return brpdinv.contexts[playername]
end

function brpdinv.delete_context(player)
	local playername = player:get_player_name()
	brpdinv.contexts[playername] = nil
end

function brpdinv.set_context(player, context)
	brpdinv[player:get_player_name()] = context
end

-- Theming

function brpdinv.make_formspec(player, context, content, show_inv, size)

	size = size or "size[8,9.1]"

	local formspec = ""
	formspec = formspec .. size
	formspec = formspec .. brpdinv.get_nav_fs(player, context, context.nav_titles, content.nav_idx)
	formspec = formspec .. inventory_theme -- TODO: how does show_inv relate?
	formspec = formspec .. content

	return formspec
end

function brpdinv.get_nav_fs(player, context, nav, current_idx)
	return ""
end

-- Etc.

function brpdinv.get_homepage_name(player)
	return "brpdinv:inventory"
end

function brpdinv.set_player_inventory_formspec(player, context)
	local formspec = brpdinv.get_formspec(player, context or brpdinv.get_or_create_context(player))
	player:set_inventory_formspec(formspec)
end

function brpdinv.get_formspec(player, context)
	local page = brpdinv.get_page(player, context.page)
	if page then
		return page:get(player, context)
	else
		local old_page = context.page
		local home_page = brpdinv.get_homepage_name(player)
		context.page = home_page
		minetest.log("Couldn't find page " .. old_page .. ", so sending them to the homepage " .. home_page)
		return brpdinv.get_formspec(player, context)
	end
end

-- the registars

-- regster an error page
brpdinv.register_page(
	"error",
	{
		title = "Error",
		get = function(self, player, context)
			minetest.log("For some reason, " .. player:get_player_name() .. " is on the error page.")
			return brpdinv.make_formspec(player, context,
				"label[0,16;SOmething Broke]"
			)
		end
	}
)

-- the inventory page
brpdinv.register_page(
	"brpdinv:inventory",
	{
		title = "Inventory",
		get = function(self, player, context)
			return brpdinv.make_formspec(player, context,
			"size[8,7.5;]" ..
			"image[1,0.6;1,2;player.png]" ..
			"list[current_player;main;0,3.5;8,4;]" ..
			"list[current_player;craft;3,0;3,3;]" .. -- TODO: 2x2 grid
			"list[current_player;craftpreview;7,1;1,1;]"
		)
		end,
	}
)

minetest.register_on_joinplayer(function(player)
	-- TODO: allow disabling
	brpdinv.set_player_inventory_formspec(player)
end)

minetest.register_on_leaveplayer(function(player)
	brpdinv.delete_context(player)
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
	if formname ~= "" then
		return false -- If we're not the inventory (as we only replace it)
	end

	local playername = player:get_player_name()
	local context = brpdinv.contexts[playername]
	if not context then
		brpdinv.set_player_inventory_formspec(player) -- creates a context for us
		return false
	end


	local page = brpdinv.pages[context.page]
	if page then
		return page:on_player_recieve_fields(player, context, fields)
	end

end)