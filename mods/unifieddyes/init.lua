-- Unified Dyes Mod by Vanessa Ezekowitz  ~~  2012-07-24
--
-- License: GPL
--
-- This mod depends on ironzorg's flowers mod and my Vessels mod.

--============================================================================
-- First, craft some bottles from the Vessels mod, then make some dye base:
-- Craft six empty bottles along with a bucket of water and a piece
-- of jungle grass to get 6 portions of dye base.

-- These craft/craftitem definitions for glass bottles are deprecated and are
-- only included here for backwards compatibility. Use vessels:glass_bottle
-- instead.

minetest.register_craftitem("unifieddyes:empty_bottle", {
        description = "Glass Bottle (empty) (Deprecated)",
        inventory_image = "unifieddyes_empty_bottle.png",
})

minetest.register_craft( {
        type = "shapeless",
        output = "vessels:glass_fragments",
        recipe = {
                "unifieddyes:empty_bottle",
                "unifieddyes:empty_bottle",
        },
})

-- Now the current stuff, using vessels:glass_bottle.

minetest.register_craftitem("unifieddyes:dye_base", {
        description = "Uncolored Dye Base Liquid",
        inventory_image = "unifieddyes_dye_base.png",
})

minetest.register_craft( {
	type = "shapeless",
	output = "unifieddyes:dye_base 6",
	recipe = {
		"vessels:glass_bottle",
		"vessels:glass_bottle",
		"vessels:glass_bottle",
		"vessels:glass_bottle",
		"vessels:glass_bottle",
		"vessels:glass_bottle",
		"bucket:bucket_water",
		"default:junglegrass",
	},
	replacements = { {'bucket:bucket_water', 'bucket:bucket_empty'}, },
})

--==========================================================================
-- Now we need to turn our color sources (flowers, etc) into pigments and from
-- there into actual usable dyes.  There are seven base colors - one for each
-- flower, plus black (as "carbon black") from coal, and white (as "titanium
-- dioxide") from stone.  Most give two portions of pigment; cactus gives 6,
-- stone gives 10.

pigments = {
	"red",
	"orange",
	"yellow",
	"green"
}

dyesdesc = {
	"Red",
	"Orange",
	"Yellow",
	"Green"
}
	
colorsources = {
	"flowers:flower_rose",
	"flowers:flower_tulip",
	"flowers:flower_dandelion_yellow",
	"flowers:flower_waterlily",
}

for color in ipairs(colorsources) do

	-- the recipes to turn sources into pigments

	minetest.register_craftitem("unifieddyes:pigment_"..pigments[color], {
		description = dyesdesc[color].." Pigment",
		inventory_image = "unifieddyes_pigment_"..pigments[color]..".png",
	})

	minetest.register_craft({
		type = "cooking",
		output = "unifieddyes:pigment_"..pigments[color].." 2",
		recipe = colorsources[color],
	})

	-- The recipes to turn pigments into usable dyes

	minetest.register_craftitem("unifieddyes:"..pigments[color], {
		description = "Full "..dyesdesc[color].." Dye",
		inventory_image = "unifieddyes_"..pigments[color]..".png",
		groups = { dye=1, ["basecolor_"..pigments[color]]=1, ["excolor_"..pigments[color]]=1, ["unicolor_"..pigments[color]]=1 }
	})

	minetest.register_craft( {
		type = "shapeless",
		output = "unifieddyes:"..pigments[color],
		recipe = {
			"unifieddyes:pigment_"..pigments[color],
			"unifieddyes:dye_base"
		}
	})
end

-- Stone->titanium dioxide and cactus->green pigment are done separately
-- because of their larger yields

minetest.register_craftitem("unifieddyes:titanium_dioxide", {
	description = "Titanium Dioxide",
	inventory_image = "unifieddyes_titanium_dioxide.png",
})

minetest.register_craft({
	type = "cooking",
	output = "unifieddyes:titanium_dioxide 10",
	recipe = "default:stone",
})

minetest.register_craft({
	type = "cooking",
	output = "unifieddyes:pigment_green 6",
	recipe = "default:cactus",
})

-- coal->carbon black and carbon black -> black dye are done separately
-- because of the different names

minetest.register_craftitem("unifieddyes:carbon_black", {
	description = "Carbon Black",
	inventory_image = "unifieddyes_carbon_black.png",
})

minetest.register_craft({
	type = "cooking",
	output = "unifieddyes:carbon_black 2",
	recipe = "default:coal_lump",
})

minetest.register_craftitem("unifieddyes:black", {
	description = "Black Dye",
	inventory_image = "unifieddyes_black.png",
	groups = { dye=1, basecolor_black=1, excolor_black=1, unicolor_black=1 }
})

minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:black",
        recipe = {
                "unifieddyes:carbon_black",
                "unifieddyes:dye_base",
        },
})

