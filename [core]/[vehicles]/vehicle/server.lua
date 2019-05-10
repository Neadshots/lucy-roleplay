mysql = exports.mysql

local _setElementData = setElementData
function setElementData(element, data, index)
	return _setElementData(element, data, index)
end

local null = nil
local toLoad = { }
local threads = { }
local syntaxTable = {
	["s"] = "#00a8ff[Lucy RPG]#ffffff ",
	["e"] = "#e84118[Lucy RPG]#ffffff ",
	["w"] = "#fbc531[Lucy RPG]#ffffff ",
}
--local vehicleTempPosList = {}
local variants =
{
	-- [model] = {{first variations}, {second variations}}
	[416] = {{0,1}}, -- Ambulance
	[435] = {{-1,0,1,2,3,4,5}}, -- Trailer
	[450] = {{-1,0}}, -- Trailer 2
	[607] = {{-1,0,1,2}}, -- Baggage Trailer
	[485] = {{-1,0,1,2}}, -- Baggage
	[433] = {{-1,0,1}}, -- Barracks
	[499] = {{-1,0,1,2,3}}, -- Benson
	[581] = {{0,1,2},{3,4}}, -- BF-400
	[424] = {{-1,0}}, -- BF Injection
	[504] = {{0,1,2,3,4,5}}, -- Bloodring
	[422] = {{-1,0,1}}, -- Bobcat
	[482] = {{-1,0}}, -- Burrito
	[457] = {{-1,0,1,2},{-1,3,4,5}}, -- Caddy
	[483] = {{-1,1}}, -- Camper
	[415] = {{-1,0,1}}, -- Cheetah
	[437] = {{0,1}}, -- Coach
	[472] = {{-1,0,1,2}}, -- Coast Guard
	[521] = {{0,1,2},{3,4}}, -- FCR900
	[407] = {{0,1,2}}, -- Firetruck
	[455] = {{-1,0,1,2}}, -- Flatbed
	[434] = {{-1,0}}, -- Hotknife
	[502] = {{0,1,2,3,4,5}}, -- Hotring A
	[503] = {{0,1,2,3,4,5}}, -- Hotring B
	[571] = {{0}}, -- Kart
	[595] = {{-1,0,1}}, -- Launch
	[484] = {{-1,0}}, -- Marquis
	[500] = {{-1,0,1}}, -- Mesa
	[556] = {{-1,0,1,2}}, -- Monster A
	[557] = {{-1,1}}, -- Monster B
	[423] = {{-1,0,1}}, -- Mr. Whoopee
	[414] = {{-1,0,1,2,3}}, -- Mule
	[522] = {{0,1,2},{3,4}}, -- NRG-500
	[470] = {{-1,0,1,2}}, -- Patriot
	[404] = {{-1,0}}, -- Perennial
	[600] = {{-1,0,1}}, -- Picador
	[413] = {{-1,0}}, -- Pony
	[453] = {{-1,0,1}}, -- Reefer
	[442] = {{-1,0,1,2}}, -- Romero
	[440] = {{-1,0,1,2,3,4,5}}, -- Rumpo
	[543] = {{-1,0,1,2,3}}, -- Sadler
	[605] = {{-1,0,1,2,3}}, -- Sadler (shit)
	[428] = {{-1,0,1}}, -- Securicar
	[535] = {{0,1}}, -- Slamvan
	[439] = {{-1,0,1,2}}, -- Stallion
	[506] = {{-1,0}}, -- Super GT
	[601] = {{0,1,2,3}}, -- SWAT Van
	[459] = {{-1,0}}, -- ?
	[408] = {{-1,0}}, -- Trashmaster
	[583] = {{-1,0,1}}, -- Tug
	[552] = {{-1,0,1}}, -- Utility Van
	[478] = {{-1,0,1,2}}, -- Walton
	[555] = {{-1,0}}, -- Windsor
	[456] = {{-1,0,1,2,3}}, -- Yankee
	[477] = {{-1,0}}, -- ZR350
}

local function uc(num)
	return num == -1 and 255 or num
end

local function nuc(num)
	return num == 255 and -1 or num
end

