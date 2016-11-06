-------------------------------------
-- Star Wars mod v0.5a by AoM Clan --
-------------------------------------
-- Team:			--
-- 1. LEO			--
-- Special for RU2D	--
----------------------

---------------------------------------------------
-- List of Targets							-------
-- 1. Fix grenade							--   --
-- 2. Fix Move img 							--   --
-- 3. Left-Hand img 						--   --
-- 4. Fix outing of memory (rewrite logic)	-- - --
-- 5. Add Block for Saber 					--   --
---------------------------------------------------

--[[ Global Values and Support Functions ]]--
function arrays(m, n)
	local array = {}
	for i = 1, m do
		array[i] = n
	end
	return array
end

admins = {5910}
sw_sound_distance = 350
sw_bullet_lifetime = 400
sw_p_locals = {}
sw_p_debug = {}
for i = 1, 32 do
	sw_p_locals[i] = { ["imageproj"] = arrays(50, nil), ["x"] = arrays(50, 0), ["y"] = arrays(50, 0), ["incx"] = arrays(50, 0), ["incy"] = arrays(50, 0),
						["rot"] = arrays(50, 0), ["k"] = arrays(50, 0), ["imagelight"] = arrays(50, nil), ["lightsaber"] = nil, ["lsb"] = nil,
						["canedge"] = false, ["grenade"] = false, ["block"] = false }
	sw_p_debug[i] = { ["debugconsole"] = false }
end

function freeid(p)
	for i = 1, 50 do
		if (sw_p_locals[p]["imageproj"][i] == nil) then
			return i;
		end
	end
end

function freeimg(img)
	freeimage(tonumber(img))
end

function freeedge(id)
	sw_p_locals[tonumber(id)]["canedge"] = false
end

function checkadmin(usgn)
	for i = 1, #admins do
		if (usgn == admins[i]) then
			return true
		end
	end
	return false
end

function __free(id)
	for i = 1, 50 do
		if (sw_p_locals[id]["imageproj"][i] ~= nil) then
			freeimage(sw_p_locals[id]["imageproj"][i])
			sw_p_locals[id]["imageproj"][i] = nil
		end
		if (sw_p_locals[id]["imagelight"][i] ~= nil) then
			freeimage(sw_p_locals[id]["imagelight"][i])
			sw_p_locals[id]["imagelight"][i] = nil
		end
	end
	if (sw_p_locals[id]["lightsaber"] ~= nil) then
		freeimage(sw_p_locals[id]["lightsaber"])
		sw_p_locals[id]["lightsaber"] = nil
	end
	if (sw_p_locals[id]["lsb"] ~= nil) then
		freeimage(sw_p_locals[id]["lsb"])
		sw_p_locals[id]["lsb"] = nil
	end
end

function __createlaser(id)
	local imgid = freeid(id)
	sw_p_locals[id]["imagelight"][imgid] = image("gfx/sprites/flare4.bmp", 0, 0, 1)
	sw_p_locals[id]["imageproj"][imgid] = image("gfx/sprites/laserbeam1.bmp", 0, 0, 1)
	local img = sw_p_locals[id]["imageproj"][imgid]
	local light = sw_p_locals[id]["imagelight"][imgid]
	if (player(id, "team") == 1) then
		imagecolor(img, 255, 0, 0)
		imagecolor(light, 255, 0, 0)
	elseif (player(id, "team") == 2) then
		imagecolor(img, 0, 0, 255)
		imagecolor(light, 0, 0, 255)
	end
	imagescale(img, 0.1, 0.8)

	local px = player(id, "x")
	local py = player(id, "y")
	local pr = math.rad(player(id, "rot") - 90)
	local incx = math.cos(pr)
	local incy = math.sin(pr)
	sw_p_locals[id]["incx"][imgid] = incx
	sw_p_locals[id]["incy"][imgid] = incy
	sw_p_locals[id]["x"][imgid] = px + (incx * 20)
	sw_p_locals[id]["y"][imgid] = py + (incy * 20)
	sw_p_locals[id]["rot"][imgid] = player(id, "rot")
	sw_p_locals[id]["k"][imgid] = 0

	imageblend(img, 1)
	imageblend(light, 1)
	imagealpha(light, 0.2)
	imagescale(img, 0.1, 0.8)
	local cx = px + (incx * 20)
	local cy = py + (incy * 20)
	imagepos(img, cx, cy, player(id, "rot"))
	imagepos(light, cx, cy, 0)
	
