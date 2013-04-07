-- This file provides the actual flow and pathfinding logic that makes water
-- move through the pipes.
--
-- Contributed by mauvebic, 2013-01-03, with tweaks by Vanessa Ezekowitz
--

local check4liquids = function(pos)
	local coords = {
		{x=pos.x,y=pos.y-1,z=pos.z},
		{x=pos.x,y=pos.y+1,z=pos.z},
		{x=pos.x-1,y=pos.y,z=pos.z},
		{x=pos.x+1,y=pos.y,z=pos.z},
		{x=pos.x,y=pos.y,z=pos.z-1},
		{x=pos.x,y=pos.y,z=pos.z+1},	}
	for i =1,6 do
		local name = minetest.env:get_node(coords[i]).name
		if string.find(name,'water') then return true end
	end
	return false
end

local check4inflows = function(pos,node)
	local coords = {
		{x=pos.x,y=pos.y-1,z=pos.z},
		{x=pos.x,y=pos.y+1,z=pos.z},
		{x=pos.x-1,y=pos.y,z=pos.z},
		{x=pos.x+1,y=pos.y,z=pos.z},
		{x=pos.x,y=pos.y,z=pos.z-1},
		{x=pos.x,y=pos.y,z=pos.z+1},	}
	local newnode = false
	local source = false
	for i =1,6 do
		if newnode then break end
		local name = minetest.env:get_node(coords[i]).name
		if (name == 'pipeworks:pump_on' and check4liquids(coords[i])) or string.find(name,'_loaded') then
			if string.find(name,'_loaded') then
				local source = minetest.env:get_meta(coords[i]):get_string('source')
				if source == minetest.pos_to_string(pos) then break end
			end
			newnode = string.gsub(node.name,'empty','loaded')
			source = {x=coords[i].x,y=coords[i].y,z=coords[i].z}
			if newnode ~= nil then dbg(newnode) end
		end
	end
	if newnode then 
		dbg(newnode..' to replace '..node.name) 
		minetest.env:add_node(pos,{name=newnode}) 
		minetest.env:get_meta(pos):set_string('source',minetest.pos_to_string(source))
	end
end

local checksources = function(pos,node)
	local sourcepos = minetest.string_to_pos(minetest.env:get_meta(pos):get_string('source'))
	local source = minetest.env:get_node(sourcepos).name
	local newnode = false
	if not ((source == 'pipeworks:pump_on' and check4liquids(sourcepos)) or string.find(source,'_loaded') or source == 'ignore' ) then
		newnode = string.gsub(node.name,'loaded','empty')
	end

	if newnode then dbg(newnode..' to replace '..node.name) end
	if newnode then 
		minetest.env:add_node(pos,{name=newnode}) 
		minetest.env:get_meta(pos):set_string('source','')
	end
end

local update_outlet = function(pos)
	local top = minetest.env:get_node({x=pos.x,y=pos.y+1,z=pos.z}).name
	if string.find(top,'_loaded') then
		minetest.env:add_node({x=pos.x,y=pos.y-1,z=pos.z},{name='default:water_source'}) 
	elseif minetest.env:get_node({x=pos.x,y=pos.y-1,z=pos.z}).name == 'default:water_source' then
		minetest.env:remove_node({x=pos.x,y=pos.y-1,z=pos.z})
	end
end

local spigot_check = function(pos,node)
	local fdir=node.param2
	local check = {{x=pos.x,y=pos.y,z=pos.z+1},{x=pos.x+1,y=pos.y,z=pos.z},{x=pos.x,y=pos.y,z=pos.z-1},{x=pos.x-1,y=pos.y,z=pos.z}	}
	dbg(fdir..' checking '..minetest.pos_to_string(check[fdir+1])..' for spigot at '..minetest.pos_to_string(pos))
	local top = minetest.env:get_node(check[fdir+1]).name
	dbg('found '..top)
	if string.find(top,'_loaded') then
		minetest.env:add_node({x=pos.x,y=pos.y,z=pos.z},{name='pipeworks:spigot_pouring', param2 = fdir}) 
		minetest.env:add_node({x=pos.x,y=pos.y-1,z=pos.z},{name='default:water_source'}) 
	elseif minetest.env:get_node({x=pos.x,y=pos.y-1,z=pos.z}).name == 'default:water_source' then
		minetest.env:add_node({x=pos.x,y=pos.y,z=pos.z},{name='pipeworks:spigot', param2 = fdir}) 
		minetest.env:remove_node({x=pos.x,y=pos.y-1,z=pos.z})
	end
end

minetest.register_abm({
	nodenames = pipes_empty_nodenames,
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider) check4inflows(pos,node) end
})

minetest.register_abm({
	nodenames = pipes_full_nodenames,
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider) checksources(pos,node) end
})

minetest.register_abm({
	nodenames = {'pipeworks:outlet','pipeworks:spigot','pipeworks:spigot_pouring'},
	interval = 1,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider) 
		if node.name == 'pipeworks:outlet' then update_outlet(pos)
		elseif node.name == 'pipeworks:spigot' or node.name == 'pipeworks:spigot_pouring' then spigot_check(pos,node) end
	end
})
