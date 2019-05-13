mysql = exports.mysql
local getPlayerName_ = getPlayerName
getPlayerName = function( ... )
	s = getPlayerName_( ... )
	return s and s:gsub( "_", " " ) or s
end

local _setElementData = setElementData
function setElementData(element, data, index)
	return _setElementData(element, data, index)
end

MTAoutputChatBox = outputChatBox
function outputChatBox( text, visibleTo, r, g, b, colorCoded )
	if string.len(text) > 128 then -- MTA Chatbox size limit
		MTAoutputChatBox( string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded  )
		outputChatBox( string.sub(text, 128), visibleTo, r, g, b, colorCoded  )
	else
		MTAoutputChatBox( text, visibleTo, r, g, b, colorCoded  )
	end
end

--/AUNCUFF
function adminUncuff(thePlayer, commandName, targetPlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)

				if (logged==0) then
					outputChatBox(exports.pool:getServerSyntax(false, "e").."Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
				else
					local restrain = getElementData(targetPlayer, "restrain")

					if (restrain==0) then
						outputChatBox("Player is not restrained.", thePlayer, 255, 0, 0)
					else
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						if hiddenAdmin == 0 then
							outputChatBox("You have been uncuffed by " .. username .. ".", targetPlayer)
						else
							outputChatBox("You have been uncuffed by a Hidden Admin.", targetPlayer)
						end
						outputChatBox("You have uncuffed " .. targetPlayerName .. ".", thePlayer)
						toggleControl(targetPlayer, "sprint", true)
						toggleControl(targetPlayer, "fire", true)
						toggleControl(targetPlayer, "jump", true)
						toggleControl(targetPlayer, "next_weapon", true)
						toggleControl(targetPlayer, "previous_weapon", true)
						toggleControl(targetPlayer, "accelerate", true)
						toggleControl(targetPlayer, "brake_reverse", true)
						toggleControl(targetPlayer, "aim_weapon", true)
						setElementData(targetPlayer, "restrain", 0, true)
						setElementData(targetPlayer, "restrainedBy", false, true)
						setElementData(targetPlayer, "restrainedObj", false, true)
						exports.global:removeAnimation(targetPlayer)
						dbExec(mysql:getConnection(), "UPDATE characters SET cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. (getElementData( targetPlayer, "dbid" )) )
						exports['item-system']:deleteAll(47, getElementData( targetPlayer, "dbid" ))
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNCUFF")
					end
				end
			end
		end
	end
end
addCommandHandler("auncuff", adminUncuff, false, false)

--/AUNMASK
function adminUnmask(thePlayer, commandName, targetPlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)

				if (logged==0) then
					outputChatBox(exports.pool:getServerSyntax(false, "e").."Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
				else
					local any = false
					local masks = exports['item-system']:getMasks()
					for key, value in pairs(masks) do
						if getElementData(targetPlayer, value[1]) then
							any = true
							setElementData(targetPlayer, value[1], false, true)
						end
					end

					if any then
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						if hiddenAdmin == 0 then
							outputChatBox("Your mask has been removed by admin "..username, targetPlayer, 255, 0, 0)
						else
							outputChatBox("Your mask has been removed by a Hidden Admin", targetPlayer, 255, 0, 0)
						end
						outputChatBox("You have removed the mask from " .. targetPlayerName .. ".", thePlayer, 255, 0, 0)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNMASK")
					else
						outputChatBox("Player is not masked.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("aunmask", adminUnmask, false, false)

function infoDisplay(thePlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		outputChatBox("---[        Useful Information        ]---", getRootElement(), 255, 194, 15)
		outputChatBox("---[ Server: owlgaming.net Port: 22003", getRootElement(), 255, 194, 15)
		outputChatBox("---[ Ventrilo: vent.owlgaming.net Port: 3083", getRootElement(), 255, 194, 15)
		outputChatBox("---[ UCP: www.owlgaming.net", getRootElement(), 255, 194, 15)
		outputChatBox("---[ Forums: www.forums.owlgaming.net", getRootElement(), 255, 194, 15)
		outputChatBox("---[ Mantis: www.owlgaming.net/mantis", getRootElement(), 255, 194, 15)
	end
end
addCommandHandler("info", infoDisplay)

function adminUnblindfold(thePlayer, commandName, targetPlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)

				if (logged==0) then
					outputChatBox(exports.pool:getServerSyntax(false, "e").."Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
				else
					local blindfolded = getElementData(targetPlayer, "rblindfold")

					if (blindfolded==0) then
						outputChatBox("Player is not blindfolded", thePlayer, 255, 0, 0)
					else
						setElementData(targetPlayer, "blindfold", false, false)
						fadeCamera(targetPlayer, true)
						outputChatBox("You have unblindfolded " .. targetPlayerName .. ".", thePlayer)
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						if hiddenAdmin == 0 then
							outputChatBox("You have been unblindfolded by admin " .. username .. ".", thePlayer)
						else
							outputChatBox("You have been unblindfolded by a Hidden Admin.", thePlayer)
						end
						dbExec(mysql:getConnection(), "UPDATE characters SET blindfold = 0 WHERE id = " .. (getElementData( targetPlayer, "dbid" )) )
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNBLINDFOLD")
					end
				end
			end
		end
	end
end
addCommandHandler("aunblindfold", adminUnblindfold, false, false)

-- /MUTE
function mutePlayer(thePlayer, commandName, targetPlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged==0) then
					outputChatBox(exports.pool:getServerSyntax(false, "e").."Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
				else
					local muted = getElementData(targetPlayer, "muted") or 0
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					if muted == 0 then
						setElementData(targetPlayer, "muted", 1, false)
						outputChatBox(targetPlayerName .. " is now muted from OOC.", thePlayer, 255, 0, 0)
						if hiddenAdmin == 0 then
							outputChatBox("You were muted by '" .. getPlayerName(thePlayer) .. "'.", targetPlayer, 255, 0, 0)
						else
							outputChatBox("You were muted by a Hidden Admin.", targetPlayer, 255, 0, 0)
						end
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "MUTE")
					else
						setElementData(targetPlayer, "muted", 0, false)
						outputChatBox(targetPlayerName .. " is now unmuted from OOC.", thePlayer, 0, 255, 0)

						if hiddenAdmin == 0 then
							outputChatBox("You were unmuted by '" .. getPlayerName(thePlayer) .. "'.", targetPlayer, 0, 255, 0)
						else
							outputChatBox("You were unmuted by a Hidden Admin.", targetPlayer, 0, 255, 0)
						end
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNMUTE")
					end
					dbExec(mysql:getConnection(), "UPDATE accounts SET muted=" .. (getElementData(targetPlayer, "muted")) .. " WHERE id = " .. (getElementData(targetPlayer, "account:id")) )
				end
			end
		end
	end
end
addCommandHandler("pmute", mutePlayer, false, false)

-- /DISARM
function disarmPlayer(thePlayer, commandName, targetPlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged==0) then
					outputChatBox(exports.pool:getServerSyntax(false, "e").."Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
				elseif (logged==1) then
					for i = 115, 116 do
						while exports['item-system']:takeItem(targetPlayer, i) do
						end
					end
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
					if (hiddenAdmin==0) then
						exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " has disarmed " .. targetPlayerName..".")
						outputChatBox("You have been disarmed by "..tostring(adminTitle) .. " " .. getPlayerName(thePlayer)..".", targetPlayer, 255, 0, 0)
					else
						exports.global:sendMessageToAdmins("AdmCmd: A Hidden Admin has disarmed " .. targetPlayerName..".")
						outputChatBox("You have been disarmed by a hidden Admin.", targetPlayer, 255, 0, 0)
					end
					outputChatBox(targetPlayerName .. " is now disarmed.", thePlayer, 255, 0, 0)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "DISARM")
				end
			end
		end
	end
end
addCommandHandler("disarm", disarmPlayer, false, false)

-- /FRECONNECT
function forceReconnect(thePlayer, commandName, targetPlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				local adminName = getPlayerName(thePlayer)
				if (hiddenAdmin==0) then
					exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. adminName .. " reconnected " .. targetPlayerName )
				else
					adminTitle = ""
					adminName = "a hidden admin"
					exports.global:sendMessageToAdmins("AdmCmd: A hidden admin reconnected " .. targetPlayerName )
				end
				outputChatBox("Player '" .. targetPlayerName .. "' was forced to reconnect.", thePlayer, 255, 0, 0)

				local timer = setTimer(kickPlayer, 1000, 1, targetPlayer, getRootElement(), "You were forced to reconnect by "..tostring(adminTitle) .. " " .. adminName ..".")
				addEventHandler("onPlayerQuit", targetPlayer, function( ) killTimer( timer ) end)

				redirectPlayer ( targetPlayer, "", 0 )

				exports.logs:dbLog(thePlayer, 4, targetPlayer, "FRECONNECT")
			end
		end
	end
end
addCommandHandler("freconnect", forceReconnect, false, false)
addCommandHandler("frec", forceReconnect, false, false)

-- /MAKEGUN
function givePlayerGun(thePlayer, commandName, targetPlayer, ...)
	if exports["integration"]:isPlayerDeveloper(thePlayer) then
		local args = {...}
		if not (targetPlayer) or (#args < 1) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick/ID] [Weapon Name/ID]", thePlayer, 255, 194, 14)
			outputChatBox("     Give player a weapon.", thePlayer, 150, 150, 150)
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick/ID] [Weapon Name/ID] [Quantity]", thePlayer, 255, 194, 14)
			outputChatBox("     Give player an amount of weapons.", thePlayer, 150, 150, 150)
			outputChatBox("(Type /gunlist or hit F4 to open Weapon Creator)", thePlayer, 0, 255, 0)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local weaponID = tonumber(args[1])
				local weaponName = args[1]
				local quantity = tonumber(args[2])
				if weaponID == nil then
					local cWeaponName = weaponName:lower()
					if cWeaponName == "colt45" then
						weaponID = 22
					elseif cWeaponName == "rocketlauncher" then
						weaponID = 35
					elseif cWeaponName == "combatshotgun" then
						weaponID = 27
					elseif cWeaponName == "fireextinguisher" then
						weaponID = 42
					else
						if getWeaponIDFromName(cWeaponName) == false then
							outputChatBox("[MAKEGUN] Invalid Weapon Name/ID. Type /gunlist or hit F4 to open Weapon Creator.", thePlayer, 255, 0, 0)
							return
						else
							weaponID = getWeaponIDFromName(cWeaponName)
						end
					end
				end

				if getAmmoPerClip(weaponID) == "disabled" then
						outputChatBox("[MAKEGUN] Invalid Weapon Name/ID. Type /gunlist or hit F4 to open Weapon Creator.", thePlayer, 255, 0, 0)
						return
				end

				local logged = getElementData(targetPlayer, "loggedin")
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

				if (logged==0) then
					outputChatBox("[MAKEGUN] Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then

					local adminDBID = tonumber(getElementData(thePlayer, "account:character:id"))
					local playerDBID = tonumber(getElementData(targetPlayer, "account:character:id"))

					if quantity == nil then
						quantity = 1
					end

					local maxAmountOfWeapons = tonumber(get( getResourceName( getThisResource( ) ).. '.maxAmountOfWeapons' ))
					if quantity > maxAmountOfWeapons then
						quantity = maxAmountOfWeapons
						outputChatBox("[MAKEGUN] You can't give more than "..maxAmountOfWeapons.." weapons at a time. Trying to spawn "..maxAmountOfWeapons.."...", thePlayer, 150, 150, 150)
					end

					local count = 0
					local fails = 0
					local allSerials = ""
					local give, error = ""
					for variable = 1, quantity, 1 do
						local mySerial = exports.global:createWeaponSerial( 1, adminDBID, playerDBID)
						--outputChatBox(mySerial)
						give, error = exports.global:giveItem(targetPlayer, 115, weaponID..":"..mySerial..":"..getWeaponNameFromID(weaponID).."::")
						if give then
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVEWEAPON "..getWeaponNameFromID(weaponID).." "..tostring(mySerial))
							if count == 0 then
								allSerials = mySerial
							else
								allSerials = allSerials.."', '"..mySerial
							end
							count = count + 1
						else
							fails = fails + 1
						end
					end
					if count > 0 then
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						if (hiddenAdmin==0) then
							--Inform Spawner
							outputChatBox("[MAKEGUN] You have given (x"..count..") ".. getWeaponNameFromID(weaponID).." to "..targetPlayerName..".", thePlayer, 0, 255, 0)
							--Inform Player
							outputChatBox("You've received (x"..count..") ".. getWeaponNameFromID(weaponID).." from "..adminTitle.." "..getPlayerName(thePlayer)..".", targetPlayer, 0, 255, 0)
							--Send adm warning
							exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " (x"..count..") " .. getWeaponNameFromID(weaponID) .. " with serial '"..allSerials.."'")
						else -- If hidden admin
							outputChatBox("[MAKEGUN] You have given (x"..count..") ".. getWeaponNameFromID(weaponID).." to "..targetPlayerName.." with serials '"..allSerials, thePlayer, 0, 255, 0)

							outputChatBox("You've received (x"..count..") ".. getWeaponNameFromID(weaponID).." from a Hidden Admin.", targetPlayer, 0, 255, 0)
						end
					end
					if fails > 0 then
						outputChatBox("[MAKEGUN] "..fails.." weapons couldn't be created. Player's ".. error ..".", thePlayer, 255, 0, 0)
						outputChatBox("[ERROR] "..fails.." weapons couldn't be received from Admin. Your ".. error ..".", targetPlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("makegun", givePlayerGun, false, false)
addEvent("onMakeGun", true)
addEventHandler("onMakeGun", getRootElement(), givePlayerGun)

-- /makeammo
function givePlayerGunAmmo(thePlayer, commandName, targetPlayer, ...)
	if exports["integration"]:isPlayerDeveloper(thePlayer)  then
		local args = {...}
		if not (targetPlayer) or (#args < 1) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick/ID] [Weapon Name/ID] ", thePlayer, 255, 194, 14)
			outputChatBox("     Give player an amount of clips and amount of ammo in each clip.", thePlayer, 150, 150, 150)
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick/ID] [Weapon Name/ID] [Amount/clip,-1=full clip] [quantity]", thePlayer, 255, 194, 14)
			outputChatBox("     Give player an amount of clips and amount of ammo in each clip.", thePlayer, 150, 150, 150)
			outputChatBox("(Type /gunlist or hit F4 to open Weapon Creator)", thePlayer, 0, 255, 0)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				--local ammo =  tonumber(args[2]) or 1
				local weaponID = tonumber(args[1])
				local weaponName = args[1]
				local ammo = tonumber(args[2]) or -1
				local quantity = tonumber(args[3]) or -1

				if weaponID == nil then
					local cWeaponName = weaponName:lower()
					if cWeaponName == "colt45" then
						weaponID = 22
					elseif cWeaponName == "rocketlauncher" then
						weaponID = 35
					elseif cWeaponName == "combatshotgun" then
						weaponID = 27
					elseif cWeaponName == "fireextinguisher" then
						weaponID = 42
					else
						if getWeaponIDFromName(cWeaponName) == false then
							outputChatBox("[MAKEAMMO] Invalid Weapon Name/ID. Type /gunlist or hit F4 to open Weapon Creator.", thePlayer, 255, 0, 0)
							return
						else
							weaponID = getWeaponIDFromName(cWeaponName)
						end
					end
				end

				if getAmmoPerClip(weaponID) == "disabled" then --If weapon is not allowed
					outputChatBox("[MAKEAMMO] Invalid Weapon Name/ID. Type /gunlist or hit F4 to open Weapon Creator.", thePlayer, 255, 0, 0)
					return
				elseif getAmmoPerClip(weaponID) == tostring(0)  then-- if weapon doesn't need ammo to work
					outputChatBox("[MAKEAMMO] This weapon doesn't use ammo.", thePlayer, 255, 0, 0)
					return
				else
				end

				local logged = getElementData(targetPlayer, "loggedin")
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

				if (logged==0) then
					outputChatBox(exports.pool:getServerSyntax(false, "e").."Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
				elseif (logged==1) then
					if ammo == -1 then -- if full ammopack
						ammo = getAmmoPerClip(weaponID)
					end

					if quantity == -1 then
						quantity = 1
					end

					local maxAmountOfAmmopacks = tonumber(get( getResourceName( getThisResource( ) ).. '.maxAmountOfAmmopacks' ))
					if quantity > maxAmountOfAmmopacks then
						quantity = maxAmountOfAmmopacks
						outputChatBox("[MAKEAMMO] You can't give more than "..maxAmountOfAmmopacks.." magazines at a time. Trying to spawn "..maxAmountOfAmmopacks.."...", thePlayer, 150, 150, 150)
					end

					local count = 0
					local fails = 0
					local give, error = ""
					for variable = 1, quantity, 1 do
						give, error = exports.global:giveItem(targetPlayer, 116, weaponID..":"..ammo..":Ammo for "..getWeaponNameFromID(weaponID))
						if give then
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVEBULLETS "..getWeaponNameFromID(weaponID).." "..tostring(bullets))
							count = count + 1
						else
							fails = fails + 1
						end
					end

					if count > 0 then
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						if (hiddenAdmin==0) then
							--Inform Spawner
							outputChatBox("[MAKEAMMO] You have given (x"..count..") " .. getWeaponNameFromID(weaponID) .. " ammopacks ("..ammo.." bullets each) to "..targetPlayerName..".", thePlayer, 0, 255, 0)
							--Inform Player
							outputChatBox("You've received (x"..count..") " .. getWeaponNameFromID(weaponID) .. " ammopacks ("..ammo.." bullets each) from "..adminTitle.." "..getPlayerName(thePlayer), targetPlayer, 0, 255, 0)
							--Send adm warning
							exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " gave (x"..count..") " .. getWeaponNameFromID(weaponID) .. " ammopacks ("..ammo.." bullets each) to " .. targetPlayerName)
						else -- If hidden admin
							--Inform Spawner
							outputChatBox("[MAKEAMMO] You have given (x"..count..") "..getWeaponNameFromID(weaponID).." ammopacks ("..ammo.." bullets each) to "..targetPlayerName..".", thePlayer, 0, 255, 0)
							--Inform Player
							outputChatBox("You've received (x"..count..") "..getWeaponNameFromID(weaponID).." ammopacks ("..ammo.." bullets each) from a Hidden Admin.", targetPlayer, 0, 255, 0)
						end
					end
					if fails > 0 then
						outputChatBox("[MAKEAMMO] "..fails.." ammopacks couldn't be created. Player's ".. error ..".", thePlayer, 255, 0, 0)
						outputChatBox("[ERROR] "..fails.." ammopacks couldn't be received from Admin. Your ".. error ..".", targetPlayer, 255, 0, 0)
					end


				end
			end
		end
	end
end
addCommandHandler("makeammo", givePlayerGunAmmo, false, false)
addEvent("onMakeAmmo", true)
addEventHandler("onMakeAmmo", getRootElement(), givePlayerGunAmmo)

function getAmmoPerClip(id)
	if id == 0 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.fist' ))
	elseif id == 1 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.brassknuckle' ))
	elseif id == 2 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.golfclub' ))
	elseif id == 3 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.nightstick' ))
	elseif id == 4 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.knife' ))
	elseif id == 5 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.bat' ))
	elseif id == 6 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.shovel' ))
	elseif id == 7 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.poolstick' ))
	elseif id == 8 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.katana' ))
	elseif id == 9 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.chainsaw' ))
	elseif id == 10 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.dildo' ))
	elseif id == 11 then
		return tostring(get( getResourceName( getThisResource( ) ).. 'dildo2' ))
	elseif id == 12 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.vibrator' ))
	elseif id == 13 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.vibrator2' ))
	elseif id == 14 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.flower' ))
	elseif id == 15 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.cane' ))
	elseif id == 16 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.grenade' ))
	elseif id == 17 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.teargas' ))
	elseif id == 18 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.molotov' ))
	elseif id == 22 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.colt45' ))
	elseif id == 23 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.silenced' ))
	elseif id == 24 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.deagle' ))
	elseif id == 25 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.shotgun' ))
	elseif id == 26 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.sawed-off' ))
	elseif id == 27 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.combatshotgun' ))
	elseif id == 28 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.uzi' ))
	elseif id == 29 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.mp5' ))
	elseif id == 30 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.ak-47' ))
	elseif id == 31 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.m4' ))
	elseif id == 32 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.tec-9' ))
	elseif id == 33 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.rifle' ))
	elseif id == 34 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.sniper' ))
	elseif id == 35 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.rocketlauncher' ))
	--elseif id == 39 then -- Satchel
	--elseif id == 40 then -- Satchel remote (Bomb)
	elseif id == 41 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.spraycan' ))
	elseif id == 42 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.fireextinguisher' ))
	elseif id == 43 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.camera' ))
	elseif id == 44 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.nightvision' ))
	elseif id == 45 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.infrared' ))
	--elseif id == 46 then -- Parachute
	else
		return "disabled"
	end
	return "disabled"
end
addEvent("onGetAmmoPerClip", true)
addEventHandler("onGetAmmoPerClip", getRootElement(), getAmmoPerClip)

function loadWeaponStats()
	for id = 0, 45, 1 do
		if id ~= 19 and id ~= 20 and id ~=21 then
			local tmp = getAmmoPerClip(id)
			if tmp == "disable" then
				setWeaponProperty( id , "std", "maximum_clip_ammo", 0)
			else
			--	setWeaponProperty( id , "std", "maximum_clip_ammo", tmp)
			end
		end
	end
end
addEventHandler ( "onResourceStart", resourceRoot, loadWeaponStats )


-- /GIVEITEM
function givePlayerItem(thePlayer, commandName, targetPlayer, itemID, ...)
	if (exports.integration:isPlayerLeadAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer)) then
		if not (itemID) or not (...) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Item ID] [Item Value]", thePlayer, 255, 194, 14)
		else
			itemID = tonumber(itemID)

			if (itemID == 169 or itemID == 150) and getElementData(thePlayer, "account:id") ~= 1 then
				outputChatBox("Invalid Item ID.", thePlayer, 255, 0, 0)
				return false
			end

			if ( itemID == 74 or itemID == 150 or itemID == 75 or itemID == 78 or itemID == 2) and not exports.integration:isPlayerSeniorAdmin( thePlayer) then -- Banned Items
				exports.hud:sendBottomNotification(thePlayer, "Banned Items", "Only Lead+ Admin can spawn this kind of item.")
				return false
			end
			local itemValue = table.concat({...}, " ")
			itemValue = tonumber(itemValue) or itemValue

			if itemID == 114 and exports['npc']:getDisabledUpgrades()[tonumber(itemValue)] then
				outputChatBox("This item is temporarily disabled.", thePlayer, 255, 0, 0)
				return false
			end
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			local preventSpawn = exports["item-system"]:getItemPreventSpawn(itemID, itemValue)
			if preventSpawn then
				exports.hud:sendBottomNotification(thePlayer, "Non-Spawnable Item", "This item cannot be spawned. It might be temporarily restricted or only obtainable IC.")
				return false
			end

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				if ( itemID == 84 ) and not exports.integration:isPlayerAdmin( thePlayer ) then
				elseif itemID == 114 and not exports.integration:isPlayerTrialAdmin( thePlayer ) then
				elseif (itemID == 115 or itemID == 116 or itemID == 68 or itemID == 134 --[[or itemID == 137)]]) then
					outputChatBox("Sorry, you cannot use this with /giveitem.", thePlayer, 255, 0, 0)
				elseif (logged==0) then
					outputChatBox(exports.pool:getServerSyntax(false, "e").."Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
				elseif (logged==1) then
					local name = call( getResourceFromName( "item-system" ), "getItemName", itemID, itemValue )

					if itemID > 0 and name and name ~= "?" then
						local success, reason = exports.global:giveItem(targetPlayer, itemID, itemValue)
						if success then
							outputChatBox("Player " .. targetPlayerName .. " has received a " .. name .. " with value " .. itemValue .. ".", thePlayer, 0, 255, 0)
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "GIVEITEM "..name.." "..tostring(itemValue))
							triggerClientEvent(targetPlayer, "item:updateclient", targetPlayer)
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
							if (hiddenAdmin==0) then
								outputChatBox(tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " has given you a " .. name .. " with value " .. itemValue .. ".", targetPlayer, 0, 255, 0)
							else
								outputChatBox("A Hidden Admin has given you a " .. name .. " with value " .. itemValue .. ".", targetPlayer, 0, 255, 0)
							end
						else
							outputChatBox("Couldn't give " .. targetPlayerName .. " a " .. name .. ": " .. tostring(reason), thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("Invalid Item ID.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("giveitem", givePlayerItem, false, false)

-- /GIVEPEDITEM
function givePedItem(thePlayer, commandName, ped, itemID, ...)
	if (exports.integration:isPlayerLeadAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer)) then
		if not (itemID) or not (...) or not (ped) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Ped dbid] [Item ID] [Item Value]", thePlayer, 255, 194, 14)
		else
			if ped then
				--local logged = getElementData(targetPlayer, "loggedin")
				local element = exports.pool:getElement("ped", tonumber(ped))
				local pedname = getElementData(element, "rpp.npc.name")
				itemID = tonumber(itemID)
				local itemValue = table.concat({...}, " ")
				itemValue = tonumber(itemValue) or itemValue
				
				if ( itemID == 74 or itemID == 150 or itemID == 75 or itemID == 78 or itemID == 2) and not exports.integration:isPlayerSeniorAdmin( thePlayer) then -- Banned Items
					exports.hud:sendBottomNotification(thePlayer, "Banned Items", "Only Lead+ Admin can spawn this kind of item.")
					return false
				elseif ( itemID == 84 ) and not exports.global:isPlayerAdmin( thePlayer ) then
				elseif itemID == 114 and not exports.global:isPlayerTrialAdmin( thePlayer ) then
				--elseif (itemID == 115 or itemID == 116) then
				--	outputChatBox("Not possible to use this item with /giveitem, sorry.", thePlayer, 255, 0, 0)
				else
					local name = call( getResourceFromName( "item-system" ), "getItemName", itemID, itemValue )
					
					if itemID > 0 and name and name ~= "?" then
						local success, reason = exports.global:giveItem(element, itemID, itemValue)
						if success then
							outputChatBox("Ped "..tostring(pedname) or "".." (".. tostring(ped) ..") now has a " .. name .. " with value " .. itemValue .. ".", thePlayer, 0, 255, 0)
							exports.logs:dbLog(thePlayer, 4, ped, "GIVEITEM "..name.." "..tostring(itemValue))
							if element then
								exports['item-system']:npcUseItem(element, itemID)
							else
								outputChatBox("Failed to get ped element from dbid.", thePlayer, 255, 255, 255)
							end
						else
							outputChatBox("Couldn't give ped " .. tostring(ped) .. " a " .. name .. ": " .. tostring(reason), thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("Invalid Item ID.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("givepeditem", givePedItem, false, false)

function makeGenericItem(thePlayer, commandName, price, quantity, ...)
	if exports.global:isStaffOnDuty(thePlayer) and getElementData(thePlayer, "loggedin") == 1 then
		if not (price) or not (...) or not tonumber(price) or not (tonumber(price) > 0) or not (quantity) or not (tonumber(quantity) > 0) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Price] [Quantity, max=10] [Name:ObjectModel]", thePlayer, 255, 194, 14)
			outputChatBox("This command creates to yourself a generic item after taking away an amount of money as item's value.", thePlayer, 200, 200, 200)
			outputChatBox("Maximum quantity is 10. Will be spawned until you reach maximum weight.", thePlayer, 200, 200, 200)
		else
			if (tonumber(quantity) > 11) then
				outputChatBox("Your quantity was above 10. 10 have been requested.", thePlayer, 255, 0, 0)
				quantity = 10
			end
			local itemValue = table.concat({...}, " ")
			price = tonumber(price) * tonumber(quantity)
			local fPrice = exports.global:formatMoney(price)
			if not exports.global:takeMoney(thePlayer, price) then
				outputChatBox("You could not afford $"..fPrice.." for a '"..itemValue.."'.", thePlayer, 255, 0, 0)
				return false
			end

			local success, reason = setTimer ( function ()
				exports.global:giveItem(thePlayer, 80, itemValue)
			end, 250, quantity )
			if success then
				local playerName = exports.global:getAdminTitle1(thePlayer)
				exports.global:sendWrnToStaff(playerName.." has created "..quantity.." '"..itemValue.."' to themselves for $"..fPrice.." (total: "..tonumber(quantity)*tonumber(fPrice).."$).", "MAKEGENERIC")

				exports.logs:dbLog(thePlayer, 4, thePlayer, commandName.." x"..quantity.." "..itemValue.." for "..fPrice)
				triggerClientEvent(thePlayer, "item:updateclient", thePlayer)
				return true
			else
				outputChatBox("Failed to created generic item. Reason: " .. tostring(reason), thePlayer, 255, 0, 0)
				return false
			end
		end
	end
end
addCommandHandler("makegenericitem", makeGenericItem, false, false)
addCommandHandler("makegeneric", makeGenericItem, false, false)


--Cargo Group generic maker, approved by Maxime, made by anumaz 16/07/2014 /CMG /CARGOMAKEGENERIC
function createCargoGenericPed()
	local thePed = createPed(27, 1613.6572265625, 1321.0185546875, 10.8225440979)
	setElementDimension(thePed, 0)
	setElementInterior(thePed, 0)
	setElementData( thePed, "name", "Michael Dupont")
    setElementFrozen(thePed, true)
    setElementData( thePed, "nametag", true)
    setPedRotation(thePed, 89.136)
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), createCargoGenericPed)

function makeGenericItemCargo(thePlayer, commandName, price, ...)
	if getElementData(thePlayer, "factionleader") == 1 and getElementData(thePlayer, "loggedin") == 1 and tostring(getTeamName(getPlayerTeam(thePlayer))) == "Cargo Group" then
		if getDistanceBetweenPoints3D(1613.6572265625, 1321.0185546875, 10.8225440979, getElementPosition(thePlayer)) > 20 then return end
		if not (price) or not (...) or not tonumber(price) or not (tonumber(price) > 0) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Price] [Name:ObjectModel] OR use the NPC GUI", thePlayer, 255, 194, 14)
			outputChatBox("This command creates to yourself a generic item after taking away an amount of money as item's value.", thePlayer, 200, 200, 200)
		else
			local itemValue = table.concat({...}, " ")
			price = tonumber(price)
			local fPrice = exports.global:formatMoney(price)
			if not exports.global:takeMoney(getTeamFromName("Cargo Group"), price) then
				outputChatBox("You could not afford $"..fPrice.." for a '"..itemValue.."'.", thePlayer, 255, 0, 0)
				return false
			end
			local success, reason = exports.global:giveItem(thePlayer, 80, itemValue)
			if success then
				local playerName = exports.global:getPlayerFullIdentity(thePlayer)
				exports.global:sendMessageToStaff("[CARGO GROUP] "..playerName.." has created a '"..itemValue.."' to themselves for $"..fPrice..".")
				exports.logs:dbLog(thePlayer, 4, thePlayer, "Cargo Group "..commandName.." "..itemValue.." for "..fPrice)
				triggerClientEvent(thePlayer, "item:updateclient", thePlayer)
				return true
			else
				outputChatBox("Failed to created generic item. Reason: " .. tostring(reason), thePlayer, 255, 0, 0)
				return false
			end
		end
	end
end
addEvent("createCargoGeneric", true)
addEventHandler("createCargoGeneric", getResourceRootElement(), makeGenericItemCargo)
addCommandHandler("cmg", makeGenericItemCargo, false, false)
addCommandHandler("cargomakegeneric", makeGenericItemCargo, false, false)

-- /TAKEITEM
function takePlayerItem(thePlayer, commandName, targetPlayer, itemID, ...)
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer)) then
		if not (itemID) or not (...) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Item ID] [Item Value]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				itemID = tonumber(itemID)
				local itemValue = table.concat({...}, " ")
				itemValue = tonumber(itemValue) or itemValue

				if (logged==0) then
					outputChatBox(exports.pool:getServerSyntax(false, "e").."Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
				elseif (logged==1) then
					if exports.global:hasItem(targetPlayer, itemID, itemValue) then
						outputChatBox("You took item " .. itemID .. " with the value of (" .. itemValue .. ") from " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
						exports.global:takeItem(targetPlayer, itemID, itemValue)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "TAKEITEM "..tostring(itemID).." "..tostring(itemValue))

						triggerClientEvent(targetPlayer, "item:updateclient", targetPlayer)
					else
						outputChatBox("Player doesn't have that item", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("takeitem", takePlayerItem, false, false)

-- /SETHP
function setPlayerHealth(thePlayer, commandName, targetPlayer, health)
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer)) then
		if not tonumber(health) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Health]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				if tonumber( health ) < getElementHealth( targetPlayer ) and getElementData( thePlayer, "admin_level" ) < getElementData( targetPlayer, "admin_level" ) then
					outputChatBox("Nah.", thePlayer, 255, 0, 0)
				elseif not setElementHealth(targetPlayer, tonumber(health)) then
					outputChatBox("Invalid health value.", thePlayer, 255, 0, 0)
				else
					outputChatBox("Player " .. targetPlayerName .. " has received " .. health .. " Health.", thePlayer, 0, 255, 0)
					triggerEvent("onPlayerHeal", targetPlayer, true)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETHP "..health)
				end
			end
		end
	end
