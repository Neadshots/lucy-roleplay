local mysql = exports.mysql

function saveToDescription(descriptions, theVehicle)
	local dbid = getElementData(theVehicle, "dbid")
	local acceptedQuerys = { }
	for i = 1, 5 do
		local result = dbExec(mysql:getConnection(),"UPDATE vehicles SET description" .. i .. " = '" .. ( descriptions[i] ) .. "' WHERE id = '".. (dbid) .."'")
		if result then
			exports.anticheat:changeProtectedElementDataEx(theVehicle, "description:"..i, descriptions[i], true)
			acceptedQuerys[i] = true
		end
	end
	local counter = 0
	for j = 1, #acceptedQuerys do
		if acceptedQuerys[j] then
			counter = counter + 1
		end
	end
	if counter == 5 then
		outputChatBox("Description saved succesfully.", source, 0, 255, 0)
	else
		outputChatBox("ERROR-VEHDESC-0001 Please report on the mantis. Thank-you.", source, 255, 0, 0)
	end
end
addEvent("saveDescriptions", true)
addEventHandler("saveDescriptions", getRootElement(), saveToDescription)





addEvent("oyuncuBilgisi", true)
addEventHandler("oyuncuBilgisi", getRootElement(), function(thePlayer, theVehicle)
	 for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
		local owner = tonumber(getElementData(value, "owner"))
		
				local dbid2 = getElementData(theVehicle, "dbid")
	    local fetchData = mysql:query_fetch_assoc( "SELECT `fiyat` FROM `vehicles` WHERE `id`='"..mysql:escape_string(getElementData(value, "dbid")).."'" )
        local fiyat = fetchData["fiyat"] or 0


	end
		triggerServerEvent(thePlayer, "oyuncuBilgisiDevam", thePlayer, fiyat )
end)