end

function __destroylaser(id, las)
	if (sw_p_locals[id]["imageproj"][las] ~= nil) then
		freeimage(sw_p_locals[id]["imageproj"][las])
		sw_p_locals[id]["imageproj"][las] = nil
	end
	if (sw_p_locals[id]["imagelight"][las] ~= nil) then
		freeimage(sw_p_locals[id]["imagelight"][las])
		sw_p_locals[id]["imagelight"][las] = nil
	end
end

function __createsaber(id)
	sw_p_locals[id]["lsb"] = image("gfx/sprites/flare4.bmp", 0, 0, 1)
	sw_p_locals[id]["lightsaber"] = image("gfx/sw/sh_lightsaber.PNG", 1, 0, 1)
	local img = sw_p_locals[id]["lightsaber"] 
	local light = sw_p_locals[id]["lsb"]
	if (player(id, "team") == 1) then
		imagecolor(img, 255, 0, 0)
		imagecolor(light, 255, 0, 0)
	elseif (player(id, "team") == 2) then
		imagecolor(img, 0, 0, 255)
		imagecolor(light, 0, 0, 255)
	end
	imageblend(light, 1)
	imagealpha(light, 0.25)

	local plsl = player(0, "table")
	local px = player(id, "x")
	local py = player(id, "y")
	-- Sound of Saber (ON)
	for _, i in pairs(plsl) do
		if (dist(px, py, player(i, "x"), player(i, "y")) <= sw_sound_distance) then
			parse("sv_sound2 "..i.." \"sw/lb_on.wav\"")
		end
	end
end

function __destroysaber(id)
	if (sw_p_locals[id]["lightsaber"] ~= nil) then
		freeimage(sw_p_locals[id]["lightsaber"])
		sw_p_locals[id]["lightsaber"] = nil
	end
	if (sw_p_locals[id]["lsb"] ~= nil) then
		freeimage(sw_p_locals[id]["lsb"])
		sw_p_locals[id]["lsb"] = nil
	end
end

function dist(x1, y1, x2, y2)
	return math.sqrt((x1 - x2) ^ 2 + (y1 - y2) ^ 2)
end

--[[ General Functions ]]--
-- Startround
sw_startround = function()
	local pls = player(0, "table")
	for i = 1, #pls do
		if (player(pls[i], "weapontype") == 50) then
			if (sw_p_locals[pls[i]]["lightsaber"] ~= nil) then
				__createsaber(pls[i])
			end
		end
	end
end