end
addCommandHandler("sethp", setPlayerHealth, false, false)

-- /AHEAL -MAXIME
function adminHeal(thePlayer, commandName, targetPlayer)
	if (exports.global:isStaffOnDuty(thePlayer)) then
		local health = 100
		local targetPlayerName = getPlayerName(thePlayer):gsub("_", " ")
		if not (targetPlayer) then
			targetPlayer = thePlayer
		else
			targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
		end

		if targetPlayer then
			setElementHealth(targetPlayer, tonumber(health))
			outputChatBox("Player " .. targetPlayerName .. " has received " .. health .. " Health.", thePlayer, 0, 255, 0)
			triggerEvent("onPlayerHeal", targetPlayer, true)
			exports.logs:dbLog(thePlayer, 4, targetPlayer, "AHEAL "..health)
		end
	end
end
addCommandHandler("aheal", adminHeal, false, false)

--[[ /SETARMOR
function setPlayerArmour(thePlayer, commandName, targetPlayer, armor)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (armor) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Armor]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged==0) then
					outputChatBox(exports.pool:getServerSyntax(false, "e").."Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
				elseif (tostring(type(tonumber(armor))) == "number") then
					local setArmor = setPedArmor(targetPlayer, tonumber(armor))
					outputChatBox("Player " .. targetPlayerName .. " has received " .. armor .. " Armor.", thePlayer, 0, 255, 0)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETARMOR "..tostring(armor))
				else
					outputChatBox("Invalid armor value.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("setarmor", setPlayerArmour, false, false)
]]--