function getRandomVariant(model)
	local data = variants[model] or {}
	local first = data[1] or {-1}
	local second = data[2] or {-1}
	
	return uc(first[math.random(1, #first)]), uc(second[math.random(1, #second)])
end

function isValidVariant(model, a, b)
	a,b = nuc(a),nuc(b)
	
	-- Can't have a part double
	if a ~= -1 and a == b then
		return false
	end
	
	local data = variants[model] or {}
	local first = data[1] or {-1}
	local second = data[2] or {-1}
	
	-- check if first variant is okay
	local found = false
	for k, v in ipairs(first) do
		if v == a then
			found = true
			break
		end
	end
	if not found then return false end
	
	-- check if second variant is okay
	for k, v in ipairs(second) do
		if v == b then
			return true
		end
	end
	return false
end

function cabrioletToggleRoof(theVehicle)
	if isCabriolet(theVehicle) then
		local data = g_cabriolet[getElementModel(theVehicle)]
		local currentVariant, currentVariant2 = getVehicleVariant(theVehicle)
		local newVariant
		if(currentVariant == data[1]) then
			newVariant = data[2] --set closed
		else
			newVariant = data[1] --set open
		end
		local engineState = getVehicleEngineState(theVehicle)
		setVehicleVariant(theVehicle,newVariant,255)

		--fix for vehicles auto-starting engine when variant is changed
		setVehicleEngineState(theVehicle, engineState)
	end
end
addEvent("vehicle:toggleRoof", true)
addEventHandler("vehicle:toggleRoof", getRootElement( ), cabrioletToggleRoof)

function SmallestID() -- finds the smallest ID in the SQL instead of auto increment
	local query = dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM vehicles AS e1 LEFT JOIN vehicles AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result = dbPoll(query, -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end

-- WORKAROUND ABIT
function getVehicleName(vehicle)
	return exports.global:getVehicleName(vehicle)
end

-- /makeveh
function createPermVehicle(thePlayer, commandName, ...)
	if exports.integration:isPlayerDeveloper(thePlayer) then
		local args = {...}
		if (#args < 7) then
			printMakeVehError(thePlayer, commandName )
		else

			local vehShopData = exports["vehicle_manager"]:getInfoFromVehShopID(tonumber(args[1]))
			if not vehShopData then
				outputDebugString("VEHICLE SYSTEM / createPermVehicle / FAILED TO FETCH VEHSHOP DATA")
				printMakeVehError(thePlayer, commandName )
				return false
			end

			local vehicleID = tonumber(vehShopData.vehmtamodel)
			local col1, col2, userName, factionVehicle, cost, tint

			if not vehicleID then -- vehicle is specified as name
				outputDebugString("VEHICLE SYSTEM / createPermVehicle / FAILED TO FETCH VEHSHOP DATA")
				printMakeVehError(thePlayer, commandName )
				return false
			end

			col1 = tonumber(args[2])
			col2 = tonumber(args[3])
			userName = args[4]
			factionVehicle = tonumber(args[5])
			cost = tonumber(args[6])
			if cost < 0 then
				cost = tonumber(vehShopData.vehprice)
			end
			tint = tonumber(args[7])

			local id = vehicleID

			local r = getPedRotation(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
			y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )

			local targetPlayer, username = exports.global:findPlayerByPartialNick(thePlayer, userName)

			if targetPlayer then
				local to = nil
				local dbid = getElementData(targetPlayer, "dbid")

				if (factionVehicle==1) then
					factionVehicle = tonumber(getElementData(targetPlayer, "faction"))
					local theTeam = getPlayerTeam(targetPlayer)
					to = theTeam

					if not exports.global:takeMoney(theTeam, cost) then
						outputChatBox("[MAKEVEH] This faction cannot afford this vehicle.", thePlayer, 255, 0, 0)
						outputChatBox("Your faction cannot afford this vehicle.", targetPlayer, 255, 0, 0)
						return
					end
				else
					factionVehicle = -1
					to = targetPlayer
					if not exports.global:takeMoney(targetPlayer, cost) then
						outputChatBox("[MAKEVEH] This player cannot afford this vehicle.", thePlayer, 255, 0, 0)
						outputChatBox("You cannot afford this vehicle.", targetPlayer, 255, 0, 0)
						return
					elseif not exports.global:canPlayerBuyVehicle(targetPlayer) then
						outputChatBox("[MAKEVEH] This player has too many cars.", thePlayer, 255, 0, 0)
						outputChatBox("You have too many cars.", targetPlayer, 255, 0, 0)
						exports.global:giveMoney(targetPlayer, cost)
						return
					end
				end

				local letter1 = string.char(math.random(65,90))
				local letter2 = string.char(math.random(65,90))
				local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)

				local veh = Vehicle(id, x, y, z, 0, 0, r, plate)
				if not (veh) then
					outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
					exports.global:giveMoney(to, cost)
				else
					setVehicleColor(veh, col1, col2, col1, col2)
					local col =  { getVehicleColor(veh, true) }
					local color1 = toJSON( {col[1], col[2], col[3]} )
					local color2 = toJSON( {col[4], col[5], col[6]} )
					local color3 = toJSON( {col[7], col[8], col[9]} )
					local color4 = toJSON( {col[10], col[11], col[12]} )
					local vehicleName = getVehicleName(veh)
					destroyElement(veh)
					local dimension = getElementDimension(thePlayer)
					local interior = getElementInterior(thePlayer)
					local var1, var2 = exports['vehicle']:getRandomVariant(id)
					local smallestID = SmallestID()
					dbExec(mysql:getConnection(),"INSERT INTO vehicles SET id='" .. (smallestID) .. "', model='" .. (id) .. "', x='" .. (x) .. "', y='" .. (y) .. "', z='" .. (z) .. "', rotx='0', roty='0', rotz='" .. (r) .. "', color1='" .. (color1) .. "', color2='" .. (color2) .. "', color3='" .. (color3) .. "', color4='" .. (color4) .. "', faction='" .. (factionVehicle) .. "', owner='" .. (( factionVehicle == -1 and dbid or -1 )) .. "', plate='" .. (plate) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='0', currry='0', currrz='" .. (r) .. "', locked=1, interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "', tintedwindows='" .. (tint) .. "',variant1="..var1..",variant2="..var2..", creationDate=NOW(), createdBy="..getElementData(thePlayer, "account:id")..", `vehicle_shop_id`='"..args[1].."' ")
					local insertid = smallestID
					if (insertid) then
						if (factionVehicle==-1) then
							exports.global:giveItem(targetPlayer, 3, tonumber(insertid))
						end

						local owner = ""
						if factionVehicle == -1 then
							owner = getPlayerName( targetPlayer )
						else
							owner = "Faction #" .. factionVehicle
						end

					
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						local adminUsername = getElementData(thePlayer, "account:username")
						local adminID = getElementData(thePlayer, "account:id")

					
						if (hiddenAdmin==0) then
							exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " ("..adminUsername..") has spawned a "..vehicleName .. " (ID #" .. insertid .. ") to "..owner.." for $"..cost..".")
							outputChatBox(tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " has spawned a "..vehicleName .. " (ID #" .. insertid .. ") to "..owner.." for $"..cost..".", targetPlayer, 255, 194, 14)
						else
							exports.global:sendMessageToAdmins("AdmCmd: A Hidden Admin has spawned a "..vehicleName .. " (ID #" .. insertid .. ") to "..owner.." for $"..cost..".")
							outputChatBox("A Hidden Admin has spawned a "..vehicleName .. " (ID #" .. insertid .. ") to "..owner.." for $"..cost..".", targetPlayer, 255, 194, 14)
						end
						outputChatBox("[MAKEVEH] "..vehicleName .. " (ID #" .. insertid .. ") successfully spawned to "..owner..".", thePlayer, 0, 255, 0)

						

						reloadVehicle(tonumber(insertid))
					end
				end
			end
		end
	end
end
addCommandHandler("makeveh", createPermVehicle, false, false)

function printMakeVehError(thePlayer, commandName )
	outputChatBox("SYNTAX: /" .. commandName .. " [ID from Veh Lib] [color1] [color2] [Owner] [Faction Vehicle (1/0)] [-1=carshop price] [Tinted Windows] ", thePlayer, 255, 194, 14)
	outputChatBox("NOTE: If it is a faction vehicle, ownership will be given to the 'owner''s faction.", thePlayer, 255, 194, 14)
	outputChatBox("NOTE: If it is a faction vehicle, the cost is taken from the faction fund, rather than the player.", thePlayer, 255, 194, 14)
end

-- /makecivveh
function createCivilianPermVehicle(thePlayer, commandName, ...)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		local args = {...}
		if (#args < 4) then
			outputChatBox("SYNTAX: /" .. commandName .. " [id/name] [color1 (-1 for random)] [color2 (-1 for random)] [Job ID -1 for none]", thePlayer, 255, 194, 14)
		else
			local vehicleID = tonumber(args[1])
			local col1, col2, job

			if not vehicleID then -- vehicle is specified as name
				local vehicleEnd = 1
				repeat
					vehicleID = getVehicleModelFromName(table.concat(args, " ", 1, vehicleEnd))
					vehicleEnd = vehicleEnd + 1
				until vehicleID or vehicleEnd == #args
				if vehicleEnd == #args then
					outputChatBox("Invalid Vehicle Name.", thePlayer, 255, 0, 0)
					return
				else
					col1 = tonumber(args[vehicleEnd])
					col2 = tonumber(args[vehicleEnd + 1])
					job = tonumber(args[vehicleEnd + 2])
				end
			else
				col1 = tonumber(args[2])
				col2 = tonumber(args[3])
				job = tonumber(args[4])
			end

			local id = vehicleID

			local r = getPedRotation(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			local interior = getElementInterior(thePlayer)
			local dimension = getElementDimension(thePlayer)
			x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
			y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )

			local letter1 = string.char(math.random(65,90))
			local letter2 = string.char(math.random(65,90))
			local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)

			local veh = Vehicle(id, x, y, z, 0, 0, r, plate)
			if not (veh) then
				outputChatBox("Invalid Vehicle ID.", thePlayer, 255, 0, 0)
			else
				local vehicleName = getVehicleName(veh)
				destroyElement(veh)

				local var1, var2 = exports['vehicle']:getRandomVariant(id)
				local smallestID = SmallestID()
				local insertid = dbExec(mysql:getConnection(), "INSERT INTO vehicles SET id='" .. (smallestID) .. "', job='" .. (job) .. "', model='" .. (args[1]) .. "', x='" .. (x) .. "', y='" .. (y) .. "', z='" .. (z) .. "', rotx='" .. ("0.0") .. "', roty='" .. ("0.0") .. "', rotz='" .. (r) .. "', color1='[ [ 0, 0, 0 ] ]', color2='[ [ 0, 0, 0 ] ]', color3='[ [ 0, 0, 0 ] ]', color4='[ [0, 0, 0] ]', faction='-1', owner='-2', plate='" .. (plate) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='0', currry='0', currrz='" .. (r) .. "', interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "',variant1="..var1..",variant2="..var2..", creationDate=NOW(), createdBy="..getElementData(thePlayer, "account:id").."")
			
				insertid = smallestID
				if (insertid) then
					reloadVehicle(insertid)

					local adminID = getElementData(thePlayer, "account:id")
					local addLog = dbExec(mysql:getConnection(), "INSERT INTO `vehicle_logs` (`vehID`, `action`, `actor`) VALUES ('"..tostring(insertid).."', '"..commandName.." "..vehicleName.." (job "..job..")', '"..adminID.."')") or false
					if not addLog then
						outputDebugString("Failed to add vehicle logs.")
					end
				end
							
			
			end
		end
	end
end
addCommandHandler("makecivveh", createCivilianPermVehicle, false, false)

function loadAllVehicles(res)
	-- Reset player in vehicle states
	local players = exports.pool:getPoolElementsByType("player")
	for key, value in ipairs(players) do
		setElementData(value, "realinvehicle", 0, false)
	end
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				Async:foreach(res, function(row)
				--for index, row in ipairs(res) do
				
					local var1, var2 = row.variant1, row.variant2
					if not isValidVariant(row.model, var1, var2) then
						var1, var2 = getRandomVariant(row.model)
						dbExec(mysql:getConnection(), "UPDATE vehicles SET variant1 = " .. var1 .. ", variant2 = " .. var2 .. " WHERE id='" .. (row.id) .. "'")
					end
					local veh = Vehicle(row.model, row.x, row.y, row.z, row.rotx, row.roty, row.rotz, row.plate, false, var1, var2)
					if veh then
						exports["item-system"]:loadItems(veh)
						veh:setData("dbid", row.id)
						exports.pool:allocateElement(veh, row.id)
						if row.paintjob ~= 0 then
							setVehiclePaintjob(veh, row.paintjob)
						end
			
						if row.paintjob_url then
							veh:setData("paintjob:url", row.paintjob_url, true)
						end
			
						local color1 = fromJSON(row.color1)
						local color2 = fromJSON(row.color2)
						local color3 = fromJSON(row.color3)
						local color4 = fromJSON(row.color4)
						setVehicleColor(veh, color1[1], color1[2], color1[3], color2[1], color2[2], color2[3], color3[1], color3[2], color3[3], color4[1], color4[2], color4[3])
						-- Set the vehicle armored if it is armored
						if (armoredCars[row.model]) then
							setVehicleDamageProof(veh, true)
						end
			
						-- Cosmetics
						local upgrades = fromJSON(row["upgrades"])
						for slot, upgrade in ipairs(upgrades) do
							if upgrade and tonumber(upgrade) > 0 then
								addVehicleUpgrade(veh, upgrade)
							end
						end

						local panelStates = fromJSON(row["panelStates"])
						for panel, state in ipairs(panelStates) do
							setVehiclePanelState(veh, panel-1 , tonumber(state) or 0)
						end
			
						local doorStates = fromJSON(row["doorStates"])
						for door, state in ipairs(panelStates) do
							setVehicleDoorState(veh, door-1, tonumber(state) or 0)
						end
			
						local headlightColors = fromJSON(row["headlights"])
						if headlightColors then
							setVehicleHeadLightColor ( veh, headlightColors[1], headlightColors[2], headlightColors[3])
						end
						veh:setData("headlightcolors", headlightColors, true)
			
						local wheelStates = fromJSON(row["wheelStates"])
						setVehicleWheelStates(veh, tonumber(wheelStates[1]) , tonumber(wheelStates[2]) , tonumber( wheelStates[3]) , tonumber(wheelStates[4]) )
			
						-- lock the vehicle if it's locked
						setVehicleLocked(veh, row.owner ~= -1 and row.locked == 1)
			
						-- set the sirens on if it has some
						setVehicleSirensOn(veh, row.sirens == 1)
			
						-- job
						if row.job > 0 then
							toggleVehicleRespawn(veh, true)
							setVehicleRespawnDelay(veh, 60000)
							setVehicleIdleRespawnDelay(veh, 15 * 60000)
							veh:setData("job", row.job, true)
						else
							veh:setData("job", 0, true)
						end
			
						setVehicleRespawnPosition(veh, row.x, row.y, row.z, row.rotx, row.roty, row.rotz)
						veh:setData("respawnposition", {row.x, row.y, row.z, row.rotx, row.roty, row.rotz}, false)
						veh:setData("vehicle_shop_id", row.vehicle_shop_id)
						veh:setData("fuel", row.fuel)
						veh:setData("oldx", row.currx, false)
						veh:setData("oldy", row.curry, false)
						veh:setData("oldz", row.currz, false)
						veh:setData("faction", tonumber(row.faction))
						veh:setData("owner", tonumber(row.owner))
						veh:setData("vehicle:windowstat", 0, true)
						veh:setData("plate", row.plate, true)
						veh:setData("registered", row.registered, true)
						veh:setData("show_plate", row.show_plate, true)
						veh:setData("show_vin", row.show_vin, true)
						veh:setData("description:1", row.description1, true)
						veh:setData("description:2", row.description2, true)
						veh:setData("description:3", row.description3, true)
						veh:setData("description:4", row.description4, true)
						veh:setData("description:5", row.description5, true)
						veh:setData("toplamvergi", row.vergi, true)
						veh:setData("faizkilidi", row.faizkilidi == 1 and true or false, true)
						if tonumber(row.faizkilidi) > 0 then
							setVehicleDamageProof(veh, true)
						end
			
						if row.lastused_sec ~= nil then
							veh:setData("lastused", row.lastused_sec, true)
						end
			
					
						if row.owner_last_login ~= nil then
							veh:setData("owner_last_login", row.owner_last_login, true)
						end
			
						if row.owner > 0 and row.protected_until ~= -1 then
							veh:setData("protected_until", row.protected_until, true)
						end
			
						local customTextures = fromJSON(row.textures) or {}
						veh:setData("textures", customTextures, true) -- 30/12/14 Exciter
			
						veh:setData("deleted", row.deleted, false)
						veh:setData("chopped", row.chopped, false)
						setElementDimension(veh, row.currdimension)
						setElementInterior(veh, row.currinterior)
			
						veh:setData("dimension", row.dimension, false)
						veh:setData("interior", row.interior, false)
			
						-- lights
						setVehicleOverrideLights(veh, row.lights == 0 and 1 or row.lights )
			
						-- engine
						if row.hp <= 350 then
							setElementHealth(veh, 300)
							setVehicleDamageProof(veh, true)
							setVehicleEngineState(veh, false)
							veh:setData("engine", 0, false)
							veh:setData("enginebroke", 1, false)
						else
							setElementHealth(veh, row.hp)
							setVehicleEngineState(veh, row.engine == 1)
							veh:setData("engine", row.engine, true)
							veh:setData("enginebroke", 0, true)
						end
						setVehicleFuelTankExplodable(veh, false)
			
						-- handbrake
						veh:setData("handbrake", row.handbrake, true)
						if row.handbrake > 0 then
							setElementFrozen(veh, true)
						end
			
						local hasInterior, interior = exports['vehicle_interiors']:add( veh )
						if hasInterior and row.safepositionX and row.safepositionY and row.safepositionZ and row.safepositionRZ then
							addSafe( row.id, row.safepositionX, row.safepositionY, row.safepositionZ, row.safepositionRZ, interior )
						end
			
						if row.bulletproof == 1 then
							setVehicleDamageProof(veh, true)
						end
			
						if row.tintedwindows == 1 then
							veh:setData("tinted", true, true)
						end
						veh:setData("odometer", tonumber(row.odometer), false)
			
				
						if #customTextures > 0 then
							for somenumber, texture in ipairs(customTextures) do
								exports['item-texture']:addTexture(veh, texture[1], texture[2])
							end
						end

						if getResourceFromName ( "vehicle_manager" ) then
							exports["vehicle_manager"]:loadCustomVehProperties(tonumber(row.id), veh) --MAXIME / LOAD CUSTOM VEHICLE PROPERTIES AND HANDLING
						end
					end
				end)
			end
		end,
	mysql:getConnection(), "SELECT * FROM `vehicles` WHERE deleted=0")
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllVehicles)


function reloadVehicle(id)
	local theVehicle = exports.pool:getElement("vehicle", tonumber(id))
	if (theVehicle) then
		removeSafe(tonumber(id))
		saveVehicle(theVehicle)
		destroyElement(theVehicle)
	end
	--vehicleTempPosList = exports["admin-system"]:getVehTempPosList() or false
	loadOneVehicle(id, false)
	return true
end

function loadOneVehicle(id, hasCoroutine, loadDeletedOne)
	if loadDeletedOne then
		loadDeletedOne = "AND deleted = '0'"
	else
		loadDeletedOne = ""
	end

	local result_numb = "SELECT v.*, (CASE WHEN ((protected_until IS NULL) OR (protected_until > NOW() = 0)) THEN -1 ELSE TO_SECONDS(protected_until) END) AS protected_until, "
			.."TO_SECONDS(lastUsed) AS lastused_sec, (CASE WHEN lastlogin IS NOT NULL THEN TO_SECONDS(lastlogin) ELSE NULL END) AS owner_last_login, "
			.."l.faction AS impounder, "
			.."i.premium, i.insurancefaction "
			.."FROM vehicles v "
			.."LEFT JOIN characters c ON v.owner=c.id "
			.."LEFT JOIN leo_impound_lot l ON v.id=l.veh "
			.."LEFT JOIN insurance_data i ON v.id=i.vehicleid "
			.."WHERE v.id = " .. (id) .. " "..loadDeletedOne.." LIMIT 1"

	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					local var1, var2 = row.variant1, row.variant2
					if not isValidVariant(row.model, var1, var2) then
						var1, var2 = getRandomVariant(row.model)
						dbExec(mysql:getConnection(), "UPDATE vehicles SET variant1 = " .. var1 .. ", variant2 = " .. var2 .. " WHERE id='" .. (row.id) .. "'")
					end
					local veh = Vehicle(row.model, row.currx, row.curry, row.currz, row.currrx, row.currry, row.currrz, row.plate, false, var1, var2)
					if veh then
						veh:setData("dbid", row.id)
						exports["item-system"]:loadItems(veh)
						exports.pool:allocateElement(veh, row.id)
						if row.paintjob ~= 0 then
							setVehiclePaintjob(veh, row.paintjob)
						end
			
						if row.paintjob_url then
							veh:setData("paintjob:url", row.paintjob_url, true)
						end
			
						local color1 = fromJSON(row.color1)
						local color2 = fromJSON(row.color2)
						local color3 = fromJSON(row.color3)
						local color4 = fromJSON(row.color4)
						setVehicleColor(veh, color1[1], color1[2], color1[3], color2[1], color2[2], color2[3], color3[1], color3[2], color3[3], color4[1], color4[2], color4[3])
						-- Set the vehicle armored if it is armored
						if (armoredCars[row.model]) then
							setVehicleDamageProof(veh, true)
						end
			
						-- Cosmetics
						local upgrades = fromJSON(row["upgrades"])
						for slot, upgrade in ipairs(upgrades) do
							if upgrade and tonumber(upgrade) > 0 then
								addVehicleUpgrade(veh, upgrade)
							end
						end
			
						local panelStates = fromJSON(row["panelStates"])
						for panel, state in ipairs(panelStates) do
							setVehiclePanelState(veh, panel-1 , tonumber(state) or 0)
						end
			
						local doorStates = fromJSON(row["doorStates"])
						for door, state in ipairs(panelStates) do
							setVehicleDoorState(veh, door-1, tonumber(state) or 0)
						end
			
						local headlightColors = fromJSON(row["headlights"])
						if headlightColors then
							setVehicleHeadLightColor ( veh, headlightColors[1], headlightColors[2], headlightColors[3])
						end
						veh:setData("headlightcolors", headlightColors, true)
			
						local wheelStates = fromJSON(row["wheelStates"])
						setVehicleWheelStates(veh, tonumber(wheelStates[1]) , tonumber(wheelStates[2]) , tonumber( wheelStates[3]) , tonumber(wheelStates[4]) )
			
						-- lock the vehicle if it's locked
						setVehicleLocked(veh, row.owner ~= -1 and row.locked == 1)
			
						-- set the sirens on if it has some
						setVehicleSirensOn(veh, row.sirens == 1)
			
						-- job
						if row.job > 0 then
							toggleVehicleRespawn(veh, true)
							setVehicleRespawnDelay(veh, 60000)
							setVehicleIdleRespawnDelay(veh, 15 * 60000)
							veh:setData("job", row.job, true)
						else
							veh:setData("job", 0, true)
						end
			
						setVehicleRespawnPosition(veh, row.x, row.y, row.z, row.rotx, row.roty, row.rotz)
						veh:setData("respawnposition", {row.x, row.y, row.z, row.rotx, row.roty, row.rotz}, false)
			
						-- element data
						veh:setData("vehicle_shop_id", row.vehicle_shop_id)
						veh:setData("fuel", row.fuel)
						veh:setData("oldx", row.currx)
						veh:setData("oldy", row.curry)
						veh:setData("oldz", row.currz)
						veh:setData("faction", tonumber(row.faction))
						veh:setData("owner", tonumber(row.owner))
						veh:setData("vehicle:windowstat", 0, true)
						veh:setData("plate", row.plate, true)
						veh:setData("registered", row.registered, true)
						veh:setData("show_plate", row.show_plate, true)
						veh:setData("show_vin", row.show_vin, true)
						veh:setData("description:1", row.description1, true)
						veh:setData("description:2", row.description2, true)
						veh:setData("description:3", row.description3, true)
						veh:setData("description:4", row.description4, true)
						veh:setData("description:5", row.description5, true)
						
						if row.lastused_sec ~= nil then
							veh:setData("lastused", row.lastused_sec, true)
						end
			
						--outputDebugString(tostring(row.owner_last_login))
						if row.owner_last_login ~= nil then
							veh:setData("owner_last_login", row.owner_last_login, true)
						end
			
						if row.owner > 0 and row.protected_until ~= -1 then
							veh:setData("protected_until", row.protected_until, true)
						end
			
						local customTextures = fromJSON(row.textures) or {}
						veh:setData("textures", customTextures, true) -- 30/12/14 Exciter
			
						veh:setData("deleted", row.deleted, false)
						veh:setData("chopped", row.chopped, false)
						--veh:setData("note", row.note, true)
			
						-- impound shizzle
						veh:setData("Impounded", tonumber(row.Impounded), true)
						if tonumber(row.Impounded) > 0 then
							setVehicleDamageProof(veh, true)
							if row.impounder then
								--outputDebugString("set")
								veh:setData("impounder", row.impounder, false, true)
							else
								veh:setData("impounder", 4, false, true) --RT
							end
						end
			
						-- insurance stuff
						if exports.global:isResourceRunning("insurance") then
							veh:setData("insurance:fee", row.premium or 0, false, true)
							veh:setData("insurance:faction", row.insurancefaction or 0, false, true)
						end
			
			
			
						setElementDimension(veh, row.currdimension)
						setElementInterior(veh, row.currinterior)
			
						veh:setData("dimension", row.dimension, false)
						veh:setData("interior", row.interior, false)
			
						-- lights
						setVehicleOverrideLights(veh, row.lights == 0 and 1 or row.lights )
			
						-- engine
						if row.hp <= 350 then
							setElementHealth(veh, 300)
							setVehicleDamageProof(veh, true)
							setVehicleEngineState(veh, false)
							veh:setData("engine", 0, false)
							veh:setData("enginebroke", 1, false)
						else
							setElementHealth(veh, row.hp)
							setVehicleEngineState(veh, row.engine == 1)
							veh:setData("engine", row.engine, true)
							veh:setData("enginebroke", 0, true)
						end
						setVehicleFuelTankExplodable(veh, false)
			
						-- handbrake
						veh:setData("handbrake", row.handbrake, true)
						if row.handbrake > 0 then
							setElementFrozen(veh, true)
						end
			
						local hasInterior, interior = exports['vehicle_interiors']:add( veh )
						if hasInterior and row.safepositionX and row.safepositionY and row.safepositionZ and row.safepositionRZ then
							addSafe( row.id, row.safepositionX, row.safepositionY, row.safepositionZ, row.safepositionRZ, interior )
						end
			
						if row.bulletproof == 1 then
							setVehicleDamageProof(veh, true)
						end
			
						if row.tintedwindows == 1 then
							veh:setData("tinted", true, true)
						end
						veh:setData("odometer", tonumber(row.odometer), false)
			
						
			
						if getResourceFromName("vehicle_manager") then
							exports["vehicle_manager"]:loadCustomVehProperties(tonumber(row.id), veh) --MAXIME / LOAD CUSTOM VEHICLE PROPERTIES AND HANDLING
						end
					end
				end
			end
		end,
	mysql:getConnection(), result_numb)