--=======================================================================
-- Now that we have the dyes in a usable form, let's mix the various
-- ingredients together to create the rest of the mod's colors and greys.


----------------------------
-- The 5 levels of greyscale

-- White paint

minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:white_paint",
        recipe = {
                "unifieddyes:titanium_dioxide",
                "bucket:bucket_water",
                "default:junglegrass",
        },
})

minetest.register_craftitem("unifieddyes:white_paint", {
        description = "White Paint",
        inventory_image = "unifieddyes_white_paint.png",
	groups = { dye=1, basecolor_white=1, excolor_white=1, unicolor_white=1 }
})

-- Light grey paint

minetest.register_craft( {
       type = "shapeless",
       output = "unifieddyes:lightgrey_paint 3",
       recipe = {
               "unifieddyes:white_paint",
               "unifieddyes:white_paint",
               "unifieddyes:carbon_black",
		},
})

minetest.register_craftitem("unifieddyes:lightgrey_paint", {
        description = "Light Grey Paint",
        inventory_image = "unifieddyes_lightgrey_paint.png",
	groups = { dye=1, excolor_lightgrey=1, unicolor_lightgrey=1 }
})

-- Medium grey paint

minetest.register_craft( {
       type = "shapeless",
       output = "unifieddyes:grey_paint 2",
       recipe = {
               "unifieddyes:white_paint",
               "unifieddyes:carbon_black",
		},
})

minetest.register_craftitem("unifieddyes:grey_paint", {
        description = "Medium Grey Paint",
        inventory_image = "unifieddyes_grey_paint.png",
	groups = { dye=1, basecolor_grey=1, excolor_grey=1, unicolor_grey=1 }
})

-- Dark grey paint

minetest.register_craft( {
       type = "shapeless",
       output = "unifieddyes:darkgrey_paint 3",
       recipe = {
               "unifieddyes:white_paint",
               "unifieddyes:carbon_black",
               "unifieddyes:carbon_black",
		},
})

minetest.register_craftitem("unifieddyes:darkgrey_paint", {
        description = "Dark Grey Paint",
        inventory_image = "unifieddyes_darkgrey_paint.png",
	groups = { dye=1, excolor_darkgrey=1, unicolor_darkgrey=1 }
})


--=============================================================================
-- Smelting/crafting recipes needed to generate various remaining 'full' colors
-- (the register_craftitem functions are in the generate-the-rest loop below).

-- Cyan

minetest.register_craftitem("unifieddyes:cyan", {
        description = "Full Cyan Dye",
        inventory_image = "unifieddyes_cyan.png",
	groups = { dye=1, basecolor_cyan=1, excolor_cyan=1, unicolor_cyan=1 }
})

minetest.register_craft( {
       type = "shapeless",
       output = "unifieddyes:cyan 2",
       recipe = {
               "unifieddyes:blue",
               "unifieddyes:green",
		},
})

-- Magenta

minetest.register_craftitem("unifieddyes:magenta", {
        description = "Full Magenta Dye",
        inventory_image = "unifieddyes_magenta.png",
	groups = { dye=1, basecolor_magenta=1, excolor_magenta=1, unicolor_magenta=1 }
})

minetest.register_craft( {
       type = "shapeless",
       output = "unifieddyes:magenta 2",
       recipe = {
               "unifieddyes:blue",
               "unifieddyes:red",
		},
})

-- Lime

minetest.register_craftitem("unifieddyes:lime", {
        description = "Full Lime Dye",
        inventory_image = "unifieddyes_lime.png",
	groups = { dye=1, excolor_lime=1, unicolor_lime=1 }
})

minetest.register_craft( {
       type = "shapeless",
       output = "unifieddyes:lime 2",
       recipe = {
               "unifieddyes:yellow",
               "unifieddyes:green",
		},
})

