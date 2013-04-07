-- List of devices that should participate in the autoplace algorithm

pipes_devicelist = {
	"pump",
	"valve",
	"storage_tank_0",
	"storage_tank_1",
	"storage_tank_2",
	"storage_tank_3",
	"storage_tank_4",
	"storage_tank_5",
	"storage_tank_6",
	"storage_tank_7",
	"storage_tank_8",
	"storage_tank_9",
	"storage_tank_10"
}

-- tables

pipe_pumpbody = {
	{ -7/16, -6/16, -7/16, 7/16,  5/16, 7/16 },
	{ -8/16, -8/16, -8/16, 8/16, -6/16, 8/16 }
}

pipe_valvebody = {
	{ -4/16, -4/16, -4/16, 4/16, 4/16, 4/16 }
}

pipe_valvehandle_on = {
	{ -5/16, 4/16, -1/16, 0, 5/16, 1/16 }
}

pipe_valvehandle_off = {
	{ -1/16, 4/16, -5/16, 1/16, 5/16, 0 }
}

spigot_bottomstub = {
	{ -2/64, -16/64, -6/64,   2/64, 1/64, 6/64 },	-- pipe segment against -Y face
	{ -4/64, -16/64, -5/64,   4/64, 1/64, 5/64 },
	{ -5/64, -16/64, -4/64,   5/64, 1/64, 4/64 },
	{ -6/64, -16/64, -2/64,   6/64, 1/64, 2/64 },

	{ -3/64, -16/64, -8/64, 3/64, -14/64, 8/64 },	-- (the flange for it)
	{ -5/64, -16/64, -7/64, 5/64, -14/64, 7/64 },
	{ -6/64, -16/64, -6/64, 6/64, -14/64, 6/64 },
	{ -7/64, -16/64, -5/64, 7/64, -14/64, 5/64 },
	{ -8/64, -16/64, -3/64, 8/64, -14/64, 3/64 }
}

spigot_stream = { 
	{ -3/64, -48/64, -5/64, 3/64, -16/64, 5/64 },
	{ -4/64, -48/64, -4/64, 4/64, -16/64, 4/64 },
	{ -5/64, -48/64, -3/64, 5/64, -16/64, 3/64 }
}

entry_panel = {
	{ -8/16, -8/16, -1/16, 8/16, 8/16, 1/16 }
}
-- Now define the nodes.

local states = { "on", "off" }
local dgroups = ""

for s in ipairs(states) do

	if states[s] == "off" then
		dgroups = {snappy=3, pipe=1}
	else
		dgroups = {snappy=3, pipe=1, not_in_creative_inventory=1}
	end

	local pumpboxes = {}
	pipe_addbox(pumpboxes, pipe_pumpbody)
	pipe_addbox(pumpboxes, pipe_topstub)

	minetest.register_node("pipeworks:pump_"..states[s], {
		description = "Pump/Intake Module",
		drawtype = "nodebox",
		tiles = {
			"pipeworks_pump_top.png",
			"pipeworks_pump_bottom.png",
			"pipeworks_pump_sides.png",
			"pipeworks_pump_sides.png",
			"pipeworks_pump_sides.png",
			"pipeworks_pump_"..states[s]..".png"
		},
		paramtype = "light",
		paramtype2 = "facedir",
		selection_box = {
	             	type = "fixed",
			fixed = { -0.5, -0.5, -0.5, 0.5, 0.5, 0.5 }
		},
		node_box = {
			type = "fixed",
			fixed = pumpboxes
		},
		groups = dgroups,
		sounds = default.node_sound_wood_defaults(),
		walkable = true,
		pipelike = 1,
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
		drop = "pipeworks:pump_off"
	})
	
	local valveboxes = {}
	pipe_addbox(valveboxes, pipe_leftstub)
	pipe_addbox(valveboxes, pipe_valvebody)
	if states[s] == "off" then 
		pipe_addbox(valveboxes, pipe_valvehandle_off)
	else
		pipe_addbox(valveboxes, pipe_valvehandle_on)
	end
	pipe_addbox(valveboxes, pipe_rightstub)
	local tilex = "pipeworks_valvebody_ends.png"
	local tilez = "pipeworks_valvebody_sides.png"

	minetest.register_node("pipeworks:valve_"..states[s], {
		description = "Valve",
		drawtype = "nodebox",
		tiles = {
			"pipeworks_valvebody_top_"..states[s]..".png",
			"pipeworks_valvebody_bottom.png",
			tilex,
			tilex,
			tilez,
			tilez,
		},
		paramtype = "light",
		paramtype2 = "facedir",
		selection_box = {
	             	type = "fixed",
			fixed = { -8/16, -4/16, -5/16, 8/16, 5/16, 5/16 }
		},
		node_box = {
			type = "fixed",
			fixed = valveboxes
		},
		groups = dgroups,
		sounds = default.node_sound_wood_defaults(),
		walkable = true,
		pipelike = 1,
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
		drop = "pipeworks:valve_off",
		pipelike=1,
	})
