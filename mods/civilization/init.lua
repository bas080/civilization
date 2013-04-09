civilization = {}
local mod_name = "civilization"

dofile(minetest.get_modpath(mod_name).."/mods.lua")
dofile(minetest.get_modpath(mod_name).."/register_age_node.lua")
dofile(minetest.get_modpath(mod_name).."/register_mod_node.lua")

civilization.common_age_nodes = {"default:stick"}

civilization.register_age_node({
  name = "Wood",
  tiles = "default_tree.png",
  nodes = {"default:tree", "default:wood", "default:stick"}
})

civilization.register_age_node({
  name = "Stone",
  tiles = "default_cobble.png",
  nodes = {"default:stone", "default:cobble"}
})

civilization.register_age_node({
  name = "Bronze",
  tiles = "default_bronze_block.png",
  nodes = {"default:bronze_ingot", "default:bronzeblock"}
})

civilization.register_age_node({
  name = "Iron",
  tiles = "default_steel_block.png",
  nodes = {"default:steel_ingot", "default:iron_lump", "default:steelblock"}
})

civilization.register_age_node({
  name = "Mese",
  tiles = "default_mese_block.png",
  nodes = {"default:mese", "default:mese_crystal", "default:mese_crystal_fragment"}
})
--define smaller inventory abd 1x2 crafting grid
civilization.set_formspec = function(player)
  player:set_inventory_formspec(
    "size[5,3]"..
    "list[current_player;main;0,0;3,3;]"..
    "list[current_player;craft;3,0.5;1,2;]"..
    "list[current_player;craftpreview;4,1;1,1;]")
  player:get_inventory():set_size("main", 3*3) --NotNick's contribution
  player:get_inventory():set_width("craft", 1)
  player:get_inventory():set_size("craft", 2)
end
--set formspec
minetest.register_on_joinplayer(function(player)
  if not minetest.setting_getbool("creative_mode") == false then
    return
  end
  civilization.set_formspec(player, 0, 1)
end)

minetest.register_on_dignode(function(pos, newnode, placer, oldnode)
  if placer:get_inventory():get_stack("main", 4):get_name() ~= "" then
    print(newnode.name)
  end
end)
--oddly breakable by hand is no longer allowed. Tools are required
minetest.register_item(":", {
  type = "none",
  wield_image = "wieldhand.png",
  wield_scale = {x=1,y=1,z=2.5},
  tool_capabilities = {
    full_punch_interval = 0.9,
    max_drop_level = 0,
    groupcaps = {
      fleshy = {times={[2]=0.75, [3]=0.6}, uses=0, maxlevel=1},
      crumbly = {times={[3]=2}, uses=0, maxlevel=1},
      snappy = {times={[3]=0.40}, uses=0, maxlevel=1},
    }
  }
})
--give the wood age crafting.
minetest.register_on_newplayer(function(player)
  
  player:get_inventory():add_item('main', "civilization:".."Wood")
  player:get_inventory():add_item('main', 'default:tree 2')
end)

print("["..mod_name.."]".."Loaded!")