-- Always
sw_always = function()
	local pls = player(0, "table")
	local j
	local img
	local light
	local lol
	for i = 1, #pls do
		if (player(pls[i], "exists")) then
			-- Lasers
			for j = 1, 50 do
				img = sw_p_locals[pls[i]]["imageproj"][j]
				light = sw_p_locals[pls[i]]["imagelight"][j]
				if (img ~= nil) then
					local x = sw_p_locals[pls[i]]["x"][j] 
					local y = sw_p_locals[pls[i]]["y"][j]
					local incx = sw_p_locals[pls[i]]["incx"][j] 
					local incy = sw_p_locals[pls[i]]["incy"][j] 
					local rot = sw_p_locals[pls[i]]["rot"][j]
					local cx = x + incx * 32
					local cy = y + incy * 32
					tween_move(img, 20, cx, cy, rot)
					tween_move(light, 20, cx, cy, 0)

					sw_p_locals[pls[i]]["x"][j] = cx
					sw_p_locals[pls[i]]["y"][j] = cy
					if (tile(cx / 32, cy / 32, "wall")) then
						__destroylaser(pls[i], j)
					end
					local plsl = player(0, "tableliving")
					for _, p in pairs(plsl) do
						if ((dist(cx, cy, player(p, "x"), player(p, "y")) <= 20) and (p ~= i)) then
							-- Edge system
							if (sw_p_locals[p]["canedge"]) then
								local var = math.ceil(math.random(1, 3))
								local angle = math.random(90, 180)
								if ((var - 1) < 2) then
									angle = -angle
								end
								local dir = math.rad(sw_p_locals[pls[i]]["rot"][j] + angle)
								local _incx = math.cos(dir)
								local _incy = math.sin(dir)
								sw_p_locals[pls[i]]["incx"][j] = _incx
								sw_p_locals[pls[i]]["incy"][j] = _incy
								sw_p_locals[pls[i]]["rot"][j] = sw_p_locals[pls[i]]["rot"][j] + 90 + angle

								sw_p_locals[p]["canedge"] = false
								-- Sound of edge
								local plss = player(0, "table")
								for _t, s in pairs(plss) do
									if (dist(cx, cy, player(s, "x"), player(s, "y")) <= sw_sound_distance) then
										parse("sv_sound2 "..s.." \"sw/lb_edge"..var..".wav\"")
									end
								end
							else
								__destroylaser(pls[i], j)
							end
						end
					end

					-- Live Time
					sw_p_locals[pls[i]]["k"][j] = sw_p_locals[pls[i]]["k"][j] + 1 
					if (sw_p_locals[pls[i]]["k"][j] > sw_bullet_lifetime) then
						__destroylaser(pls[i], j)
					end
				end
			end

			-- Laser Saber
			if (sw_p_locals[pls[i]]["lightsaber"] ~= nil) then
				local pr = math.rad(player(pls[i], "rot") - 90)
				local incx = math.cos(pr)
				local incy = math.sin(pr)
				local cx = player(pls[i], "x") + (incx * 18)
				local cy = player(pls[i], "y") + (incy * 18)
				imagepos(sw_p_locals[pls[i]]["lightsaber"], cx, cy, player(pls[i], "rot"))
				imagepos(sw_p_locals[pls[i]]["lsb"], cx, cy, 0)
			end
		end
	end
end

-- Attack
sw_attack = function(id)
	if ((player(id, "weapontype") < 50) and (not (sw_p_locals[id]["grenade"]))) then
		__createlaser(id)

		local px = player(id, "x")
		local py = player(id, "y")
		-- Sound of Blaster
		local plsl = player(0, "table")
		for _, i in pairs(plsl) do
			if (dist(px, py, player(i, "x"), player(i, "y")) <= sw_sound_distance) then
				if (player(id, "weapontype") < 10) then
					parse("sv_sound2 "..i.." \"sw/pistol-1.wav\"")
				else
					local n = math.ceil(math.random(1, 2))
					parse("sv_sound2 "..i.." \"sw/trprsht"..n..".wav\"")
				end
			end
		end
	elseif (player(id, "weapontype") == 50) then -- Laser Saber
		local img = image("gfx/sw/knifeslash.bmp", 1, 0, 1)
		local pr = math.rad(player(id, "rot") - 90)
		local incx = math.cos(pr)
		local incy = math.sin(pr)
		local cx = player(id, "x") + (incx * 30)
		local cy = player(id, "y") + (incy * 30)
		imageblend(img, 1)
		imagepos(img, cx, cy, player(id, "rot"))
		tween_alpha(img, 200, 0)
		timer(200, "freeimg", tostring(img))

		-- Edge system
		sw_p_locals[id]["canedge"] = true
		timer(200, "freeedge", tostring(id))

		-- Sound of Light Saber
		local plsl = player(0, "table")
		for _, i in pairs(plsl) do
			if (dist(cx, cy, player(i, "x"), player(i, "y")) <= sw_sound_distance) then
				parse("sv_sound2 "..i.." \"sw/lb_slash.wav\"")
			end
		end
	end
end

-- Attack2
sw_attack2 = function(id)
	sw_p_locals[id]["block"] = not (sw_p_locals[id]["block"])
	if (sw_p_locals[id]["block"]) then
		
	else
		
	end
end

-- Hit
sw_hit = function(id, source, weapon, hpdmg)
	local p_team = player(id, "team")
	local s_team = player(source, "team")
	if (id ~= source) then
		if (weapon == 50) then
			local cx = player(id, "x")
			local cy = player(id, "y")
			-- Sound of Light Saber
			local plsl = player(0, "table")
			for _, i in pairs(plsl) do
				if (dist(cx, cy, player(i, "x"), player(i, "y")) <= sw_sound_distance) then
					parse("sv_sound2 "..i.." \"sw/lb_hit.wav\"")
				end
			end
			if (p_team ~= s_team) then
				parse("customkill "..source.." \"Light Saber\" "..id)
			end
		end

		if (sw_p_locals[id]["canedge"]) then
			return 1
		end
	end
