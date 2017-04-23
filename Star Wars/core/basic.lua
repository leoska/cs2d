----------------------------
-- General Functions File --
----------------------------

sw.load_admins()
sw.load_adverts()
sw.load_maps()
sw.load_heroes()
sw.load_boxes()
sw.load_items()
sw.load_ranks()


function sw.startround()
	-- Init lasers imgs
	sw.lasers_init()
	local pls = player(0, "tableliving")
	-- Update HUD
	for i, p in pairs(pls) do
		sw.hud_interface_clear(p)
		sw.hud_interface_update(p)
	end
end

function sw.endround()
end

function sw.second()
	--[[seconds = seconds + 1
	if (seconds >= 60) then
		seconds = 0
	end]]
	local pls, class = player(0, "tableliving"), 0
	-- Regen event
	for i, p in pairs(pls) do
		if (sw.p_lasthit[p] < 60) then
			sw.p_lasthit[p] = sw.p_lasthit[p] + 1
		end
		if (sw.p_class[p] > 0) then
			class = sw.heroes[sw.p_class[p]]
			sw.heroes_seconds_regen(p, class)
		end
	end
end

function sw.minute()
	minutes = minutes + 1
	-- Adverts
	if (minutes >= sw_adv_time) then 
		minutes = 0
		if (sw_adv_enable > 0) then
			local n = math.random(1, #adverts)
			parse("msg \""..string.format("%s", adverts[n]).."\"")
		end
	end
	-- Rank Stats
	sw.stats_minutes = sw.stats_minutes + 1
	if (sw.stats_minutes >= sw_stats_update) then
		sw.stats_minutes = 0
		sw.save_ranks()
	end
end

function sw.serveraction(id, but)
	if (but == 1) then -- Main Menu
		sw.open_menu(id, 0)
		--local img = image("gfx/sw/"..sw.items[1][4].."<m>", 2, 0, 200 + id)
		--image("gfx/sw/stormtrooper.bmp<m>", 2, 0, 200 + id)
	elseif (but == 2) then
		table.insert(sw.p_boxes[id], 1)
	elseif (but == 3) then
		table.insert(sw.p_inventory[id], math.random(2, 4))
	end
end

function sw.select(id, wpn)
end

function sw.menu(id, title, but)
	if (string.sub(title, 1, 14) == "Star Wars Menu") then
		if ((but > 0) and (but < 4)) then
			sw.p_page[id] = 0
			sw.open_menu(id, but)
		end
	elseif (string.sub(title, 1, 17) == "Choose Your Class") then
		sw.heroes_render_menu(id, but)
	elseif (string.sub(title, 1, 10) == "Loot Boxes") then
		sw.boxes_render_menu(id, but)
	end
end

function sw.spawn(id)
	if (sw.p_subclass[id] == 0) then
		sw.p_subclass[id] = 1
	end
	local hero, i, str = sw.p_subclass[id], 0, ""
	sw.p_class[id] = hero
	--sw.p_health[id] = sw.heroes[hero][4]
	sw.p_health[id] = 90
	parse("speedmod "..id.." "..sw.heroes[hero][6])
	sw.p_lasthit[id] = 60

	sw.player_reset_times(id)

	sw.heroes_event_spawn(id)

	sw.hud_interface_update(id)

	for _, i in pairs(sw.heroes[hero][7]) do
		str = str..""..i..","
	end

	parse("strip "..id.." 50") -- Remove knife
	return str
end

function sw.spawn(id)
	return "32"
end

function sw.team(id, t)
	if (sw.p_load[id] < 1) then
		if (t > 0) then
			sw.open_menu(id, 1)
		end
		sw.check_usgn_rank(id)
		--sw.load_usgn_stats(id)
		sw.p_load[id] = 1
	end
	sw.hud_interface_clear(id)
end

function sw.join(id)
	sw.p_load[id] = 0
	if (#sw.p_boxes[id] < 1) then
		table.insert(sw.p_boxes[id], 1)
	end
	print(#sw.p_boxes[id])
end

function sw.hit(id, source, weapon, hpdmg)
	sw.p_lasthit[id] = 0
	sw.p_times[id]["hpreg"] = 0
	sw.p_times[id]["brreg"] = 0
	if (player(id, "team") ~= player(source, "team")) then
		-- Damage (Hit)
		if (sw.p_barrier[id] > 0) then
			if (sw.p_barrier[id] < hpdmg) then
				local dmg = hpdmg - sw.p_barrier[id]
				sw.p_health[id] = sw.p_health[id] - dmg
				sw.p_barrier[id] = 0
			else
				sw.p_barrier[id] = sw.p_barrier[id] - hpdmg
			end
		else
			sw.p_health[id] = sw.p_health[id] - hpdmg
		end
		sw.heroes_event_hit(id, source)
		sw.hud_interface_update(id)
		-- Kill player
		if (sw.p_health[id] < 1) then
			sw.p_health[id] = 0
			if (weapon == 32) then
				parse('customkill '..source..' "DC-15a" '..id)
			elseif (weapon == 50) then
				parse('customkill '..source..' "Lightsaber" '..id)
			elseif (weapon == 4) then
				parse('customkill '..source..' "ST-1" '..id)
			elseif (weapon == 24) then
				parse('customkill '..source..' "DC-15s" '..id)
			elseif (weapon == 35) then
				parse('customkill '..source..' "DC-15x" '..id)
			elseif (weapon == 21) then
				parse('customkill '..source..' "DC-15x" '..id)
			end
			sw.hud_interface_clear(id)
		end	
	end
	return 1
end

function sw.say(id, txt)
	-- Check rank
	if (txt == "!rank") then
		sw.check_usgn_rank(id)
		return 1
	-- Show Top (GrandMaster League)
	elseif (txt == "!top") then
		local top = sw.get_rank_table()
		local col1 = "©255128128"
		msg2(id, col1.."=== Top "..sw_ampls_grandmaster.." ===")
		for i = 1, sw_ampls_grandmaster do
			if (top[i] ~= nil) then
				msg2(id, col1..""..i..". "..top[i][3].." ("..top[i][2].." points)")
			end
		end
	end
end

function sw.drop(id)
	if (sw_droping_item == 0) then
		return 1
	end
end

function sw.die(id)
	sw.hud_interface_clear(id)
	if (sw_droping_item == 0) then
		return 1
	end
end

function sw.buy(id)
	if (sw_buying_item == 0) then
		return 1
	end
end