--Mod by kotolegokot

minetest.register_node("locked_sign:sign_wall_locked", {
	description = "Locked Sign",
	drawtype = "signlike",
	tiles = {"locked_sign_sign_wall_lock.png"},
	inventory_image = "locked_sign_sign_wall_lock.png",
	wield_image = "locked_sign_sign_wall_lock.png",
	paramtype = "light",
	paramtype2 = "wallmounted",
	sunlight_propagates = true,
	walkable = false,
	metadata_name = "sign",
	selection_box = {
		type = "wallmounted",
		--wall_top = <default>
		--wall_bottom = <default>
		--wall_side = <default>
	},
	groups = {choppy=2,dig_immediate=2},
	legacy_wallmounted = true,
	sounds = default.node_sound_defaults(),
	after_place_node = function(pos, placer)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("owner", placer:get_player_name() or "")
		meta:set_string("infotext", "\"\" (owned by " .. placer:get_player_name() .. ")")
	end,
	on_construct = function(pos)
		--local n = minetest.env:get_node(pos)
		local meta = minetest.env:get_meta(pos)
		meta:set_string("formspec", "hack:sign_text_input")
		meta:set_string("infotext", "\"\"")
	end,
	can_dig = function(pos,player)
		local meta = minetest.env:get_meta(pos);
		local owner = meta:get_string("owner")
		return player:get_player_name() == owner
	end,
	on_receive_fields = function(pos, formname, fields, sender)
		local meta = minetest.env:get_meta(pos)
		local owner = meta:get_string("owner")
		if sender:get_player_name() ~= owner then
			return
		end
		--print("Sign at "..minetest.pos_to_string(pos).." got "..dump(fields))
		local meta = minetest.env:get_meta(pos)
		fields.text = fields.text or ""
		print((sender:get_player_name() or "").." wrote \""..fields.text..
				"\" to sign at "..minetest.pos_to_string(pos))
		meta:set_string("text", fields.text)
		meta:set_string("infotext", "\"" .. fields.text .. "\" (owned by " .. sender:get_player_name() .. ")")
	end,
})

minetest.register_craft({
	output = "locked_sign:sign_wall_locked",
	recipe = {
		{"default:wood", "default:wood", "default:wood"},
		{"default:wood", "default:wood", "default:steel_ingot"},
		{"", "default:stick", ""},
	}
})

minetest.register_alias("sign_wall_locked", "locked_sign:sign_wall_locked")