end

-- grating

minetest.register_node("pipeworks:grating", {
	description = "Decorative grating",
	tiles = {
		"pipeworks_grating_top.png",
		"pipeworks_grating_sides.png",
		"pipeworks_grating_sides.png",
		"pipeworks_grating_sides.png",
		"pipeworks_grating_sides.png",
		"pipeworks_grating_sides.png"
	},
	paramtype = "light",
	groups = {snappy=3, pipe=1},
	sounds = default.node_sound_wood_defaults(),
	walkable = true,
	after_place_node = function(pos)
		pipe_scanforobjects(pos)
	end,
	after_dig_node = function(pos)
		pipe_scanforobjects(pos)
	end,
	pipelike=1,
	on_construct = function(pos)
	local meta = minetest.env:get_meta(pos)
	meta:set_int("pipelike",1)
	end,
})

-- outlet spigot

	local spigotboxes = {}
	pipe_addbox(spigotboxes, pipe_backstub)
	pipe_addbox(spigotboxes, spigot_bottomstub)
	pipe_addbox(spigotboxes, pipe_bendsphere)

	local spigotboxes_pouring = {}
	pipe_addbox(spigotboxes_pouring, spigot_stream)
	pipe_addbox(spigotboxes_pouring, pipe_backstub)
	pipe_addbox(spigotboxes_pouring, spigot_bottomstub)
	pipe_addbox(spigotboxes_pouring, pipe_bendsphere)

minetest.register_node("pipeworks:spigot", {
	description = "Spigot outlet",
	drawtype = "nodebox",
	tiles = {
		"pipeworks_spigot_sides.png",
		"pipeworks_spigot_sides.png",
		"pipeworks_spigot_sides.png",
		"pipeworks_spigot_sides.png",
		"pipeworks_pipe_end_empty.png",
		"pipeworks_spigot_sides.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=3, pipe=1},
	sounds = default.node_sound_wood_defaults(),
	walkable = true,
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
	node_box = {
		type = "fixed",
		fixed = spigotboxes,
	},
	selection_box = {
		type = "fixed",
		fixed = { -2/16, -6/16, -2/16, 2/16, 2/16, 8/16 }
	}
})

minetest.register_node("pipeworks:spigot_pouring", {
	description = "Spigot outlet",
	drawtype = "nodebox",
	tiles = {
		"pipeworks_spigot_sides.png",
		"pipeworks_spigot_sides.png",
		"default_water.png^pipeworks_spigot_sides2.png",
		"default_water.png^pipeworks_spigot_sides2.png",
		"default_water.png^pipeworks_spigot_sides2.png",
		"default_water.png^pipeworks_spigot_sides2.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=3, pipe=1},
	sounds = default.node_sound_wood_defaults(),
	walkable = true,
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
	node_box = {
		type = "fixed",
		fixed = spigotboxes_pouring,
	},
	selection_box = {
		type = "fixed",
		fixed = { -2/16, -6/16, -2/16, 2/16, 2/16, 8/16 }
	},
	drop = "pipeworks:spigot",
})


-- sealed pipe entry/exit (decorative horizontal pipe passing through a metal
-- wall, for use in places where walls should look like they're airtight)

	local airtightboxes = {}
	pipe_addbox(airtightboxes, pipe_frontstub)
	pipe_addbox(airtightboxes, pipe_backstub)
	pipe_addbox(airtightboxes, entry_panel)

minetest.register_node("pipeworks:entry_panel", {
	description = "Airtight Pipe entry/exit",
	drawtype = "nodebox",
	tiles = {
		"pipeworks_plain.png",
		"pipeworks_plain.png",
		"pipeworks_plain.png",
		"pipeworks_plain.png",
		"pipeworks_pipe_end_empty.png",
		"pipeworks_pipe_end_empty.png"
	},
	paramtype = "light",
	paramtype2 = "facedir",
	groups = {snappy=3, pipe=1},
	sounds = default.node_sound_wood_defaults(),
	walkable = true,
	after_place_node = function(pos)
		pipe_scanforobjects(pos)
	end,
	after_dig_node = function(pos)
		pipe_scanforobjects(pos)
	end,
	pipelike=1,
	on_construct = function(pos)
	local meta = minetest.env:get_meta(pos)
	meta:set_int("pipelike",1)
	end,
	node_box = {
		type = "fixed",
		fixed = airtightboxes,
	},
})

-- tanks

for fill = 0, 10 do
	if fill == 0 then 
		filldesc="empty"
		sgroups = {snappy=3, pipe=1, tankfill=fill+1}
		image = nil
	else
		filldesc=fill.."0% full"
		sgroups = {snappy=3, pipe=1, tankfill=fill+1, not_in_creative_inventory=1}
		image = "pipeworks_storage_tank_fittings.png"
	end

	minetest.register_node("pipeworks:expansion_tank_"..fill, {
		description = "Expansion Tank ("..filldesc..")... You hacker, you.",
		tiles = {
			"pipeworks_storage_tank_fittings.png",
			"pipeworks_storage_tank_fittings.png",
			"pipeworks_storage_tank_back.png",
			"pipeworks_storage_tank_back.png",
			"pipeworks_storage_tank_back.png",
			pipeworks_liquid_texture.."^pipeworks_storage_tank_front_"..fill..".png"
		},
		inventory_image = image,
		paramtype = "light",
		paramtype2 = "facedir",
		groups = {snappy=3, pipe=1, tankfill=fill+1, not_in_creative_inventory=1},
		sounds = default.node_sound_wood_defaults(),
		walkable = true,
		drop = "pipeworks:storage_tank_"..fill,
		after_place_node = function(pos)
			pipe_look_for_stackable_tanks(pos)
			pipe_scanforobjects(pos)
		end,
		after_dig_node = function(pos)
			pipe_scanforobjects(pos)
		end,
		pipelike=0,
		on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("pipelike",0)
		end,
	})

	minetest.register_node("pipeworks:storage_tank_"..fill, {
		description = "Fluid Storage Tank ("..filldesc..")",
		tiles = {
			"pipeworks_storage_tank_fittings.png",
			"pipeworks_storage_tank_fittings.png",
			"pipeworks_storage_tank_back.png",
			"pipeworks_storage_tank_back.png",
			"pipeworks_storage_tank_back.png",
			pipeworks_liquid_texture.."^pipeworks_storage_tank_front_"..fill..".png"
		},
		inventory_image = image,
		paramtype = "light",
		paramtype2 = "facedir",
		groups = sgroups,
		sounds = default.node_sound_wood_defaults(),
		walkable = true,
		after_place_node = function(pos)
			pipe_look_for_stackable_tanks(pos)
			pipe_scanforobjects(pos)
		end,
		after_dig_node = function(pos)
			pipe_scanforobjects(pos)
		end,
		pipelike=1,
		on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_int("pipelike",1)
		end,
	})
end

-- various actions

minetest.register_on_punchnode(function (pos, node)
	if node.name=="pipeworks:valve_on" then 
		fdir = minetest.env:get_node(pos).param2
		minetest.env:add_node(pos, { name = "pipeworks:valve_off", param2 = fdir })
		local meta = minetest.env:get_meta(pos)
		meta:set_int("pipelike",0)
	end
end)

minetest.register_on_punchnode(function (pos, node)
	if node.name=="pipeworks:valve_off" then 
		fdir = minetest.env:get_node(pos).param2
		minetest.env:add_node(pos, { name = "pipeworks:valve_on", param2 = fdir })
		local meta = minetest.env:get_meta(pos)
		meta:set_int("pipelike",1)
	end
end)

minetest.register_on_punchnode(function (pos, node)
	if node.name=="pipeworks:pump_on" then 
		fdir = minetest.env:get_node(pos).param2
		minetest.env:add_node(pos, { name = "pipeworks:pump_off", param2 = fdir })
	end
end)

minetest.register_on_punchnode(function (pos, node)
	if node.name=="pipeworks:pump_off" then 
		fdir = minetest.env:get_node(pos).param2
		minetest.env:add_node(pos, { name = "pipeworks:pump_on", param2 = fdir })
	end
end)

-- backwards compatibility

minetest.register_alias("pipeworks:intake", "pipeworks:grating")
minetest.register_alias("pipeworks:outlet", "pipeworks:grating")
minetest.register_alias("pipeworks:pump_off_x", "pipeworks:pump_off")
minetest.register_alias("pipeworks:pump_off_z", "pipeworks:pump_off")
minetest.register_alias("pipeworks:pump_on_x", "pipeworks:pump_on")
minetest.register_alias("pipeworks:pump_on_z", "pipeworks:pump_on")
minetest.register_alias("pipeworks:valve_off_x", "pipeworks:valve_off")
minetest.register_alias("pipeworks:valve_off_z", "pipeworks:valve_off")
minetest.register_alias("pipeworks:valve_on_x", "pipeworks:valve_on")
minetest.register_alias("pipeworks:valve_on_z", "pipeworks:valve_on")
minetest.register_alias("pipeworks:storage_tank_0_x", "pipeworks:storage_tank_0")
minetest.register_alias("pipeworks:storage_tank_0_z", "pipeworks:storage_tank_0")
minetest.register_alias("pipeworks:storage_tank_1_x", "pipeworks:storage_tank_1")
minetest.register_alias("pipeworks:storage_tank_1_z", "pipeworks:storage_tank_1")
minetest.register_alias("pipeworks:storage_tank_2_x", "pipeworks:storage_tank_2")
minetest.register_alias("pipeworks:storage_tank_2_z", "pipeworks:storage_tank_2")
minetest.register_alias("pipeworks:storage_tank_3_x", "pipeworks:storage_tank_3")
minetest.register_alias("pipeworks:storage_tank_3_z", "pipeworks:storage_tank_3")
minetest.register_alias("pipeworks:storage_tank_4_x", "pipeworks:storage_tank_4")
minetest.register_alias("pipeworks:storage_tank_4_z", "pipeworks:storage_tank_4")
minetest.register_alias("pipeworks:storage_tank_5_x", "pipeworks:storage_tank_5")
minetest.register_alias("pipeworks:storage_tank_5_z", "pipeworks:storage_tank_5")
minetest.register_alias("pipeworks:storage_tank_6_x", "pipeworks:storage_tank_6")
minetest.register_alias("pipeworks:storage_tank_6_z", "pipeworks:storage_tank_6")
minetest.register_alias("pipeworks:storage_tank_7_x", "pipeworks:storage_tank_7")
minetest.register_alias("pipeworks:storage_tank_7_z", "pipeworks:storage_tank_7")
minetest.register_alias("pipeworks:storage_tank_8_x", "pipeworks:storage_tank_8")
minetest.register_alias("pipeworks:storage_tank_8_z", "pipeworks:storage_tank_8")
minetest.register_alias("pipeworks:storage_tank_9_x", "pipeworks:storage_tank_9")
minetest.register_alias("pipeworks:storage_tank_9_z", "pipeworks:storage_tank_9")
minetest.register_alias("pipeworks:storage_tank_10_x", "pipeworks:storage_tank_10")
minetest.register_alias("pipeworks:storage_tank_10_z", "pipeworks:storage_tank_10")