-- /SETARMOR
--Armor only for law enforcement members, unless admin is lead+. - Chuevo, 19/05/13
function setPlayerArmour(thePlayer, theCommand, targetPlayer, armor)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) or not (armor) then
			outputChatBox("SYNTAX: /" .. theCommand .. " [Player Partial Nick / ID] [Armor]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==1) then
					if (tostring(type(tonumber(armor))) == "number") then
						local targetPlayerFaction = getElementData(targetPlayer, "faction")
						if (targetPlayerFaction == 1) or (targetPlayerFaction == 15) or (targetPlayerFaction == 59) then
							local setArmor = setPedArmor(targetPlayer, tonumber(armor))
							outputChatBox("Player " .. targetPlayerName .. " has received " .. armor .. " Armor.", thePlayer, 0, 255, 0)
							exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETARMOR " ..tostring(armor))
						elseif (targetPlayerFaction ~= 1) or (targetPlayerFaction ~= 15) or (targetPlayerFaction ~= 59) then
							if (exports.integration:isPlayerAdmin(thePlayer)) then
								local setArmor = setPedArmor(targetPlayer, tonumber(armor))
								outputChatBox("Player " .. targetPlayerName .. " has received " .. armor .. " Armor.", thePlayer, 0, 255, 0)
								exports.logs:dbLog(thePlayer, 4, tagetPlayer, "SETARMOR " ..tostring(armor))
							else
								outputChatBox("This player is not in a law enforcement faction. Contact a lead+ administrator to set armor.", thePlayer, 255, 0, 0)
							end
						end
					else
						outputChatBox("Invalid armor value.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox(exports.pool:getServerSyntax(false, "e").."Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addCommandHandler("setarmor", setPlayerArmour, false, false)


-- /SETSKIN
function setPlayerSkinCmd(thePlayer, commandName, targetPlayer, skinID, clothingID)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (skinID) or not (targetPlayer) then -- Clothing ID is a optional argument
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Skin ID] (Clothing ID)", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				if not clothingID then clothingID = 0 end
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged==0) then
					outputChatBox(exports.pool:getServerSyntax(false, "e").."Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
				elseif tostring(type(tonumber(skinID))) == "number" and tonumber(skinID) ~= 0 then
					local fat = getPedStat(targetPlayer, 21)
					local muscle = getPedStat(targetPlayer, 23)

					setPedStat(targetPlayer, 21, 0)
					setPedStat(targetPlayer, 23, 0)
					local oldSkin = getElementModel(targetPlayer)
					local skin = setElementModel(targetPlayer, tonumber(skinID))

					setPedStat(targetPlayer, 21, fat)
					setPedStat(targetPlayer, 23, muscle)
					if not (skin) and tonumber(oldSkin) ~= tonumber(skin) then
						outputChatBox("Invalid skin ID.", thePlayer, 255, 0, 0)
					else
						if not tonumber(clothingID) then
							clothingID = nil
						end
						outputChatBox("Player " .. targetPlayerName .. " has received skin " .. skinID, thePlayer, 0, 255, 0)
						setElementData(targetPlayer, 'clothing:id', tonumber(clothingID), true)
						dbExec(mysql:getConnection(), "UPDATE characters SET skin = " .. (skinID) .. ", clothingid = " .. (clothingID) .. " WHERE id = " .. (getElementData( targetPlayer, "dbid" )) )
						
					end
				else
					outputChatBox("Invalid skin ID.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("setskin", setPlayerSkinCmd, false, false)

-- /CHANGENAME
function asetPlayerName(thePlayer, commandName, targetPlayer, ...)
	if (exports.integration:isPlayerLeadAdmin(thePlayer)) then
		if not (...) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Player New Nick]", thePlayer, 255, 194, 14)
		else
			local newName = table.concat({...}, "_")
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local hoursPlayed = getElementData( targetPlayer, "hoursplayed" )
				if hoursPlayed > 5 and not exports.integration:isPlayerAdmin(thePlayer) then
					outputChatBox( "Only Regular Admin or higher up can change character name which is older than 5 hours.", thePlayer, 255, 0, 0)
					return false
				end
				if newName == targetPlayerName then
					outputChatBox( "The player's name is already that.", thePlayer, 255, 0, 0)
				else
					local dbid = getElementData(targetPlayer, "dbid")
					
						setElementData(targetPlayer, "legitnamechange", 1, false)
						local name = setPlayerName(targetPlayer, tostring(newName))

						if (name) then
							exports['cache']:clearCharacterName( dbid )
							dbExec(mysql:getConnection(), "UPDATE characters SET charactername='" .. (newName) .. "' WHERE id = " .. (dbid))
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

							local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
							local processedNewName = string.gsub(tostring(newName), "_", " ")
							if (hiddenAdmin==0) then
								exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " changed " .. targetPlayerName .. "'s Name to " .. newName .. ".")
								outputChatBox("You character's name has been changed from '"..targetPlayerName .. "' to '" .. tostring(newName) .. "' by "..adminTitle.." "..getPlayerName(thePlayer)..".", targetPlayer, 0, 255, 0)
							else
								outputChatBox("You character's name has been changed from '"..targetPlayerName .. "' to " .. processedNewName .. "' by a Hidden Admin.", targetPlayer, 0, 255, 0)
							end
							outputChatBox("You changed " .. targetPlayerName .. "'s name to '" .. processedNewName .. "'.", thePlayer, 0, 255, 0)

							setElementData(targetPlayer, "legitnamechange", 0, false)

							triggerClientEvent(targetPlayer, "updateName", targetPlayer, getElementData(targetPlayer, "dbid"))
						else
							outputChatBox("Failed to change name.", thePlayer, 255, 0, 0)
						end
						setElementData(targetPlayer, "legitnamechange", 0, false)
				
				
				end
			end
		end
	end
