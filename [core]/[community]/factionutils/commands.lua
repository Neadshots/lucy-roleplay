local mysql = exports.mysql

function birlikaracekle(thePlayer, theCommand, vehicleID, factionID)
		if not (vehicleID) or not (factionID) then
			outputChatBox("KOD: /" .. theCommand .. " [aracID] [birlikID]", thePlayer, 255, 194, 14)
		else
			local owner = -1
			local theVehicle = exports.pool:getElement("vehicle", vehicleID)
			local factionElement = exports.pool:getElement("team", factionID)
			if getElementData(theVehicle, "owner") == getElementData(thePlayer, "dbid") then
			local sahibi = getElementData(thePlayer, "dbid")
			if theVehicle then
				if (tonumber(factionID) == -1) then
					owner = getElementData(thePlayer, "account:character:id")
				else
					if not factionElement then
						outputChatBox("#6699FF[!] #FF0000Lütfen doğru bilgileri girin.", thePlayer, 255, 255, 255, true)
						return
					end
				end
             
				dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `owner`='".. (owner) .."', `faction`='" .. (factionID) .. "', `eskisahibi`='" .. (sahibi) .. "' WHERE id = '" .. (vehicleID) .. "'")

				local x, y, z = getElementPosition(theVehicle)
				local int = getElementInterior(theVehicle)
				local dim = getElementDimension(theVehicle)
				exports['vehicle']:reloadVehicle(tonumber(vehicleID))
				local newVehicleElement = exports.pool:getElement("vehicle", vehicleID)
				setElementPosition(newVehicleElement, x, y, z)
				setElementInterior(newVehicleElement, int)
				setElementDimension(newVehicleElement, dim)
				outputChatBox("#6699FF[!] #FFFFFFAracınız #66FF00(ID : "..vehicleID..") #FFFFFFbirliğe #66FF00(ID : "..factionID..") #FFFFFFgeçirilmiştir.", thePlayer, 255, 255, 255, true)

				exports.logs:dbLog(thePlayer, 4, { pveh, theVehicle }, theCommand.." "..factionID)
				--addVehicleLogs(vehicleID, theCommand.." "..factionID, thePlayer)
			else
				outputChatBox("#6699FF[!] #FF0000Lütfen doğru bilgileri girin.", thePlayer, 255, 255, 255, true)
			end
			else
			outputChatBox("#6699FF[!] #FF0000Bu işlemi aracın sahibi yapabilir.", thePlayer, 255, 255, 255, true)
		end
	end
end
addCommandHandler("abv", birlikaracekle)

function birlikaraccikart(thePlayer, theCommand, vehicleID)
		if not (vehicleID) then
			outputChatBox("KOD: /" .. theCommand .. " [aracID]", thePlayer, 255, 194, 14)
		else
		    local factionID = -1
			local owner = getElementData(thePlayer, "dbid")
			local theVehicle = exports.pool:getElement("vehicle", vehicleID)
			local sahibi = getElementData(thePlayer, "dbid")
		    dbQuery(
		    	function(qh, thePlayer, vehicleID)
		    		local res, rows, err = dbPoll(qh, 0)
		    		if rows > 0 then
		    			sayi = tonumber(res[1]["eskisahibi"])
		    			if sayi < 0 then return end
	    				if sahibi == sayi then
							if theVehicle then
				             
								dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `owner`='".. (owner) .."', `faction`='" .. (factionID) .. "', `eskisahibi`='" .. (sahibi) .. "' WHERE id = '" .. (vehicleID) .. "'")


								local x, y, z = getElementPosition(theVehicle)
								local int = getElementInterior(theVehicle)
								local dim = getElementDimension(theVehicle)
								exports['vehicle']:reloadVehicle(tonumber(vehicleID))
								local newVehicleElement = exports.pool:getElement("vehicle", vehicleID)
								setElementPosition(newVehicleElement, x, y, z)
								setElementInterior(newVehicleElement, int)
								setElementDimension(newVehicleElement, dim)
								local yenisahibi = getElementData(newVehicleElement, "owner") or -1
								outputChatBox("#6699FF[!] #FFFFFFAracınız #66FF00(ID : "..vehicleID..") #FFFFFFoyuncuya #66FF00(ID : "..exports.cache:getCharacterNameFromID(yenisahibi)..") #FFFFFFgeçirilmiştir.", thePlayer, 255, 255, 255, true)

								exports.logs:dbLog(thePlayer, 4, { pveh, theVehicle }, theCommand.." "..factionID)
								--addVehicleLogs(vehicleID, theCommand.." "..factionID, thePlayer)
							else
								outputChatBox("#6699FF[!] #FF0000Lütfen doğru bilgileri girin.", thePlayer, 255, 255, 255, true)
							end
						else
							outputChatBox("#6699FF[!] #FF0000Bu işlemi aracın sahibi yapabilir.", thePlayer, 255, 255, 255, true)
						end
		    		end
		    	end,
		    {thePlayer, vehicleID}, mysql:getConnection(), "SELECT `eskisahibi` FROM `vehicles` WHERE `id`=" .. (vehicleID))
	end
end
addCommandHandler("abg", birlikaraccikart)