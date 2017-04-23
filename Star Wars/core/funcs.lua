----------------------------
-- Support Functions File --
----------------------------

--[[ Read Files ]]--

function sw.load_admins()
	local f = io.open(path.."config/admins.txt", "r")
	if (f ~= nil) then
		for line in f:lines() do
			if (string.sub(line, 1, 2) ~= "//") then -- Comment string
				if (tonumber(line) ~= nil) then
					table.insert(admins, tonumber(line))
				end
			end
		end
		io.close(f)
		print("File \"admins.txt\" is successfully loaded.")
	else
		print("File \"admins.txt\" is missing!")
	end
end

function sw.load_adverts()
	local f = io.open(path.."config/adverts.txt", "r")
	if (f ~= nil) then
		for line in f:lines() do
			if (string.sub(line, 1, 2) ~= "//") then -- Comment string
				table.insert(adverts, line)
			end
		end
		io.close(f)
		print("File \"adverts.txt\" is successfully loaded.")
	else
		print("File \"adverts.txt\" is missing!")
	end
end

function sw.load_maps()
	local f = io.open(path.."config/maplist.txt", "r")
	if (f ~= nil) then
		for line in f:lines() do
			if (string.sub(line, 1, 2) ~= "//") then -- Comment string
				table.insert(maps, line)
			end
		end
		io.close(f)
		print("File \"maplist.txt\" is successfully loaded.")
	else
		print("File \"maplist.txt\" is missing!")
	end
end

function sw.load_boxes()
	local f = io.open(path.."config/boxes.txt", "r")
	if (f ~= nil) then
		for line in f:lines() do
			if (string.sub(line, 1, 2) ~= "//") then -- Comment string
				if (string.sub(line, 1, 4) == "#box") then
					local stat = sw.get_table_boxes(line)
					table.insert(sw.boxes, stat)
				end
			end
		end
		io.close(f)
		print("File \"boxes.txt\" is successfully loaded.")
	else
		print("File \"boxes.txt\" is missing!")
	end
end

function sw.load_items()
	local f = io.open(path.."config/items.txt", "r")
	if (f ~= nil) then
		for line in f:lines() do
			if (string.sub(line, 1, 2) ~= "//") then -- Comment string
				if (string.sub(line, 1, 5) == "#item") then
					local stat = sw.get_table_items(line)
					table.insert(sw.items, stat)
				end
			end
		end
		io.close(f)
		print("File \"items.txt\" is successfully loaded.")
	else
		print("File \"items.txt\" is missing!")
	end
end

function sw.load_heroes()
	local f = io.open(path.."config/heroes.txt", "r")
	if (f ~= nil) then
		for line in f:lines() do
			if (string.sub(line, 1, 2) ~= "//") then -- Comment string
				if (string.sub(line, 1, 5) == "#hero") then
					local stat = sw.get_table_heroes(line)
					table.insert(sw.heroes, stat)
				end
			end
		end
		io.close(f)
		print("File \"heroes.txt\" is successfully loaded.")
	else
		print("File \"heroes.txt\" is missing!")
	end
end

function sw.load_ranks()
	local f = io.open(path.."data/ranks.txt", "r")
	if (f ~= nil) then
		local args, usgn, points, kills, deaths
		for line in f:lines() do
			args = string.split(line, ":")
			name = args[1]
			usgn = tonumber(args[2])
			points = tonumber(args[3])
			kills = tonumber(args[4])
			deaths = tonumber(args[5])
			table.insert(sw.ranks, {name, usgn, points, kills, deaths})
		end
		io.close(f)
		print("File \"ranks.txt\" is successfully loaded.")
	else
		print("File \"ranks.txt\" is missing!")
	end
end

--[[ Get Functions ]]--

