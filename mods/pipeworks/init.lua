-- Pipeworks mod by Vanessa Ezekowitz - 2012-08-05
--
-- Entirely my own code.  This mod supplies various shapes of pipes
-- and devices that they can connect to such as pumps, valves, etc.
-- All pipes autoconnect as you lay them out, and devices will auto-
-- connect to them.
--
-- License: WTFPL
--

-- Un-comment the following dofile line to re-enable the old pipe nodes.
-- dofile(minetest.get_modpath("pipeworks").."/oldpipes.lua")
--

minetest.register_alias("pipeworks:pipe", "pipeworks:pipe_110000_empty")
local DEBUG = false

pipeworks_liquid_texture = "default_water.png"

pipe_leftstub = {
	{ -32/64, -2/64, -6/64,   1/64, 2/64, 6/64 },	-- pipe segment against -X face
	{ -32/64, -4/64, -5/64,   1/64, 4/64, 5/64 },
	{ -32/64, -5/64, -4/64,   1/64, 5/64, 4/64 },
	{ -32/64, -6/64, -2/64,   1/64, 6/64, 2/64 },

	{ -32/64, -3/64, -8/64, -30/64, 3/64, 8/64 },	-- (the flange for it)
	{ -32/64, -5/64, -7/64, -30/64, 5/64, 7/64 },
	{ -32/64, -6/64, -6/64, -30/64, 6/64, 6/64 },
	{ -32/64, -7/64, -5/64, -30/64, 7/64, 5/64 },
	{ -32/64, -8/64, -3/64, -30/64, 8/64, 3/64 }
}

pipe_rightstub = {
	{ -1/64, -2/64, -6/64,  32/64, 2/64, 6/64 },	-- pipe segment against +X face
	{ -1/64, -4/64, -5/64,  32/64, 4/64, 5/64 },
	{ -1/64, -5/64, -4/64,  32/64, 5/64, 4/64 },
	{ -1/64, -6/64, -2/64,  32/64, 6/64, 2/64 },

	{ 30/64, -3/64, -8/64, 32/64, 3/64, 8/64 },	-- (the flange for it)
	{ 30/64, -5/64, -7/64, 32/64, 5/64, 7/64 },
	{ 30/64, -6/64, -6/64, 32/64, 6/64, 6/64 },
	{ 30/64, -7/64, -5/64, 32/64, 7/64, 5/64 },
	{ 30/64, -8/64, -3/64, 32/64, 8/64, 3/64 }
}

pipe_bottomstub = {
	{ -2/64, -32/64, -6/64,   2/64, 1/64, 6/64 },	-- pipe segment against -Y face
	{ -4/64, -32/64, -5/64,   4/64, 1/64, 5/64 },
	{ -5/64, -32/64, -4/64,   5/64, 1/64, 4/64 },
	{ -6/64, -32/64, -2/64,   6/64, 1/64, 2/64 },

	{ -3/64, -32/64, -8/64, 3/64, -30/64, 8/64 },	-- (the flange for it)
	{ -5/64, -32/64, -7/64, 5/64, -30/64, 7/64 },
	{ -6/64, -32/64, -6/64, 6/64, -30/64, 6/64 },
	{ -7/64, -32/64, -5/64, 7/64, -30/64, 5/64 },
	{ -8/64, -32/64, -3/64, 8/64, -30/64, 3/64 }
}


pipe_topstub = {
	{ -2/64, -1/64, -6/64,   2/64, 32/64, 6/64 },	-- pipe segment against +Y face
	{ -4/64, -1/64, -5/64,   4/64, 32/64, 5/64 },
	{ -5/64, -1/64, -4/64,   5/64, 32/64, 4/64 },
	{ -6/64, -1/64, -2/64,   6/64, 32/64, 2/64 },

	{ -3/64, 30/64, -8/64, 3/64, 32/64, 8/64 },	-- (the flange for it)
	{ -5/64, 30/64, -7/64, 5/64, 32/64, 7/64 },
	{ -6/64, 30/64, -6/64, 6/64, 32/64, 6/64 },
	{ -7/64, 30/64, -5/64, 7/64, 32/64, 5/64 },
	{ -8/64, 30/64, -3/64, 8/64, 32/64, 3/64 }
}

pipe_frontstub = {
	{ -6/64, -2/64, -32/64,   6/64, 2/64, 1/64 },	-- pipe segment against -Z face
	{ -5/64, -4/64, -32/64,   5/64, 4/64, 1/64 },
	{ -4/64, -5/64, -32/64,   4/64, 5/64, 1/64 },
	{ -2/64, -6/64, -32/64,   2/64, 6/64, 1/64 },

	{ -8/64, -3/64, -32/64, 8/64, 3/64, -30/64 },	-- (the flange for it)
	{ -7/64, -5/64, -32/64, 7/64, 5/64, -30/64 },
	{ -6/64, -6/64, -32/64, 6/64, 6/64, -30/64 },
	{ -5/64, -7/64, -32/64, 5/64, 7/64, -30/64 },
	{ -3/64, -8/64, -32/64, 3/64, 8/64, -30/64 }
}

