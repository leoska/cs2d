---------------------
--  Valuables File --
---------------------

function array(m)
	local array = {}
	for i = 1, m do
		array[i] = 0
	end
	return array
end

function arrays(m, n)
	local array = {}
	for i = 1, m do
		array[i] = n
	end
	return array
end

-- Players values
sw.p_credits = array(32)
sw.p_page = array(32)
sw.p_class = array(32)
sw.p_subclass = array(32)
sw.p_health = array(32)
sw.p_barrier = array(32)
sw.p_levels = arrays(32, {})
sw.p_exp = arrays(32, {})
sw.p_maxexp = arrays(32, {})
sw.p_lasers = arrays(32, {arrays(sw_max_lasers, nil), arrays(sw_max_lasers, nil)})
sw.p_inventory = arrays(32, {})
sw.p_boxes = arrays(32, {})
sw.p_rank = arrays(32, {})
sw.p_interface = arrays(32, {})
sw.p_lasthit = array(32)
sw.p_load = array(32)
sw.p_times = arrays(32, {["hpreg"] = 0, ["brreg"] = 0, ["enreg"] = 0, ["invis"] = 0, ["cd"] = 0})