end

function vehicleExploded()
	local job = source:getData("job")

	if not job or job<=0 then
		setTimer(respawnVehicle, 60000, 1, source)
	end
end
addEventHandler("onVehicleExplode", getRootElement(), vehicleExploded)

function vehicleRespawn(exploded)
	local id = source:getData("dbid")
	local faction = source:getData("faction")
	local job = source:getData("job")
	local owner = source:getData("owner")
	local windowstat = source:getData("vehicle:windowstat")

	if (job>0) then
		toggleVehicleRespawn(source, true)
		setVehicleRespawnDelay(source, 60000)
		setVehicleIdleRespawnDelay(source, 15 * 60000)
		setElementFrozen(source, true)
		setElementData(source, "handbrake", 1, false)
	end

	-- Set the vehicle armored if it is armored
	local vehid = getElementModel(source)
	if (armoredCars[tonumber(vehid)]) then
		setVehicleDamageProof(source, true)
	else
		setVehicleDamageProof(source, false)
	end

	setVehicleFuelTankExplodable(source, false)
	setVehicleEngineState(source, false)
	setVehicleLandingGearDown(source, true)

	setElementData(source, "enginebroke", 0, false)

	setElementData(source, "dbid", id)
	setElementData(source, "fuel", exports["vehicle_fuel"]:getMaxFuel(vehid))
	setElementData(source, "engine", 0, false)
	setElementData(source, "vehicle:windowstat", windowstat, false)

	local x, y, z = getElementPosition(source)
	setElementData(source, "oldx", x, false)
	setElementData(source, "oldy", y, false)
	setElementData(source, "oldz", z, false)

	setElementData(source, "faction", faction)
	setElementData(source, "owner", owner, false)

	setVehicleOverrideLights(source, 1)
	setElementFrozen(source, false)

	-- Set the sirens off
	setVehicleSirensOn(source, false)

	setVehicleLightState(source, 0, 0)
	setVehicleLightState(source, 1, 0)

	local dimension = getElementDimension(source)
	local interior = getElementInterior(source)

	setElementDimension(source, dimension)
	setElementInterior(source, interior)

	-- unlock civ vehicles
	if owner == -1 then
		setVehicleLocked(source, false)
		setElementFrozen(source, true)
		setElementData(source, "handbrake", 1, false)
	end

	setElementFrozen(source, source:getData("handbrake") == 1)
end
addEventHandler("onVehicleRespawn", getResourceRootElement(), vehicleRespawn)

function setEngineStatusOnEnter(thePlayer, seat)
	-- outputDebugString('server engine state')
	if source:getData("botVehicle") then return end
	if seat == 0 then
		local engine = source:getData("engine")
		local model = getElementModel(source)
		if not (enginelessVehicle[model]) then
			if (engine==0) then
				toggleControl(thePlayer, 'brake_reverse', false)
				setVehicleEngineState(source, false)
			else
				toggleControl(thePlayer, 'brake_reverse', true)
				setVehicleEngineState(source, true)
			end
		else
			toggleControl(thePlayer, 'brake_reverse', true)

			setVehicleEngineState(source, true)
			setElementData(source, "engine", 1, false)
		end
	end
	triggerEvent("sendCurrentInventory", thePlayer, source)
end
addEventHandler("onVehicleEnter", root, setEngineStatusOnEnter)

function vehicleExit(thePlayer, seat)
	if (isElement(thePlayer)) then
		toggleControl(thePlayer, 'brake_reverse', true)
		-- For oldcar
		local vehid = source:getData("dbid")
		setElementData(thePlayer, "lastvehid", vehid, false)
		setPedGravity(thePlayer, 0.008)
		setElementFrozen(thePlayer, false)
	end
end
addEventHandler("onVehicleExit", getRootElement(), vehicleExit)

function destroyTyre(veh)
	local tyre1, tyre2, tyre3, tyre4 = getVehicleWheelStates(veh)

	if (tyre1==1) then
		tyre1 = 2
	end

	if (tyre2==1) then
		tyre2 = 2
	end

	if (tyre3==1) then
		tyre3 = 2
	end

	if (tyre4==1) then
		tyre4 = 2
	end

	if (tyre1==2 and tyre2==2 and tyre3==2 and tyre4==2) then
		tyre3 = 0
	end

	veh:setData("tyretimer", false)
	setVehicleWheelStates(veh, tyre1, tyre2, tyre3, tyre4)
end

function damageTyres()
	local tyre1, tyre2, tyre3, tyre4 = getVehicleWheelStates(source)
	local tyreTimer = source:getData("tyretimer")

	if (tyretimer~=1) then
		if (tyre1==1) or (tyre2==1) or (tyre3==1) or (tyre4==1) then
			setElementData(source, "tyretimer", 1, false)
			local randTime = math.random(5, 15)
			randTime = randTime * 1000
			setTimer(destroyTyre, randTime, 1, source)
		end
	end
end
addEventHandler("onVehicleDamage", getRootElement(), damageTyres)

-- Bind Keys required
function bindKeys()
	local players = exports.pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		if not(isKeyBound(arrayPlayer, "j", "down", toggleEngine)) then
			bindKey(arrayPlayer, "j", "down", toggleEngine)
		end

		if not(isKeyBound(arrayPlayer, "l", "down", toggleLights)) then
			bindKey(arrayPlayer, "l", "down", toggleLights)
		end

		if not(isKeyBound(arrayPlayer, "k", "down", toggleLock)) then
			bindKey(arrayPlayer, "k", "down", toggleLock)
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "j", "down", toggleEngine)
	bindKey(source, "l", "down", toggleLights)
	bindKey(source, "k", "down", toggleLock)
end
addEventHandler("onResourceStart", getResourceRootElement(), bindKeys)
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

