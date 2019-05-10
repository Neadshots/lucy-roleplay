function aracCek(thePlayer, commandName, id)
local playerID = getElementData(thePlayer, "dbid")
		if not (id) then
			outputChatBox("#ff0000 [!] #ffffffKOD: /" .. commandName .. " [ARAC ID]", thePlayer, 255, 194, 14,true)
		else
		local vehicle = exports.pool:getElement("vehicle", id)
		if vehicle then
			local vehicleOwner = getElementData(vehicle, "owner")
			if vehicleOwner == playerID then
			if exports.global:takeMoney(thePlayer, 4000) then
				local r = getPedRotation(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
				y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )

				if	(getElementHealth(vehicle)==0) then
					spawnVehicle(vehicle, x, y, z, 0, 0, r)
				else
					setElementPosition(vehicle, x, y, z)
					setVehicleRotation(vehicle, 0, 0, r)
				end


				outputChatBox("#ff0000[!] #ffffffAracını Yanına Çektin #ff0000[4.000$] #ffffffÖdendi.", thePlayer, 255, 194, 14,true) -- #FFFFFF Olan Kodu ( http://www.abecem.net/web/renk.html ) sitesinden bularak değiştir, Birşeylere Renk Eklemek İster İsen,
			else                                                                              -- ( 255, 194, 14,true ) R G B Kodunun Yanına "," Çekip "true" yazman yeterli..
				outputChatBox("#ff0000[!] #ffffffYeterli Miktarda Paran Yok.", thePlayer, 255, 0, 0,true)
			end
		end
		else
			outputChatBox("#ff0000[!] #ffffffArac Size Ait Değildir.", thePlayer, 255, 0, 0,true)
	end
end
end
addCommandHandler("aracgetir", aracCek, false, false)