pipe_backstub = {
	{ -6/64, -2/64, -1/64,   6/64, 2/64, 32/64 },	-- pipe segment against -Z face
	{ -5/64, -4/64, -1/64,   5/64, 4/64, 32/64 },
	{ -4/64, -5/64, -1/64,   4/64, 5/64, 32/64 },
	{ -2/64, -6/64, -1/64,   2/64, 6/64, 32/64 },

	{ -8/64, -3/64, 30/64, 8/64, 3/64, 32/64 },	-- (the flange for it)
	{ -7/64, -5/64, 30/64, 7/64, 5/64, 32/64 },
	{ -6/64, -6/64, 30/64, 6/64, 6/64, 32/64 },
	{ -5/64, -7/64, 30/64, 5/64, 7/64, 32/64 },
	{ -3/64, -8/64, 30/64, 3/64, 8/64, 32/64 }
} 

pipe_selectboxes = {
	{ -32/64,  -8/64,  -8/64,  8/64,  8/64,  8/64 },
	{ -8/64 ,  -8/64,  -8/64, 32/64,  8/64,  8/64 },
	{ -8/64 , -32/64,  -8/64,  8/64,  8/64,  8/64 },
	{ -8/64 ,  -8/64,  -8/64,  8/64, 32/64,  8/64 },
	{ -8/64 ,  -8/64, -32/64,  8/64,  8/64,  8/64 },
	{ -8/64 ,  -8/64,  -8/64,  8/64,  8/64, 32/64 }
}

pipe_bendsphere = {	
	{ -4/64, -4/64, -4/64, 4/64, 4/64, 4/64 },
	{ -5/64, -3/64, -3/64, 5/64, 3/64, 3/64 },
	{ -3/64, -5/64, -3/64, 3/64, 5/64, 3/64 },
	{ -3/64, -3/64, -5/64, 3/64, 3/64, 5/64 }
}

--  Functions

dbg = function(s)
	if DEBUG then
		print('[PIPEWORKS] ' .. s)
	end
end

function pipes_fix_image_names(table, replacement)
	outtable={}
	for i in ipairs(table) do
		outtable[i]=string.gsub(table[i], "_XXXXX", replacement)
	end

	return outtable
end

function pipe_addbox(t, b)
	for i in ipairs(b)
		do table.insert(t, b[i])
	end
end

-- now define the nodes!

pipes_empty_nodenames = {}
pipes_full_nodenames = {}

