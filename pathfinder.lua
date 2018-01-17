local pathfinder = { fringes = {}, mesh = {} }

local MAXRADIUS = 60
local hash = grid.hash
local unhash = grid.unhash
local cx, cy, neighbor_x, neighbor_y, neighbor_hash
local orth_neighbors = {}
local orth_dirs = {
	{x=1, y=0}, -- east
	{x=-1, y=0}, -- west
	{x=0, y=1}, -- south
	{x=0, y=-1}, -- north
}
pathfinder.origin_x = -9999
pathfinder.origin_y = -9999
pathfinder.rebuild_time = 0

function pathfinder.reset()
	pathfinder.mesh = {}
	for k = 0, 64 do
		pathfinder.fringes[k] = {}
	end
end

function pathfinder.build_nav_mesh(origin_x, origin_y)
	pathfinder.reset()
	pathfinder.origin_x, pathfinder.origin_y = origin_x, origin_y
	pathfinder.fringes[0][hash(origin_x, origin_y)] = 10
	pathfinder.mesh[hash(origin_x, origin_y)] = 10

	for k = 1, MAXRADIUS do
		for i,v in pairs(pathfinder.fringes[k-1]) do
			-- i is the hash of the square; v its "distance" to the player
			cx, cy = unhash(i)
			orth_neighbors = {}
			for direction = 1, 4 do -- orthogonal neighbors
				neighbor_x, neighbor_y = cx + orth_dirs[direction].x, cy + orth_dirs[direction].y
				if not current_room:is_solid(neighbor_x, neighbor_y) then
					neighbor_hash = hash(neighbor_x, neighbor_y)
					if not pathfinder.mesh[neighbor_hash] or pathfinder.mesh[neighbor_hash] > v + 10 then
						pathfinder.mesh[neighbor_hash] = v + 10
						pathfinder.fringes[k][neighbor_hash] = v + 10
						orth_neighbors[direction] = true
					end
				end
			end

			-- now consider diagonals

		end
	end
end

local pgx, pgy
function pathfinder.update()
	pgx = room.pos_to_grid(player.x)
	pgy = room.pos_to_grid(player.y)
	if (pgx ~= pathfinder.origin_x or pgy ~= pathfinder.origin_y) and game_time >= pathfinder.rebuild_time then
		pathfinder.build_nav_mesh(pgx, pgy)
		pathfinder.rebuild_time = game_time + 0.5
	end
end

function pathfinder.draw_debug()
	local v
	love.graphics.setFont(debug_font)
	for i = 1, current_room.width do
		for j = 1, current_room.height do
			v = pathfinder.mesh[hash(i,j)]
			if v then
				love.graphics.print(v, math.floor(i * TILESIZE - camera.x), math.floor(j * TILESIZE - camera.y))
			end
		end
	end
end

return pathfinder
