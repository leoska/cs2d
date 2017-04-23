-------------------------------------------
-- Star Wars v0.6a by leoska			 --
-------------------------------------------
-- Team:				--
-- 1. LEO				--
-- Special for RU2D		--
--------------------------

---------------------------
-- List of Targets	-------
---------------------------

--[[ Namespaces (Tables) ]]--
sw = {}


--[[ Global Values ]]--
minutes = 0
seconds = 0
version = { release = 0, path = 0, debug = "a"}
admins = {}
adverts = {}
maps = {}
sw.stats_minutes = 0
sw.items = {}
sw.ranks = {}
sw.boxes = {}
sw.heroes = {}
sw.objects = {}
sw.rarity = {"Common", "Uncommon", "Rare", "Mythical", "Legendary"}


--[[ Dofiles ]]--
path = "sys/lua/Star Wars/"
dofile(path.."config/settings.cfg")
dofile(path.."config/config.cfg")
--dofile(path.."core/filter.lua")
dofile(path.."core/values.lua")
dofile(path.."core/updates.lua")
dofile(path.."core/funcs.lua")
dofile(path.."core/basic.lua")


--[[ Addhooks ]]--
addhook("startround", "sw.startround")
addhook("endround", "sw.endround")
addhook("second", "sw.second")
addhook("minute", "sw.minute")
addhook("serveraction", "sw.serveraction")
addhook("select", "sw.select")
addhook("menu", "sw.menu")
addhook("spawn", "sw.spawn")
addhook("team", "sw.team")
addhook("join", "sw.join")
addhook("hit", "sw.hit")
addhook("say", "sw.say")
addhook("drop", "sw.drop")
addhook("die", "sw.die")
addhook("buy", "sw.buy")

print(_VERSION)
print(os.date("%X", os.time()))
parse('restart')