end
addCommandHandler("changename", asetPlayerName, false, false)

-- /HIDEADMIN
function hideAdmin(thePlayer, commandName)
	if exports.integration:isPlayerHeadAdmin(thePlayer) then
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

		if (hiddenAdmin==0) then
			setElementData(thePlayer, "hiddenadmin", 1, true)
			outputChatBox("Hidden Admin - ON", thePlayer, 255, 194, 14)
		elseif (hiddenAdmin==1) then
			setElementData(thePlayer, "hiddenadmin", 0, true)
			outputChatBox("Hidden Admin - OFF", thePlayer, 255, 194, 14)
		end
		exports.global:updateNametagColor(thePlayer)
		dbExec(mysql:getConnection(), "UPDATE accounts SET hiddenadmin=" .. (getElementData(thePlayer, "hiddenadmin")) .. " WHERE id = " .. (getElementData(thePlayer, "account:id")) )
	end
end
addCommandHandler("hideadmin", hideAdmin, false, false)

-- /SLAP
function slapPlayer(thePlayer, commandName, targetPlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local thePlayerPower = exports.global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.global:getPlayerAdminLevel(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged==0) then
					outputChatBox(exports.pool:getServerSyntax(false, "e").."Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
				elseif (targetPlayerPower > thePlayerPower) then -- Check the admin isn't slapping someone higher rank them him
					outputChatBox("You cannot slap this player as they are a higher admin rank then you.", thePlayer, 255, 0, 0)
				else
					local x, y, z = getElementPosition(targetPlayer)

					if (isPedInVehicle(targetPlayer)) then
						setElementData(targetPlayer, "realinvehicle", 0, false)
						removePedFromVehicle(targetPlayer)
					end
					detachElements(targetPlayer)

					setElementPosition(targetPlayer, x, y, z+15)
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

					if (hiddenAdmin==0) then
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " slapped " .. targetPlayerName .. ".")
					end
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "SLAP")
				end
			end
		end
	end
end
addCommandHandler("slap", slapPlayer, false, false)

-- HEADS Hidden OOC
function hiddenOOC(thePlayer, commandName, ...)
	local logged = getElementData(thePlayer, "loggedin")

	if (exports.integration:isPlayerSeniorAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Message]", thePlayer, 255, 194, 14)
		else
			local players = exports.pool:getPoolElementsByType("player")
			local message = table.concat({...}, " ")

			for index, arrayPlayer in ipairs(players) do
				local logged = getElementData(arrayPlayer, "loggedin")

				if (logged==1) and getElementData(arrayPlayer, "globalooc") == 1 then
					outputChatBox("(( Hidden Admin: " .. message .. " ))", arrayPlayer, 255, 255, 255)
				end
			end
		end
	end
end
addCommandHandler("ho", hiddenOOC, false, false)

-- HEADS Hidden Whisper
function hiddenWhisper(thePlayer, command, who, ...)
	if (exports.integration:isPlayerSeniorAdmin(thePlayer)) then
		if not (who) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Message]", thePlayer, 255, 194, 14)
		else
			message = table.concat({...}, " ")
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, who)

			if (targetPlayer) then
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged==1) then
					local playerName = getPlayerName(thePlayer)
					outputChatBox("PM From Hidden Admin: " .. message, targetPlayer, 255, 194, 14)
					outputChatBox("Hidden PM Sent to " .. targetPlayerName .. ": " .. message, thePlayer, 255, 194, 14)
				elseif (logged==0) then
					outputChatBox("Player is not logged in yet.", thePlayer, 255, 194, 14)
				end
			end
		end
	end
end
addCommandHandler("hw", hiddenWhisper, false, false)

-- Kick
function kickAPlayer(thePlayer, commandName, targetPlayer, ...)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Reason]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local thePlayerPower = exports.global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.global:getPlayerAdminLevel(targetPlayer)
				reason = table.concat({...}, " ")

				if (targetPlayerPower <= thePlayerPower) then
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local playerName = getPlayerName(thePlayer)
					--[[outputDebugString("---------------")
					outputDebugString(getPlayerName(targetPlayer))
					outputDebugString(tostring(getElementData(targetPlayer, "account:id")))
					outputDebugString(getPlayerName(thePlayer))
					outputDebugString(tostring(getElementData(thePlayer, "account:id")))
					outputDebugString(tostring(hiddenAdmin))
					outputDebugString(reason)]]
					addAdminHistory(targetPlayer, thePlayer, reason, 1 , 0)
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "PKICK "..reason)
					if (hiddenAdmin==0) then
						if commandName ~= "skick" then
							local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
							exports.global:sendMessageToAdmins("[PKICK]: " .. adminTitle .. " " .. playerName .. " booted " .. targetPlayerName .. " out of game.")
							exports.global:sendMessageToAdmins("[PKICK]: Reason: " .. reason .. ".")

						end
						kickPlayer(targetPlayer, thePlayer, reason)
					else
						if commandName ~= "skick" then
							exports.global:sendMessageToAdmins("[PKICK]: "..targetPlayerName.." has been booted out of game.")
							exports.global:sendMessageToAdmins("[PKICK]: Reason: " .. reason .. ".")
						end
						kickPlayer(targetPlayer, reason)
					end

				else
					outputChatBox(" This player is a higher level admin than you.", thePlayer, 255, 0, 0)
					outputChatBox(playerName .. " attempted to execute the kick command on you.", targetPlayer, 255, 0 ,0)
				end
			end
		end
	end
end
addCommandHandler("pkick", kickAPlayer, false, false)
addCommandHandler("skick", kickAPlayer, false, false)

