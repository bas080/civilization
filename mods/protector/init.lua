-- Zeg9's protector mod
-- based on glomie's mod of the same name
-- Released under WTFPL

--[[table.contains = function(list, what)
	for _, i in ipairs(list) do
		if i == what then
			return true
		end
	end
	return false
end]]

minetest.register_privilege("delprotect","Delete other's protection by sneaking")

protector = {}

protector.node = "protector:protect"
protector.item = "protector:stick"

protector.get_member_list = function(meta)
	s = meta:get_string("members")
	list = s:split(" ")
	print(dump(list))
	return list
end

protector.set_member_list = function(meta, list)
	s = ""
	for _, i in ipairs(list) do
		s = s .. i .. " "
	end
	s = s:sub(0,s:len()-1) -- remove last space
	print ("Members: " .. s .. ";")
	meta:set_string("members",s)
end

protector.is_member = function (meta, name)
	list = protector.get_member_list(meta)
	for _, n in ipairs(list) do
		if n == name then
			return true
		end
	end
	return false
end

protector.add_member = function(meta, name)
	if protector.is_member(meta, name) then return end
	list = protector.get_member_list(meta)
	table.insert(list,name)
	protector.set_member_list(meta,list)
end

protector.del_member = function(meta,name)
	list = protector.get_member_list(meta)
	for i, n in ipairs(list) do
		if n == name then
			table.remove(list, i)
			break
		end
	end
	protector.set_member_list(meta,list)
end

protector.generate_formspec = function (meta)
	if meta:get_int("page") == nil then meta:set_int("page",0) end
	formspec = "size[8,8]"
	formspec = formspec .. "label[0,0;Protection owned by "..meta:get_string("owner")..".]"
		.."label[0,1;Add a member:]"
		.."field[3,1.33;2,1;add_member;;]"
		.."button[5,1;1,1;submit;Ok]"
		.."label[0,2;Members (click to remove):]"
	members = protector.get_member_list(meta)
	
	s = 0
	i = 0
	for _, member in ipairs(members) do
		if s < meta:get_int("page")*16 then s = s +1 else
			if i < 16 then
				formspec = formspec .. "button["..(i%4*2)..","..math.floor(i/4+3)..";2,.5;del_member;"..member.."]"
			end
			i = i +1
		end
	end
	
	if s > 0 then
		formspec = formspec .. "button[0,7;1,1;page_prev;<<]"
	else
		formspec = formspec .. "button[0,7;1,1;;<<]"
	end
	if i > 16 then
		formspec = formspec .. "button[7,7;1,1;page_next;>>]"
	else
		formspec = formspec .. "button[7,7;1,1;;>>]"
	end
	formspec = formspec .. "label[3,7;Page "..(meta:get_int("page")+1).."/"..math.floor((s+i-1)/16+1).."]"
	return formspec
end

protector.can_dig = function(r,pos,digger,onlyowner)
		if minetest.get_player_privs(digger:get_player_name()).delprotect
		and digger:get_player_control().sneak
		then return true end
	local ok=true
	for ix = pos.x-r,pos.x+r do
		for iy = pos.y-r,pos.y+r do
			for iz = pos.z-r,pos.z+r do
				local node_name = minetest.env:get_node({x=ix,y=iy,z=iz})
				if node_name.name == protector.node then
					local meta = minetest.env:get_meta({x=ix,y=iy,z=iz})
					if digger ~= nil then
						local owner = (meta:get_string("owner"))					
							if owner ~= digger:get_player_name() then 
								ok=false
								if not onlyowner and protector.is_member(meta, digger:get_player_name()) then
									ok=true
								end
								if not ok then
									minetest.chat_send_player(digger:get_player_name(), "This area is owned by "..owner.." !")
									return false
								end
							end
						end			
				end
			end
		end
	end
	return true
end

local old_node_dig = minetest.node_dig
function minetest.node_dig(pos, node, digger)
	local ok=true
	if node.name ~= protector.node then
	ok = protector.can_dig(5,pos,digger)
	else ok = protector.can_dig(5,pos,digger,true)
	end
	if ok == true then
		old_node_dig(pos, node, digger)
	end
end

local old_node_place = minetest.item_place
function minetest.item_place(itemstack, placer, pointed_thing)
	if itemstack:get_definition().type == "node" then
		local ok=true
		if itemstack:get_name() ~= protector.node then
			local pos = pointed_thing.above
			ok = protector.can_dig(5,pos,placer)
		else
			local pos = pointed_thing.above
			ok = protector.can_dig(10,pos,placer,true)
		end 
		if ok == true then
			return old_node_place(itemstack, placer, pointed_thing)
		else
			return
		end	
	end	
	return old_node_place(itemstack, placer, pointed_thing)
end
protect = {}
minetest.register_node(protector.node, {
	description = "Protection",
	tile_images = {"protector_top.png","protector_top.png","protector_side.png"},
	sounds = default.node_sound_stone_defaults(),
	groups = {dig_immediate=2},
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "Protection (owned by "..
				meta:get_string("owner")..")")
		meta:set_string("members", "")
		meta:set_string("formspec",protector.generate_formspec(meta))
	end,
	on_receive_fields = function(pos,formname,fields,sender)
		local meta = minetest.env:get_meta(pos)
		if meta:get_int("page") == nil then meta:set_int("page",0) end
		if sender:get_player_name() == meta:get_string("owner") then
			if fields.add_member then
				for _, i in ipairs(fields.add_member:split(" ")) do
					protector.add_member(meta,i)
				end
			end
			if fields.del_member then
				protector.del_member(meta, fields.del_member)
			end
			if fields.page_prev then
				meta:set_int("page",meta:get_int("page")-1)
			end
			if fields.page_next then
				meta:set_int("page",meta:get_int("page")+1)
			end
		end
		meta:set_string("formspec",protector.generate_formspec(meta))
	end,
})

minetest.register_craftitem(protector.item, {
	description = "Protection tool",
	inventory_image = "protector_stick.png",
	on_use = function(itemstack, user, pointed_thing)
		if pointed_thing.type ~= "node" then
			return
		end
		pos = pointed_thing.under
		r = 5
		for ix = pos.x-r,pos.x+r do
			for iy = pos.y-r,pos.y+r do
				for iz = pos.z-r,pos.z+r do
					local node_name = minetest.env:get_node({x=ix,y=iy,z=iz})
					if node_name.name == protector.node then
						local meta = minetest.env:get_meta({x=ix,y=iy,z=iz})
						minetest.chat_send_player(user:get_player_name(),"This area is owned by "..meta:get_string("owner")..".")
						if meta:get_string("members") ~= "" then
							minetest.chat_send_player(user:get_player_name(),"Members are: "..meta:get_string("members")..".")
						end
						return
					end
				end
			end
		end
		minetest.chat_send_player(user:get_player_name(),"This area is not protected.")
	end,
})

minetest.register_craft({
	output = '"' .. protector.node .. '" 4',
	recipe = {
		{"default:stone","default:stone","default:stone"},
		{"default:stone","default:steel_ingot","default:stone"},
		{"default:stone","default:stone","default:stone"},
	}
})
minetest.register_craft({
	output = protector.item,
	recipe = {
		{protector.node},
		{'default:stick'},
	}
})