function toggleEngine(source, key, keystate)
	local veh = getPedOccupiedVehicle(source)
	local inVehicle = source:getData("realinvehicle")
	if isTimer(vehicleRunnerTimer) then return end
	if veh and inVehicle == 1 then
		local seat = getPedOccupiedVehicleSeat(source)

		if (seat == 0) then
			local model = getElementModel(veh)
			if not (enginelessVehicle[model]) then
				local engine = veh:getData("engine")
				local vehID = veh:getData("dbid")
				local vehKey = exports['global']:hasItem(source, 3, vehID)
				if engine == 0 then
					local vjob = tonumber(veh:getData("job"))
					local job = source:getData("job")
					local owner = veh:getData("owner")
					local faction = tonumber(veh:getData("faction"))
					local playerFaction = tonumber(source:getData("faction"))
					-- Anthony's fix - MAXIME FIXED ANTHONY'S MESS
					if (vehKey) or (owner < 0) and (faction == -1) or (playerFaction == faction) and (faction ~= -1) or ((source:getData("duty_admin") or 0) == 1) then
						local fuel = veh:getData("fuel")
						local broke = veh:getData("enginebroke")
						if broke == 1 then
							triggerEvent('sendAme', source, "aracın motorunu çalıştırmayı dener.")
							outputChatBox(syntaxTable["e"].."Aracın motoru bozulduğu için aracı çalıştıramazsın.", source, 255, 255, 255, true)
						elseif exports.global:hasItem(veh, 74) then
							while exports.global:hasItem(veh, 74) do
								exports.global:takeItem(veh, 74)
							end

							blowVehicle(veh)
						elseif veh:getData("faizkilidi") then
							outputChatBox("[!] #f0f0f0Araç vergi borcu yüzünden kilitlenmiştir.", source, 255, 0, 0, true)
							return
						elseif fuel > 0 then
							randomVehicleEngine = math.random(1,9)
							triggerEvent('sendAme', source, "aracın motorunu çalıştırmayı dener.")
							triggerClientEvent(source, 'vehicleEngineSound', source, "engine.wav")
							local vehicleRunnerTimer = setTimer(
								function()
									if randomVehicleEngine ~= 1 then
										toggleControl(source, 'brake_reverse', true)
										setVehicleEngineState(veh, true)
										veh:setData("engine", 1, false)
										veh:setData("vehicle:radio", tonumber(veh:getData("vehicle:radio:old")), true)
										veh:setData("lastused", exports.datetime:now(), true)
										dbExec(mysql:getConnection(), "UPDATE vehicles SET lastUsed=NOW() WHERE id="..vehID)
									
										triggerEvent('sendAdo', source, "Aracın motoru çalışmıştır.")
									else
										triggerEvent('sendAdo', source, "Araç çalıştırılamadı.")
									end
								end,
							1000, 1)

						elseif fuel <= 0 then
							triggerEvent('sendAme', source, "aracın motorunu çalıştırmayı dener.")
							outputChatBox(syntaxTable["e"].."Araçta yakıt olmadığı için aracı çalıştıramazsın.", source, 255, 255, 255, true)
						end
					else
						outputChatBox(syntaxTable["w"].."Anahtarın olmadığı için aracı çalıştıramazsın.", source, 255, 0, 0, true)
					end
				else
					toggleControl(source, 'brake_reverse', false)
					setVehicleEngineState(veh, false)
					triggerClientEvent(source, 'vehicleEngineSound', source, "engineoff.mp3")
					veh:setData("engine", 0, false)
					veh:setData("vehicle:radio", 0, true)
				end
			end
		end
	end
end
addEvent("toggleEngine", true)
addEventHandler("toggleEngine", root, toggleEngine)
addCommandHandler("motor", toggleEngine)

function toggleLock(source, key, keystate)
	local veh = getPedOccupiedVehicle(source)
	local inVehicle = source:getData("realinvehicle")

	if (veh) and (inVehicle==1) then
		triggerEvent("lockUnlockInsideVehicle", source, veh)
	elseif not veh then
		if getElementDimension(source) >= 19000 then
			local vehicle = exports.pool:getElement("vehicle", getElementDimension(source) - 20000)
			if vehicle and exports['vehicle_interiors']:isNearExit(source, vehicle) then
				local model = getElementModel(vehicle)
				local owner = getElementData(vehicle, "owner")
				local dbid = getElementData(vehicle, "dbid")

				--if (owner ~= -1) then
					if ( getElementData(vehicle, "Impounded") or 0 ) == 0 then
						local locked = isVehicleLocked(vehicle)
						if (locked) then
							setVehicleLocked(vehicle, false)
							triggerEvent('sendAme', source, "araç kapılarını açar.")
						else
							setVehicleLocked(vehicle, true)
							triggerEvent('sendAme', source, "araç kapılarını kilitler.")
						end
					else
						outputChatBox("(( You can't lock impounded vehicles. ))", source, 255, 195, 14)
					end
				--else
					--outputChatBox("(( You can't lock civilian vehicles. ))", source, 255, 195, 14)
				--end
				return
			end
		end

		local interiorFound, interiorDistance = exports['interiors']:lockUnlockHouseEvent(source, true)

		local x, y, z = getElementPosition(source)
		local nearbyVehicles = exports.global:getNearbyElements(source, "vehicle", 30)

		local found = nil
		local shortest = 31
		for i, veh in ipairs(nearbyVehicles) do
			local dbid = tonumber(veh:getData("dbid"))
			local distanceToVehicle = getDistanceBetweenPoints3D(x, y, z, getElementPosition(veh))
			if shortest > distanceToVehicle and ( exports.global:isStaffOnDuty(source) or exports.global:hasItem(source, 3, dbid) or (source:getData("faction") > 0 and source:getData("faction") == veh:getData("faction")) ) then
				shortest = distanceToVehicle
				found = veh
			end
		end

		if (interiorFound and found) then
			if shortest < interiorDistance then
				triggerEvent("lockUnlockOutsideVehicle", source, found)
			else
				triggerEvent("lockUnlockHouse", source)
			end
		elseif found then
			triggerEvent("lockUnlockOutsideVehicle", source, found)
		elseif interiorFound then
			triggerEvent("lockUnlockHouse", source)
		end
	end
end
addCommandHandler("lock", toggleLock, true)
addEvent("togLockVehicle", true)
addEventHandler("togLockVehicle", getRootElement(), toggleLock)

function checkLock(thePlayer, seat, jacked)
	local locked = isVehicleLocked(source)

	if (locked) and not (jacked) then
		cancelEvent()
		outputChatBox(syntaxTable["w"].."Arabanın kapıları kilitli olduğu için araçtan inemezsin!", thePlayer, 255, 255, 255, true)
	end
end
addEventHandler("onVehicleStartExit", getRootElement(), checkLock)

function toggleLights(source, key, keystate)
	local veh = getPedOccupiedVehicle(source)
	local inVehicle = source:getData("realinvehicle")

	if (veh) and (inVehicle==1) then
		local model = getElementModel(veh)
		if not (lightlessVehicle[model]) then
			local lights = getVehicleOverrideLights(veh)
			local seat = getPedOccupiedVehicleSeat(source)

			if (seat==0) then
				veh:setData("long_headlights", not veh:getData("long_headlights"))
				if (lights~=2) then
					setVehicleOverrideLights(veh, 2)
					veh:setData("lights", 1, true)
					local trailer = getVehicleTowedByVehicle(veh)
					if trailer then
						setVehicleOverrideLights(trailer, 2)
					end
				elseif (lights~=1) then
					setVehicleOverrideLights(veh, 1)
					veh:setData("lights", 0, true)
					local trailer = getVehicleTowedByVehicle(veh)
					if trailer then
						setVehicleOverrideLights(trailer, 1)
					end
				end
			end
		end
	end
end
addCommandHandler("lights", toggleLights, true)
addEvent('togLightsVehicle', true)
addEventHandler('togLightsVehicle', root,
	function()
		toggleLights(client)
	end)

--/////////////////////////////////////////////////////////
--Fix for spamming keys to unlock etc on entering
--/////////////////////////////////////////////////////////

-- bike lock fix
function checkBikeLock(thePlayer)
	if (isVehicleLocked(source))then
		if not getElementData(thePlayer, "interiormarker") then
			outputChatBox("(( Araç kapıları kilitli. ))", thePlayer, 255, 0, 0, true)
		end
		cancelEvent()
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), checkBikeLock)

function setRealInVehicle(thePlayer)
	if isVehicleLocked(source) then
		setElementData(thePlayer, "realinvehicle", 0, false)
		removePedFromVehicle(thePlayer)
		setVehicleLocked(source, true)
	else
		--MAXIME 'S CUSTOM VEHICLE
		local brand = source:getData("brand") or false
		local model = source:getData("maximemodel")
		local year = source:getData("year")
		local sistemf = source:getData("carshop:cost") or 0
		setElementData(thePlayer, "realinvehicle", 1, false)

		-- 0000464: Car owner message.
		local owner = source:getData("owner") or -1
		local faction = source:getData("faction") or -1
		local birlika = source:getData("faction") or -1
		local carName = getVehicleName(source)
		local plaka = source:getData("plate")
		local kilom = source:getData("odometer")
		local vergiborc = source:getData("toplamvergi") or 0
		
		
		local birlika = 'Birlik Yok'
							if birlika == 0 then
								birlika = exports.cache:getFactionNameFromId(birlika)
							end
		 
		 
		if owner < 0 and faction == -1 then
			if brand then
				outputChatBox("(( Bu "..year.." "..brand.." "..model.." bir sivil aracıdır. ))", thePlayer, 255, 194, 14)
			else
				-- outputChatBox("(( Bu "..carName.." bir sivil aracıdır. ))", thePlayer, 255, 194, 14)
				outputChatBox("#EAFF00[!][Araba] Bu "..carName.." bir sivil aracıdır.", thePlayer, 0, 255, 0, true)
			end
		elseif (faction==-1) and (owner>0) then
			local ownerName = exports['cache']:getCharacterName(owner)

			if ownerName then
				if brand then
					outputChatBox("#EAFF00[!][Araba] Sahibi: " .. ownerName .. " / Model: "..year.." "..brand.." "..model.." / Kilometre: "..kilom.."km.", thePlayer, 0, 255, 0, true)
					outputChatBox("#EAFF00[!][Araba] Sistem Fiyatı: "..sistemf.." / Araç Plakası: ".. plaka ..".", thePlayer, 255, 194, 14, true)
					outputChatBox("#EAFF00[!][Araba] Vergi borcu: "..vergiborc, thePlayer, 255, 194, 14, true)
					outputChatBox("#EAFF00[!][Araba] Ait Olduğu Birlik: "..birlika.." ", thePlayer, 255, 194, 14, true)
				else
			if ownerName then
				if brand then
				if year then
				if model then
					outputChatBox("#EAFF00[!][Araba] Sahibi: " .. ownerName .. " / Model: "..year.." "..brand.." "..model.."  / Kilometre: "..kilom.."km.", thePlayer, 0, 255, 0, true)
					outputChatBox("#EAFF00[!][Araba] Sistem Fiyatı: "..sistemf.." / Araç Plakası: ".. plaka ..".", thePlayer, 255, 194, 14, true)
					outputChatBox("#EAFF00[!][Araba] Vergi borcu: "..vergiborc, thePlayer, 255, 194, 14, true)
					outputChatBox("#EAFF00[!][Araba] Ait Olduğu Birlik: "..birlika.." ", thePlayer, 255, 194, 14, true)
				end
				if (source:getData("Impounded") > 0) then
					local output = getRealTime().yearday-source:getData("Impounded")
					if brand then
						outputChatBox("(( Bu "..year.." "..brand.." "..model..", " .. output .. (output == 1 and " gündür" or " gündür") .. " hacizli.))", thePlayer, 255, 194, 14)
					else
						outputChatBox("(( Bu "..carName..", " .. output .. (output == 1 and "gündür" or "gündür") .. " hacizli.))", thePlayer, 255, 194, 14)
					end
				end
				if (source:getData("faizkilidi")) then
					if brand then
						outputChatBox("(( Bu "..year.." "..brand.." "..model..", vergi borcu ödenmediği için çekilmiştir. ))", thePlayer, 255, 194, 14)
					else
						outputChatBox("(( Bu " .. carName .. ", vergi borcu ödenmediği için çekilmiştir. ))", thePlayer, 255, 194, 14)
					end
					outputChatBox("(( Toplam Vergi Borcu: " .. source:getData("toplamvergi") .. " ))", thePlayer, 255, 194, 14)
			end
		end
	end
end
end
end
end
end
end
addEventHandler("onVehicleEnter", getRootElement(), setRealInVehicle)

function setRealNotInVehicle(thePlayer)
	local locked = isVehicleLocked(source)

	if not (locked) then
		if (thePlayer) then
			setElementData(thePlayer, "realinvehicle", 0, false)
		end
	end
end
addEventHandler("onVehicleStartExit", getRootElement(), setRealNotInVehicle)

