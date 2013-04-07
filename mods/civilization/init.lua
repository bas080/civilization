--disable the crafting and shrink inventory size
local no_craft = {}

no_craft.set_creative_formspec = function(player)
  player:set_inventory_formspec("size[3,3]"..
    "list[current_player;main;0,0;3,3;]")
    player:get_inventory():set_size("main", 3*3) --NotNick's contribution
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

--oddly breakable by hand is no longer allowed
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

--craft node in which you can craft items automatically.
function autocraft(inventory)
	local recipe=inventory:get_list("recipe")
	local result
	local new
	for i=1,9 do
		recipe[i]=ItemStack({name=recipe[i]:get_name(),count=1})
	end
	result,new=minetest.get_craft_result({method="normal",width=3,items=recipe})
	local input=inventory:get_list("input")
	if result.item:is_empty() then return end
	result=result.item
	local to_use={}
	for _,item in ipairs(recipe) do
		if item~=nil and not item:is_empty() then
			if to_use[item:get_name()]==nil then
				to_use[item:get_name()]=1
			else
				to_use[item:get_name()]=to_use[item:get_name()]+1
			end
		end
	end
	local stack
	for itemname,number in pairs(to_use) do
		stack=ItemStack({name=itemname, count=number})
		if not inventory:contains_item("src",stack) then return end
	end
	for itemname,number in pairs(to_use) do
		stack=ItemStack({name=itemname, count=number})
		inventory:remove_item("src",stack)
	end
	inventory:add_item("dst",result)
	for i=1,9 do
		inventory:add_item("dst",new.items[i])
	end
end

minetest.register_node("civilization:factory",{
	description = "Craft items (automatically)",
	drawtype="normal",
	tiles={"civilization_factory.png"},
	groups={cracky=1,tubedevice=1,tubedevice_receiver=1},
	tube={insert_object=function(pos,node,stack,direction)
			local meta=minetest.env:get_meta(pos)
			local inv=meta:get_inventory()
			return inv:add_item("src",stack)
		end,
		can_insert=function(pos,node,stack,direction)
			local meta=minetest.env:get_meta(pos)
			local inv=meta:get_inventory()
			return inv:room_for_item("src",stack)
		end,
		input_inventory="dst"},
	on_construct = function(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec",
				"size[6.5,7]"..
				"label[0,0;Inventory:]"..
				"list[current_player;main;0,0.5;3,3;]"..
				"label[0,3.5;Craft recipe:]"..
				"list[current_name;recipe;0,4;3,3;]"..
				"label[3.5,0;Resources:]"..
				"list[current_name;src;3.5,0.5;3,3;]"..
				"label[3.5,3.5;Crafted:]"..
				"list[current_name;dst;3.5,4;3,3;]")
		meta:set_string("infotext", "Factory")
		local inv = meta:get_inventory()
		inv:set_size("src",3*3)
		inv:set_size("recipe",3*3)
		inv:set_size("dst",3*3)
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local inv = meta:get_inventory()
		return (inv:is_empty("src") and inv:is_empty("recipe") and inv:is_empty("dst"))
	end})

minetest.register_abm({
  nodenames={"civilization:factory"},
  interval=3,
  chance=1,
  action=function(pos,node)
    local meta=minetest.env:get_meta(pos)
    local inv=meta:get_inventory()
    autocraft(inv)
  end
})
			
minetest.register_craft({
  output = 'civilization:factory',
  recipe = {
    {'default:mese', 'default:steel_ingot', 'default:mese'},
    {'default:steel_ingot', 'default:steel_ingot', 'default:steel_ingot'},
    {'default:mese', 'default:steel_ingot', 'default:mese'},
  }
})