-- Aqua

minetest.register_craftitem("unifieddyes:aqua", {
        description = "Full Aqua Dye",
        inventory_image = "unifieddyes_aqua.png",
	groups = { dye=1, excolor_aqua=1, unicolor_aqua=1 }
})

minetest.register_craft( {
       type = "shapeless",
       output = "unifieddyes:aqua 2",
       recipe = {
               "unifieddyes:cyan",
               "unifieddyes:green",
		},
})

-- Sky blue

minetest.register_craftitem("unifieddyes:skyblue", {
        description = "Full Sky-blue Dye",
        inventory_image = "unifieddyes_skyblue.png",
	groups = { dye=1, excolor_sky_blue=1, unicolor_sky_blue=1 }
})

minetest.register_craft( {
       type = "shapeless",
       output = "unifieddyes:skyblue 2",
       recipe = {
               "unifieddyes:cyan",
               "unifieddyes:blue",
		},
})

-- Red-violet

minetest.register_craftitem("unifieddyes:redviolet", {
        description = "Full Red-violet Dye",
        inventory_image = "unifieddyes_redviolet.png",
	groups = { dye=1, excolor_red_violet=1, unicolor_red_violet=1 }
})

minetest.register_craft( {
       type = "shapeless",
       output = "unifieddyes:redviolet 2",
       recipe = {
               "unifieddyes:red",
               "unifieddyes:magenta",
		},
})

-- We need to check if the version of the Flowers mod that is installed
-- contains geraniums or not.  If it doesn't, use the Viola to make blue dye.
-- If Geraniums do exist, use them to make blue dye instead, and use Violas
-- to get violet dye.  Violet can always be made by mixing blue with magenta
-- or red as usual.


minetest.register_craftitem("unifieddyes:pigment_blue", {
	description = "Blue Pigment",
	inventory_image = "unifieddyes_pigment_blue.png",
})

minetest.register_craft( {
	type = "shapeless",
	output = "unifieddyes:blue",
	recipe = {
		"unifieddyes:pigment_blue",
		"unifieddyes:dye_base"
	}
})

minetest.register_craftitem("unifieddyes:blue", {
	description = "Full Blue Dye",
	inventory_image = "unifieddyes_blue.png",
	groups = { dye=1, basecolor_blue=1, excolor_blue=1, unicolor_blue=1 }
})

minetest.register_craftitem("unifieddyes:violet", {
        description = "Full Violet/Purple Dye",
        inventory_image = "unifieddyes_violet.png",
	groups = { dye=1, basecolor_violet=1, excolor_violet=1, unicolor_violet=1 }
})

minetest.register_craft( {
       type = "shapeless",
       output = "unifieddyes:violet 2",
       recipe = {
               "unifieddyes:blue",
               "unifieddyes:magenta",
		},
})

minetest.register_craft( {
       type = "shapeless",
       output = "unifieddyes:violet 3",
       recipe = {
               "unifieddyes:blue",
               "unifieddyes:blue",
               "unifieddyes:red",
		},
})

if minetest.registered_nodes["flowers:flower_geranium"] == nil then


	minetest.register_craft({
		type = "cooking",
		output = "unifieddyes:pigment_blue 2",
		recipe = "flowers:flower_viola",
	})
else
	minetest.register_craftitem("unifieddyes:pigment_violet", {
	        description = "Violet Pigment",
	        inventory_image = "unifieddyes_pigment_violet.png",
	})

	minetest.register_craft({
		type = "cooking",
		output = "unifieddyes:pigment_blue 2",
		recipe = "flowers:flower_geranium",
	})

	minetest.register_craft({
		type = "cooking",
		output = "unifieddyes:pigment_violet 2",
		recipe = "flowers:flower_viola",
	})

	minetest.register_craft( {
		type = "shapeless",
		output = "unifieddyes:violet",
		recipe = {
			"unifieddyes:pigment_violet",
			"unifieddyes:dye_base"
		}
	})
end


-- =================================================================

-- Finally, generate all of additional variants of hue, saturation, and
-- brightness.

-- "s50" in a file/item name means "saturation: 50%".
-- Brightness levels in the textures are 33% ("dark"), 66% ("medium"),
-- 100% ("full" but not so-named), and 150% ("light").

