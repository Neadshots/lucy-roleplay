local _outputChatBox = outputChatBox
local function outputChatBox(text, showPlayer)
	if not text then return end
	local syntax = exports.pool:getServerSyntax(false, "s")
	_outputChatBox(syntax..text, showPlayer, 255, 255, 255, true)
end
function showStats(thePlayer, commandName, targetPlayerName)
	local showPlayer = thePlayer
	if exports.integration:isPlayerTrialAdmin(thePlayer) and targetPlayerName then
		targetPlayer = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerName)
		if targetPlayer then
			if getElementData(targetPlayer, "loggedin") == 1 then
				thePlayer = targetPlayer
			else
				outputChatBox("Player is not logged in.", showPlayer, 255, 0, 0)
				return
			end
		else
			return
		end
	end
	
	local isOverlayDisabled = true
	--LICNESES
	local carlicense = getElementData(thePlayer, "license.car")
	local bikelicense = getElementData(thePlayer, "license.bike")
	local boatlicense = getElementData(thePlayer, "license.boat")
	--local pilotlicense = getElementData(thePlayer, "license.pilot")
	local fishlicense = getElementData(thePlayer, "license.fish")
	local gunlicense = getElementData(thePlayer, "license.gun")
	local gun2license = getElementData(thePlayer, "license.gun2")
	if (carlicense==1) then
		carlicense = "Var"
	elseif (carlicense==3) then
		carlicense = "Sınavı geçmiş"
	else
		carlicense = "Yok"
	end
	if (bikelicense==1) then
		bikelicense = "Var"
	elseif (bikelicense==3) then
		bikelicense = "Sınavı geçmiş"
	else
		bikelicense = "Yok"
	end
	if (boatlicense==1) then
		boatlicense = "Var"
	else
		boatlicense = "Yok"
	end
	--[[
	local pilotLicenses = exports['mdc']:getPlayerPilotLicenses(thePlayer) or {}
	local pilotlicense = ""
	local maxShow = 5
	local numAdded = 0
	local numOverflow = 0
	local typeratings = 0
	for k,v in ipairs(pilotLicenses) do
		local licenseID = v[1]
		local licenseValue = v[2]
		local licenseName = v[3]
		if licenseID == 7 then --if typerating
			if licenseValue then
				typeratings = typeratings + 1
			end
		else
			if numAdded >= maxShow then
				numOverflow = numOverflow + 1
			else
				if numAdded == 0 then
					pilotlicense = pilotlicense..tostring(licenseName)
				else
					pilotlicense = pilotlicense..", "..tostring(licenseName)
				end
				numAdded = numAdded + 1
			end
		end
	end
	if(numAdded == 0) then
		pilotlicense = "Yok"
	else
		if numOverflow > 0 then
			pilotlicense = pilotlicense.." (+"..tostring(numOverflow+typeratings)..")"
		else
			if typeratings > 0 then
				pilotlicense = pilotlicense.." (+"..tostring(typeratings)..")"
			else
				pilotlicense = pilotlicense.."."
			end
		end
	end
	]]--
	if (fishlicense==1) then
		fishlicense = "Var"
	else
		fishlicense = "Yok"
	end
	if (gunlicense==1) then
		gunlicense = "Var"
	else
		gunlicense = "Yok"
	end
	if (gun2license==1) then
		gun2license = "Var"
	else
		gun2license = "Yok"
	end
	--VEHICLES
	local dbid = tonumber(getElementData(thePlayer, "dbid"))
	local carids = ""
	local numcars = 0
	local printCar = ""
	for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
		local owner = tonumber(getElementData(value, "owner"))

		if (owner) and (owner==dbid) then
			local id = getElementData(value, "dbid")
			carids = carids .. id .. ", "
			numcars = numcars + 1
			exports.anticheat:changeProtectedElementDataEx(value, "owner_last_login", exports.datetime:now(), true)
		end
	end
	printCar = numcars .. "/" .. getElementData(thePlayer, "maxvehicles")

	-- PROPERTIES
	local properties = ""
	local numproperties = 0
	for key, value in ipairs(getElementsByType("interior")) do
		local interiorStatus = getElementData(value, "status")
		
		if interiorStatus[4] and interiorStatus[4] == dbid and getElementData(value, "name") then
			local id = getElementData(value, "dbid")
			properties = properties .. id .. ", "
			numproperties = numproperties + 1
			--Update owner last login / MAXIME 2015.01.07
			exports.anticheat:changeProtectedElementDataEx(value, "owner_last_login", exports.datetime:now(), true)
		end
	end

	if (properties=="") then properties = "None.  " end
	if (carids=="") then carids = "None.  " end
	--FETCH ABOVE
	local hoursplayed = getElementData(thePlayer, "hoursplayed")
	local info = {}

	outputChatBox(getPlayerName(thePlayer):gsub("_", " ").."'e ait Karakter Bilgileri", showPlayer , 255, 194, 14)
	outputChatBox(" Araba Ehliyeti: " .. carlicense, showPlayer)
	outputChatBox(" Motor Ehliyeti: " .. bikelicense, showPlayer)
	--outputChatBox(" Gemi Ehliyeti: " .. boatlicense, showPlayer)
	--outputChatBox(" Pilot Lisansı: " .. pilotlicense, showPlayer)
	outputChatBox(" 1.Seviye silah lisansı: " .. gunlicense , showPlayer)
	outputChatBox(" 2.Seviye silah lisansı: " .. gun2license , showPlayer)

	outputChatBox(" Araçlar (" .. printCar .. "): " .. string.sub(carids, 1, string.len(carids)-2) , showPlayer)
	outputChatBox(" Mülkler (" .. numproperties .. "/"..(getElementData(thePlayer, "maxinteriors") or 10).."): " .. string.sub(properties, 1, string.len(properties)-2) , showPlayer)
	outputChatBox(" Bu karakterde geçirilen zaman: " .. hoursplayed .. " Saat." , showPlayer)
	--CAREER
	local job = getElementData(thePlayer, "job") or 0
	if job == 0 then
		outputChatBox(" Kariyer: İşsiz", showPlayer)
	else
		local jobName = exports["jobs"]:getJobTitleFromID(job)
		local joblevel = getElementData(thePlayer, "jobLevel") or 1
		local jobProgress = getElementData(thePlayer, "jobProgress") or 0
		
		outputChatBox(" Kariyer: "..jobName, showPlayer)
		outputChatBox("   - Beceri Seviyesi: "..joblevel, showPlayer)
		outputChatBox("   - İlerleme: "..jobProgress, showPlayer)
	end

	outputChatBox( carried, showPlayer)

	local currentGC = getElementData(thePlayer, "account:credits") or 0
	local bankmoney = getElementData(thePlayer, "bankmoney") or 0
	local money = getElementData(thePlayer, "money") or 0
	
	outputChatBox( " Finans: ", showPlayer)
	outputChatBox( "   - Bakiye: "..exports.global:formatMoney(currentGC), showPlayer)
	outputChatBox( "   - Para: $"..exports.global:formatMoney(money), showPlayer)
	outputChatBox( "   - Banka: $"..exports.global:formatMoney(bankmoney), showPlayer)
	
	
end
addCommandHandler("stats", showStats, false, false)
addEvent("showStats", true)
addEventHandler("showStats", root, showStats)