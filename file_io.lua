local file_io = {}
-- http://lua-users.org/wiki/FileInputOutput

-- check if a file exists
function file_io.file_exists(file)
	local f = io.open(file, "rb")
	if f then f:close() end
	return f ~= nil
end

function file_io.lines_from(file)
	lines = {}
	for line in io.lines(file) do
		lines[#lines + 1] = line
	end
	return lines
end

function file_io.parse_room_file(n)
	local f = file_io.lines_from(file_io.room_files[n][1])
	local m = room:new()
	m:init(file_io.room_files[n][2], file_io.room_files[n][3])
	for j,str in ipairs(f) do
		i = 1
		for c in str:gmatch"." do
			if c == "W" then
				m[i][j].kind = "wall"
			elseif c == "-" then
				m[i][j].kind = "floor"
			elseif c == "t" then
				m[i][j].kind = "teleporter"
				table.insert(spawner.teleporters, {x=i, y=j})
			elseif c == "w" then
				m[i][j].kind = "water_border"
			elseif c == "b" then
				m[i][j].kind = "ballpost"
			else
				m[i][j].kind = "void"
			end
			i = i+1
		end
	end

	m:setup_tile_images()
	return m
end

file_io.room_files = {
	{"assets/rooms/room_empty.txt", 16, 16},
	{"assets/rooms/room_empty_horiz.txt", 24, 8},
	{"assets/rooms/room_s.txt", 6, 24},
	{"assets/rooms/room_test.txt", 16, 14},
}

return file_io