--MAXIME
function setMoney(thePlayer, commandName, target, money, ...)
	if exports["integration"]:isPlayerLeadAdmin(thePlayer) then
		if not (target) or not money or not tonumber(money) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Money] [Reason]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)

			if targetPlayer then
				money = tonumber(money) or 0
				if money and money > 5000 then
					outputChatBox("For security reason, you're not allowed to set more than $5000 at once to a player.", thePlayer, 255, 0, 0)
					return false
				end

				if not exports.global:setMoney(targetPlayer, money) then
					outputChatBox("Could not set that amount.", thePlayer, 255, 0, 0)
					return false
				end

				exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETMONEY "..money)


				local amount = exports.global:formatMoney(money)
				reason = table.concat({...}, " ")
				outputChatBox(targetPlayerName .. " has received " .. amount .. " $.", thePlayer)
				outputChatBox("Admin " .. username .. " set your money to " .. amount .. " $.", targetPlayer)
				outputChatBox("Reason: " .. reason .. ".", targetPlayer)
				local targetUsername = string.gsub(getElementData(targetPlayer, "account:username"), "_", " ")
				targetUsername = (targetUsername)
				local targetCharacterName = (targetPlayerName)


				if tonumber(money) >= 5000 then
					local content = "[B]Set money to username:[/B][INDENT]"..targetUsername.."[/INDENT][B]Character name: [/B][INDENT]"..targetCharacterName.."[/INDENT][B]Amount: [/B][INDENT]$"..amount.."[/INDENT][B]Reason: [/B][INDENT]"..reason..".[/INDENT][INDENT][/INDENT][U][I]Note: Please make a reply to this post with any additional information you may have.[/I][/U]"
					exports["integration"]:createForumThread(thePlayer, thePlayer, 143, "/"..commandName.." $"..amount.." to ("..targetUsername..") "..targetCharacterName, content, "Please make a reply to this post with any additional information you may have")
					exports.global:sendMessageToAdmins("[SETMONEY] Admin " .. username .. " has set money of ("..targetUsername..") "..targetCharacterName.." to $" .. amount .. " ("..reason.."). Info: http://forums.owlgaming.net/forumdisplay.php?143")
				else
					exports.global:sendMessageToAdmins("[SETMONEY] Admin " .. username .. " has set money of ("..targetUsername..") "..targetCharacterName.." to $" .. amount.." ("..reason..")." )
				end

			end
		end
	end
end
addCommandHandler("setmoney", setMoney, false, false)

--MAXIME
function giveMoney(thePlayer, commandName, target, money, ...)
	if exports["integration"]:isPlayerLeadAdmin(thePlayer) then
		if not (target) or not money or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Money] [Reason]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)

			if targetPlayer then
				money = tonumber(money) or 0
				if money and money > 100000 then
					outputChatBox("For security reason, you're only allowed to give a player less than $100000 at once.", thePlayer, 255, 0, 0)
					return false
				end

				if not exports.global:giveMoney(targetPlayer, money) then
					outputChatBox("Could not give player that amount.", thePlayer, 255, 0, 0)
					return false
				end

				local amount = exports.global:formatMoney(money)
				reason = table.concat({...}, " ")
				outputChatBox("You have given " .. targetPlayerName .. " $" .. amount .. ".", thePlayer)
				outputChatBox("Admin " .. username .. " has given you: $" .. amount .. ".", targetPlayer)
				outputChatBox("Reason: " .. reason .. ".", targetPlayer)

				local targetUsername = string.gsub(getElementData(targetPlayer, "account:username"), "_", " ")
				targetUsername = (targetUsername)
				local targetCharacterName = (targetPlayerName)


				if tonumber(money) >= 100000 then
					exports.global:sendMessageToAdmins("[GIVEMONEY] Admin " .. username .. " has given ("..targetUsername..") "..targetCharacterName.." $" .. amount .. " ("..reason.."). Info: http://forums.owlgaming.net/forumdisplay.php?143")
				else
					exports.global:sendMessageToAdmins("[GIVEMONEY] Admin " .. username .. " has given ("..targetUsername..") "..targetCharacterName.." $" .. amount .. " ("..reason..").")
				end

			end
		end
	end
end
addCommandHandler("givemoney", giveMoney, false, false)

--MAXIME
function takeMoney(thePlayer, commandName, target, money, ...)
	if exports["integration"]:isPlayerAdmin(thePlayer) then
		if not (target) or not money or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Money] [Reason]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)

			if targetPlayer then
				money = tonumber(money) or 0
				local amount = exports.global:formatMoney(money)
				if not exports.global:takeMoney(targetPlayer, money) then
					outputChatBox("Could not take away $"..amount.." from the player.", thePlayer, 255, 0, 0)
					return false
				end

				exports.logs:dbLog(thePlayer, 4, targetPlayer, "TAKEMONEY " ..money)

				outputChatBox("You have taken away from " .. targetPlayerName .. " $" .. amount .. ".", thePlayer)
				outputChatBox("Admin " .. username .. " has taken away from you: $" .. amount .. ".", targetPlayer)

				local targetUsername = string.gsub(getElementData(targetPlayer, "account:username"), "_", " ")
				targetUsername = (targetUsername)
				local targetCharacterName = (targetPlayerName)
				reason = table.concat({...}, " ")
				if tonumber(money) >= 5000 then
					local content = "[B]Took away from username:[/B][INDENT]"..targetUsername.."[/INDENT][B]Character name: [/B][INDENT]"..targetCharacterName.."[/INDENT][B]Amount: [/B][INDENT]$"..amount.."[/INDENT][B]Reason: [/B][INDENT]"..reason..".[/INDENT][INDENT][/INDENT][U][I]Note: Please make a reply to this post with any additional information you may have.[/I][/U]"
					exports["integration"]:createForumThread(thePlayer, thePlayer, 143, "/"..commandName.." $"..amount.." from ("..targetUsername..") "..targetCharacterName, content, "Please make a reply to this post with any additional information you may have")
					exports.global:sendMessageToAdmins("[TAKEMONEY] Admin " .. username .. " taken away from ("..targetUsername..") "..targetCharacterName.." $" .. amount .. " ("..reason.."). Info: http://forums.owlgaming.net/forumdisplay.php?143")
				else
					exports.global:sendMessageToAdmins("[TAKEMONEY] Admin " .. username .. " taken away from ("..targetUsername..") "..targetCharacterName.." $" .. amount .. ". ("..reason..")")
				end
			end
		end
	end
end
addCommandHandler("takemoney", takeMoney, false, false)

-----------------------------------[FREEZE]----------------------------------
function freezePlayer(thePlayer, commandName, target)
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				local textStr = "admin"
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				local veh = getPedOccupiedVehicle( targetPlayer )
				if (veh) then
					setElementFrozen(veh, true)
					toggleAllControls(targetPlayer, false, true, false)
					outputChatBox(" You have been frozen by an ".. textStr ..". Take care when following instructions.", targetPlayer)
					outputChatBox(" You have frozen " ..targetPlayerName.. ".", thePlayer)
				else
					detachElements(targetPlayer)
					toggleAllControls(targetPlayer, false, true, false)
					setElementFrozen(targetPlayer, true)
					triggerClientEvent(targetPlayer, "onClientPlayerWeaponCheck", targetPlayer)
					setPedWeaponSlot(targetPlayer, 0)
					setElementData(targetPlayer, "freeze", 1, false)
					outputChatBox(" You have been frozen by an ".. textStr ..". Take care when following instructions.", targetPlayer)
					outputChatBox(" You have frozen " ..targetPlayerName.. ".", thePlayer)
				end

				local username = getPlayerName(thePlayer)
				exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. username .. " froze " .. targetPlayerName .. ".")
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "FREEZE")
			end
		end
	end
end
addCommandHandler("freeze", freezePlayer, false, false)
addEvent("remoteFreezePlayer", true )
addEventHandler("remoteFreezePlayer", getRootElement(), freezePlayer)

-----------------------------------[UNFREEZE]----------------------------------
function unfreezePlayer(thePlayer, commandName, target)
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " /unfreeze [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				local textStr = "admin"
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)

				local veh = getPedOccupiedVehicle( targetPlayer )
				if (veh) then
					setElementFrozen(veh, false)
					toggleAllControls(targetPlayer, true, true, true)
					triggerClientEvent(targetPlayer, "onClientPlayerWeaponCheck", targetPlayer)
					if (isElement(targetPlayer)) then
						outputChatBox(" You have been unfrozen by an ".. textStr ..". Thanks for your co-operation.", targetPlayer)
					end

					if (isElement(thePlayer)) then
						outputChatBox(" You have unfrozen " ..targetPlayerName.. ".", thePlayer)
					end
				else
					toggleAllControls(targetPlayer, true, true, true)
					setElementFrozen(targetPlayer, false)
					-- Disable weapon scrolling if restrained
					if getElementData(targetPlayer, "restrain") == 1 then
						setPedWeaponSlot(targetPlayer, 0)
						toggleControl(targetPlayer, "next_weapon", false)
						toggleControl(targetPlayer, "previous_weapon", false)
					end
					setElementData(targetPlayer, "freeze", false, false)
					outputChatBox(" You have been unfrozen by an ".. textStr ..". Thanks for your co-operation.", targetPlayer)
					outputChatBox(" You have unfrozen " ..targetPlayerName.. ".", thePlayer)
				end

				local username = getPlayerName(thePlayer)
				exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. username .. " unfroze " .. targetPlayerName .. ".")
				exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNFREEZE")
			end
		end
	end
end
addCommandHandler("unfreeze", unfreezePlayer, false, false)

function adminDuty(thePlayer, commandName)
	if exports.integration:isPlayerTrialAdmin(thePlayer) then
		local adminduty = getElementData(thePlayer, "duty_admin")
		local username = getPlayerName(thePlayer)

		if adminduty == 0 then
			setElementData(thePlayer, "duty_admin", 1)
			exports.global:sendMessageToAdmins("AdmDuty: " .. username .. " came on duty.")
			outputChatBox("(( Başarıyla göreve başladınız. ))", thePlayer, 255, 0, 0)
			exports.global:updateNametagColor(thePlayer)
		else
			setElementData(thePlayer, "duty_admin", 0)
			exports.global:updateNametagColor(thePlayer)
			exports.global:sendMessageToAdmins("AdmDuty: " .. username .. " went off duty.")
			outputChatBox("(( Başarıyla görevden ayrıldınız. ))", thePlayer, 255, 0, 0)
			if getElementData(thePlayer, "supervising") == true then
				setElementData(thePlayer, "supervising", false)
				setElementData(thePlayer, "supervisorBchat", false)
				setElementAlpha(thePlayer, 255)
			end
		end
	end
end
addCommandHandler("adminduty", adminDuty, false, false)
addCommandHandler("aduty", adminDuty, false, false)
addEvent("admin-system:adminduty", true)
addEventHandler("admin-system:adminduty", getRootElement(), adminDuty)


function gmDuty(thePlayer, commandName)
	if exports.integration:isPlayerSupporter(thePlayer) or exports.integration:isPlayerHeadAdmin(thePlayer) then

		local gmDuty = getElementData(thePlayer, "duty_supporter") or 0
		local username = getPlayerName(thePlayer)
		

		if gmDuty == 0 then
			setElementData(thePlayer, "duty_supporter", 1)
			exports.global:sendMessageToAdmins("SDuty: " .. username .. " came on duty.")
		elseif gmDuty == 1 then
			setElementData(thePlayer, "duty_supporter", 0)
			exports.global:sendMessageToAdmins("SDuty: " .. username .. " went off duty.")
		end
	end
end
addCommandHandler("sduty", gmDuty, false, false)
addCommandHandler("gduty", gmDuty, false, false)
addEvent("admin-system:gmduty", true)
addEventHandler("admin-system:gmduty", getRootElement(), gmDuty)