-- Faction vehicles removal script
function removeFromFactionVehicle(thePlayer)
	if source:getData("botVehicle") then return end
	
	local faction = getElementData(thePlayer, "faction")
	local vfaction = tonumber(source:getData("faction"))
	
	if (vfaction~=-1) then
		local seat = getPedOccupiedVehicleSeat(thePlayer)
		local factionName = "None (to be deleted)"
		for key, value in ipairs(exports.pool:getPoolElementsByType("team")) do
			local id = tonumber(getElementData(value, "id"))
			if (id==vfaction) then
				factionName = getTeamName(value)
				break
			end
		end
		if (faction~=vfaction) and (seat==0) then
			outputChatBox(syntaxTable["s"]..getVehicleName(source).." - Sahip : " .. factionName, thePlayer, 255, 194, 14, true)
			
			setElementData(source, "enginebroke", 1, false)
			setVehicleDamageProof(source, true)
			setVehicleEngineState(source, false)
			return
		end
	end
	local Impounded = getElementData(source,"Impounded")
	if (Impounded and Impounded > 0) then
		setElementData(source, "enginebroke", 1, false)
		setVehicleDamageProof(source, true)
		setVehicleEngineState(source, false)
	end
	if (CanTowDriverEnter) then -- Nabs abusing
		return
	end
	local vjob = tonumber(source:getData("job")) or -1
	local job = getElementData(thePlayer, "job") or -1
	local seat = getPedOccupiedVehicleSeat(thePlayer)

	if (vjob>0) and (seat==0) then
		for key, value in pairs(exports['item-system']:getMasks()) do
			if getElementData(thePlayer, value[1]) then
				exports.global:sendLocalMeAction(thePlayer, value[3] .. ".")
				setElementData(thePlayer, value[1], false, true)
			end
		end
	end
end
addEventHandler("onVehicleEnter", root, removeFromFactionVehicle)

-- engines dont break down
function doBreakdown()
	if exports.global:hasItem(source, 74) then
		while exports.global:hasItem(source, 74) do
			exports.global:takeItem(source, 74)
		end

		blowVehicle(source)
	else
		local health = getElementHealth(source)
		local broke = source:getData("enginebroke")

		if (health<=350) and (broke==0 or broke==false) then
			setElementHealth(source, 300)
			setVehicleDamageProof(source, true)
			setVehicleEngineState(source, false)
			setElementData(source, "enginebroke", 1, false)
			setElementData(source, "engine", 0, false)

			local player = getVehicleOccupant(source)
			if player then
				toggleControl(player, 'brake_reverse', false)
			end
		end
	end
end
addEventHandler("onVehicleDamage", getRootElement(), doBreakdown)



------------------------------------------------
-- SELL A VEHICLE
------------------------------------------------
function sellVehicle(thePlayer, commandName, targetPlayerName, aracFiyati)
	if isPedInVehicle(thePlayer) then
		if not targetPlayerName or not aracFiyati then
			outputChatBox("SÖZDİZİMİ: /" .. commandName .. " [Oyuncu ID] [Ucret]", thePlayer, 255, 194, 14)
			outputChatBox("Alıcının /satisonayla yazması gerekmektedir.", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerName)
			if targetPlayer and getElementData(targetPlayer, "dbid") then
				local px, py, pz = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
				if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) < 20 then
					local theVehicle = getPedOccupiedVehicle(thePlayer)
					if theVehicle then
						local vehicleID = getElementData(theVehicle, "dbid")
						if getElementData(theVehicle, "owner") == getElementData(thePlayer, "dbid") or exports.integration:isPlayerDeveloper(thePlayer) then
							if getElementData(targetPlayer, "dbid") ~= getElementData(theVehicle, "owner") then
								if exports.global:hasSpaceForItem(targetPlayer, 3, vehicleID) then
									if exports.global:canPlayerBuyVehicle(targetPlayer) then
										if not (tonumber(aracFiyati) >= 0) then
											outputChatBox("[!] #f0f0f0Fiyat en az $0 ve üzeri olmalıdır.", thePlayer, 255, 0, 0, true)
											return false
										end
										if not (exports.global:hasMoney(targetPlayer, tonumber(aracFiyati))) then
											outputChatBox("[!] #f0f0f0" .. targetPlayerName .. " isimli kişinin yeterli parası yoktur.", thePlayer, 255, 0, 0)
											return false
										end
										setElementData(targetPlayer, "aracSatis", true)
										setElementData(targetPlayer, "aracSatis:aracID", vehicleID)
										setElementData(targetPlayer, "aracSatis:aracFiyati", tonumber(aracFiyati))
										setElementData(targetPlayer, "aracSatis:satanPlayer", thePlayer)
										outputChatBox("[!] #f0f0f0" .. targetPlayerName .. " isimli kişiye araç satma teklifi gönderdiniz. Fiyat: $" .. exports.global:formatMoney(aracFiyati), thePlayer, 0, 0, 255, true)
										outputChatBox("[!] #f0f0f0" .. (getPlayerName(thePlayer):gsub("_", " ")) .. " isimli kişi size #" .. tostring(vehicleID) .. " ID'li '" .. getVehicleName(theVehicle) .. "' aracı $" .. exports.global:formatMoney(aracFiyati) .. "'a satmak istiyor. Satın almak isterseniz /satisonayla iptal etmek isterseniz ise /satisiptal yazınız. ", targetPlayer, 0, 0, 255, true)
									else
										outputChatBox("[!] #f0f0f0" .. targetPlayerName .. " isimli kişinin araç alacak yeri yoktur.", thePlayer, 255, 0, 0)
										outputChatBox("[!] #f0f0f0" .. (getPlayerName(thePlayer):gsub("_", " ")) .. " size bir araç satmaya çalıştı ancak yeni bir araç alacak yeriniz yok.", targetPlayer, 255, 0, 0, true)
									end
								else
									outputChatBox("[!] #f0f0f0" .. targetPlayerName .. " isimli kişinin envanterinde anahtarı alacak yer yok.", thePlayer, 255, 0, 0, true)
									outputChatBox("[!] #f0f0f0" .. (getPlayerName(thePlayer):gsub("_", " ")) .. " size bir araç satmaya çalıştı ancak envanterinizde anahtar için yer yok.", targetPlayer, 255, 0, 0, true)
								end
							else
								outputChatBox("[!] #f0f0f0Kendi aracınızı kendinize satamazsınız.", thePlayer, 255, 0, 0, true)
							end
						else
							outputChatBox("[!] #f0f0f0Bu araç size ait değil.", thePlayer, 255, 0, 0, true)
						end
					else
						outputChatBox("[!] #f0f0f0Bir araçta olmalısınız.", thePlayer, 255, 0, 0, true)
					end
				else
					outputChatBox("[!] #f0f0f0'" .. targetPlayerName .. "' isimli kişiden çok uzaksınız.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addEvent("sellVehicle", true)
addEventHandler("sellVehicle", getResourceRootElement(), sellVehicle)

function satisOnayla(thePlayer, cmd)
	if getElementData(thePlayer, "aracSatis") then
		if cmd == "satisiptal" then
			local satanPlayer = getElementData(thePlayer, "aracSatis:satanPlayer")
			outputChatBox("[!] '" .. getPlayerName(thePlayer) .. "' isimli oyuncu, satışı onaylamadı.", satanPlayer, 255, 255, 0, true)
			setElementData(thePlayer, "aracSatis", false)
			setElementData(thePlayer, "aracSatis:aracID", false)
			setElementData(thePlayer, "aracSatis:satanPlayer", false)
			setElementData(thePlayer, "aracSatis:aracFiyati", false)
			return
		end
		local vehicleID = getElementData(thePlayer, "aracSatis:aracID")
		local theVehicle = exports.pool:getElement("vehicle", vehicleID)
		local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET owner = '" .. (getElementData(thePlayer, "dbid")) .. "', lastUsed=NOW() WHERE id='" .. (vehicleID) .. "'")
		if query then
			setElementData(theVehicle, "owner", getElementData(thePlayer, "dbid"), true)
			setElementData(theVehicle, "owner_last_login", exports.datetime:now(), true)
			setElementData(theVehicle, "lastused", exports.datetime:now(), true)

			local satisFiyat = getElementData(thePlayer, "aracSatis:aracFiyati")
			local satanPlayer = getElementData(thePlayer, "aracSatis:satanPlayer")
			exports.global:takeItem(satanPlayer, 3, vehicleID)
			
			exports.global:takeMoney(thePlayer, satisFiyat)
			exports.global:giveMoney(satanPlayer, satisFiyat)

			if not exports.global:hasItem(thePlayer, 3, vehicleID) then
				exports.global:giveItem(thePlayer, 3, vehicleID)
			end

			setElementData(thePlayer, "aracSatis", false)
			setElementData(thePlayer, "aracSatis:aracID", false)
			setElementData(thePlayer, "aracSatis:satanPlayer", false)
			setElementData(thePlayer, "aracSatis:aracFiyati", false)
			setElementData(targetPlayer, "aracSatis", false)
			setElementData(targetPlayer, "aracSatis:aracID", false)
			setElementData(targetPlayer, "aracSatis:satanPlayer", false)
			setElementData(targetPlayer, "aracSatis:aracFiyati", false)

			exports.logs:logMessage("[SELL] car #" .. vehicleID .. " was sold from " .. getPlayerName(satanPlayer):gsub("_", " ") .. " to " .. getPlayerName(thePlayer), 9)

			outputChatBox("[!] '" .. getVehicleName(theVehicle) .. "' aracınızı başarıyla $" .. exports.global:formatMoney(satisFiyat) .. "'a " .. getPlayerName(thePlayer) .. " isimli oyuncuya sattınız.", satanPlayer, 0, 255, 0)
			outputChatBox((getPlayerName(thePlayer):gsub("_", " ")) .. " isimli oyuncudan $" .. exports.global:formatMoney(satisFiyat) .. "'a bir '" .. getVehicleName(theVehicle) .. "' satın aldınız.", thePlayer, 0, 255, 0)
			outputChatBox("[!] '" .. getVehicleName(theVehicle) .. "' aracınızı /park etmeyi unutmayınız.", thePlayer, 255, 255, 0)

			local adminID = getElementData(satanPlayer, "account:id")
		else
			outputChatBox("Bir problem oluştu.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("satisonayla", satisOnayla)
--addCommandHandler("satisiptal", satisOnayla)

function toggleSellExceptions (thePlayer, commandName, player)
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) and player then
		local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, player)
		if getElementData(targetPlayer, "temporarySell") == true then
			setElementData(targetPlayer, "temporarySell", false)
			outputChatBox("You have revoked "..targetPlayerName.." temporary access to use /sell.", thePlayer)
			outputChatBox("An administrator has revoked your temporary access to use /sell.", targetPlayer)
		else
			setElementData(targetPlayer, "temporarySell", true)
			outputChatBox("You have given "..targetPlayerName.." temporary access to use /sell.", thePlayer)
			outputChatBox("An administrator has given you temporary access to use /sell.", targetPlayer)
		end
	elseif not player and (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) then
		outputChatBox("SYNTAX: /"..commandName.." [player] - This gives temporary access for old /sell.", thePlayer)
	end
end
addCommandHandler("tempsell", toggleSellExceptions)

function AdminVehicleSale(thePlayer, commandName, args)
	if isPedInVehicle(thePlayer) and exports.integration:isPlayerDeveloper(thePlayer) then
		local vehType = getVehicleType(getPedOccupiedVehicle(thePlayer))
		if ( vehType == ("Plane" or "Helicopter" or "Boat") or (getElementData(thePlayer, "temporarySell") == true ) or (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) ) and not args then
			outputChatBox("SYNTAX: /" .. commandName .. " [partial player name / id]", thePlayer, 255, 194, 14)
			outputChatBox("Sells the Vehicle you're in to that Player.", thePlayer, 255, 194, 14)
			outputChatBox("Ask the buyer to use /pay to recieve the money for the vehicle.", thePlayer, 255, 194, 14)
		elseif ( vehType == ("Plane" or "Helicopter" or "Boat") or (getElementData(thePlayer, "temporarySell") == true ) or (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) ) and args then
			triggerEvent("sellVehicle", getResourceRootElement(), thePlayer, "sell", args)
		end
	end
end
addCommandHandler("sell", sellVehicle)
addCommandHandler("aracsat", sellVehicle)

function lockUnlockInside(vehicle)
	local model = getElementModel(vehicle)
	local owner = getElementData(vehicle, "owner")
	local dbid = getElementData(vehicle, "dbid")

	--if (owner ~= -1) then
		if ( getElementData(vehicle, "Impounded") or 0 ) == 0 then
			if not locklessVehicle[model] or exports.global:hasItem( source, 3, dbid ) then
				if (source:getData("realinvehicle") == 1) then
					local locked = isVehicleLocked(vehicle)
					local seat = getPedOccupiedVehicleSeat(source)
					if seat == 0 or exports.global:hasItem( source, 3, dbid ) then
						
						if (locked) then
							setVehicleLocked(vehicle, false)
							triggerEvent('sendAme', source, "aracın kapılarını açar.")
						else
							setVehicleLocked(vehicle, true)
							triggerEvent('sendAme', source, "aracın kapılarını kilitler.")
						end
					end
				end
			end
		else
			outputChatBox("(( You can't lock impounded vehicles. ))", source, 255, 195, 14)
		end
end
addEvent("lockUnlockInsideVehicle", true)
addEventHandler("lockUnlockInsideVehicle", getRootElement(), lockUnlockInside)


local storeTimers = { }

function lockUnlockOutside(vehicle)
	if (not source or exports.integration:isPlayerTrialAdmin(source)) or ( getElementData(vehicle, "Impounded") or 0 ) == 0 then
		local dbid = getElementData(vehicle, "dbid")

		if (isVehicleLocked(vehicle)) then
			setVehicleLocked(vehicle, false)
			triggerEvent('sendAme', source, "anahtara basarak aracın kapılarını açar. ((" .. getVehicleName(vehicle) .. "))")
		else
			setVehicleLocked(vehicle, true)
			triggerEvent('sendAme', source, "anahtara basarak aracın kapılarını kilitler. ((" .. getVehicleName(vehicle) .. "))")
		end

		if (storeTimers[vehicle] == nil) or not (isTimer(storeTimers[vehicle])) then
			storeTimers[vehicle] = setTimer(storeVehicleLockState, 180000, 1, vehicle, dbid)
		end
	end
end
addEvent("lockUnlockOutsideVehicle", true)
addEventHandler("lockUnlockOutsideVehicle", getRootElement(), lockUnlockOutside)

function storeVehicleLockState(vehicle, dbid)
	if (isElement(vehicle)) then
		local newdbid = getElementData(vehicle, "dbid")
		if tonumber(newdbid) > 0 then
			local locked = isVehicleLocked(vehicle)

			local state = 0
			if (locked) then
				state = 1
			end

			local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET locked='" .. (tostring(state)) .. "' WHERE id='" .. (tostring(newdbid)) .. "' LIMIT 1")
		end
		storeTimers[vehicle] = nil
	end
end

function fillFuelTank(veh, fuel)
	local currFuel = veh:getData("fuel")
	local engine = veh:getData("engine")
	local max = exports["vehicle_fuel"]:getMaxFuel(getElementModel(veh))
	if (math.ceil(currFuel)==max) then
		outputChatBox(syntaxTable["e"].."Aracın yakıt deposu zaten dolu.", source, 255, 255, 255, true)
	elseif (fuel==0) then
		outputChatBox(syntaxTable["e"].."İstasyonda yakıt bulunmuyor!", source, 255, 0, 0, true)
	elseif (engine==1) then
		outputChatBox(syntaxTable["w"].."Aracın motorunu durdurman gerekiyor.", source, 255, 0, 0)
	else
		local fuelAdded = fuel

		if (fuelAdded+currFuel>max) then
			fuelAdded = max - currFuel
		end

		outputChatBox(syntaxTable["s"].."Başarıyla "..math.ceil(fuelAdded).." lt yakıt doldurdun.", source, 0, 255, 0, true)

		local gender = source:getData("gender")
		local genderm = "his"
		if (gender == 1) then
			genderm = "her"
		end
		triggerEvent('sendAme', source, "fills up " .. genderm .. " vehicle from a small petrol canister.")
		exports.global:takeItem(source, 57, fuel)
		exports.global:giveItem(source, 57, math.ceil(fuel-fuelAdded))

		veh:setData("fuel", currFuel+fuelAdded, false)
		triggerClientEvent(source, "syncFuel", veh, currFuel+fuelAdded)
	end
end
addEvent("fillFuelTankVehicle", true)
addEventHandler("fillFuelTankVehicle", getRootElement(), fillFuelTank)

function getYearDay(thePlayer)
	local time = getRealTime()
	local currYearday = time.yearday

	outputChatBox("Year day is " .. currYearday, thePlayer)
end
addCommandHandler("yearday", getYearDay)

function removeNOS(theVehicle)
	removeVehicleUpgrade(theVehicle, getVehicleUpgradeOnSlot(theVehicle, 8))
	triggerEvent('sendAme', source, "removes NOS from the " .. getVehicleName(theVehicle) .. ".")
	exports['savevehicle']:saveVehicleMods(theVehicle)
	exports.logs:dbLog(source, 4, {  theVehicle }, "MODDING REMOVENOS")
end
addEvent("removeNOS", true)
addEventHandler("removeNOS", getRootElement(), removeNOS)

-- /VEHPOS /PARK
local destroyTimers = { }
--[[
function createShopVehicle(dbid, ...)
	local veh = Vehicle(unpack({...}))
	exports.pool:allocateElement(veh, dbid)

	veh:setData("dbid", dbid)
	--veh:setData("requires.vehpos", 1, false)
	local timer = setTimer(checkVehpos, 3600000, 1, veh, dbid)
	table.insert(destroyTimers, {timer, dbid})

	exports['vehicle_interiors']:add( veh )

	return veh
end
]]

function checkVehpos(veh, dbid)
	local requires = veh:getData("requires.vehpos")

	if (requires) then
		if (requires==1) then
			local id = tonumber(veh:getData("dbid"))

			if (id==dbid) then
				destroyElement(veh)
				local query = dbExec(mysql:getConnection(), "DELETE FROM vehicles WHERE id='" .. (id) .. "' LIMIT 1")

				call( getResourceFromName( "item-system" ), "clearItems", veh )
				call( getResourceFromName( "item-system" ), "deleteAll", 3, id )
			end
		end
	end
end
-- VEHPOS
local PershingSquareCol = createColRectangle( 1420, -1775, 130, 257 )
local HospitalCol = createColRectangle( 1166, -1384, 52, 92 )

function setVehiclePosition(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	if not veh or getElementData(thePlayer, "realinvehicle") == 0 then
		outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
	else
		if isElementWithinColShape( thePlayer, HospitalCol ) and getElementData( thePlayer, "faction" ) ~= 2 and not exports.integration:isPlayerTrialAdmin(thePlayer) and not exports.integration:isPlayerSupporter(thePlayer) then
			outputChatBox("Only Los Santos Emergency Service is allowed to park their vehicles in front of the Hospital.", thePlayer, 255, 0, 0)
		elseif isElementWithinColShape( thePlayer, PershingSquareCol ) and getElementData( thePlayer, "faction" ) ~= 1  and not exports.integration:isPlayerTrialAdmin(thePlayer) and not exports.integration:isPlayerSupporter(thePlayer) then
			outputChatBox("Only Los Santos Police Department is allowed to park their vehicles on Pershing Square.", thePlayer, 255, 0, 0)
		else
			local playerid = getElementData(thePlayer, "dbid")
			local playerfl = getElementData(thePlayer, "factionleader")
			local playerfid = getElementData(thePlayer, "faction")
			local owner = veh:getData("owner")
			local dbid = veh:getData("dbid")
			local carfid = veh:getData("faction")
			local x, y, z = getElementPosition(veh)
			if (owner==playerid) or (exports.global:hasItem(thePlayer, 3, dbid)) or (exports.integration:isPlayerSupporter(thePlayer) and  exports.logs:logMessage("[AVEHPOS] " .. getPlayerName( thePlayer ) .. " parked car #" .. dbid .. " at " .. x .. ", " .. y .. ", " .. z, 9)) or (exports.integration:isPlayerTrialAdmin(thePlayer) and exports.logs:logMessage("[AVEHPOS] " .. getPlayerName( thePlayer ) .. " parked car #" .. dbid .. " at " .. x .. ", " .. y .. ", " .. z, 9)) then
				if (dbid<0) then
					outputChatBox("This vehicle is not permanently spawned.", thePlayer, 255, 0, 0)
				else
				
					local rx, ry, rz = getVehicleRotation(veh)

					local interior = getElementInterior(thePlayer)
					local dimension = getElementDimension(thePlayer)

					local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET x='" .. (x) .. "', y='" .. (y) .."', z='" .. (z) .. "', rotx='" .. (rx) .. "', roty='" .. (ry) .. "', rotz='" .. (rz) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='" .. (rx) .. "', currry='" .. (ry) .. "', currrz='" .. (rz) .. "', interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "' WHERE id='" .. (dbid) .. "'")
					setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
					veh:setData("respawnposition", {x, y, z, rx, ry, rz}, false)
					veh:setData("interior", interior)
					veh:setData("dimension", dimension)
					outputChatBox(syntaxTable["s"].."Araç başarıyla bulunduğunuz noktaya park edildi.", thePlayer, 255, 255, 255, true)
					exports.logs:dbLog(thePlayer, 4, {  veh }, "PARK")

					local adminID = getElementData(thePlayer, "account:id")

					for key, value in ipairs(destroyTimers) do
						if (tonumber(destroyTimers[key][2]) == dbid) then
							local timer = destroyTimers[key][1]

							if (isTimer(timer)) then
								killTimer(timer)
								table.remove(destroyTimers, key)
							end
						end
					end

					if ( veh:getData("Impounded") or 0 ) > 0 then
						local owner = getPlayerFromName( exports['cache']:getCharacterName( getElementData( veh, "owner" ) ) )
						if isElement( owner ) and exports.global:hasItem( owner, 2 ) then
							outputChatBox("((SFT&R)) #5555 [SMS]: Your " .. getVehicleName(veh) .. " has been impounded. Head over to the impound to release it.", owner, 120, 255, 80)
						end
					end
				end
			end
		end
	end
end
addCommandHandler("vehpos", setVehiclePosition, false, false)
addCommandHandler("park", setVehiclePosition, false, false)

function autoSetVehiclePosition(thePlayer, seat, jacked)
	if thePlayer and seat == 0 then
		if getElementData(thePlayer, "autopark") == "1" then
			local dbid = source:getData("dbid")
			if source:getData("owner") > -1 and dbid > 0 then
				if exports.global:hasItem(thePlayer, 3, dbid) or exports.global:hasItem(source, 3, dbid) then
					local x, y, z = getElementPosition(source)
					local rx, ry, rz = getElementRotation(source)
					local interior = getElementInterior(source)
					local dimension = getElementDimension(source)
					local query = dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `x`='" .. (x) .. "', `y`='" .. (y) .."', `z`='" .. (z) .. "', `rotx`='" .. (rx) .. "', `roty`='" .. (ry) .. "', `rotz`='" .. (rz) .. "', `currx`='" .. (x) .. "', `curry`='" .. (y) .. "', `currz`='" .. (z) .. "', `currrx`='" .. (rx) .. "', `currry`='" .. (ry) .. "', `currrz`='" .. (rz) .. "', `interior`='" .. (interior) .. "', `currinterior`='" .. (interior) .. "', `dimension`='" .. (dimension) .. "', `currdimension`='" .. (dimension) .. "' WHERE `id`='" .. (dbid) .. "'")
					if not query then
						outputDebugString("[vehicle] Auto park failed, Vehicle: " .. dbid, 2)
					end
					setVehicleRespawnPosition(source, x, y, z, rx, ry, rz)
					setElementData(source, "respawnposition", {x, y, z, rx, ry, rz}, false)
					setElementData(source, "interior", interior)
					setElementData(source, "dimension", dimension)
					--outputDebugString("Autoparked. "..dbid)
					--outputChatBox("Vehicle spawn position set.", thePlayer)
				end
			end
		end
	end
end
addEventHandler("onVehicleExit", getRootElement(), autoSetVehiclePosition)

function setVehiclePosition2(thePlayer, commandName, vehicleID)
	if exports.integration:isPlayerTrialAdmin( thePlayer ) then
		local vehicleID = tonumber(vehicleID)
		if not vehicleID or vehicleID < 0 then
			outputChatBox( "SYNTAX: /" .. commandName .. " [vehicle id]", thePlayer, 255, 194, 14 )
		else
			local veh = exports.pool:getElement("vehicle", vehicleID)
			if veh then
				--veh:setData("requires.vehpos")
				local x, y, z = getElementPosition(veh)
				local rx, ry, rz = getVehicleRotation(veh)

				local interior = getElementInterior(thePlayer)
				local dimension = getElementDimension(thePlayer)

				local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET x='" .. (x) .. "', y='" .. (y) .."', z='" .. (z) .. "', rotx='" .. (rx) .. "', roty='" .. (ry) .. "', rotz='" .. (rz) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='" .. (rx) .. "', currry='" .. (ry) .. "', currrz='" .. (rz) .. "', interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "' WHERE id='" .. (vehicleID) .. "'")
				setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
				veh:setData("respawnposition", {x, y, z, rx, ry, rz}, false)
				veh:setData("interior", interior)
				veh:setData("dimension", dimension)
				outputChatBox(syntaxTable["s"].."Aracın park pozisyonu başarıyla ayarlandı.", thePlayer, 255, 255, 255, true)
				exports.logs:dbLog(thePlayer, 4, {  veh }, "PARK")
				for key, value in ipairs(destroyTimers) do
					if (tonumber(destroyTimers[key][2]) == vehicleID) then
						local timer = destroyTimers[key][1]

						if (isTimer(timer)) then
							killTimer(timer)
							table.remove(destroyTimers, key)
						end
					end
				end

				if ( veh:getData("Impounded") or 0 ) > 0 then
					local owner = getPlayerFromName( exports['cache']:getCharacterName( getElementData( veh, "owner" ) ) )
					if isElement( owner ) and exports.global:hasItem( owner, 2 ) then
						outputChatBox("((SFT&R)) #5555 [SMS]: Your " .. getVehicleName(veh) .. " has been impounded. Head over to the impound to release it.", owner, 120, 255, 80)
					end
				end
				exports.logs:logMessage("[AVEHPOS] " .. getPlayerName( thePlayer ) .. " parked car #" .. vehicleID .. " at " .. x .. ", " .. y .. ", " .. z, 9)
			else
				outputChatBox("Vehicle not found.", thePlayer, 255, 0, 0 )
			end
		end
	end
end
addCommandHandler("avehpos", setVehiclePosition2, false, false)
addCommandHandler("apark", setVehiclePosition2, false, false)

function setVehiclePosition3(veh)
	if isElementWithinColShape( source, HospitalCol ) and getElementData( source, "faction" ) ~= 2 and not exports.integration:isPlayerTrialAdmin(source) then
		outputChatBox("Only Los Santos Emergency Service is allowed to park their vehicles in front of the Hospital.", source, 255, 0, 0)
	elseif isElementWithinColShape( source, PershingSquareCol ) and getElementData( source, "faction" ) ~= 1  and not exports.integration:isPlayerTrialAdmin(source) then
		outputChatBox("Only Los Santos Police Department is allowed to park their vehicles on Pershing Square.", source, 255, 0, 0)
	else
		local playerid = source:getData("dbid")
		local owner = veh:getData("owner")
		local dbid = veh:getData("dbid")
		local x, y, z = getElementPosition(veh)
		if (owner==playerid) or (exports.global:hasItem(source, 3, dbid)) or (exports.integration:isPlayerTrialAdmin(source) and exports.logs:logMessage("[AVEHPOS] " .. getPlayerName( source ) .. " parked car #" .. dbid .. " at " .. x .. ", " .. y .. ", " .. z, 9)) then
			if (dbid<0) then
				outputChatBox("This vehicle is not permanently spawned.", source, 255, 0, 0)
			else
				
				--veh:setData("requires.vehpos")
				local rx, ry, rz = getVehicleRotation(veh)

				local interior = getElementInterior(source)
				local dimension = getElementDimension(source)

				local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET x='" .. (x) .. "', y='" .. (y) .."', z='" .. (z) .. "', rotx='" .. (rx) .. "', roty='" .. (ry) .. "', rotz='" .. (rz) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='" .. (rx) .. "', currry='" .. (ry) .. "', currrz='" .. (rz) .. "', interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "' WHERE id='" .. (dbid) .. "'")
				setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
				veh:setData("respawnposition", {x, y, z, rx, ry, rz}, false)
				veh:setData("interior", interior)
				veh:setData("dimension", dimension)
				outputChatBox(syntaxTable["s"].."Aracın park pozisyonu başarıyla ayarlandı.", source, 255, 255, 255, true)
				exports.logs:dbLog(thePlayer, 4, {  veh }, "PARK")
				for key, value in ipairs(destroyTimers) do
					if (tonumber(destroyTimers[key][2]) == dbid) then
						local timer = destroyTimers[key][1]

						if (isTimer(timer)) then
							killTimer(timer)
							table.remove(destroyTimers, key)
						end
					end
				end

				if ( veh:getData("Impounded") or 0 ) > 0 then
					local owner = getPlayerFromName( exports['cache']:getCharacterName( getElementData( veh, "owner" ) ) )
					if isElement( owner ) and exports.global:hasItem( owner, 2 ) then
						outputChatBox("((SFT&R)) #5555 [SMS]: Your " .. getVehicleName(veh) .. " has been impounded. Head over to the impound to release it.", owner, 120, 255, 80)
					end
				end
			end
		else
			outputChatBox( "[!]	#8B0000Bu aracı park edemezsin.", source, 255, 0, 0 )
		end
	end
end
addEvent( "parkVehicle", true )
addEventHandler( "parkVehicle", getRootElement( ), setVehiclePosition3 )

function setVehiclePosition4(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	if not veh or getElementData(thePlayer, "realinvehicle") == 0 then
		outputChatBox(syntaxTable["e"].."Bir araçta değilsin!", thePlayer, 255, 0, 0, true)
	else
		local playerid = getElementData(thePlayer, "dbid")
		local playerfl = getElementData(thePlayer, "factionleader")
		local playerfid = getElementData(thePlayer, "faction")
		local owner = veh:getData("owner")
		local dbid = veh:getData("dbid")
		local carfid = veh:getData("faction")
		if (playerfl == 1) and (playerfid==carfid) then
			--veh:setData("requires.vehpos")

			local x, y, z = getElementPosition(veh)
			local rx, ry, rz = getVehicleRotation(veh)

			local interior = getElementInterior(thePlayer)
			local dimension = getElementDimension(thePlayer)

			local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET x='" .. (x) .. "', y='" .. (y) .."', z='" .. (z) .. "', rotx='" .. (rx) .. "', roty='" .. (ry) .. "', rotz='" .. (rz) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='" .. (rx) .. "', currry='" .. (ry) .. "', currrz='" .. (rz) .. "', interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "' WHERE id='" .. (dbid) .. "'")
			setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
			veh:setData("respawnposition", {x, y, z, rx, ry, rz}, false)
			veh:setData("interior", interior)
			veh:setData("dimension", dimension)
			outputChatBox(syntaxTable["s"].."Birlik aracının park pozisyonu başarıyla ayarlandı.", thePlayer, 255, 255, 255, true)

			local adminID = getElementData(thePlayer, "account:id")
		

			for key, value in ipairs(destroyTimers) do
				if (tonumber(destroyTimers[key][2]) == dbid) then
					local timer = destroyTimers[key][1]

					if (isTimer(timer)) then
						killTimer(timer)
						table.remove(destroyTimers, key)
					end
				end
			end

			if ( veh:getData("Impounded") or 0 ) > 0 then
				local owner = getPlayerFromName( exports['cache']:getCharacterName( getElementData( veh, "owner" ) ) )
				if isElement( owner ) and exports.global:hasItem( owner, 2 ) then
					outputChatBox("((SFT&R)) #5555 [SMS]: Your " .. getVehicleName(veh) .. " has been impounded. Head over to the impound to release it.", owner, 120, 255, 80)
				end
			end
		end
	end
end
addCommandHandler("fvehpos", setVehiclePosition4, false, false)
addCommandHandler("fpark", setVehiclePosition4, false, false)

function quitPlayer ( quitReason )
	if (quitReason == "Timed out") then -- if timed out
		if (isPedInVehicle(source)) then -- if in vehicle
			local vehicleSeat = getPedOccupiedVehicleSeat(source)
			if (vehicleSeat == 0) then	-- is in driver seat?
				local theVehicle = getPedOccupiedVehicle(source)
				local dbid = tonumber(getElementData(theVehicle, "dbid"))
				--------------------------------------------
				--Take the player's key / Crash fix -> Done by Anthony
				if exports.global:hasItem(theVehicle, 3, dbid) then
					exports.global:takeItem(theVehicle, 3, dbid)
					exports.global:giveItem(source, 3, dbid)
				end
				--------------------------------------------
				local passenger1 = getVehicleOccupant( theVehicle , 1 )
				local passenger2 = getVehicleOccupant( theVehicle , 2 )
				local passenger3 = getVehicleOccupant( theVehicle , 3 )
				if not (passenger1) and not (passenger2) and not (passenger3) then
					local vehicleFaction = tonumber(getElementData(theVehicle, "faction"))
					local playerFaction = tonumber(source:getData("faction"))
					if exports.global:hasItem(source, 3, dbid) or ((playerFaction == vehicleFaction) and (vehicleFaction ~= -1)) then
						if not isVehicleLocked(theVehicle) then -- check if the vehicle aint locked already
							lockUnlockOutside(theVehicle)
						end
						local engine = getElementData(theVehicle, "engine")
						if engine == 1 then -- stop the engine when its running
							setVehicleEngineState(theVehicle, false)
							setElementData(theVehicle, "engine", 0, false)
						end
					end
					setElementData(theVehicle, "handbrake", 1, false)
					setElementVelocity(theVehicle, 0, 0, 0)
					setElementFrozen(theVehicle, true)
				end
			end
		end
	end
end
addEventHandler("onPlayerQuit",getRootElement(), quitPlayer)

function detachVehicle(thePlayer)
	if isPedInVehicle(thePlayer) and getPedOccupiedVehicleSeat(thePlayer) == 0 then
		local veh = getPedOccupiedVehicle(thePlayer)
		if getVehicleTowedByVehicle(veh) then
			detachTrailerFromVehicle(veh)
			outputChatBox("The trailer was detached.", thePlayer, 0, 255, 0)
		else
			outputChatBox("There is no trailer...", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("detach", detachVehicle)

safeTable = {}

function addSafe( dbid, x, y, z, rz, interior )
	local tempobject = createObject(2332, x, y, z, 0, 0, rz)
	setElementInterior(tempobject, interior)
	setElementDimension(tempobject, dbid + 20000)
	safeTable[dbid] = tempobject
end

function removeSafe( dbid )
	if safeTable[dbid] then
		destroyElement(safeTable[dbid])
		safeTable[dbid] = nil
	end
end

function getSafe( dbid )
	return safeTable[dbid]
end

local strToConvert = {
	["kilit"] = "lock",
	["motor"] = "motor",
	["vergi"] = "toplamvergi",
	["kemer"] = "seatbelt",
}

addCommandHandler("a",
	function(player, cmd, verb)
		if getElementData(player, "loggedin") == 1 then
			if not verb then
				outputChatBox("Komut Dizini: kilit, motor, vergi, kemer", player, 225, 225, 225, true)
			elseif strToConvert[verb] then
				executeCommandHandler(strToConvert[verb], player)
			end
		end
	end
)

function controlVehicleDoor(door, position)
	if not (isElement(source)) then
		return
	end
	
	if (isVehicleLocked(source)) then
		return
	end
	
	vehicle1x, vehicle1y, vehicle1z = getElementPosition ( source )
	player1x, player1y, player1z = getElementPosition ( client )
	if not (getPedOccupiedVehicle ( client ) == source) and not (getDistanceBetweenPoints2D ( vehicle1x, vehicle1y, player1x, player1y ) < 5) then
		return
	end
	
	local ratio = position/100
	if position == 0 then
		ratio = 0
	elseif position == 100 then
		ratio = 1
	end
	setVehicleDoorOpenRatio(source, door, ratio, 0.5)
end		
addEvent("vehicle:control:doors", true)
addEventHandler("vehicle:control:doors", getRootElement(), controlVehicleDoor)

function controlRamp(theVehicle)
	local playerVehicle = getPedOccupiedVehicle(client)
	
	if not (isElement(theVehicle) and theVehicle == playerVehicle) then
		outputChatBox("Bu düğmeyi kullanmak için araçta olmanız gerekir", client, 255, 0, 0)
		return
	end
	
	if not (exports['item-system']:hasItem(theVehicle, 117)) then
		outputChatBox("Bunu yapmadan önce araç envanterindeki öğeye ihtiyacınız var!", client, 255, 0, 0)
		return
	end

	if not (getElementData(theVehicle, "handbrake") == 1) or not isElementFrozen(theVehicle) then
		outputChatBox("Rampayı açmadan önce aracı el frenlemeniz gerekir.!", client, 255, 0, 0)
		return
	end
	
	if not (getElementModel(theVehicle) == 578) then
		outputChatBox("Bu araç bu rampa tipiyle uyumlu değil!", client, 255, 0, 0)
		return
	end
	
	local rampObject = getElementData(theVehicle, "vehicle:ramp:object")
	if not (rampObject) or not (isElement(rampObject)) then
		if (getElementModel(theVehicle) == 578) then
			local vehiclePositionX, vehiclePositionY, vehiclePositionZ = getElementPosition(theVehicle)
			local vehicleRotationX, vehicleRotationY, vehicleRotationZ = getElementRotation(theVehicle)
		
			rampObject = createObject(16644, vehiclePositionX +0.37, vehiclePositionY -15.41, vehiclePositionZ -2.05, vehicleRotationX +180, vehicleRotationY +10, vehicleRotationZ + 90) 
			--attachElements( rampObject, theVehicle, 0.37, -15.45, -2.05, 180, 10, 90)
			attachElements( rampObject, theVehicle, 0.37, -15.4, -2.05, 180, 10, 90)
			setElementPosition(theVehicle, getElementPosition(theVehicle))
			exports.anticheat:changeProtectedElementDataEx(theVehicle, "vehicle:ramp:object", rampObject, false)
		end
	else
		destroyElement(rampObject)
		exports.anticheat:changeProtectedElementDataEx(theVehicle, "vehicle:ramp:object", nil, false)
	end
end
addEvent("vehicle:control:ramp", true)
addEventHandler("vehicle:control:ramp", getRootElement(), controlRamp)

function checkRamp(sourcePlayer)
	local theVehicle = source
	if not (isElement(theVehicle)) then
		return
	end
	
	local rampObject = getElementData(theVehicle, "vehicle:ramp:object")
	if rampObject then
		destroyElement(rampObject)
		exports.anticheat:changeProtectedElementDataEx(theVehicle, "vehicle:ramp:object", nil, false)
	end
end
addEventHandler("vehicle:handbrake:lifted", getRootElement(), checkRamp)

function handleOdoMeterRequest(totalDistance, syncDistance)
	if not totalDistance then
		local theVehicle = getPedOccupiedVehicle(client)
		if theVehicle == source then
			local totDistance = getElementData(theVehicle,"odometer") or 0
			triggerClientEvent(client, "realism:distance", theVehicle, totDistance)			
		end
	else
		if not syncDistance then
			return
		end
		local theVehicle = getPedOccupiedVehicle(client)
		if theVehicle == source then
			local theSeat = getPedOccupiedVehicleSeat(client)
			if theSeat == 0 then
				local totDistance = getElementData(theVehicle,"odometer") or 0
				exports.anticheat:changeProtectedElementDataEx(theVehicle, 'odometer', totDistance + syncDistance, false )
			end
		end
	end
end
addEvent("realism:distance", true)
addEventHandler("realism:distance", getRootElement(), handleOdoMeterRequest)

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function saveVehicle(source)
	local dbid = tonumber(source:getData("dbid")) or -1
	
	if isElement(source) and getElementType(source) == "vehicle" and dbid > 0 then
		--local owner = source:getData("owner")
		--if (owner~=-1) then
			local x, y, z = getElementPosition(source)
			local rx, ry, rz = getElementRotation(source)
			local fuel = source:getData("fuel")
			local engine = source:getData("engine")
			local odometer = source:getData("odometer") or 0
			local locked = isVehicleLocked(source) and 1 or 0		
			local lights = getVehicleOverrideLights(source)
			local sirens = getVehicleSirensOn(source) and 1 or 0
			local Impounded = source:getData("Impounded") or 0
			local handbrake = source:getData("handbrake") or 0
			local health = getElementHealth(source)
			local dimension = getElementDimension(source)
			local interior = getElementInterior(source)

			local wheel1, wheel2, wheel3, wheel4 = getVehicleWheelStates(source)
			local wheelState = toJSON( { wheel1, wheel2, wheel3, wheel4 } )
			
			local panel0 = getVehiclePanelState(source, 0)
			local panel1 = getVehiclePanelState(source, 1)
			local panel2 = getVehiclePanelState(source, 2)
			local panel3 = getVehiclePanelState(source, 3)
			local panel4 = getVehiclePanelState(source, 4)
			local panel5 = getVehiclePanelState(source, 5)
			local panel6 = getVehiclePanelState(source, 6)
			local panelState = toJSON( { panel0, panel1, panel2, panel3, panel4, panel5, panel6 } )
			
			local door0 = getVehicleDoorState(source, 0)
			local door1 = getVehicleDoorState(source, 1)
			local door2 = getVehicleDoorState(source, 2)
			local door3 = getVehicleDoorState(source, 3)
			local door4 = getVehicleDoorState(source, 4)
			local door5 = getVehicleDoorState(source, 5)
			local doorState = toJSON( { door0, door1, door2, door3, door4, door5 } )
			
			dbExec(mysql:getConnection(), "UPDATE vehicles SET `fuel`='" .. (fuel) ..
				"', `engine`='" .. (engine) ..
				"', `locked`='" .. (locked) ..
				"', `lights`='" .. (lights) ..
				"', `hp`='" .. (health) ..
				"', `sirens`='" .. (sirens) ..
				"', `Impounded`='" .. (tonumber(Impounded)) ..
				"', `handbrake`='" .. (tonumber(handbrake)) ..
				"', `currx`=" .. x .. 
				" , `curry`=" .. y ..
				" , `currz`=" .. z ..
				" , `currrx`=" .. rx ..
				" , `currry`=" .. ry ..
				" , `currrz`=" .. rz ..
				" WHERE id='" .. (dbid) .. "'")
			dbExec(mysql:getConnection(), "UPDATE vehicles SET `panelStates`='" .. (panelState) .. "', `wheelStates`='" .. (wheelState) .. "', `doorStates`='" .. (doorState) .. "', `hp`='" .. (health) .. "', sirens='" .. (sirens) .. "', Impounded='" .. (tonumber(Impounded)) .. "', handbrake='" .. (tonumber(handbrake)) .. "', `odometer`='"..(tonumber(odometer)).."', `lastUsed`=NOW() WHERE id='" .. (dbid) .. "'")
		--end
	end
end

local function saveVehicleOnExit(thePlayer, seat)
	saveVehicle(source)
end
addEventHandler("onVehicleExit", getRootElement(), saveVehicleOnExit)

function saveVehicleMods(source)
	local dbid = tonumber(source:getData("dbid")) or -1
	local owner = tonumber(source:getData("owner")) or -1
	if isElement(source) and getElementType(source) == "vehicle" and dbid >= 0 then -- and owner > 0 
		local col =  { getVehicleColor(source, true) }
		if source:getData("oldcolors") then
			col = unpack(source:getData("oldcolors"))
		end
		
		local color1 = toJSON( {col[1], col[2], col[3]} )
		local color2 = toJSON( {col[4], col[5], col[6]} )
		local color3 = toJSON( {col[7], col[8], col[9]} )
		local color4 = toJSON( {col[10], col[11], col[12]} )
		
		
		local hcol1, hcol2, hcol3 = getVehicleHeadLightColor( source )
		if source:getData("oldheadcolors") then
			hcol1, hcol2, hcol3 = unpack(source:getData("oldheadcolors"))
		end
		local headLightColors = toJSON( { hcol1, hcol2, hcol3 } )
		
		local upgrade0 = getElementData( source, "oldupgrade" .. 0 ) or getVehicleUpgradeOnSlot(source, 0)
		local upgrade1 = getElementData( source, "oldupgrade" .. 1 ) or getVehicleUpgradeOnSlot(source, 1)
		local upgrade2 = getElementData( source, "oldupgrade" .. 2 ) or getVehicleUpgradeOnSlot(source, 2)
		local upgrade3 = getElementData( source, "oldupgrade" .. 3 ) or getVehicleUpgradeOnSlot(source, 3)
		local upgrade4 = getElementData( source, "oldupgrade" .. 4 ) or getVehicleUpgradeOnSlot(source, 4)
		local upgrade5 = getElementData( source, "oldupgrade" .. 5 ) or getVehicleUpgradeOnSlot(source, 5)
		local upgrade6 = getElementData( source, "oldupgrade" .. 6 ) or getVehicleUpgradeOnSlot(source, 6)
		local upgrade7 = getElementData( source, "oldupgrade" .. 7 ) or getVehicleUpgradeOnSlot(source, 7)
		local upgrade8 = getElementData( source, "oldupgrade" .. 8 ) or getVehicleUpgradeOnSlot(source, 8)
		local upgrade9 = getElementData( source, "oldupgrade" .. 9 ) or getVehicleUpgradeOnSlot(source, 9)
		local upgrade10 = getElementData( source, "oldupgrade" .. 10 ) or getVehicleUpgradeOnSlot(source, 10)
		local upgrade11 = getElementData( source, "oldupgrade" .. 11 ) or getVehicleUpgradeOnSlot(source, 11)
		local upgrade12 = getElementData( source, "oldupgrade" .. 12 ) or getVehicleUpgradeOnSlot(source, 12)
		local upgrade13 = getElementData( source, "oldupgrade" .. 13 ) or getVehicleUpgradeOnSlot(source, 13)
		local upgrade14 = getElementData( source, "oldupgrade" .. 14 ) or getVehicleUpgradeOnSlot(source, 14)
		local upgrade15 = getElementData( source, "oldupgrade" .. 15 ) or getVehicleUpgradeOnSlot(source, 15)
		local upgrade16 = getElementData( source, "oldupgrade" .. 16 ) or getVehicleUpgradeOnSlot(source, 16)
		
		local paintjob =  source:getData("oldpaintjob") or getVehiclePaintjob(source)
		local variant1, variant2 = getVehicleVariant(source)
		
		local upgrades = toJSON( { upgrade0, upgrade1, upgrade2, upgrade3, upgrade4, upgrade5, upgrade6, upgrade7, upgrade8, upgrade9, upgrade10, upgrade11, upgrade12, upgrade13, upgrade14, upgrade15, upgrade16 } )
		dbExec(mysql:getConnection(), "UPDATE vehicles SET `upgrades`='" .. (upgrades) .. "', paintjob='" .. (paintjob) .. "', color1='" .. (color1) .. "', color2='" .. (color2) .. "', color3='" .. (color3) .. "', color4='" .. (color4) .. "', `headlights`='"..(headLightColors).."',variant1="..variant1..",variant2="..variant2.." WHERE id='" .. (dbid) .. "'")
	end
end

function addVehicleLogs(vehID, action, actor, clearPreviousLogs)
	if vehID and action then
		if clearPreviousLogs then
			if not dbExec(mysql:getConnection(), "DELETE FROM `vehicle_logs` WHERE `vehID`='"..tostring(vehID).. "'") then
				outputDebugString("[VEHICLE MANAGER] Failed to clean previous logs #"..vehID.." from `vehicle_logs`.")
				return false
			end
			if not dbExec(mysql:getConnection(), "DELETE FROM `logtable` WHERE `affected`='ve"..tostring(vehID).. ";'") then
				outputDebugString("[VEHICLE MANAGER] Failed to clean previous logs #"..vehID.." from `logtable`.")
				return false
			end
		end

		local adminID = nil
		if actor and isElement(actor) and getElementType(actor) == "player" then
		 	adminID = getElementData(actor, "account:id") 
		end
		
		local addLog = dbExec(mysql:getConnection(), "INSERT INTO `vehicle_logs` SET `vehID`= '"..tostring(vehID).."', `action` = '"..(action).."' "..(adminID and (", `actor` = '"..adminID.."' ") or "")) or false

		if not addLog then
			outputDebugString("[VEHICLE MANAGER] Failed to add VEHICLE logs.")
			return false
		else
			return true
		end
	else
		outputDebugString("[VEHICLE MANAGER] Lack of agruments #1 or #2 for the function addVEHICLELogs().")
		return false
	end
end

function getVehicleOwner(vehicle)
	local faction = tonumber(getElementData(vehicle, 'faction')) or 0
	if faction > 0 then
		return getTeamName(exports.pool:getElement('team', faction))
	else
		return call(getResourceFromName("cache"), "getCharacterName", getElementData(vehicle, "owner")) or "N/A"
	end
end

function toggleWindow(thePlayer)
	if not thePlayer then
		thePlayer = source
	end
	
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	if theVehicle then
		if hasVehicleWindows(theVehicle) then
			if (getVehicleOccupant(theVehicle) == thePlayer) or (getVehicleOccupant(theVehicle, 1) == thePlayer) then
				if not (isVehicleWindowUp(theVehicle)) then
					exports.anticheat:changeProtectedElementDataEx(theVehicle, "vehicle:windowstat", 0, true)
					exports.global:sendLocalMeAction(thePlayer, "panelden aracın camını kapatır.")
					for i = 0, getVehicleMaxPassengers(theVehicle) do
						local player = getVehicleOccupant(theVehicle, i)
						if (player) then
							triggerClientEvent(player, "updateWindow", theVehicle)
							triggerEvent("setTintName", player)
						end
					end
				else
					exports.anticheat:changeProtectedElementDataEx(theVehicle, "vehicle:windowstat", 1, true)
					exports.global:sendLocalMeAction(thePlayer, "panelden aracın camını açar.")
					for i = 0, getVehicleMaxPassengers(theVehicle) do
						local player = getVehicleOccupant(theVehicle, i)
						if (player) then
							triggerClientEvent(player, "updateWindow", theVehicle)
							triggerEvent("resetTintName", theVehicle, player)
						end
					end
				end
			end
		end
	end
end
addEvent("vehicle:togWindow", true)
addEventHandler("vehicle:togWindow", root, toggleWindow)
addCommandHandler("togwindow", toggleWindow)