end

-- Select
sw_select = function(id, type, mode)
	sw_p_locals[id]["grenade"] = false
	if ((type == 50) and (sw_p_locals[id]["lightsaber"] == nil)) then
		__createsaber(id)
	elseif (type ~= 50) then
		if (sw_p_locals[id]["lightsaber"] ~= nil) then
			__destroysaber(id)

			--[[local plsl = player(0, "table")
			local px = player(id, "x")
			local py = player(id, "y")
			-- Sound
			for _, i in pairs(plsl) do
				if (dist(px, py, player(i, "x"), player(i, "y")) <= 500) then
					parse("sv_sound2 "..i.." \"sw/lb_on.wav\"")
				end
			end]]
		end
	elseif (type == 51) then
		sw_p_locals[id]["grenade"] = true
	end
end

-- Spawn
sw_spawn = function(id)
	if ((sw_p_locals[id]["lightsaber"] ~= nil) and (player(id, "weapontype") ~= 50)) then
		__destroysaber(id)
	end
end

-- Menu
sw_menu = function(id, men, but)
end

-- Die
sw_die = function(id, victim)
	if (sw_p_locals[victim]["lightsaber"] ~= nil) then
		__destroysaber(victim)
	end
end

-- Team
sw_team = function(id)
	parse(string.format("hudtxt2 %d %d \"%s\" %d %d %d", id, 0, "©000255000[AoM] Star Wars v0.5a", 320, 10, 1))
	parse(string.format("hudtxt2 %d %d \"%s\" %d %d %d", id, 1, "©255128128It's so have some bugs!", 320, 25, 1))
end

-- ServerAction
sw_serveraction = function(id, but)
	if (but == 3) then
		if (checkadmin(player(id, "usgn"))) then
			menu(id, "Debug Menu@b, Debug Mode | OFF, Debug Console | OFF, Enter Console,,,Reset LUA")
		end
	end
end

-- Buy
sw_buy = function(id, weapon)
	if ((weapon < 56) or (weapon > 62)) then
		__destroysaber(id)
	end
end

-- Join
sw_join = function(id)
	sw_p_locals[id] = { ["imageproj"] = arrays(50, nil), ["x"] = arrays(50, 0), ["y"] = arrays(50, 0), ["incx"] = arrays(50, 0), ["incy"] = arrays(50, 0),
						["rot"] = arrays(50, 0), ["k"] = arrays(50, 0), ["imagelight"] = arrays(50, nil), ["lightsaber"] = nil, ["lsb"] = nil,
						["canedge"] = false, ["grenade"] = false, ["block"] = false }
	sw_p_debug[id] = { ["debugconsole"] = false }
end

-- Leave
sw_leave = function(id)
	sw_p_locals[id] = { ["imageproj"] = arrays(50, nil), ["x"] = arrays(50, 0), ["y"] = arrays(50, 0), ["incx"] = arrays(50, 0), ["incy"] = arrays(50, 0),
						["rot"] = arrays(50, 0), ["k"] = arrays(50, 0), ["imagelight"] = arrays(50, nil), ["lightsaber"] = nil, ["lsb"] = nil,
						["canedge"] = false, ["grenade"] = false, ["block"] = false }
	sw_p_debug[id] = { ["debugconsole"] = false }
end

--[[ AddHooks ]]--
addhook("startround", "sw_startround")
addhook("always", "sw_always")
addhook("attack", "sw_attack")
addhook("attack2", "sw_attack2")
addhook("hit", "sw_hit")
addhook("select", "sw_select")
addhook("spawn", "sw_spawn")
addhook("menu", "sw_menu")
addhook("die", "sw_die")
addhook("team", "sw_team")
addhook("serveraction", "sw_serveraction")
addhook("buy", "sw_buy")
addhook("join", "sw_join")
addhook("leave", "sw_leave")
print(_VERSION)
parse("restart")

--▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ஜ۩۞۩ஜ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬--