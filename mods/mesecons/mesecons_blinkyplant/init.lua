-- The BLINKY_PLANT

minetest.register_node("mesecons_blinkyplant:blinky_plant_off", {
	drawtype = "plantlike",
	visual_scale = 1,
	tiles = {"jeija_blinky_plant_off.png"},
	inventory_image = "jeija_blinky_plant_off.png",
	paramtype = "light",
	walkable = false,
	groups = {dig_immediate=3, mesecon = 2},
    	description="Blinky Plant",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, -0.5+0.6, 0.1},
	},
	mesecons = {receptor = {
		state = mesecon.state.off
	}}
})

minetest.register_node("mesecons_blinkyplant:blinky_plant_on", {
	drawtype = "plantlike",
	visual_scale = 1,
	tiles = {"jeija_blinky_plant_on.png"},
	inventory_image = "jeija_blinky_plant_off.png",
	paramtype = "light",
	walkable = false,
	groups = {dig_immediate=3, not_in_creative_inventory=1, mesecon = 2},
	drop='"mesecons_blinkyplant:blinky_plant_off" 1',
	light_source = LIGHT_MAX-7,
	description = "Blinky Plant",
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-0.1, -0.5, -0.1, 0.1, -0.5+0.6, 0.1},
	},
	mesecons = {receptor = {
		state = mesecon.state.on
	}}
})

minetest.register_craft({
	output = '"mesecons_blinkyplant:blinky_plant_off" 1',
	recipe = {
	{'','"group:mesecon_conductor_craftable"',''},
	{'','"group:mesecon_conductor_craftable"',''},
	{'"default:sapling"','"default:sapling"','"default:sapling"'},
	}
})

minetest.register_abm(
	{nodenames = {"mesecons_blinkyplant:blinky_plant_off"},
	interval = BLINKY_PLANT_INTERVAL,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		--minetest.env:remove_node(pos)
		minetest.env:add_node(pos, {name="mesecons_blinkyplant:blinky_plant_on"})
		nodeupdate(pos)	
		mesecon:receptor_on(pos)
	end,
})

minetest.register_abm({
	nodenames = {"mesecons_blinkyplant:blinky_plant_on"},
	interval = BLINKY_PLANT_INTERVAL,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		--minetest.env:remove_node(pos)
		minetest.env:add_node(pos, {name="mesecons_blinkyplant:blinky_plant_off"})
		nodeupdate(pos)	
		mesecon:receptor_off(pos)
	end,
})