function sw.get_table_boxes(line)
	local load_string = string.split(line, ":")
	local i, j, g
	local stata = {}
	local ln
	local str = ""
	for i = 1, 3 do
		if (load_string[i + 1] ~= nil) then
			ln = string.split(load_string[i + 1], " ")
			if (ln[1]) then
				if (#ln > 1) then
					str = ln[1]
					for g, j in pairs(ln) do
						if (g > 1) then
							str = str.." "..j
						end
					end
					table.insert(stata, str)
				elseif ((i < 3)) then -- Name and Group must be string!
					table.insert(stata, ln[1])
				else -- Other may be tonumber.
					table.insert(stata, tonumber(ln[1]))
				end
			end
		end
	end
	return stata
end

function sw.get_table_items(line)
	local load_string = string.split(line, ":")
	local i, j, g
	local stata = {}
	local ln
	local str = ""
	for i = 1, 6 do
		if (load_string[i + 1] ~= nil) then
			ln = string.split(load_string[i + 1], " ")
			if (ln[1]) then
				if (#ln > 1) then
					str = ln[1]
					for g, j in pairs(ln) do
						if (g > 1) then
							str = str.." "..j
						end
					end
					table.insert(stata, str)
				elseif ((i < 4) or (i == 5)) then -- Name, Group and IMG must be string!
					table.insert(stata, ln[1])
				else -- Other may be tonumber.
					table.insert(stata, tonumber(ln[1]))
				end
			end
		end
	end
	return stata
end

function sw.get_table_heroes(line)
	local load_string = string.split(line, ":")
	local i, j, g
	local stata = {}
	local ln
	local str = ""
	for i = 1, 9 do
		if (load_string[i + 1] ~= nil) then
			ln = string.split(load_string[i + 1], " ")
			if (ln[1]) then
				if (i == 7) then -- Items
					local items = string.split(ln[1], ",")
					if (#items > 0) then
						table.insert(stata, items)
					else
						-- Error here
					end
				elseif (i > 7) then -- Skills
					local skill = {}
					skill = sw.skills_check_list(ln[1])
					if (table.count(skill) > 0) then
						table.insert(stata, skill)
					end
				else
					if (#ln > 1) then
						str = ln[1]
						for g, j in pairs(ln) do
							if (g > 1) then
								str = str.." "..j
							end
						end
						table.insert(stata, str)
					elseif (i < 4) then -- Name must be string!
						table.insert(stata, ln[1])
					else -- Other may be tonumber.
						table.insert(stata, tonumber(ln[1]))
					end
				end
			end
		end
	end
	return stata
end

function sw.get_rank_table()
	local top, flag = {}, true
	for _, p in pairs(sw.ranks) do
		-- 1: USGN; 2: Points; 3: Name
		table.insert(top, {p[2], p[3], p[1]})
	end
	-- Bubble Sort
	for i = 1, (#top - 1) do
		flag = true
		for j = 1, (#top - 1) do
			if (top[j][2] < top[j + 1][2]) then
				top[j][1], top[j + 1][1] = top[j + 1][1], top[j][1]
				top[j][2], top[j + 1][2] = top[j + 1][2], top[j][2]
				top[j][3], top[j + 1][3] = top[j + 1][3], top[j][3]
				flag = false
			end
		end
		if (flag) then
			break
		end
	end
	return top
end

function sw.get_usgn_points(id)
	local usgn = player(id, "usgn")
	if (usgn > 0) then
		for _, p in pairs(sw.ranks) do
			if (p[2] == usgn) then
				return p[3]
			end
		end
	end
	return nil
end

--[[ Init Functions ]]--

function sw.lasers_init()
	local i, j
	for i = 1, 32 do -- 32 Players
		for j = 1, sw_max_lasers do -- (15) Max Lasers
			sw.p_lasers[i][1] = image("gfx/sw/pixel.bmp<n>", 0, 0, 1) 
			sw.p_lasers[i][2] = image("gfx/sprites/flare4.bmp", 0, 0, 1)
		end
	end
end

--[[ Menu Functions ]]--

function sw.open_menu(id, m)
	if (m == 0) then -- Main Menu
		local class, boxes, credits = 1, #sw.p_boxes[id], sw.p_credits[id]
		local rank, points  = sw.check_league_rank(player(id, "usgn")), sw.get_usgn_points(id)
		local league = sw.check_usgn_league(rank, points)
		menu(id, "Star Wars Menu@b,Class Menu|Current Class: "..class..",Collection|Class Items and Inventory,Loot Boxes|Boxes: "..boxes..",(Shop|Credits: "..credits.."),Rank ("..league..")|Points: "..points)
	elseif (m == 1) then -- Class Menu
		local page = sw.p_page[id]
		sw.heroes_menu(id, page)
	elseif (m == 2) then -- Inventory
		menu(id, "Class Items and Inventory@b,Class Items,All Items,,,,,,Back|Main Menu")
		local page = sw.p_page[id]
		sw.items_menu(id, page)
	elseif (m == 3) then -- Loot Boxes
		local page = sw.p_page[id]
		sw.boxes_menu(id, page)
	end
end

function sw.heroes_menu(id, page)
	local i, body_menu, hero = 0, ""
	if (page == 0) then
		for i = 1, 7 do
			if (i <= #sw.heroes) then
				body_menu = body_menu..""..sw.heroes[i][1].." ("..sw.heroes[i][3]..")|Affiliation: "..sw.heroes[i][2]..","
			else
				body_menu = body_menu..","
			end
		end
		body_menu = body_menu.."Back|Main Menu"
		if (#sw.heroes > 7) then
			body_menu = body_menu..",Next|Next Page"
		end
	elseif (page > 0) then
		local starti = 8 + 7 * (page - 1)
		local endi = 14 + 7 * (page - 1)
		for i = starti, endi do
			if (i <= #sw.heroes) then
				body_menu = body_menu..""..sw.heroes[i][1].." ("..sw.heroes[i][3]..")|Affiliation: "..sw.heroes[i][2]..","
			else
				body_menu = body_menu..","
			end
		end
		body_menu = body_menu.."Back|Previous Page"
		if (endi < #sw.heroes) then
			body_menu = body_menu..",Next|Next Page"
		end
	end
	menu(id, "Choose Your Class Page "..(page + 1).."@b,"..body_menu)
end

function sw.items_menu(id, page)
	local i, body_menu, item = 0, ""
	if (page == 0) then
		for i = 1, 7 do
			if (i <= #sw.p_inventory[id]) then
				item = sw.p_inventory[id][i]
				body_menu = body_menu..""..sw.items[item][1].."|Category: "..sw.items[item][2]..","
			else
				body_menu = body_menu..","
			end
		end
		body_menu = body_menu.."Back|Main Menu"
		if (#sw.p_inventory[id] > 7) then
			body_menu = body_menu..",Next|Next Page"
		end
	elseif (page > 0) then
		local starti = 8 + 7 * (page - 1)
		local endi = 14 + 7 * (page - 1)
		for i = starti, endi do
			if (i <= #sw.p_inventory[id]) then
				item = sw.p_inventory[id][i]
				body_menu = body_menu..""..sw.items[item][1].."|Category: "..sw.items[item][2]..","
			else
				body_menu = body_menu..","
			end
		end
		body_menu = body_menu.."Back|Previous Page"
		if (endi < #sw.p_inventory[id]) then
			body_menu = body_menu..",Next|Next Page"
		end
	end
	menu(id, "Inventory Page "..(page + 1)..","..body_menu)
end

function sw.boxes_menu(id, page)
	local i, body_menu, box = 0, ""
	if (page == 0) then
		for i = 1, 7 do
			if (i <= #sw.p_boxes[id]) then
				box = sw.p_boxes[id][i]
				body_menu = body_menu..""..sw.boxes[box][1].."|Category: "..sw.boxes[box][2]..","
			else
				body_menu = body_menu..","
			end
		end
		body_menu = body_menu.."Back|Main Menu"
		if (#sw.p_boxes[id] > 7) then
			body_menu = body_menu..",Next|Next Page"
		end
	elseif (page > 0) then
		local starti = 8 + 7 * (page - 1)
		local endi = 14 + 7 * (page - 1)
		for i = starti, endi do
			if (i <= #sw.p_boxes[id]) then
				box = sw.p_boxes[id][i]
				body_menu = body_menu..""..sw.boxes[box][1].."|Category: "..sw.boxes[box][2]..","
			else
				body_menu = body_menu..","
			end
		end
		body_menu = body_menu.."Back|Previous Page"
		if (endi < #sw.p_boxes[id]) then
			body_menu = body_menu..",Next|Next Page"
		end
	end
	menu(id, "Loot Boxes Page "..(page + 1)..","..body_menu)
end

function sw.heroes_render_menu(id, but)
	local page = sw.p_page[id]
	if (page == 0) then
		if (but > 0 and but < 8) then
			sw.p_subclass[id] = but
			msg2(id, string.format("©128255255Your Class After The Next Spawn Will Be %s", sw.heroes[but][1]))
		elseif (but == 8) then
			sw.open_menu(id, 0)
		end
	elseif (page > 0) then
		local p = but + 7 + 7 * (page - 1)
		if (but > 0 and but < 8) then
			sw.p_subclass[id] = p
			msg2(id, string.format("©128255255Your Class After The Next Spawn Will Be %s", sw.heroes[p][1]))
		elseif (but == 8) then
			sw.p_page[id] = page - 1
			sw.heroes_menu(id, page)
		end
	end
	if (but == 9) then
		sw.p_page[id] = page + 1
		sw.heroes_menu(id, sw.p_page[id])
	end
end

function sw.boxes_render_menu(id, but)
	local page = sw.p_page[id]
	if (page == 0) then
		if (but > 0 and but < 8) then
			-- Drop from box system here
			table.remove(sw.p_boxes[id], but)
		elseif (but == 8) then
			sw.open_menu(id, 0)
		end
	--[[elseif (page > 0) then
		local p = but + 7 + 7 * (page - 1)
		local pls = player(0, "table")
		if (but > 0 and but < 8) then
			if (player(pls[p], "exists")) then
				if (ap_admact_enable > 0) then
					parse("msg \"Admin "..player(id, "name").." kick player "..player(pls[p], "name").."\"")
				end
				parse("kick "..pls[p])
			end
		elseif (but == 8) then
			sw.p_page[id] = page - 1
			sw.boxes_menu(id, page)
		end]]
	end
	if (but == 9) then
		sw.p_page[id] = page + 1
		sw.boxes_menu(id, sw.p_page[id])
	end
end

--[[ Checks Functions ]]--

function sw.item_check_hero(hero)
	for _, j in pairs(sw.heroes) do
		if (j[1] == hero) then
			return true
		end
	end
	return false
end

function sw.skills_check_list(skill)
	local args = string.split(skill, "~")
	local stats = {}
	-- Passives
	if (string.sub(args[1], 1, 15) == "#z_health_regen") then
		stats["name"] = "hpreg"
		stats["time"] = tonumber(args[2])
		stats["hpreg"] = tonumber(args[3])
	elseif (string.sub(args[1], 1, 18) == "#z_critical_chance") then
		stats["name"] = "critdmg"
		stats["chance"] = tonumber(args[2])
		stats["dmgpercent"] = tonumber(args[3])
	elseif (string.sub(args[1], 1, 18) == "#z_protect_barrier") then
		stats["name"] = "barrier"
		stats["barrier"] = tonumber(args[2])
		stats["time"] = tonumber(args[3])
		stats["regen"] = tonumber(args[4])
	elseif (string.sub(args[1], 1, 16) == "#z_stackable_dmg") then
		stats["name"] = "dmgstack"
		stats["stack"] = tonumber(args[2])
		stats["time"] = tonumber(args[3])
		stats["dmg"] = tonumber(args[4])
	elseif (string.sub(args[1], 1, 16) == "#z_star_engineer") then
		stats["name"] = "energy"
		stats["energy"] = tonumber(args[2])
		stats["time"] = tonumber(args[3])
		stats["regen"] = tonumber(args[4])
	elseif (string.sub(args[1], 1, 20) == "#z_invisible_stealth") then
		stats["name"] = "invis"
		stats["time"] = tonumber(args[2])
	-- Skills
	--elseif (string.sub(args[1], 1, 20) == "#s_explosive_shoot") then
	end
	return stats
end

function sw.check_usgn_rank(id)
	local usgn, flag = player(id, "usgn"), true
	if (usgn > 0) then
		for _, p in pairs(sw.ranks) do
			if (p[2] == usgn) then
				flag = false
				local league
				local rank = sw.check_league_rank(usgn)
				local col1 = "©000255000"
				-- Show Stats
				if (rank > 0) then
					league = sw.check_usgn_league(rank, p[3])
					msg2(id, col1.."=== Your stats ===")
					msg2(id, col1.."Logged in: #"..usgn)
					msg2(id, col1.."Rank: "..rank.." of "..(#sw.ranks))
					msg2(id, col1.."League: "..league)
					msg2(id, col1.."Points: "..p[3])
				end
				-- Update NickName
				if (p[1] ~= player(id, "name")) then
					p[1] = player(id, "name")
				end
				break
			end
		end
		if (flag) then

		end
	else
		local col1 = "©255000000"
		msg2(id, col1.."Please Check Your U.S.G.N. Account Settings!@C")
	end
end

function sw.check_usgn_league(rank, points)
	if (points < 500) then
		return "Bronze"
	elseif ((points >= 500) and (points < 1000)) then
		return "Silver"
	elseif ((points >= 1000) and (points < 1500)) then
		return "Gold"
	elseif ((points >= 1500) and (points < 2000)) then
		return "Platinum"
	elseif (points >= 2000) then
		if (rank <= sw_ampls_grandmaster) then
			return "GrandMaster"
		else
			return "Diamond"
		end
	end
end

function sw.check_league_rank(usgn)
	local top = sw.get_rank_table()
	for i, p in pairs(top) do
		if (usgn == p[1]) then
			return i
		end
	end
	return 0
end

--[[ Interface ]]--

function sw.hud_interface_update(id)
	local col1, col2, col3, col4 = "©128255000", "©000255000", "©255255255", "©128166255"
	local class = sw.heroes[sw.p_class[id]]
	if (#sw.p_interface[id] < 1) then
		local img = image("gfx/sw/pixel.bmp<n>", 0, 0, 2)
		imagecolor(img, 0, 0, 0)
		imagescale(img, 150, 60)
		imagepos(img, 85, 420, 0)
		imagealpha(img, 0.5)
		table.insert(sw.p_interface[id], img)
	end

	parse(string.format("hudtxt2 %d %d \"%s\" %d %d %d", id, 10, col1.."Class: "..class[1], 20, 395, 0))
	if (sw.p_barrier[id] > 0) then
		parse(string.format("hudtxt2 %d %d \"%s\" %d %d %d", id, 11, col1.."Health: "..sw.p_health[id]..""..col3.."("..col4..""..sw.p_barrier[id]..""..col3..")"..col1.."/"..sw.heroes[sw.p_class[id]][4], 20, 410, 0))
	else
		parse(string.format("hudtxt2 %d %d \"%s\" %d %d %d", id, 11, col1.."Health: "..sw.p_health[id].."/"..sw.heroes[sw.p_class[id]][4], 20, 410, 0))
	end
	sw.hud_interface_hpbar(id)
	--parse(string.format("hudtxt2 %d %d \"%s\" %d %d %d", p, 11, col1.."Health: ", 20, 455, 0))
end

function sw.hud_interface_hpbar(id)
	local str1 = ""
	local str2 = ""
	local col1, col2, col3 = "©255255255", "©128255000", "©000128255"
	for i = 1, (math.ceil(sw.p_health[id] / 5)) do
		str1 = str1.."|"
	end
	for i = 1, (math.ceil(sw.p_barrier[id] / 5)) do
		str2 = str2.."|"
	end
	parse(string.format("hudtxt2 %d %d \"%s\" %d %d %d", id, 12, col1.."["..col2..""..str1..""..col3..""..str2..""..col1.."]", 20, 425, 0))
end

function sw.hud_interface_clear(id)
	for i = 10, 19 do
		parse(string.format("hudtxt2 %d %d \"%s\" %d %d %d", id, i, "", 0, 0, 0))
	end
	for _, p in pairs(sw.p_interface[id]) do
		freeimage(p)
	end
	sw.p_interface[id] = {}
end

--[[ Events ]]--

function sw.heroes_seconds_regen(id, class)
	for _, j in pairs(class) do
		if (type(j) == "table") then
			if (j["name"] == "hpreg") then
				if (sw.p_lasthit[id] > 1) then
					sw.p_times[id]["hpreg"] = sw.p_times[id]["hpreg"] + 1
					if (sw.p_times[id]["hpreg"] >= j["time"]) then
						sw.p_times[id]["hpreg"] = 0
						if (sw.p_health[id] < class[4]) then
							sw.p_health[id] = sw.p_health[id] + j["hpreg"]
							if (sw.p_health[id] > class[4]) then
								sw.p_health[id] = class[4]
							end
							sw.hud_interface_update(id)
						end
					end
				end
			elseif (j["name"] == "barrier") then
				if (sw.p_lasthit[id] > 1) then
					sw.p_times[id]["brreg"] = sw.p_times[id]["brreg"] + 1
					if (sw.p_times[id]["brreg"] >= j["time"]) then
						sw.p_times[id]["brreg"] = 0
						if (sw.p_barrier[id] < j["barrier"]) then
							sw.p_barrier[id] = sw.p_barrier[id] + j["regen"]
							if (sw.p_barrier[id] > j["barrier"]) then
								sw.p_barrier[id] = j["barrier"]
							end
							sw.hud_interface_update(id)
						end
					end
				end
			end
		end
	end
end

function sw.heroes_event_spawn(id)
	local class = sw.heroes[sw.p_class[id]]
	for _, j in pairs(class) do
		if (type(j) == "table") then
			if (j["name"] == "barrier") then
				sw.p_barrier[id] = j["barrier"]
			end
		end
	end
end

function sw.heroes_event_hit(id, source)
end

--[[ Other functions ]]--

function checkadmin(usgn)
	for i = 1, #admins do
		if (usgn == admins[i]) then
			return true
		end
	end
	return false
end

function sw.load_usgn_stats(id)
	local usgn = player(id, "usgn")

end

function sw.item_box_drop(id, box)
end

function sw.player_reset_times(id)
	sw.p_times[id] = {["hpreg"] = 0, ["brreg"] = 0, ["enreg"] = 0, ["invis"] = 0, ["cd"] = 0}
end

function sw.save_ranks()
	local f, str = assert(io.open(path.."data/ranks.txt", "w")), ""
	if (f ~= nil) then
		for _, j in pairs(sw.ranks) do
			str = ""
			for i = 1, #j do
				if (str == "") then
					str = j[1]
				else
					str = str..":"..j[i]
				end
			end
			if (str ~= "") then
				f:write(str)
			else
				print("error")
			end
		end
		io.close(f)
	end
end