--nodes and crafts
local hue = "white"

minetest.register_craft( {
  output = "flags:white 16",
  recipe = {
    {"wool:white", "wool:white", "wool:white"},
    {"wool:white", "wool:white", "wool:white"},
  },
})

minetest.register_node("flags:"..hue, {
  description = hue2 .. " flag",
  drawtype = "torchlike",
  inventory_image = "flags_item_"..hue..".png",
  wield_image = "flags_item_"..hue..".png",
  tiles = {
    {name="flags_"..hue..".png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1.0}},
    {name="flags_"..hue..".png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1.0}},
    {name="flags_"..hue..".png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1.0}}
  },
  paramtype = "light",
  paramtype2 = "wallmounted",
  sunlight_propagates = true,
  walkable = false,
  selection_box = {
  type = "wallmounted",
    wall_top = {-0.1, 0.5-0.6, -0.1, 0.1, 0.5, 0.1},
    wall_bottom = {0, -0.5, -0.1, 0.1, -0.5+0.6, 0.1},
    wall_side = {-0.5, -0.3, -0.1, 0.5, 0.3, 0.1},
  },
  groups = {dig_immediate=3, attached=1},
  legacy_wallmounted = true,
  sounds = default.node_sound_defaults(),
})

for i = 1, 12 do
  local hue = HUES[i]
  local hue2 = HUES2[i]
  
  minetest.register_craft( {
    type = "shapeless",
    output = "flags:" .. hue,
    recipe = {
      "flags:" .. "white",
      "unifieddyes:" .. hue,
    },
	})

  minetest.register_node("flags:"..hue, {
    description = hue2 .. " flag",
    drawtype = "torchlike",
    inventory_image = "flags_item_"..hue..".png",
    wield_image = "flags_item_"..hue..".png",
    tiles = {
      {name="flags_"..hue..".png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1.0}},
      {name="flags_"..hue..".png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1.0}},
      {name="flags_"..hue..".png", animation={type="vertical_frames", aspect_w=16, aspect_h=16, length=1.0}}
    },
    paramtype = "light",
    paramtype2 = "wallmounted",
    sunlight_propagates = true,
    walkable = false,
    selection_box = {
    type = "wallmounted",
      wall_top = {-0.1, 0.5-0.6, -0.1, 0.1, 0.5, 0.1},
      wall_bottom = {0, -0.5, -0.1, 0.1, -0.5+0.6, 0.1},
      wall_side = {-0.5, -0.3, -0.1, 0.5, 0.3, 0.1},
    },
    groups = {dig_immediate=3, attached=1},
    legacy_wallmounted = true,
    sounds = default.node_sound_defaults(),
  })
end

print("[flags] Loaded!")
