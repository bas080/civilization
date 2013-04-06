-- Jungletree mod by Bas080.
-- License WTFPL.

	-- Forked by paramat.
	-- Perlin Jungletrees Ongen 0.1.0.
	-- License WTFPL as before, see license.txt file.

	-- Deleted habitat mod.
	-- Only find ground level in randomly chosen columns within biome.
	-- Only check for grass away from trunks when altitude <= MAXALT.
	-- Increased roots depth to 2 or 5 nodes.
	-- Fixed bug "if height <= 0 then" line 131.
	-- Jungletree function defined and spawn jungletrees on generated chunk.
	-- Deleted laggy "find_node_near" functions with large radius that checked for water and sand, now only check trunk spacing.
	-- Added debug messages option.
	-- Added remove default trees option.
	-- Perlin matched to snow biomes perlin(112, 3, 0.5, 150) to keep jungle away from snow biomes.
	-- Noise range for more biome shapes.
	-- Added abm to grow saplings into jungletrees.
	-- ONGEN option.
	-- Variables MINSPA and MAXSPA to control denstity at centre and edge.
	-- More red and yellow leaves.

local MAXALT = 23 -- 23 -- Maximum altitude.
local MINSPA = 2 -- 2 -- Minimum spacing to other trunks or roots in deep jungle.
local MAXSPA = 11 -- 11 -- Average spacing to other trunks or roots at jungle edge.

-- Snowy perlin. Should match your snow biomes mod perlin.
local SEEDDIFF = 112 -- 112 -- World specific perlin seed = world seed + seeddiff.
local OCTAVES = 3 -- 3 -- Each higher octave adds variation on a scale half as big.
local PERSISTENCE = 0.5 -- 0.5 -- Relative amplitude of each higher octave.
local SCALE = 150 -- 150 -- Scale of largest pattern variation.

local NOISEH = -0.6 -- -0.6 ]
local NOISEL = -1.2 -- -1.2 ] Noise range for jungle biome. Negative values keep jungle away from snow biomes. Snow biomes when noise > 0.53.

local SAPLING_ABM_INTERVAL = 23 -- 23
local SAPLING_ABM_CHANCE = 13 -- 13

local ONGEN = true -- Spawn jungletrees on generated chunk? (true / false).
local REMOVE_TREES = true -- Remove default trees on generated chunk in jungle biomes?
local DEBUG = true

local colchamin = MINSPA ^ 2
local factor = (MAXSPA ^ 2 - colchamin) * 4
local nav = (NOISEH + NOISEL) / 2
local nra = NOISEH - NOISEL

minetest.register_node("jungletree:sapling", {
	description = "Jungle Tree Sapling",	
	drawtype = "plantlike",	
	visual_scale = 1.0,	
	tiles = {"jungletree_sapling.png"},	
	inventory_image = "jungletree_sapling.png",	
	wield_image = "jungletree_sapling.png",	
	paramtype = "light",	
	walkable = false,	
	groups = {snappy=2,dig_immediate=3,flammable=2},
})

local leaves = {"green","yellow","red"}
for color = 1, 3 do
	local leave_name = "jungletree:leaves_"..leaves[color]
	minetest.register_node(leave_name, {
		description = "Jungle Tree Leaves",
		drawtype = "allfaces_optional",
		tiles = {"jungletree_leaves_"..leaves[color]..".png"},
		paramtype = "light",
		groups = {snappy=3, leafdecay=3, flammable=2},
		drop = {
			max_items = 1,
			items = {
				{items = {'jungletree:sapling'},rarity = 20},
				{items = {leave_name}}
			}
		},
		sounds = default.node_sound_leaves_defaults(),
	})
end

minetest.register_alias("jungletree:tree", "default:jungletree")

minetest.register_node(":default:jungletree", {
	description = "Jungle Tree",
	tiles = {"default_jungletree_top.png", "default_jungletree_top.png", "default_jungletree.png"},
	groups = {tree=1,snappy=1,choppy=2,oddly_breakable_by_hand=1,flammable=2},
	sounds = default.node_sound_wood_defaults(),
})

local function add_tree_branch(pos)
	--chooze random leave
	local leave = "jungletree:leaves_"..leaves[math.random(1,3)]
	minetest.env:add_node(pos, {name="default:jungletree"})
	for i = math.floor(math.random(2)), -math.floor(math.random(2)), -1 do
		for k = math.floor(math.random(2)), -math.floor(math.random(2)), -1 do
			local p = {x=pos.x+i, y=pos.y, z=pos.z+k}
			local n = minetest.env:get_node(p)
			if (n.name=="air") then
				minetest.env:add_node(p, {name=leave})
			end
			local chance = math.abs(i+k)
			if (chance < 1) then
				p = {x=pos.x+i, y=pos.y+1, z=pos.z+k}
				n = minetest.env:get_node(p)
				if (n.name=="air") then
					minetest.env:add_node(p, {name=leave})
				end
			end
		end
	end