-- GET PLAYER ID
function getPlayerID(thePlayer, commandName, target)
	if not (target) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
	else
		local username = getPlayerName(thePlayer)
		local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)

		if targetPlayer then
			local logged = getElementData(targetPlayer, "loggedin")
			if (logged==1) then
				local id = getElementData(targetPlayer, "playerid")
				outputChatBox("** " .. targetPlayerName .. "'s ID is " .. id .. ".", thePlayer, 255, 194, 14)
			else
				outputChatBox(exports.pool:getServerSyntax(false, "e").."Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("getid", getPlayerID, false, false)
addCommandHandler("id", getPlayerID, false, false)

--[[ EJECT
function ejectPlayer(thePlayer, commandName, target)
	if not target then
		if isPedInVehicle(thePlayer) then
			outputChatBox("You have thrown yourself out of your vehicle.", thePlayer, 0, 255, 0)
			removePedFromVehicle(thePlayer)
			setElementData(targetPlayer, "realinvehicle", 0, false)
			local x, y, z = getElementPosition(thePlayer)
			setElementPosition(thePlayer, x, y, z+3)
		else
			outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
		end
	else
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle or exports.integration:isPlayerTrialAdmin(thePlayer) then
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)
			local targetVehicle = getPedOccupiedVehicle(targetPlayer)
			if targetVehicle and (targetVehicle == theVehicle or exports.integration:isPlayerTrialAdmin(thePlayer)) then
				outputChatBox("This player is not in your vehicle.", thePlayer, 255, 0, 0)
			else
				outputChatBox("You have thrown " .. targetPlayerName .. " out of your vehicle.", thePlayer, 0, 255, 0)
				removePedFromVehicle(targetPlayer)
				setElementData(targetPlayer, "realinvehicle", 0, false)
				local x, y, z = getElementPosition(targetPlayer)
				setElementPosition(targetPlayer, x, y, z+2)
			end
		else
			outputChatBox("You are not in a vehicle", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("eject", ejectPlayer, false, false) ]]--

--Temporary eject (Chuevo, 09/04/13)
function ejectPlayer(thePlayer, commandName, target)
	if not (target) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
	else
		if not (isPedInVehicle(thePlayer)) then
			outputChatBox("You are not in a vehicle.", thePlayer, 255, 0, 0)
		else
			local vehicle = getPedOccupiedVehicle(thePlayer)
			local seat = getPedOccupiedVehicleSeat(thePlayer)

			if (seat~=0) then
				outputChatBox("You must be the driver to eject.", thePlayer, 255, 0, 0)
			else
				local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, target)

				if not (targetPlayer) then
				elseif (targetPlayer==thePlayer) then
					outputChatBox("You cannot eject yourself.", thePlayer, 255, 0, 0)
				else
					local targetvehicle = getPedOccupiedVehicle(targetPlayer)

					if targetvehicle~=vehicle and not exports.integration:isPlayerTrialAdmin(thePlayer) then
						outputChatBox("This player is not in your vehicle.", thePlayer, 255, 0, 0)
					else
						outputChatBox("You have thrown " .. targetPlayerName .. " out of your vehicle.", thePlayer, 0, 255, 0)
						removePedFromVehicle(targetPlayer)
						setElementData(targetPlayer, "realinvehicle", 0, false)
						triggerEvent("removeTintName", targetPlayer)
					end
				end
			end
		end
	end
end
addCommandHandler("eject", ejectPlayer, false, false)

function vehicleLimit(admin, command, player, limit)
	if exports.integration:isPlayerSeniorAdmin(admin) then
		if (not player and not limit) then
			outputChatBox("SYNTAX: /" .. command .. " [Player] [Limit]", admin, 255, 194, 14)
		else
			local tplayer, targetPlayerName = exports.global:findPlayerByPartialNick(admin, player)
			if (tplayer) then
				
					local oldvl = tplayer:getData("maxvehicles")
					local newl = tonumber(limit)
					if (newl) then
						if (newl>0) then
							dbExec(mysql:getConnection(), "UPDATE characters SET maxvehicles = " .. (newl) .. " WHERE id = " .. (getElementData(tplayer, "dbid")))

							setElementData(tplayer, "maxvehicles", newl, false)

							outputChatBox("You have set " .. targetPlayerName:gsub("_", " ") .. " vehicle limit to " .. newl .. ".", admin, 255, 194, 14)
							outputChatBox("Admin " .. getPlayerName(admin):gsub("_"," ") .. " has set your vehicle limit to " .. newl .. ".", tplayer, 255, 194, 14)

							exports.logs:dbLog(thePlayer, 4, tplayer, "SETVEHLIMIT "..oldvl.." "..newl)
						else
							outputChatBox("You can not set a level below 0", admin, 255, 194, 14)
						end
					end
				
			else
				outputChatBox("Something went wrong with picking the player.", admin)
			end
		end
	end
end
addCommandHandler("setvehlimit", vehicleLimit)


function intLimit(admin, command, player, limit)
	if exports.integration:isPlayerSeniorAdmin(admin) then
		if (not player and not limit) then
			outputChatBox("SYNTAX: /" .. command .. " [Player] [Limit]", admin, 255, 194, 14)
		else
			local tplayer, targetPlayerName = exports.global:findPlayerByPartialNick(admin, player)
			if (tplayer) then
				
					local oldvl = tplayer:getData("maxinteriors") or 0
					local newl = tonumber(limit)
					if (newl) then
						if (newl>0) then
							dbExec(mysql:getConnection(), "UPDATE `characters` SET `maxinteriors` = " .. (newl) .. " WHERE `id` = " .. (getElementData(tplayer, "dbid")))

							setElementData(tplayer, "maxinteriors", newl, false)

							outputChatBox("You have set " .. targetPlayerName:gsub("_", " ") .. " interior limit to " .. newl .. ".", admin, 255, 194, 14)
							outputChatBox("Admin " .. getPlayerName(admin):gsub("_"," ") .. " has set your interior limit to " .. newl .. ".", tplayer, 255, 194, 14)

							exports.logs:dbLog(thePlayer, 4, tplayer, "SETINTLIMIT "..oldvl.." "..newl)
						else
							outputChatBox("You can not set a level below 0", admin, 255, 194, 14)
						end
					end
				
			else
				outputChatBox("Something went wrong with picking the player.", admin)
			end
		end
	end
end
addCommandHandler("setintlimit", intLimit)

-- /NUDGE by Bean
function nudgePlayer(thePlayer, commandName, targetPlayer)
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if not targetPlayer then
				return false
			end
			local logged = getElementData(targetPlayer, "loggedin")
			if (logged==0) then
			   outputChatBox(exports.pool:getServerSyntax(false, "e").."Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
			else
				triggerClientEvent ( "playNudgeSound", targetPlayer)
				outputChatBox("You have nudged " .. targetPlayerName .. ".", thePlayer)
				outputChatBox("You have been nudged by " .. getPlayerName(thePlayer) .. ".", targetPlayer)
			end
		end
	end
end
addCommandHandler("nudge", nudgePlayer, false, false)

-- /EARTHQUAKE BY ANTHONY
function earthquake(thePlayer, commandName)
	if exports.integration:isPlayerSeniorAdmin(thePlayer) then
		local players = exports.pool:getPoolElementsByType("player")
		for index, arrayPlayer in ipairs(players) do
			triggerClientEvent("doEarthquake", arrayPlayer)
			outputChatBox(exports.pool:getServerSyntax(false, "s").."Şu anda deprem yaşıyorsun.", arrayPlayer, 255, 255, 255, true)
		end
	end
end
addCommandHandler("earthquake", earthquake, false, false)

--/SETAGE
function asetPlayerAge(thePlayer, commandName, targetPlayer, age)
   if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
      if not (age) or not (targetPlayer) then
         outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Age]", thePlayer, 255, 194, 14)
      else
         local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
         local dbid = getElementData(targetPlayer, "dbid")
         local ageint = tonumber(age)
         if (ageint>150) or (ageint<1) then
            outputChatBox("You cannot set the age to that.", thePlayer, 255, 0, 0)
         else
            dbExec(mysql:getConnection(), "UPDATE characters SET age='" .. (age) .. "' WHERE id = " .. (dbid))
			setElementData(targetPlayer, "age", tonumber(age), true)
            outputChatBox("You changed " .. targetPlayerName .. "'s age to " .. age .. ".", thePlayer, 0, 255, 0)
            outputChatBox("Your age was set to " .. age .. ".", targetPlayer, 0, 255, 0)
			exports.logs:dbLog(thePlayer, 4, targetPlayer, commandName.." "..age)
         end
      end
   end
end
addCommandHandler("setage", asetPlayerAge)

--/SETHEIGHT
function asetPlayerHeight(thePlayer, commandName, targetPlayer, height)
   if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
      if not (height) or not (targetPlayer) then
         outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Height (150 - 200)]", thePlayer, 255, 194, 14)
      else
         local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
         local dbid = getElementData(targetPlayer, "dbid")
         local heightint = tonumber(height)
         if (heightint>200) or (heightint<150) then
            outputChatBox("You cannot set the height to that.", thePlayer, 255, 0, 0)
         else
            dbExec(mysql:getConnection(), "UPDATE characters SET height='" .. (height) .. "' WHERE id = " .. (dbid))
			setElementData(targetPlayer, "height", height, true)
            outputChatBox("You changed " .. targetPlayerName .. "'s height to " .. height .. " cm.", thePlayer, 0, 255, 0)
            outputChatBox("Your height was set to " .. height .. " cm.", targetPlayer, 0, 255, 0)
			exports.logs:dbLog(thePlayer, 4, targetPlayer, commandName.." "..height)
         end
      end
   end
end
addCommandHandler("setheight", asetPlayerHeight)

--/SETRACE
function asetPlayerRace(thePlayer, commandName, targetPlayer, race)
   if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
      if not (race) or not (targetPlayer) then
         outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [0= Black, 1= White, 2= Asian]", thePlayer, 255, 194, 14)
      else
         local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
         local dbid = getElementData(targetPlayer, "dbid")
         local raceint = tonumber(race)
         if (raceint>2) or (raceint<0) then
            outputChatBox("Error: Please chose either 0 for black, 1 for white, or 2 for asian.", thePlayer, 255, 0, 0)
         else
         dbExec(mysql:getConnection(), "UPDATE characters SET skincolor='" .. (race) .. "' WHERE id = " .. (dbid))
			if (raceint==0) then
			    outputChatBox("You changed " .. targetPlayerName .. "'s race to black.", thePlayer, 0, 255, 0)
			    outputChatBox("Your race was changed to black.", targetPlayer, 0, 255, 0)
				outputChatBox("Please F10 for changes to take effect.", targetPlayer, 255, 194, 14)
			elseif (raceint==1) then
				outputChatBox("You changed " .. targetPlayerName .. "'s race to white.", thePlayer, 0, 255, 0)
			    outputChatBox("Your race was changed to white.", targetPlayer, 0, 255, 0)
				outputChatBox("Please F10 for changes to take effect.", targetPlayer, 255, 194, 14)
			elseif (raceint==2) then
				outputChatBox("You changed " .. targetPlayerName .. "'s race to asian.", thePlayer, 0, 255, 0)
			    outputChatBox("Your race was changed to asian.", targetPlayer, 0, 255, 0)
				outputChatBox("Please F10 for changes to take effect.", targetPlayer, 255, 194, 14)
			end
			exports.logs:dbLog(thePlayer, 4, targetPlayer, commandName.." "..raceint)
         end
      end
   end
end
addCommandHandler("setrace", asetPlayerRace)

--/SETGENDER
function asetPlayerGender(thePlayer, commandName, targetPlayer, gender)
   if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
      if not (gender) or not (targetPlayer) then
         outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [0= Male, 1= Female]", thePlayer, 255, 194, 14)
      else
         local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
         local dbid = getElementData(targetPlayer, "dbid")
         local genderint = tonumber(gender)
         if (genderint>1) or (genderint<0) then
            outputChatBox("Error: Please choose either 0 for male, or 1 for female.", thePlayer, 255, 0, 0)
         else
         dbExec(mysql:getConnection(), "UPDATE characters SET gender='" .. (gender) .. "' WHERE id = " .. (dbid))
		 setElementData(targetPlayer, "gender", gender, true)
			if (genderint==0) then
			    outputChatBox("You changed " .. targetPlayerName .. "'s gender to Male.", thePlayer, 0, 255, 0)
			    outputChatBox("Your gender was set to Male.", targetPlayer, 0, 255, 0)
				outputChatBox("Please F10 for changes to take effect.", targetPlayer, 255, 194, 14)
			elseif (genderint==1) then
				outputChatBox("You changed " .. targetPlayerName .. "'s gender to Female.", thePlayer, 0, 255, 0)
			    outputChatBox("Your gender was set to Female.", targetPlayer, 0, 255, 0)
				outputChatBox("Please F10 for changes to take effect.", targetPlayer, 255, 194, 14)
			end
			exports.logs:dbLog(thePlayer, 4, targetPlayer, commandName.." "..genderint)
         end
      end
   end
