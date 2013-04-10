--THIS API IS WIP
--IT WILL ALLOW TO MAKE A CRAFTING NODE FOR A MOD
--def
  --recipe
  --mod name
  --formspec

civilization.register_mod_node = function(def)
  local node_name = "civilization:"..def.mod
  --craft
  minetest.register_craft({
    output = node_name..' 1',
    recipe = def.recipe,
  })
  --node
  minetest.register_node(node_name,{
    description = def.name,
    drawtype="normal",
    tiles={def.tiles},
    groups={cracky=1},
    on_construct = function(pos)
      local meta = minetest.env:get_meta(pos)
      meta:set_string("formspec",
        "size[8.5,3]"..
        "image[0,1;1,1;"..def.tiles.."]"..
        "list[current_player;main;1,0;3,3;]"..
        "list[current_name;recipe;4.5,0;3,3;]"..
        "list[current_name;dst;7.5,1;1,1;]")
      meta:set_string("infotext", def.name)
      local inv = meta:get_inventory()
      inv:set_size("recipe",3*3)
      inv:set_size("dst",1)
    end,
    can_dig = function(pos,player)
      local meta = minetest.env:get_meta(pos);
      local inv = meta:get_inventory()
      if inv:is_empty("recipe") and inv:is_empty("dst") then
        return true
      end
      return false
    end,
    allow_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
      if to_list == "dst" then
        return 0
      end
      return count
    end,
    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
      if listname == "dst" then
        return 0
      end
      return stack:get_count()
    end,
    allow_metadata_inventory_take = function(pos, listname, index, stack, player)
      return stack:get_count()
    end,
    on_metadata_inventory_move = function(pos, from_list, from_index, to_list, to_index, count, player)
      minetest.node_metadata_inventory_move_allow_all(pos, from_list, from_index, to_list, to_index, count, player)
      if to_list == "recipe" or from_list == "recipe" then
        local meta = minetest.env:get_meta(pos)
        local inv = meta:get_inventory()
        local tablelist = inv:get_list("recipe")
        local crafted = nil
        local recipe
        print("inventory mode")
        if tablelist then
          crafted = minetest.get_craft_result({method = "normal", width = 3, items = tablelist})
        end

        if crafted then
          if not string.find(dump(crafted.item:get_name()), def.mod..":") then
            inv:set_stack("dst", 1, nil)
            return 
          else
            inv:set_stack("dst", 1, crafted.item)
          end
        else
          inv:set_stack("dst", 1, nil)
        end
      end
    end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
      if listname == "recipe" then
        local meta = minetest.env:get_meta(pos)
        local inv = meta:get_inventory()
        local tablelist = inv:get_list("recipe")
        local crafted = nil
        print("inventory put")
        
        if tablelist then
          crafted = minetest.get_craft_result({method = "normal", width = 3, items = tablelist})
        end

        if crafted then
          if not string.find(dump(crafted.item:get_name()), def.mod..":") then
            inv:set_stack("dst", 1, nil)
            return 
          else
            inv:set_stack("dst", 1, crafted.item)
          end
        else
          inv:set_stack("dst", 1, nil)
        end
      end
    end,
    on_metadata_inventory_take = function(pos, listname, index, count, player)
      if listname == "recipe" then
        local meta = minetest.env:get_meta(pos)
        local inv = meta:get_inventory()
        local tablelist = inv:get_list("recipe")
        local crafted = nil
        print("inventory take")
        
        if tablelist then
          crafted = minetest.get_craft_result({method = "normal", width = 3, items = tablelist})
        end

        if crafted then
          if not string.find(dump(crafted.item:get_name()), def.mod..":") then
            inv:set_stack("dst", 1, nil)
            return 
          else
            inv:set_stack("dst", 1, crafted.item)
          end
        else
          inv:set_stack("dst", 1, nil)
        end
      elseif listname == "dst" then
        local meta = minetest.env:get_meta(pos)
        local inv = meta:get_inventory()
        local tablelist = inv:get_list("recipe")
        local crafted = nil
        local table_dec = nil
        if tablelist then
          crafted,table_dec = minetest.get_craft_result({method = "normal", width = 3, items = tablelist})
        end
        if table_dec then
          inv:set_list("recipe", table_dec.items)
        else
          inv:set_list("recipe", nil)
        end
        local tablelist = inv:get_list("recipe")
        if tablelist then
          crafted,table_dec = minetest.get_craft_result({method = "normal", width = 3, items = tablelist})
        end
        if crafted then
          
          if not string.find(dump(crafted.item:get_name()), def.mod..":") then
            inv:set_stack("dst", 1, nil)
            return 
          else
            inv:set_stack("dst", 1, crafted.item)
          end
          
          inv:set_stack("dst", 1, crafted.item)
        else
          inv:set_stack("dst", 1, nil)
        end
      end
      return post
    end
  })
end