end

local function add_jungletree(pos)
		local height = 5 + math.random(15)
		if height < 10 then
			for i = height, -2, -1 do
				local p = {x=pos.x, y=pos.y+i, z=pos.z}
				minetest.env:add_node(p, {name="default:jungletree"})
				if i == height then
					add_tree_branch({x=pos.x, y=pos.y+height+math.random(0, 1), z=pos.z})
					add_tree_branch({x=pos.x+1, y=pos.y+i-math.random(2), z=pos.z})
					add_tree_branch({x=pos.x-1, y=pos.y+i-math.random(2), z=pos.z})
					add_tree_branch({x=pos.x, y=pos.y+i-math.random(2), z=pos.z+1})
					add_tree_branch({x=pos.x, y=pos.y+i-math.random(2), z=pos.z-1})
				end
				if i < 0 then
					minetest.env:add_node({x=pos.x+1, y=pos.y+i-math.random(2), z=pos.z}, {name="default:jungletree"})
					minetest.env:add_node({x=pos.x, y=pos.y+i-math.random(2), z=pos.z+1}, {name="default:jungletree"})
					minetest.env:add_node({x=pos.x-1, y=pos.y+i-math.random(2), z=pos.z}, {name="default:jungletree"})
					minetest.env:add_node({x=pos.x, y=pos.y+i-math.random(2), z=pos.z-1}, {name="default:jungletree"})
				end
				if (math.sin(i/height*i) < 0.2 and i > 3 and math.random(0,2) < 1.5) then
					branch_pos = {x=pos.x+math.random(0,1), y=pos.y+i, z=pos.z-math.random(0,1)}
					add_tree_branch(branch_pos)
				end
			end
		else
			for i = height, -5, -1 do
				if (math.sin(i/height*i) < 0.2 and i > 3 and math.random(0,2) < 1.5) then
					branch_pos = {x=pos.x+math.random(0,1), y=pos.y+i, z=pos.z-math.random(0,1)}
					add_tree_branch(branch_pos)
				end
				if i < math.random(0,1) then
					minetest.env:add_node({x=pos.x+1, y=pos.y+i, z=pos.z+1}, {name="default:jungletree"})
					minetest.env:add_node({x=pos.x+2, y=pos.y+i, z=pos.z-1}, {name="default:jungletree"})
					minetest.env:add_node({x=pos.x, y=pos.y+i, z=pos.z-2}, {name="default:jungletree"})
					minetest.env:add_node({x=pos.x-1, y=pos.y+i, z=pos.z}, {name="default:jungletree"})
				end
				if i == height then
					add_tree_branch({x=pos.x+1, y=pos.y+i, z=pos.z+1})
					add_tree_branch({x=pos.x+2, y=pos.y+i, z=pos.z-1})
					add_tree_branch({x=pos.x, y=pos.y+i, z=pos.z-2})
					add_tree_branch({x=pos.x-1, y=pos.y+i, z=pos.z})
					add_tree_branch({x=pos.x+1, y=pos.y+i, z=pos.z+2})
					add_tree_branch({x=pos.x+3, y=pos.y+i, z=pos.z-1})
					add_tree_branch({x=pos.x, y=pos.y+i, z=pos.z-3})
					add_tree_branch({x=pos.x-2, y=pos.y+i, z=pos.z})
					add_tree_branch({x=pos.x+1, y=pos.y+i, z=pos.z})
					add_tree_branch({x=pos.x+1, y=pos.y+i, z=pos.z-1})
					add_tree_branch({x=pos.x, y=pos.y+i, z=pos.z-1})
					add_tree_branch({x=pos.x, y=pos.y+i, z=pos.z})
				else
					minetest.env:add_node({x=pos.x+1, y=pos.y+i, z=pos.z}, {name="default:jungletree"})
					minetest.env:add_node({x=pos.x+1, y=pos.y+i, z=pos.z-1}, {name="default:jungletree"})
					minetest.env:add_node({x=pos.x, y=pos.y+i, z=pos.z-1}, {name="default:jungletree"})
					minetest.env:add_node({x=pos.x, y=pos.y+i, z=pos.z}, {name="default:jungletree"})
				end
			end
		end
		if DEBUG then
			print ("[jungletree] Spawn jungletree ("..pos.x.." "..pos.y.." "..pos.z..")")
		end
