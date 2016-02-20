local component = require("component")
local fs = require("filesystem")
local internet = require("internet")
local shell = require("shell")

if not component.isAvailable("internet") then
	io.stderr:write("ghget requires an internet card to run.")
	return
end

local args, options = shell.parse(...)

if #args >= 2 then
	local repo = args[1]
	local branch
	local remoteFile
	local localFile

	if #args == 2 then
		branch = "master"
		remoteFile = args[2]
		localFile = remoteFile
	elseif #args == 3 then
		branch = args[2]
		remoteFile = args[3]
		localFile = remoteFile
	elseif #args == 4 then
		branch = args[2]
		remoteFile = args[3]
		localFile = args[4]
	end

	local url = "https://raw.githubusercontent.com/" .. repo .. "/" .. branch .. "/" .. remoteFile

	io.write("Downloading from  " .. url .. "... ")

	local file, reason = io.open(localFile, "w")
	if not file then
		io.stderr:write("Failed to open file for writing: " .. reason)
		return
	end

	local result, response = pcall(internet.request, url)
	if result then
		io.write("success.\n")
		for chunk in response do
			file:write(chunk)
		end

		file:close()
		io.write("Saved data to " .. localFile .. "\n")
	else
		io.write("failed.\n")
		file:close()
		fs.remove(localFile)
		io.stderr:write("Request failed: " .. response .. "\n")
	end
	return
end

-- usage
io.write("Usages:\n")
io.write("ghget <user>/<repository> <remoteFile>\n")
io.write("ghget <user>/<repository> <branch> <remoteFile>\n")
io.write("ghget <user>/<repository> <branch> <remoteFile> <localFile>\n")
io.write(" -f: Force overwrite existing files.\n")
io.write("<branch> is master if not specified.\n")