end
addCommandHandler("setgender", asetPlayerGender)

 --/SET DATE O FBITH
function aSetDateOfBirth(thePlayer, commandName, targetPlayer, dob, mob)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
		if not (targetPlayer) or not dob or not mob then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Date] [Month]", thePlayer, 255, 194, 14)
		else
			if getElementData(targetPlayer, "loggedin") ~= 1 then
				outputChatBox(exports.pool:getServerSyntax(false, "e").."Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
				return false
			end

			if not tonumber(dob) or not tonumber(mob) then
				outputChatBox("Date and Month of birth must be numeric.", thePlayer, 255, 194, 14)
				return false
			else
				dob = tonumber(dob)
				mob = tonumber(mob)
			end

			local dbid = getElementData(targetPlayer, "dbid")
			if dbExec(mysql:getConnection(), "UPDATE `characters` SET `day`='" .. (dob) .. "', `month`='" .. (mob) .. "' WHERE id = '" .. (dbid).."' " ) then
				setElementData(targetPlayer, "day", dob, true)
				setElementData(targetPlayer, "month", mob, true)
				outputDebugString(dob.." "..mob)
				outputChatBox("You changed " .. targetPlayerName .. "'s date of birth to " .. exports.global:getPlayerDoB(targetPlayer) .. ".", thePlayer, 0, 255, 0)
				outputChatBox("Your date of birth was set to " .. exports.global:getPlayerDoB(targetPlayer) .. ".", targetPlayer, 0, 255, 0)
				exports.logs:dbLog(thePlayer, 4, targetPlayer, commandName.." "..dob.."/"..mob)
			else
				outputChatBox("Failed to set DoB, DB error.", thePlayer, 0, 255, 0)
			end
		end
	end
end
addCommandHandler("setdob", aSetDateOfBirth)
addCommandHandler("setdateofbirth", aSetDateOfBirth)

function unRecovery(thePlayer, commandName, targetPlayer)
	local theTeam = getPlayerTeam(thePlayer)
	local factionType = getElementData(theTeam, "type")
	if exports.integration:isPlayerTrialAdmin(thePlayer) or (factionType==4) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			local dbid = getElementData(targetPlayer, "dbid")
			setElementFrozen(targetPlayer, false)
			dbExec(mysql:getConnection(), "UPDATE characters SET recovery='0' WHERE id = " .. dbid) -- Allow them to move, and revert back to recovery type set to 0.
			dbExec(mysql:getConnection(), "UPDATE characters SET recoverytime=NULL WHERE id = " .. dbid)
			exports.global:sendMessageToAdmins("AdmWrn: " .. getPlayerName(targetPlayer):gsub("_"," ") .. " was removed from recovery by " .. getPlayerName(thePlayer):gsub("_"," ") .. ".")
			outputChatBox("You are no longer in recovery!", targetPlayer, 0, 255, 0) -- Let them know about it!
			exports.logs:dbLog(thePlayer, 4, targetPlayer, "UNRECOVERY")
		end
	end
end
addCommandHandler("unrecovery", unRecovery)

function checkSkin ( thePlayer, commandName)
	outputChatBox ( "Your skin ID is: " .. getPedSkin ( thePlayer ), thePlayer)
end
addCommandHandler ( "checkskin", checkSkin )

function setPlayerInterior(thePlayer, commandName, targetPlayer, interiorID)
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer)) then
		local interiorID = tonumber(interiorID)
		if (not targetPlayer) or (not interiorID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Interior ID]", thePlayer, 255, 194, 14, false)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged == 0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0, false)
				else
					if (interiorID >= 0 and interiorID <= 255) then
						local username = getPlayerName(thePlayer)
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						setElementInterior(targetPlayer, interiorID)
						outputChatBox((hiddenAdmin == 0 and adminTitle .. " " .. username or "Hidden Admin") .. " has changed your interior ID to " .. tostring(interiorID) .. ".", targetPlayer)
						outputChatBox("You set " .. targetPlayerName .. (string.find(targetPlayerName, "s", -1) and "'" or "'s") .. " interior ID to " .. tostring(interiorID) .. ".", thePlayer)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "PLAYER-SETINTERIOR " .. tostring(interiorID))
					else
						outputChatBox("Invalid interior ID (0-255).", thePlayer, 255, 0, 0, false)
					end
				end
			end
		end
	end
end
addCommandHandler("setint", setPlayerInterior, false, false)
addCommandHandler("setinterior", setPlayerInterior, false, false)

--/SETDIMENSION, /SETDIM
function setPlayerDimension(thePlayer, commandName, targetPlayer, dimensionID)
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer)) then
		local dimensionID = tonumber(dimensionID)
		if (not targetPlayer) or (not dimensionID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Dimension ID]", thePlayer, 255, 194, 14, false)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged == 0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0, false)
				else
					if (dimensionID >= 0 and dimensionID <= 65535) then
						local username = getPlayerName(thePlayer)
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
						setElementDimension(targetPlayer, dimensionID)
						outputChatBox((hiddenAdmin == 0 and adminTitle .. " " .. username or "Hidden Admin") .. " has changed your dimension ID to " .. tostring(dimensionID) .. ".", targetPlayer)
						outputChatBox("You set " .. targetPlayerName .. (string.find(targetPlayerName, "s", -1) and "'" or "'s") .. " dimension ID to " .. tostring(dimensionID) .. ".", thePlayer)
						exports.logs:dbLog(thePlayer, 4, targetPlayer, "PLAYER-SETDIMENSION " .. tostring(dimensionID))
					else
						outputChatBox("Invalid dimension ID (0-65535).", thePlayer, 255, 0, 0, false)
					end
				end
			end
		end
	end
end
addCommandHandler("setdim", setPlayerDimension, false, false)
addCommandHandler("setdimension", setPlayerDimension, false, false)

local syntaxTable = {
	["s"] = "#00a8ff[LUCY RPG]#ffffff ",
	["e"] = "#e84118[LUCY RPG]#ffffff ",
	["w"] = "#fbc531[LUCY RPG]#ffffff ",
}

addCommandHandler("paradagit",
	function(player, cmd, amount)
		if exports["integration"]:isPlayerHeadAdmin(player) then
			if amount and tonumber(amount) then
				outputChatBox(syntaxTable["w"].."Para dağıtma işlemi başlatıldı.", player, 255, 255, 255, true)
				for index, value in ipairs(getElementsByType("player")) do
					if getElementData(value, "loggedin") == 1 then
						exports["global"]:giveMoney(value, amount)
						outputChatBox(syntaxTable["s"].."Etkinlik parası olarak başarıyla "..exports["global"]:formatMoney(amount).."$ kazandınız!", value, 255, 255, 255, true)
					end
				end
			end
		end
	end
)

addCommandHandler("paraal",
	function(player, cmd, amount)
		if exports["integration"]:isPlayerHeadAdmin(player) then
			if amount and tonumber(amount) then
				outputChatBox(syntaxTable["w"].."Para alma işlemi başlatıldı.", player, 255, 255, 255, true)
				for index, value in ipairs(getElementsByType("player")) do
					if getElementData(value, "loggedin") == 1 then
						exports["global"]:takeMoney(value, amount)
					--	outputChatBox(syntaxTable["s"].."Etkinlik parası olarak başarıyla "..exports["global"]:formatMoney(amount).."$ kazandınız!", value, 255, 255, 255, true)
					end
				end
			end
		end
	end
)

local quitingPlayers = {}

addEvent("quitingPlayer:addRow", true)
addEventHandler("quitingPlayer:addRow", root,
	function(table)
		--table.insert(quitingPlayers, table)
		quitingPlayers[#quitingPlayers + 1] = table
		--triggerClientEvent(root, "quitingPlayer:updateTable", root, quitingPlayers)
	end
)

addEvent("quitingPlayer:receiveTable", true)
addEventHandler("quitingPlayer:receiveTable", root,
	function(player)
		triggerClientEvent(player, "quitingPlayer:updateTable", player, quitingPlayers, true)
	end
)

function getPosition(thePlayer, commandName)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) or (exports.integration:isPlayerScripter(thePlayer)) then
		local x, y, z = getElementPosition(thePlayer)
		local rx, ry, rz = getElementRotation(thePlayer)
		local dimension = getElementDimension(thePlayer)
		local interior = getElementInterior(thePlayer)
		
		outputChatBox("Position: " .. x .. ", " .. y .. ", " .. z, thePlayer, 255, 194, 14)
		outputChatBox("Rotation: " .. rx .. ", " .. ry .. ", " .. rz, thePlayer, 255, 194, 14)
		outputChatBox("Dimension: " .. dimension, thePlayer, 255, 194, 14)
		outputChatBox("Interior: " .. interior, thePlayer, 255, 194, 14)
		local prepairedText = x..", "..y..", "..z
		outputChatBox("'"..prepairedText.."' - panoya kopyalandı.", thePlayer, 200, 200, 200)
		triggerClientEvent(thePlayer, "copyPosToClipboard", thePlayer, prepairedText)
	end
end
addCommandHandler("getpos", getPosition, false, false)

-- /X, /Y, /Z and /XYZ
function setX(thePlayer, commandName, ix)
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer)) then
		if not (ix) or not tonumber(ix) then
			outputChatBox("SYNTAX: /" .. commandName .. " [X Value]", thePlayer, 255, 194, 14)
		else
			if (isPedInVehicle(thePlayer)) then
				local x, y, z = getElementPosition(thePlayer)
				local veh = getPedOccupiedVehicle(thePlayer)
				setElementPosition(veh, x+ix, y, z)
			else
				local x, y, z = getElementPosition(thePlayer)
				setElementPosition(thePlayer, x+ix, y, z)
			end
		end
	end
end
addCommandHandler("x", setX)

function setY(thePlayer, commandName, iy)
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer)) then
		if not (iy) or not tonumber(iy) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Y Value]", thePlayer, 255, 194, 14)
		else
			if (isPedInVehicle(thePlayer)) then
				local x, y, z = getElementPosition(thePlayer)
				local veh = getPedOccupiedVehicle(thePlayer)
				setElementPosition(veh, x, y+iy, z)
			else
				local x, y, z = getElementPosition(thePlayer)
				setElementPosition(thePlayer, x, y+iy, z)
			end
		end
	end
end
addCommandHandler("y", setY, false, false)

function setZ(thePlayer, commandName, iz)
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer)) then
		if not (iz) or not tonumber(iz) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Z Value]", thePlayer, 255, 194, 14)
		else
			if (isPedInVehicle(thePlayer)) then
				local x, y, z = getElementPosition(thePlayer)
				local veh = getPedOccupiedVehicle(thePlayer)
				setElementPosition(veh, x, y, z+iz)
			else
				local x, y, z = getElementPosition(thePlayer)
				setElementPosition(thePlayer, x, y, z+iz)
			end
		end
	end
end
addCommandHandler("z", setZ, false, false)

function setXYZ(thePlayer, commandName, ix, iy, iz)
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer)) then
		if not (ix) or not (iy) or not (iz) or not tonumber(ix) or not tonumber(iy) or not tonumber(iz) then
			outputChatBox("SYNTAX: /" .. commandName .. " [X Value][Y Value] [Z Value]", thePlayer, 255, 194, 14)
		else
			if (isPedInVehicle(thePlayer)) then
				local x, y, z = getElementPosition(thePlayer)
				local veh = getPedOccupiedVehicle(thePlayer)
				setElementPosition(veh, x+ix, y+iy, z+iz)
			else
				local x, y, z = getElementPosition(thePlayer)
				setElementPosition(thePlayer, x+ix, y+iy, z+iz)
			end
		end
	end
end
addCommandHandler("xyz", setXYZ, false, false)

function scriptWave ( thePlayer, command, height )
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer)) then
		local oldHeight = getWaveHeight()
		height = tonumber ( height )
		success = setWaveHeight ( height )
		if ( success ) then
			outputChatBox ( "The old wave height was: " .. oldHeight .. "; " .. getPlayerName ( thePlayer ) .. " set it to: " .. height, thePlayer)
		else
			outputChatBox ( "Invalid number.", thePlayer )
		end
	end
