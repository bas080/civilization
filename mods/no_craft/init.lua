local no_craft = {}

no_craft.set_creative_formspec = function(player)
  player:set_inventory_formspec("size[8,1]"..
    "list[current_player;main;0,0;8,1;]")
    player:get_inventory():set_size("main", 8*1) --NotNick's contribution
end

minetest.register_on_joinplayer(function(player)
  if not minetest.setting_getbool("creative_mode") == false then
    return
  end
  no_craft.set_creative_formspec(player, 0, 1)
end)

minetest.register_on_dignode(function(pos, newnode, placer, oldnode)
  if placer:get_inventory():get_stack("main", 4):get_name() ~= "" then
    print(newnode.name)
  end
end)