for xm = 0, 1 do
for xp = 0, 1 do
for ym = 0, 1 do
for yp = 0, 1 do
for zm = 0, 1 do
for zp = 0, 1 do
	local outboxes = {}
	local outsel = {}
	local outimgs = {}

	if yp==1 then
		pipe_addbox(outboxes, pipe_topstub)
		table.insert(outsel, pipe_selectboxes[4])
		table.insert(outimgs, "pipeworks_pipe_end.png")
	else
		table.insert(outimgs, "pipeworks_plain.png")
	end
	if ym==1 then
		pipe_addbox(outboxes, pipe_bottomstub)
		table.insert(outsel, pipe_selectboxes[3])
		table.insert(outimgs, "pipeworks_pipe_end.png")
	else
		table.insert(outimgs, "pipeworks_plain.png")
	end
	if xp==1 then
		pipe_addbox(outboxes, pipe_rightstub)
		table.insert(outsel, pipe_selectboxes[2])
		table.insert(outimgs, "pipeworks_pipe_end.png")
	else
		table.insert(outimgs, "pipeworks_plain.png")
	end
	if xm==1 then
		pipe_addbox(outboxes, pipe_leftstub)
		table.insert(outsel, pipe_selectboxes[1])
		table.insert(outimgs, "pipeworks_pipe_end.png")
	else
		table.insert(outimgs, "pipeworks_plain.png")
	end
	if zp==1 then
		pipe_addbox(outboxes, pipe_backstub)
		table.insert(outsel, pipe_selectboxes[6])
		table.insert(outimgs, "pipeworks_pipe_end.png")
	else
		table.insert(outimgs, "pipeworks_plain.png")
	end
	if zm==1 then
		pipe_addbox(outboxes, pipe_frontstub)
		table.insert(outsel, pipe_selectboxes[5])
		table.insert(outimgs, "pipeworks_pipe_end.png")
	else
		table.insert(outimgs, "pipeworks_plain.png")
	end

	local jx = xp+xm
	local jy = yp+ym
	local jz = zp+zm

	if (jx+jy+jz) == 1 then
		if xm == 1 then 
			table.remove(outimgs, 3)
			table.insert(outimgs, 3, "^pipeworks_plain.png")
		end
		if xp == 1 then 
			table.remove(outimgs, 4)
			table.insert(outimgs, 4, "^pipeworks_plain.png")
		end
		if ym == 1 then 
			table.remove(outimgs, 1)
			table.insert(outimgs, 1, "^pipeworks_plain.png")
		end
		if xp == 1 then 
			table.remove(outimgs, 2)
			table.insert(outimgs, 2, "^pipeworks_plain.png")
		end
		if zm == 1 then 
			table.remove(outimgs, 5)
			table.insert(outimgs, 5, "^pipeworks_plain.png")
		end
		if zp == 1 then 
			table.remove(outimgs, 6)
			table.insert(outimgs, 6, "^pipeworks_plain.png")
		end
	end

	if jx+jy+jz >= 2 then
		pipe_addbox(outboxes, pipe_bendsphere)
	end

	if (jx==2 and jy~=2 and jz~=2) then
		table.remove(outimgs, 5)
		table.remove(outimgs, 5)
		table.insert(outimgs, 5, pipeworks_liquid_texture.."^pipeworks_windowed_XXXXX.png")
		table.insert(outimgs, 5, pipeworks_liquid_texture.."^pipeworks_windowed_XXXXX.png")
	end

	if (jx~=2 and jy~=2 and jz==2) or (jx~=2 and jy==2 and jz~=2) then
		table.remove(outimgs, 3)
		table.remove(outimgs, 3)
		table.insert(outimgs, 3, pipeworks_liquid_texture.."^pipeworks_windowed_XXXXX.png")
		table.insert(outimgs, 3, pipeworks_liquid_texture.."^pipeworks_windowed_XXXXX.png")
	end

	local pname = xm..xp..ym..yp..zm..zp
	local pgroups = ""

	if pname ~= "110000" then
		pgroups = {snappy=3, pipe=1, not_in_creative_inventory=1}
		pipedesc = "Pipe segment (empty, "..pname..")... You hacker, you."
		image = "pipeworks_plain.png"
	else
		pgroups = {snappy=3, pipe=1}
		pipedesc = "Pipe segment"
		image = nil
	end

	minetest.register_node("pipeworks:pipe_"..pname.."_empty", {
		description = pipedesc,
		drawtype = "nodebox",
		tiles = pipes_fix_image_names(outimgs, "_empty"),
		inventory_image = image,
		paramtype = "light",
		selection_box = {
	             	type = "fixed",
			fixed = outsel
		},
		node_box = {
			type = "fixed",
			fixed = outboxes
		},
		groups = pgroups,
		sounds = default.node_sound_wood_defaults(),
		walkable = true,
		drop = "pipeworks:pipe_110000_empty",
		pipelike=1,
		on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_int("pipelike",1)
		end,
		after_place_node = function(pos)
			pipe_scanforobjects(pos)
		end,
		after_dig_node = function(pos)
			pipe_scanforobjects(pos)
		end,
	})

	minetest.register_node("pipeworks:pipe_"..pname.."_loaded", {
		description = "Pipe segment (loaded, "..pname..")... You hacker, you.",
		drawtype = "nodebox",
		tiles = pipes_fix_image_names(outimgs, "_loaded"),
		inventory_image = image,
		paramtype = "light",
		selection_box = {
	             	type = "fixed",
			fixed = outsel
		},
		node_box = {
			type = "fixed",
			fixed = outboxes
		},
		groups = {snappy=3, pipe=1, not_in_creative_inventory=1},
		sounds = default.node_sound_wood_defaults(),
		walkable = true,
		drop = "pipeworks:pipe_110000_empty",
		pipelike=1,
		on_construct = function(pos)
			local meta = minetest.env:get_meta(pos)
			meta:set_int("pipelike",1)
		end,
		after_place_node = function(pos)
			pipe_scanforobjects(pos)
		end,
		after_dig_node = function(pos)
			pipe_scanforobjects(pos)
		end
	})
	table.insert(pipes_empty_nodenames,"pipeworks:pipe_"..pname.."_empty") -- for the abms
	table.insert(pipes_full_nodenames,"pipeworks:pipe_"..pname.."_loaded") -- for bacon
end
end
end
end
end
end

dofile(minetest.get_modpath("pipeworks").."/tubes.lua")
dofile(minetest.get_modpath("pipeworks").."/devices.lua")
dofile(minetest.get_modpath("pipeworks").."/autoplace.lua")
dofile(minetest.get_modpath("pipeworks").."/crafts.lua")
dofile(minetest.get_modpath("pipeworks").."/flowing_logic.lua")
dofile(minetest.get_modpath("pipeworks").."/compat.lua")
dofile(minetest.get_modpath("pipeworks").."/item_transport.lua")
dofile(minetest.get_modpath("pipeworks").."/autocrafter.lua")

minetest.register_alias("pipeworks:deployer_off", "technic:deployer_off")
minetest.register_alias("pipeworks:deployer_on", "technic:deployer_on")
minetest.register_alias("pipeworks:nodebreaker_off", "technic:node_breaker_off")
minetest.register_alias("pipeworks:nodebreaker_on", "technic:node_breaker_on")

print("Pipeworks loaded!")