end
addCommandHandler ( "setwave", scriptWave )

function ehliyet(thePlayer, commandName, targetPlayer)
	if not (targetPlayer) then
				outputChatBox("Kullanım: /" .. commandName .. " [User/ID] ", thePlayer, 255, 194, 14)
			else
				local username = getPlayerName(thePlayer)
				local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
	local carlicense = getElementData(thePlayer, "license.car")
	local bikelicense = getElementData(thePlayer, "license.bike")
	local boatlicense = getElementData(thePlayer, "license.boat")
     local meslek = getElementData(thePlayer,"job")
	 if (carlicense==1) then
		carlicense = "#66CCFF[Var]"
	elseif (carlicense==3) then
		carlicense = "#66CCFF[Teori testi geçti]"
	else
		carlicense = "#66CCFF[Yok]"
	end
	if (bikelicense==1) then
		bikelicense = "#66CCFF[Var]"
	elseif (bikelicense==3) then
		bikelicense = "#66CCFF[Teori testi geçti]"
	else
		bikelicense = "#66CCFF[Yok]"
	end
	if (boatlicense==1) then
		boatlicense = "#66CCFF[Var]"
	else
		boatlicense = "#66CCFF[Yok]"
	end
				if targetPlayer then
					if targetPlayer == thePlayer then
						outputChatBox("#A9C4E4 Sunucu:#b9c9bf Bu eylemi kendinize uygulayamazsınız!", thePlayer, 155, 0, 0, true)
						return
					end
					
					if not getElementData(thePlayer, "ehliyet") == true then
						local x, y, z = getElementPosition(thePlayer)
						local tx, ty, tz = getElementPosition(targetPlayer)
						local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
						local theVehicle = getPedOccupiedVehicle(thePlayer)
						local theVehicleT = getPedOccupiedVehicle(targetPlayer)
						
							if distance < 3 then
							    outputChatBox("#A9C4E4 Sunucu: #b9c9bf  "..getPlayerName(thePlayer):gsub(" ", " ").." isimli kişi size ehliyet durumunu gösterdi.", targetPlayer, 155, 0, 0, true)							
								outputChatBox("[!]#ffffff Araba ehliyeti:".. carlicense .." #ffffff- Motorsiklet ehliyeti:".. bikelicense .."#ffffff - Bot lisansı:".. boatlicense .."#ffffff.",targetPlayer, 255, 255, 0, true)
	                            outputChatBox("#A9C4E4 Sunucu: #b9c9bf "..getPlayerName(targetPlayer):gsub(" ", " ").." isimli kişiye ehliyetinizi gösterdiniz.", thePlayer, 155, 0, 0, true)
							else
								outputChatBox("#A9C4E4 Sunucu:#b9c9bfBir kişiye kimliğini gostermek için yanında olmalısın.", thePlayer, 155, 0, 0, true)
							end
					end
				end
			end
end
addCommandHandler("ehliyetgoster", ehliyet)

function kimlik(thePlayer, commandName, targetPlayer)
	if not (targetPlayer) then
				outputChatBox("Kullanım: /" .. commandName .. " [User/ID] ", thePlayer, 255, 194, 14)
			else
				local username = getPlayerName(thePlayer)
				local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
				local cinsiyet = getElementData(thePlayer, "gender")
				local gun = getElementData(thePlayer, "day")
				local ay = getElementData(thePlayer, "month")
				local yas = getElementData(thePlayer, "age")
				if (ay==1) then
				ay = "Ocak"
				elseif (ay==2) then
				ay = "Subat"
				elseif (ay==3) then
				ay = "Mart"
				elseif (ay==4) then
				ay = "Nisan"
				elseif (ay==5) then
				ay = "Mayıs"
				elseif (ay==6) then
				ay = "Haziran"
				end

				if targetPlayer then
					if targetPlayer == thePlayer then
						outputChatBox("#A9C4E4 Sunucu: #b9c9bfBu eylemi kendinize uygulayamazsınız!", thePlayer, 155, 0, 0, true)
						return
					end
					
					if not getElementData(thePlayer, "kimlik") == true then
						local x, y, z = getElementPosition(thePlayer)
						local tx, ty, tz = getElementPosition(targetPlayer)
						local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
						local theVehicle = getPedOccupiedVehicle(thePlayer)
						local theVehicleT = getPedOccupiedVehicle(targetPlayer)
						
							if distance < 3 then
	exports.hud:sendBottomNotification(targetPlayer, "Aşağıdakiler '"..username.."' isimli kişinin kimlik bilgileridir.", "Adı ve Soyadı "..getPlayerName(thePlayer):gsub("_", " ").." | Cinsiyeti: "..cinsiyet.." (0 = Erkek, 1 = Kadın) | Dogum tarihi: Gün= "..gun.." Ay= "..ay.." Yaş= "..yas)
	outputChatBox("#A9C4E4 Sunucu: #b9c9bf #00FF00"..getPlayerName(targetPlayer):gsub(" ", " ").."#b9c9bf isimli kişiye kimliğinizi gösterdiniz.", thePlayer, 155, 0, 0, true)
	outputChatBox("#A9C4E4 Sunucu: #b9c9bf #00FF00"..getPlayerName(thePlayer):gsub(" ", " ").." #b9c9bf isimli kişi size kimliğini gösterdi.",targetPlayer, 155, 0, 0, true)	
							else
								outputChatBox("#A9C4E4 Sunucu: #b9c9bf Bir kişiye kimliğini gostermek için yanında olmalısın.", thePlayer, 155, 0, 0, true)
							end
					end
				end
			end
end
addCommandHandler("kimlikgoster", kimlik)

addCommandHandler("cban",
	function(player, cmd, id, ...)
		if exports.integration:isPlayerTrialAdmin(player) then
			if not (id) or not (...) then
				outputChatBox("SYNTAX: /" .. cmd .. " [id] [Sebep]", player, 255, 194, 14)
			else
				local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(player, id)
				local reason = table.concat({...}, " ")
				if targetPlayer then
					local time = getRealTime()
					local hours = time.hour
					local minutes = time.minute
					local seconds = time.second
					local charactername = getPlayerName(targetPlayer)
					dbExec(mysql:getConnection(), "UPDATE characters SET cked = ? WHERE id = ?", 1, getElementData(targetPlayer, "dbid"))
					outputChatBox("(( "..charactername:gsub("_", " ").." adlı karakter sunucudan yasaklandı. Sebep: "..reason.." - "..hours..":"..minutes..":"..seconds.." ))", root, 255, 0, 0)
					redirectPlayer(targetPlayer,"",0)
					for key, value in ipairs(exports.global:getAdmins()) do
						local adminduty = getElementData(value, "duty_admin")
						if adminduty == 1 then
							outputChatBox("[CBAN] " .. getPlayerName(player):gsub("_", " ") .. " adlı yetkili "..charactername.." adlı karakteri yasakladı.", value, 255, 0, 0)
						end
					end
				end
			end
		end
	end
)

addCommandHandler("ocban",
	function(player, cmd, id, ...)
		if exports.integration:isPlayerTrialAdmin(player) then
			if not (id) or not (...) then
				outputChatBox("SYNTAX: /" .. cmd .. " [karakter_adı] [Sebep]", player, 255, 194, 14)
			else
			
				local reason = table.concat({...}, " ")
				charactername = id
				local time = getRealTime()
				local hours = time.hour
				local minutes = time.minute
				local seconds = time.second
	
				dbExec(mysql:getConnection(), "UPDATE characters SET cked = ? WHERE id = ?", 1, charactername)
				outputChatBox("(( [OFFLINE] : "..charactername:gsub("_", " ").." adlı karakter sunucudan yasaklandı. Sebep: "..reason.." - "..hours..":"..minutes..":"..seconds.." ))", root, 255, 0, 0)
				
				for key, value in ipairs(exports.global:getAdmins()) do
					local adminduty = getElementData(value, "duty_admin")
					if adminduty == 1 then
						outputChatBox("[OCBAN] " .. getPlayerName(player):gsub("_", " ") .. " adlı yetkili "..charactername.." adlı karakteri yasakladı.", value, 255, 0, 0)
					end
				end
				
			end
		end
	end
)

addCommandHandler("uncban",
	function(player, cmd, id)
		if exports.integration:isPlayerTrialAdmin(player) then
			if not (id) then
				outputChatBox("SYNTAX: /" .. cmd .. " [karakter_adı] [Sebep]", player, 255, 194, 14)
			else
				local charactername = id
				dbExec(mysql:getConnection(), "UPDATE characters SET cked = ? WHERE charactername = ?", 0, id)

				for key, value in ipairs(exports.global:getAdmins()) do
					local adminduty = getElementData(value, "duty_admin")
					if adminduty == 1 then
						outputChatBox("[CBAN] " .. getPlayerName(player):gsub("_", " ") .. " adlı yetkili "..id.." adlı karakterin yasağını açtı.", value, 255, 0, 0)
					end
				end
			end
		end
	end
)

function tryLuck(thePlayer, commandName , pa1, pa2)
	local p1, p2, p3 = nil
	p1 = tonumber(pa1)
	p2 = tonumber(pa2)
	if pa1 == nil and pa2 == nil and pa3 == nil then
		exports.global:sendLocalText(thePlayer, "((OOC Luck)) "..getPlayerName(thePlayer):gsub("_", " ").." tries his luck from 1 to 100 and gets "..math.random(100)..".", 255, 51, 102, 30, {}, true)
	elseif pa1 ~= nil and p1 ~= nil and pa2 == nil then
		exports.global:sendLocalText(thePlayer, "((OOC Luck)) "..getPlayerName(thePlayer):gsub("_", " ").." tries his luck from 1 to "..p1.." and gets "..math.random(p1)..".", 255, 51, 102, 30, {}, true)
	else
		outputChatBox("SYNTAX: /" .. commandName.."                  - Get a random number from 1 to 100", thePlayer, 255, 194, 14)
		outputChatBox("SYNTAX: /" .. commandName.." [max]         - Get a random number from 1 to [max]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("luck", tryLuck)

function tryChance(thePlayer, commandName , pa1, pa2)
	local p1, p2, p3 = nil
	p1 = tonumber(pa1)
	p2 = tonumber(pa2)
	if pa1 ~= nil then 
		if pa2 == nil and p1 ~= nil then
			if p1 <= 100 and p1 >=0 then
				if math.random(100) >= p1 then
					exports.global:sendLocalText(thePlayer, "((OOC Chance at "..p1.."%)) "..getPlayerName(thePlayer):gsub("_", " ").."'s attempt has failed.", 255, 51, 102, 30, {}, true)
				else
					exports.global:sendLocalText(thePlayer, "((OOC Chance at "..p1.."%)) "..getPlayerName(thePlayer):gsub("_", " ").."'s attempt has succeeded.", 255, 51, 102, 30, {}, true)
				end
			else
				outputChatBox("Probability must range from 0 to 100%.", thePlayer, 255, 0, 0, true)
			end
		else
			outputChatBox("SYNTAX: /" .. commandName.." [0-100%]                 - Chance you will succeed at probability of [0-100%]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("SYNTAX: /" .. commandName.." [0-100%]                 - Chance you will succeed at probability of [0-100%]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("chance", tryChance)

function oocCoin(thePlayer)
	if  math.random( 1, 2 ) == 2 then
		exports.global:sendLocalText(thePlayer, " ((OOC Coin)) " .. getPlayerName(thePlayer):gsub("_", " ") .. " flips an coin, landing on tail.", 255, 51, 102)
	else
		exports.global:sendLocalText(thePlayer, " ((OOC Coin)) " .. getPlayerName(thePlayer):gsub("_", " ") .. " flips an coin, landing on head.", 255, 51, 102)
	end
end
addCommandHandler("flipcoin", oocCoin)