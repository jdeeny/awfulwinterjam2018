local file_io = {}
-- http://lua-users.org/wiki/FileInputOutput

-- check if a file exists
function file_io.file_exists(file)
	local f = io.open(file, "rb")
	if f then f:close() end
	return f ~= nil
end

function file_io.lines_from(file)
	local lines = {}
	local f = love.filesystem.newFile(file)
	f:open("r")
	for line in f:lines() do
		lines[#lines + 1] = line
	end
	f:close()
	return lines
end

function file_io.parse_room_file(n)
	local f = file_io.lines_from(file_io.room_files[n][1])
	local m = Level:new(file_io.room_files[n][2], file_io.room_files[n][3]):setLayerEffects(Layer.WATER, water_effect)
	--m:init(file_io.room_files[n][2], file_io.room_files[n][3])
	for j,str in ipairs(f) do
		local i = 1
		for c in str:gmatch"." do
			local tilekind = m:find_symbol(c) or 'void'
			if tilekind == 'teleporter' then
				table.insert(spawner.teleporters, {x=i, y=j})
			end
			m:addTile(grid.hash(i, j), i, j, m.tileset[tilekind])
			i = i+1
		end
	end

	--m:setup_tile_images()
	return m
end

file_io.room_files = {
    -- ONLY ADD NEW ROOMS TO THE END OF THIS LIST (unless you also update all stages)
	-- Stages use the direct index of these values to set the rooms. 
	{"assets/rooms/room_boom.txt", 16, 20},              --1
	{"assets/rooms/room_cart.txt", 8, 22},
	{"assets/rooms/room_cavern.txt", 54, 18},
	{"assets/rooms/room_columns.txt", 16, 16},
	{"assets/rooms/room_complex.txt", 18, 22},           --5
	{"assets/rooms/room_empty.txt", 14, 14},
	{"assets/rooms/room_empty_horiz.txt", 24, 8},
	{"assets/rooms/room_moat.txt", 24, 20},
	{"assets/rooms/room_octagon.txt", 24, 24},
	{"assets/rooms/room_pillar.txt", 24, 24},            --10
	{"assets/rooms/room_pool.txt", 16, 16},
	{"assets/rooms/room_rubble.txt", 24, 8},
	{"assets/rooms/room_s.txt", 8, 24},
	{"assets/rooms/room_small.txt", 16, 12},
	{"assets/rooms/room_symbol.txt", 46, 24},             --15
	{"assets/rooms/room_test.txt", 16, 14},
	{"assets/rooms/room_z.txt", 18, 12},
	{"assets/rooms/room_deserted_laboratory.txt", 72, 12},
	{"assets/rooms/room_rivers.txt", 72, 12},
	{"assets/rooms/room_hallways.txt",36,14},             --20
	{"assets/rooms/room_watertest.txt", 16, 12},
	{"assets/rooms/room_tiny.txt", 11, 8},
	{"assets/rooms/room_nobelstage.txt", 54, 30},
}

return file_io
