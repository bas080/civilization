minetest.register_on_newplayer(function(player)
	print("giving give_initial_stuff to player")
	player:get_inventory():add_item('main', 'default:tree 2')
end)

