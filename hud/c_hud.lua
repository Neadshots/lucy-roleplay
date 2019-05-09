local saveJSON = {}
saveJSON["mode"] = 1
--// Default: MTA (1), Custom: SAMP-1 (2), SAMP-2 (2) 
function jsonGET(file)
    local fileHandle
    local jsonDATA = {}
    if not fileExists(file) then
        fileHandle = fileCreate(file)
        fileWrite(fileHandle, toJSON({["mode"] = 1}))
        fileClose(fileHandle)
        fileHandle = fileOpen(file)
    else
        fileHandle = fileOpen(file)
    end
    if fileHandle then
        local buffer
        local allBuffer = ""
        while not fileIsEOF(fileHandle) do
            buffer = fileRead(fileHandle, 500)
            allBuffer = allBuffer..buffer
        end
        jsonDATA = fromJSON(allBuffer)
        fileClose(fileHandle)
    end
    return jsonDATA
end
 
function jsonSAVE(file, data)
    if fileExists(file) then
        fileDelete(file)
    end
    local fileHandle = fileCreate(file)
    fileWrite(fileHandle, toJSON(data))
    fileFlush(fileHandle)
    fileClose(fileHandle)
    return true
end

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        local data = jsonGET("@variables.json")
        saveJSON = data
        triggerEvent('hud:changeInterface', localPlayer, saveJSON['mode'] or 1)
    end
)

addCommandHandler("samp",
	function(cmd, mode)
		if localPlayer:getData("loggedin") == 1 then
			if mode and (tonumber(mode) >= 2 and tonumber(mode) <= 3) then
				saveJSON['mode'] = mode
				outputChatBox(exports.pool:getServerSyntax(false, "s").."Arayüz modu başarıyla seçildi. ("..mode..")", 255, 255, 255, true)
				triggerEvent('hud:changeInterface', localPlayer, mode)
			else
				outputChatBox(exports.pool:getServerSyntax(false, "s").."Aktif SAMP Arayüz Modları: /samp 2, /samp 3", 255, 255, 255, true)
			end
		end
	end
)

addCommandHandler("mta",
	function(cmd)
		if localPlayer:getData("loggedin") == 1 then
			local mode = 1
			saveJSON['mode'] = mode
			outputChatBox(exports.pool:getServerSyntax(false, "s").."Arayüz modu başarıyla seçildi. ("..mode..")", 255, 255, 255, true)
			triggerEvent('hud:changeInterface', localPlayer, mode)
		end
	end
)

addEventHandler("onClientResourceStop", resourceRoot,
    function()
        jsonSAVE("@variables.json", saveJSON)
    end
)

function getPlayerInterfaceMode()
	return saveJSON['mode']
end

function RemoveHEXColorCode( s )
    return s:gsub( '#%x%x%x%x%x%x', '' ) or s
end

function bindSomeHotKey()
	bindKey("z", "down", function()
		if getElementData(localPlayer, "vehicle_hotkey") == "0" then 
			return false
		end
		triggerServerEvent('realism:seatbelt:toggle', localPlayer, localPlayer)
	end) 

	bindKey("x", "down", function() 
		if getElementData(localPlayer, "vehicle_hotkey") == "0" then 
			return false
		end
		triggerServerEvent('vehicle:togWindow', localPlayer)
	end)
end
addEventHandler("onClientResourceStart", resourceRoot, bindSomeHotKey)

function isInSlot(dX, dY, dSZ, dM)
	if isCursorShowing() then
		local cX ,cY = getCursorPosition()
		cX,cY = cX*_x , cY*_y
	    if(cX >= dX and cX <= dX+dSZ and cY >= dY and cY <= dY+dM) then
	        return true, cX, cY
	    else
	        return false
	    end
	end
end

local components = { "weapon", "ammo", "health", "clock", "money", "breath", "armour", "wanted", "radar" }
addEvent('hud:changeInterface', true)
addEventHandler('hud:changeInterface', root, function(data)
	if (tonumber(data) ~= 1) then
        for i, v in ipairs(components) do
            setPlayerHudComponentVisible(v, true)
        end
	else
  		for i, v in ipairs(components) do
            setPlayerHudComponentVisible(v, false)
        end
	end
end)