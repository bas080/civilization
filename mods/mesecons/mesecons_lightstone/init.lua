function mesecon:lightstone_add(name, base_item, texture_off, texture_on)
	minetest.register_node("mesecons_lightstone:lightstone_" .. name .. "_off", {
	tiles = {texture_off},
	inventory_image = minetest.inventorycube(texture_off),
	groups = {cracky=2, mesecon_effector_off = 1, mesecon = 2},
	description=name.." Lightstone",
	sounds = default.node_sound_stone_defaults(),
	mesecons = {effector = {
		action_on = function (pos, node)
			mesecon:swap_node(pos, "mesecons_lightstone:lightstone_" .. name .. "_on")
		end
	}}
    })
	minetest.register_node("mesecons_lightstone:lightstone_" .. name .. "_on", {
	tiles = {texture_on},
	inventory_image = minetest.inventorycube(texture_on),
	groups = {cracky=2,not_in_creative_inventory=1, mesecon = 2},
	drop = "node mesecons_lightstone:lightstone_" .. name .. "_off 1",
	light_source = LIGHT_MAX-2,
	sounds = default.node_sound_stone_defaults(),
	mesecons = {effector = {
		action_off = function (pos, node)
			mesecon:swap_node(pos, "mesecons_lightstone:lightstone_" .. name .. "_off")
		end
	}}
    })

    minetest.register_craft({
	    output = "node mesecons_lightstone:lightstone_" .. name .. "_off 1",
	    recipe = {
		    {'',base_item,''},
		    {base_item,'default:torch',base_item},
		    {'','group:mesecon_conductor_craftable',''},
	    }
    })
end


mesecon:lightstone_add("red", "craft default:clay_brick 1", "jeija_lightstone_red_off.png", "jeija_lightstone_red_on.png")
mesecon:lightstone_add("green", "node default:cactus 1", "jeija_lightstone_green_off.png", "jeija_lightstone_green_on.png")
mesecon:lightstone_add("blue", "node mesecons_materials:fiber 1", "jeija_lightstone_blue_off.png", "jeija_lightstone_blue_on.png")
mesecon:lightstone_add("gray", "node default:cobble 1", "jeija_lightstone_gray_off.png", "jeija_lightstone_gray_on.png")
mesecon:lightstone_add("darkgray", "node default:gravel 1", "jeija_lightstone_darkgray_off.png", "jeija_lightstone_darkgray_on.png")