HUES = {
	"red",
	"orange",
	"yellow",
	"lime",
	"green",
	"aqua",
	"cyan",
	"skyblue",
	"blue",
	"violet",
	"magenta",
	"redviolet"
}

HUES2 = {
	"Red",
	"Orange",
	"Yellow",
	"Lime",
	"Green",
	"Aqua",
	"Cyan",
	"Sky-blue",
	"Blue",
	"Violet",
	"Magenta",
	"Red-violet"
}


for i = 1, 12 do

	hue = HUES[i]
	hue2 = HUES2[i]

	minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:dark_" .. hue .. "_s50 2",
        recipe = {
                "unifieddyes:" .. hue,
                "unifieddyes:darkgrey_paint",
	        },
	})

	minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:dark_" .. hue .. "_s50 4",
        recipe = {
                "unifieddyes:" .. hue,
                "unifieddyes:black",
                "unifieddyes:black",
		"unifieddyes:white_paint"
	        },
	})

	minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:dark_" .. hue .. " 3",
        recipe = {
                "unifieddyes:" .. hue,
                "unifieddyes:black",
                "unifieddyes:black",
	        },
	})

	minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:medium_" .. hue .. "_s50 2",
        recipe = {
                "unifieddyes:" .. hue,
                "unifieddyes:grey_paint",
	        },
	})

	minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:medium_" .. hue .. "_s50 3",
        recipe = {
                "unifieddyes:" .. hue,
		"unifieddyes:black",
                "unifieddyes:white_paint",
	        },
	})

	minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:medium_" .. hue .. " 2",
        recipe = {
                "unifieddyes:" .. hue,
                "unifieddyes:black",
	        },
	})

	minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:" .. hue .. "_s50 2",
        recipe = {
                "unifieddyes:" .. hue,
                "unifieddyes:lightgrey_paint",
	        },
	})

	minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:" .. hue .. "_s50 4",
        recipe = {
                "unifieddyes:" .. hue,
                "unifieddyes:white_paint",
                "unifieddyes:white_paint",
                "unifieddyes:black",
	        },
	})

	minetest.register_craft( {
        type = "shapeless",
        output = "unifieddyes:light_" .. hue .. " 2",
        recipe = {
                "unifieddyes:" .. hue,
                "unifieddyes:white_paint",
	        },
	})

	minetest.register_craftitem("unifieddyes:dark_" .. hue .. "_s50", {
		description = "Dark " .. hue2 .. " Dye (low saturation)",
		inventory_image = "unifieddyes_dark_" .. hue .. "_s50.png",
		groups = { dye=1, ["unicolor_dark_"..hue.."_s50"]=1 }
	})

	minetest.register_craftitem("unifieddyes:dark_" .. hue, {
		description = "Dark " .. hue2 .. " Dye",
		inventory_image = "unifieddyes_dark_" .. hue .. ".png",
		groups = { dye=1, ["unicolor_dark_"..hue]=1 }
	})

	minetest.register_craftitem("unifieddyes:medium_" .. hue .. "_s50", {
		description = "Medium " .. hue2 .. " Dye (low saturation)",
		inventory_image = "unifieddyes_medium_" .. hue .. "_s50.png",
		groups = { dye=1, ["unicolor_medium_"..hue.."_s50"]=1 }
	})

	minetest.register_craftitem("unifieddyes:medium_" .. hue, {
		description = "Medium " .. hue2 .. " Dye",
		inventory_image = "unifieddyes_medium_" .. hue .. ".png",
		groups = { dye=1, ["unicolor_medium_"..hue]=1 }
	})

	minetest.register_craftitem("unifieddyes:" .. hue .. "_s50", {
		description = "Full " .. hue2 .. " Dye (low saturation)",
		inventory_image = "unifieddyes_" .. hue .. "_s50.png",
		groups = { dye=1, ["unicolor_"..hue.."_s50"]=1 }
	})

	minetest.register_craftitem("unifieddyes:light_" .. hue, {
		description = "Light " .. hue2 .. " Dye",
		inventory_image = "unifieddyes_light_" .. hue .. ".png",
		groups = { dye=1, ["unicolor_light_"..hue]=1 }
	})

end

print("[UnifiedDyes] Loaded!")