end

if ONGEN then
	minetest.register_on_generated(function(minp, maxp, seed)
		-- If generated chunk is a surface chunk
		if minp.y == -32 then
			-- Define perlin noise, co-ords of min and max points, chunk dimensions.
			local perlin = minetest.env:get_perlin(SEEDDIFF, OCTAVES, PERSISTENCE, SCALE)
			local x0 = minp.x
			local z0 = minp.z
			local x1 = maxp.x
			local z1 = maxp.z
			local xl = x1 - x0
			local zl = z1 - z0
			-- Speed hack: checks 9 points in chunk for conifer biome.
			if not (perlin:get2d({x=x0, y=z0}) > NOISEL and perlin:get2d({x=x0, y=z0}) < NOISEH)
			and not (perlin:get2d({x=x0, y=z1}) > NOISEL and perlin:get2d({x=x0, y=z1}) < NOISEH)
			and not (perlin:get2d({x=x1, y=z0}) > NOISEL and perlin:get2d({x=x1, y=z0}) < NOISEH)
			and not (perlin:get2d({x=x1, y=z1}) > NOISEL and perlin:get2d({x=x1, y=z1}) < NOISEH)
			and not (perlin:get2d({x=x0, y=z0+(zl/2)}) > NOISEL and perlin:get2d({x=x0, y=z0+(zl/2)}) < NOISEH)
			and not (perlin:get2d({x=x1, y=z0+(zl/2)}) > NOISEL and perlin:get2d({x=x1, y=z0+(zl/2)}) < NOISEH)
			and not (perlin:get2d({x=x0+(xl/2), y=z0}) > NOISEL and perlin:get2d({x=x0+(xl/2), y=z0}) < NOISEH)
			and not (perlin:get2d({x=x0+(xl/2), y=z1}) > NOISEL and perlin:get2d({x=x0+(xl/2), y=z1}) < NOISEH)
			and not (perlin:get2d({x=x0+(xl/2), y=z0+(zl/2)}) > NOISEL and perlin:get2d({x=x0+(xl/2), y=z0+(zl/2)}) < NOISEH) then
				return
			end

			if REMOVE_TREES == true then
				-- Remove default trees in chunk.
				local trees = minetest.env:find_nodes_in_area(minp, maxp, {"default:leaves","default:tree"})
				for i,v in pairs(trees) do
					minetest.env:remove_node(v)
				end
				if DEBUG then
					print ("[jungletree] Trees removed ("..minp.x.." "..minp.y.." "..minp.z..")")
				end
			end
			-- Loop through all columns in chunk, for each column do.
			for i = 0, xl do
			for j = 0, zl do
				local x = x0 + i
				local z = z0 + j
				local noise = perlin:get2d({x = x, y = z})
				if noise > NOISEL and noise < NOISEH then
					-- Calculate column chance for varying tree density.
					local colcha = colchamin + math.floor(factor * (math.abs(noise - nav) / nra) ^ 2)
					if math.random(1,colcha) == 1 then
						-- Find ground level y.
						local ground_y = nil
						for y=maxp.y,minp.y,-1 do
							local nodename = minetest.env:get_node({x=x,y=y,z=z}).name
							if nodename ~= "air" and nodename ~= "default:water_source" then
								ground_y = y
								break
							end
						end
						-- Check if ground, check altitude
						if ground_y and ground_y <= MAXALT  then
							-- Check for grass, check trunk spacing
							local nodename = minetest.env:get_node({x=x,y=ground_y,z=z}).name
							local junnear = minetest.env:find_node_near({x=x,y=ground_y,z=z}, MINSPA, "default:jungletree")
							local defnear = minetest.env:find_node_near({x=x,y=ground_y,z=z}, MINSPA, "default:tree")
							local connear = minetest.env:find_node_near({x=x,y=ground_y,z=z}, MINSPA, "conifers:trunk")
							if nodename == "default:dirt_with_grass" and junnear == nil and defnear == nil and connear == nil then
								-- Spawn jungletree
								add_jungletree({x=x,y=ground_y+1,z=z})
							end
						end
					end
				end
			end
			end
		end
	end)
end

minetest.register_abm({
	nodenames = {"jungletree:sapling"},
	interval = SAPLING_ABM_INTERVAL,
	chance = SAPLING_ABM_CHANCE,
	action = function(pos, node)
		add_jungletree(pos)
	end,
})
