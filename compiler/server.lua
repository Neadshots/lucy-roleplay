local resources = {}
local lastResource = 0
function compileResource(res)
	local xmlPatch = ":"..res.."/meta.xml"
	local xmlFile = xmlLoadFile(xmlPatch)
	if xmlFile then
		outputDebugString("RESOURCE: "..res,0,55,167,220)
		local index = 0
		local scriptNode = xmlFindChild(xmlFile,'script',index)
		if scriptNode then
			repeat
			local scriptPath = xmlNodeGetAttribute(scriptNode,'src') or false
			local scriptType = xmlNodeGetAttribute(scriptNode,'type') or "server"
			local serverEncypt = xmlNodeGetAttribute(scriptNode,'encypt') or "null"
			if scriptPath and (scriptType:lower() == "client" or serverEncypt:lower() == "true") then
				if string.find(scriptPath:lower(), "luac") then
					outputDebugString("COMPILER: "..scriptPath.." zaten şifreli.",3,220,20,20)
				else
					local FROM=":"..res.."/"..scriptPath
					local TO= ":"..res.."/"..scriptPath.."c"
					fetchRemote("http://luac.mtasa.com/?compile=1&debug=0&obfuscate=1", function(data) fileSave(TO,data) end, fileLoad(FROM), true)
					xmlNodeSetAttribute(scriptNode,'src',scriptPath..'c')
					if serverEncypt:lower() == "true" then
						if fileExists(FROM) then
							outputDebugString("COMPILER: ".. FROM.." şifrelenemedi, dosya zaten mevcut. (encypt = true)",3,0,255,0)
							fileDelete(FROM)
						end
					end
					outputDebugString("COMPILER: ".. TO.." başarıyla şifrelendi",3,0,255,0)
				end
			end
			index = index + 1
			scriptNode = xmlFindChild(xmlFile,'script',index)
			until not scriptNode
		end
		xmlSaveFile(xmlFile)
		xmlUnloadFile(xmlFile)
	else
		outputDebugString("COMPILER: Dosya kaynağı eksik: meta.xml",3,220,20,20)
		return false
	end
end

function uncompileResource(res)
	local xmlPatch = ":"..res.."/meta.xml"
	local xmlFile = xmlLoadFile(xmlPatch)
	if xmlFile then
		outputDebugString("RESOURCE: "..res,0,55,167,220)
		local index = 0
		local scriptNode = xmlFindChild(xmlFile,'script',index)
		if scriptNode then
			repeat
			local scriptPath = xmlNodeGetAttribute(scriptNode,'src') or false
			local scriptType = xmlNodeGetAttribute(scriptNode,'type') or "server"
			if scriptPath and scriptType:lower() == "client" then
				if string.find(scriptPath:lower(), "luac") then
					fileDelete(":"..res.."/"..scriptPath)
					xmlNodeSetAttribute(scriptNode,'src',scriptPath:gsub("luac","lua"))
					outputDebugString("COMPILER: "..res.."/"..scriptPath .." adlı dosya başarıyla çözüldü.",0,255,0,0)
				else
					outputDebugString("COMPILER: "..scriptPath.." adlı dosya zaten şifresiz.",3,220,20,20)
				end
			end
			index = index + 1
			scriptNode = xmlFindChild(xmlFile,'script',index)
			until not scriptNode
		end
		xmlSaveFile(xmlFile)
		xmlUnloadFile(xmlFile)
	else
		outputDebugString("COMPILER: Nem olvasható: meta.xml",3,220,20,20)
		return false
	end
end


addCommandHandler("compileall", function(player,cmd)
	if exports['integration']:isPlayerDeveloper(player) or getElementType(player) == "console" then
		resources = getResources()
		lastResource = 0
		compileNextResource()
	end
end)

function compileNextResource()
	if lastResource < #resources then
		lastResource = lastResource + 1
		compileResource(getResourceName(resources[lastResource]))
		setTimer(compileNextResource, 1000, 1)
	end
end
local syntax = exports.pool:getServerSyntax(false, "s")

addCommandHandler("compile", function(player,cmd,res)
	if exports['integration']:isPlayerDeveloper(player) or getElementType(player) == "console" then
        if not res then
            outputChatBox(syntax .. "/" .. cmd .. " [resname]", player, 0, 255, 0, true)
            return
        end
		local resource = getResourceFromName(res)
		if resource then
			outputChatBox(syntax .. "Resource COMPILER loading ...", player, 0, 255, 0, true)
			compileResource(res)
			outputChatBox(syntax .. "Resource COMPILER completed!", player, 0, 255, 0, true)
		else
			outputChatBox(syntax .. "Could not find resource!", player, 255, 0, 0, true)
		end
	end
end)

addCommandHandler("recompile", function(player,cmd,res)
	if exports['integration']:isPlayerDeveloper(player) or getElementType(player) == "console" then
        if not res then
            outputChatBox(syntax .. "/" .. cmd .. " [resname]", player, 0, 255, 0, true)
            return
        end
		local resource = getResourceFromName(res)
		if resource then
			uncompileResource(res)
			setTimer(
				function()
					compileResource(res)
				end,
			1500, 1)
		else
			outputChatBox(syntax .. "Could not find resource!", player, 255, 0, 0, true)
		end
	end
end)

addCommandHandler("uncompile", function(player,cmd,res)
	if exports['integration']:isPlayerDeveloper(player) or getElementType(player) == "console" then
        if not res then
            outputChatBox(syntax .. "/" .. cmd .. " [resname]", player, 0, 255, 0, true)
            return
        end
		local resource = getResourceFromName(res)
		if resource then
			outputChatBox(syntax .. "Resource UNCOMPILER loading ...", player, 0, 255, 0, true)
			uncompileResource(res)
			outputChatBox(syntax .. "Resource UNCOMPILER completed!", player, 0, 255, 0, true)
		else
			outputChatBox(syntax .. "Could not find resource!", player, 255, 0, 0, true)
		end
	end
end)

function fileLoad(path)
    local File = fileOpen(path, true)
    if File then
        local data = fileRead(File, 500000000)
        fileClose(File)
        return data
    end
end
 
function fileSave(path, data)
    local File = fileCreate(path)
    if File then
        fileWrite(File, data)
        fileClose(File)
    end
end