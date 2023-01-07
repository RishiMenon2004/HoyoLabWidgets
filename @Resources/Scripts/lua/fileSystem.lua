json = dofile(ResourcesFolder.."Scripts/lua/json.lua")

fileSystem = {}

local function file_exists(file)
	local f = io.open(file, "rb")
	if f then f:close() end
	return f ~= nil
end

function fileSystem.get_json_from_file(file)
	if not file_exists(file) then return {} end
	local file = io.open(file, "rb")
	fileContents = file:read("*a")
	local jsonString = json.decode(fileContents)
	file:close()
	return jsonString
end

function fileSystem.write_json_to_file(file,data)
	if not file_exists(file) then return 0 end
	local file = io.open(file, "w+")
	file:write(json.encode(data))
	file:close()
	return 1
end

function fileSystem.lines_from(file)
	if not file_exists(file) then return {} end
	local lines = {}
	for line in io.lines(file) do 
	  lines[#lines + 1] = line
	end
	return lines
end

return fileSystem