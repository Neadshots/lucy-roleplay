function adminSetPlayerFaction(thePlayer, commandName, partialNick, factionID)
	if exports.integration:isPlayerTrialAdmin(thePlayer) then
		factionID = tonumber(factionID)
		if not (partialNick) or not (factionID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Name/ID] [Faction ID (-1 for none)]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, partialNick)
			
			if targetPlayer then
				local theTeam = exports.pool:getElement("team", factionID)
				if not theTeam and factionID ~= -1 then
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
					return
				end
				
				if dbExec(mysql:getConnection(),"UPDATE characters SET faction_leader = 0, faction_id = " .. factionID .. ", faction_rank = 1, faction_phone = NULL, duty = 0 WHERE id=" .. getElementData(targetPlayer, "dbid")) then
					setPlayerTeam(targetPlayer, theTeam)
					if factionID > 0 then
						setElementData(targetPlayer, "faction", factionID, true)
						setElementData(targetPlayer, "factionrank", 1, true)
						setElementData(targetPlayer, "factionphone", nil, true)
						--triggerClientEvent(targetPlayer, "updateFactionInfo", targetPlayer, factionID, 1)
						setElementData(targetPlayer, "factionleader", 0, true)
						triggerEvent("duty:offduty", targetPlayer)
						
						outputChatBox("Player " .. targetPlayerNick .. " is now a member of faction '" .. getTeamName(theTeam) .. "' (#" .. factionID .. ").", thePlayer, 0, 255, 0)
						
						triggerEvent("onPlayerJoinFaction", targetPlayer, theTeam)
						outputChatBox("You were set to Faction '" .. getTeamName(theTeam) .. "'.", targetPlayer, 255, 194, 14)
						
						exports.logs:dbLog(thePlayer, 4, { targetPlayer, theTeam }, "SET TO FACTION")
					else
						-- Citizen bug fix by Anthony
						local citizenTeam = getTeamFromName("Citizen")
						setPlayerTeam(targetPlayer, citizenTeam)
						setElementData(targetPlayer, "faction", -1, true)
						setElementData(targetPlayer, "factionrank", 1, true)
						setElementData(targetPlayer, "factionphone", nil, true)
						setElementData(targetPlayer, "factionleader", 0, true)
						--triggerClientEvent(targetPlayer, "updateFactionInfo", targetPlayer, -1, 1)
						if getElementData(targetPlayer, "duty") and getElementData(targetPlayer, "duty") > 0 then
							takeAllWeapons(targetPlayer)
							setElementData(targetPlayer, "duty", 0, true)
						end
						
						outputChatBox("Player " .. targetPlayerNick .. " was set to no faction.", thePlayer, 0, 255, 0)
						outputChatBox("You were removed from your faction.", targetPlayer, 255, 0, 0)
						
						exports.logs:dbLog(thePlayer, 4, { targetPlayer }, "REMOVE FROM FACTION")
					end
				end
			end
		end
	end
end
addCommandHandler("setfaction", adminSetPlayerFaction, false, false)

function adminSetFactionLeader(thePlayer, commandName, partialNick, factionID)
	if exports.integration:isPlayerAdmin(thePlayer) then
		factionID = tonumber(factionID)
		if not (partialNick) or not (factionID)  then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Name] [Faction ID]", thePlayer, 255, 194, 14)
		elseif factionID > 0 then
			local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, partialNick)
			
			if targetPlayer then
				local theTeam = exports.pool:getElement("team", factionID)
				if not theTeam then
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
					return
				end
				
				if dbExec(mysql:getConnection(),"UPDATE characters SET faction_leader = 1, faction_id = " .. tonumber(factionID) .. ", faction_rank = 1, faction_phone = NULL, duty = 0 WHERE id = " .. getElementData(targetPlayer, "dbid")) then
					setPlayerTeam(targetPlayer, theTeam)
					setElementData(targetPlayer, "faction", factionID, true)
					setElementData(targetPlayer, "factionrank", 1, true)
					setElementData(targetPlayer, "factionleader", 1, true)
					setElementData(targetPlayer, "factionphone", nil, true)
					--triggerClientEvent(targetPlayer, "updateFactionInfo", targetPlayer, factionID, 1)
					triggerEvent("duty:offduty", targetPlayer)
					
					outputChatBox("Player " .. targetPlayerNick .. " is now a leader of faction '" .. getTeamName(theTeam) .. "' (#" .. factionID .. ").", thePlayer, 0, 255, 0)
						
					triggerEvent("onPlayerJoinFaction", targetPlayer, theTeam)
					outputChatBox("You were set to the leader of Faction '" .. getTeamName(theTeam) .. "'.", targetPlayer, 255, 194, 14)
					
					exports.logs:dbLog(thePlayer, 4, { targetPlayer, theTeam }, "SET TO FACTION LEADER")
				else
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("setfactionleader", adminSetFactionLeader, false, false)

function adminSetFactionRank(thePlayer, commandName, partialNick, factionRank)
	if (exports.integration:isPlayerAdmin(thePlayer)) then
		factionRank = math.ceil(tonumber(factionRank) or -1)
		if not (partialNick) or not (factionRank)  then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Name] [Faction Rank, 1-20]", thePlayer, 255, 194, 14)
		elseif factionRank >= 1 and factionRank <= 20 then
			local targetPlayer, targetPlayerNick = exports.global:findPlayerByPartialNick(thePlayer, partialNick)
			
			if targetPlayer then
				local theTeam = getPlayerTeam(targetPlayer)
				if not theTeam or getTeamName( theTeam ) == "Citizen" then
					outputChatBox("Player is not in a faction.", thePlayer, 255, 0, 0)
					return
				end
				
				if dbExec(mysql:getConnection(),"UPDATE characters SET faction_rank = " .. factionRank .. " WHERE id = " .. getElementData(targetPlayer, "dbid")) then
					setElementData(targetPlayer, "factionrank", factionRank, true)
					
					outputChatBox("Player " .. targetPlayerNick .. " is now rank " .. factionRank .. ".", thePlayer, 0, 255, 0)
					outputChatBox("Admin " .. getPlayerName(thePlayer):gsub("_"," ") .. " set you to rank " .. factionRank .. ".", targetPlayer, 0, 255, 0)
					
					exports.logs:dbLog(thePlayer, 4, { targetPlayer, theTeam }, "SET TO FACTION RANK " .. factionRank)
				else
					outputChatBox("Error #125151 - Report on Mantis.", thePlayer, 255, 0, 0)
				end
			end
		else
			outputChatBox( "Invalid Rank - valid ones are 1 to 20", thePlayer, 255, 0, 0 )
		end
	end
end
addCommandHandler("setfactionrank", adminSetFactionRank, false, false)

addEvent("factions:delete", true)
addEventHandler("factions:delete", root,
	function(factionID)
		local theTeam = exports.pool:getElement("team", factionID)
		if (theTeam) then
			dbExec(mysql:getConnection(), "DELETE FROM factions WHERE id='" .. factionID .. "'")
			local civTeam = getTeamFromName("Citizen")
			for key, value in pairs( getPlayersInTeam( theTeam ) ) do
				setPlayerTeam( value, civTeam )
				setElementData( value, "faction", -1, true )
			end
			outputChatBox("Birlik başarıyla silindi!", client, 255, 0, 0)
			destroyElement( theTeam )
		else
			outputChatBox("Invalid Faction ID.", client, 255, 0, 0)
		end
	end
)

addEvent("factions:editFaction", true)
addEventHandler("factions:editFaction", root,
	function(player, data, factionID)
		if factionID and tonumber(factionID) then--edit
			newName, newType = data.name, data.type
			if (newName and newType) then
				local theTeam = exports.pool:getElement("team", factionID)
				if (theTeam) then
					dbExec(mysql:getConnection(), "UPDATE factions SET name='" .. (newName) .. "', type='"..newType.."' WHERE id='" .. factionID .. "'")
					local oldName = getTeamName(theTeam)
					setTeamName(theTeam, newName)
					setElementData(theTeam, "name", newName)
					
					exports.global:sendMessageToAdmins(exports.global:getPlayerFullIdentity(thePlayer).." renamed faction '" .. oldName .. "' to '" .. newName .. "'.")
				end
			end
		else--make
			factionName = data.name
			factionType = data.type
			
			local theTeam = createTeam(tostring(factionName))
			if theTeam then
				dbExec(mysql:getConnection(), "INSERT INTO factions SET name='" .. (factionName) .. "', bankbalance='0', type='" .. (factionType) .. "'")

				dbQuery(
					function(qh)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							row = res[1]
							id = row["id"]

							exports.pool:allocateElement(theTeam, id)
							dbExec(mysql:getConnection(), "UPDATE factions SET rank_1='LUCY RPG Rank #1', rank_2='LUCY RPG Rank #2', rank_3='LUCY RPG Rank #3', rank_4='LUCY RPG Rank #4', rank_5='LUCY RPG Rank #5', rank_6='LUCY RPG Rank #6', rank_7='LUCY RPG Rank #7', rank_8='LUCY RPG Rank #8', rank_9='LUCY RPG Rank #9', rank_10='LUCY RPG Rank #10', rank_11='LUCY RPG Rank #11', rank_12='LUCY RPG Rank #12', rank_13='LUCY RPG Rank #13', rank_14='LUCY RPG Rank #14', rank_15='LUCY RPG Rank #15', rank_16='LUCY RPG Rank #16', rank_17='LUCY RPG Rank #17', rank_18='LUCY RPG Rank #18', rank_19='LUCY RPG Rank #19', rank_20='LUCY RPG Rank #20',  motd='Ayarlanabilir', note = '' WHERE id='" .. id .. "'")

							outputChatBox(factionName .. " adlı birlik başarıyla oluşturuldu, ID #" .. id .. ".", player, 0, 255, 0)
							setElementData(theTeam, "type", tonumber(factionType))
							setElementData(theTeam, "id", tonumber(id))
							setElementData(theTeam, "name", factionName)
							setElementData(theTeam, "money", 0)
							local factionRanks = {}
							local factionWages = {}
							for i = 1, 20 do
								factionRanks[i] = "LUCY RPG Rank #" .. i
								factionWages[i] = 100
							end
							setElementData(theTeam, "ranks", factionRanks, false)
							setElementData(theTeam, "wages", factionWages, false)

							setElementData(theTeam, "motd", "Ayarlanabilir", false)
							setElementData(theTeam, "note", "", false)
							table.insert(dutyAllow, { row.id, row.name, { --[[Duty information]] } })
						end
					end,
				mysql:getConnection(), "SELECT * FROM factions WHERE id = LAST_INSERT_ID()")
			end
		end
		triggerClientEvent(player, "factions:editFaction:callback", player, "ok")
	end
)

addEvent("factions:listMember", true)
addEventHandler("factions:listMember", root,
	function(player, factionID)
		factionPlayers = {}
		dbQuery(
			function(qh, thePlayer, factionID)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					local theTeam = exports.pool:getElement("team", factionID)
					for index, value in ipairs(res) do
						local ranks = getElementData(theTeam,"ranks")
						local factionRankTitle = ranks[factionRank]

						factionPlayers[#factionPlayers + 1] = {
							["charactername"] = value["charactername"],
							["faction_leader"] = value["faction_leader"],
							["faction_rank_name"] = ranks[value["faction_rank"]],
							["online"] = getPlayerOnlineState(value["charactername"]),
							["username"] = "N/A",
							["duty"] = false,

						}
					end
					setElementData(theTeam, "receivePlayers", factionPlayers)
				end
			end,
		{player, factionID}, mysql:getConnection(), "SELECT * FROM characters WHERE faction_id = ?", factionID)
	end
)

function getPlayerOnlineState(charname)
	for _, player in ipairs(getElementsByType("player")) do
		if getPlayerName(player) == charname then
			return 1
		end
	end
	return 0
end

function adminShowFactionOnlinePlayers(thePlayer, commandName, factionID)
	if (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) then
		if not (factionID)  then
			outputChatBox("SYNTAX: /" .. commandName .. " [Faction ID]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.pool:getElement("team", factionID)
				local theTeamName = getTeamName(theTeam)
				local teamPlayers = getPlayersInTeam(theTeam)
				
				if #teamPlayers == 0 then
					outputChatBox("There are no players online in faction '".. theTeamName .."'", thePlayer, 255, 194, 14)
				else
					local teamRanks = getElementData(theTeam, "ranks")
					outputChatBox("Players online in faction '".. theTeamName .."':", thePlayer, 255, 194, 14)
					for k, teamPlayer in ipairs(teamPlayers) do
						local leader = ""
						local playerRank = teamRanks [ getElementData(teamPlayer, "factionrank") ]
						if (getElementData(teamPlayer, "factionleader") == 1) then
							leader = "LEADER "
						end
						outputChatBox("  "..leader.." ".. getPlayerName(teamPlayer) .." - "..playerRank, thePlayer, 255, 194, 14)
					end
				end
			else
				outputChatBox("Faction not found.", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("showfactionplayers", adminShowFactionOnlinePlayers, false, false)

function callbackAdminPlayersFaction(teamID)
	adminShowFactionOnlinePlayers(client, "showfactionplayers", teamID)
end
addEvent("faction:admin:showplayers", true )
addEventHandler("faction:admin:showplayers", getRootElement(), callbackAdminPlayersFaction)

addEvent('faction:admin:showf3', true)
addEventHandler('faction:admin:showf3', root,
	function(id, fromF3)
		if exports.integration:isPlayerTrialAdmin(client) --[[or exports.integration:isPlayerSupporter(client)]] then
			showFactionMenuEx(client, id, fromF3)
		end
	end)

function setFactionMoney(thePlayer, commandName, factionID, amount)
	if (exports.integration:isPlayerHeadAdmin(thePlayer)) then
		if not (factionID) or not (amount)  then
			outputChatBox("SYNTAX: /" .. commandName .. " [Faction ID] [Money]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.pool:getElement("team", factionID)
				amount = tonumber(amount) or 0
				if amount and amount > 500000*2 then
					outputChatBox("For security reason, you're not allowed to set more than $1,000,000 at once to a faction.", thePlayer, 255, 0, 0)
					return false
				end
				
				if (theTeam) then
					if exports.global:setMoney(theTeam, amount) then
						outputChatBox("Set faction '" .. getTeamName(theTeam) .. "'s money to " .. amount .. " $.", thePlayer, 255, 194, 14)
					else
						outputChatBox("Could not set money to that faction.", thePlayer, 255, 194, 14)
					end
				else
					outputChatBox("Invalid faction ID.", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("Invalid faction ID.", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("setfactionmoney", setFactionMoney, false, false)

function loadWelfare()
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				unemployedPay = res[1].value
			end
		end,
	mysql:getConnection(), "SELECT value FROM settings WHERE name = 'welfare'")
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		loadWelfare()
	end
)

function getTax(thePlayer)
	loadWelfare()
	outputChatBox( "Welfare: $" .. exports.global:formatMoney(unemployedPay), thePlayer, 255, 194, 14 )
	outputChatBox( "Tax: " .. ( exports.global:getTaxAmount(thePlayer) * 100 ) .. "%", thePlayer, 255, 194, 14 )
	outputChatBox( "Income Tax: " .. ( exports.global:getIncomeTaxAmount(thePlayer) * 100 ) .. "%", thePlayer, 255, 194, 14 )
end
addCommandHandler("gettax", getTax, false, false)

function setFactionBudget(thePlayer, commandName, factionID, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Government of Los Santos") and getElementData(thePlayer, "factionrank") >= 15 then
		local amount = tonumber( amount )
		if not factionID or not amount or amount < 0 then
			outputChatBox("SYNTAX: /" .. commandName .. " [Faction ID] [Money]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.pool:getElement("team", factionID)
				amount = tonumber(amount)
				
				if (theTeam) then
					if getElementData(theTeam, "type") >= 2 and getElementData(theTeam, "type") <= 6 then
						if exports.global:takeMoney(getPlayerTeam(thePlayer), amount) then
							exports.global:giveMoney(theTeam, amount)
							outputChatBox("You added $" .. exports.global:formatMoney(amount) .. " to the budget of '" .. getTeamName(theTeam) .. "' (Total: " .. exports.global:getMoney(theTeam) .. ").", thePlayer, 255, 194, 14)
							dbExec(mysql:getConnection(), "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. -getElementData(getPlayerTeam(thePlayer), "id") .. ", " .. -getElementData(theTeam, "id") .. ", " .. amount .. ", '', 8)" )
						else
							outputChatBox("You can't afford this.", thePlayer, 255, 194, 14)
						end
					else
						outputChatBox("You can't set a budget for that faction.", thePlayer, 255, 194, 14)
					end
				else
					outputChatBox("Invalid faction ID.", thePlayer, 255, 194, 14)
				end
			else
				outputChatBox("Invalid faction ID.", thePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("setbudget", setFactionBudget, false, false)

function setTax(thePlayer, commandName, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Government of Los Santos") and getElementData(thePlayer, "factionrank") >= 15 then
		local amount = tonumber( amount )
		if not amount or amount < 0 or amount > 30 then
			outputChatBox("SYNTAX: /" .. commandName .. " [0-30%]", thePlayer, 255, 194, 14)
		else
			exports.global:setTaxAmount(amount)
			outputChatBox("New Tax is " .. amount .. "%", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("settax", setTax, false, false)

function setIncomeTax(thePlayer, commandName, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Government of Los Santos") and getElementData(thePlayer, "factionrank") >= 15 then
		local amount = tonumber( amount )
		if not amount or amount < 0 or amount > 25 then
			outputChatBox("SYNTAX: /" .. commandName .. " [0-25%]", thePlayer, 255, 194, 14)
		else
			exports.global:setIncomeTaxAmount(amount)
			outputChatBox("New Income Tax is " .. amount .. "%", thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("setincometax", setIncomeTax, false, false)

function setWelfare(thePlayer, commandName, amount)
	if getPlayerTeam(thePlayer) == getTeamFromName("Government of Los Santos") and getElementData(thePlayer, "factionrank") >= 15 then
		local amount = tonumber( amount )
		if not amount or amount <= 0 then
			outputChatBox("SYNTAX: /" .. commandName .. " [Money]", thePlayer, 255, 194, 14)
		elseif dbExec(mysql:getConnection(), "UPDATE settings SET value = " .. unemployedPay .. " WHERE name = 'welfare'" ) then
			unemployedPay = amount
			outputChatBox("New Welfare is $" .. exports.global:formatMoney(unemployedPay) .. "/payday", thePlayer, 0, 255, 0)
		else
			outputChatBox("Error 129314 - Report on Mantis.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("setwelfare", setWelfare, false, false)

function issueGovLicense(thePlayer, commandName, type, ...)
	local licenseTypes = {"Business License - Regular", "Business License - Premium", "Adult Entertainment License", "Gambling License", "Liquor License"}
	if getPlayerTeam(thePlayer) == getTeamFromName("Government of Los Santos") and getElementData(thePlayer, "factionrank") >= 3 then
		local type = tonumber(type)
		if not type or not licenseTypes[type] or not ... then
			outputChatBox("SYNTAX: /" .. commandName .. " [type] [biz name]", thePlayer, 255, 194, 14)
			for k, v in ipairs(licenseTypes) do
			outputChatBox("  " .. k .. ": " .. v, thePlayer, 255, 194, 14)
			end
		else
			local text = licenseTypes[type] .. " - " .. table.concat({...}, " ")
			local success, error = exports.global:giveItem(thePlayer, 80, text)
			if success then
				outputChatBox("Created a " .. text .. ".", thePlayer, 0, 255, 0)
			else
				outputChatBox(error, thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("govlicense", issueGovLicense, false, false)

--

function respawnFactionVehicles(thePlayer, commandName, factionID)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		local factionID = tonumber(factionID)
		if (factionID) and (factionID > 0) then
			local theTeam = exports.pool:getElement("team", factionID)
			if (theTeam) then
				for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
					local faction = tonumber(getElementData(value, "faction"))
					if (faction == factionID and not getVehicleOccupant(value, 0) and not getVehicleOccupant(value, 1) and not getVehicleOccupant(value, 2) and not getVehicleOccupant(value, 3) and not getVehicleTowingVehicle(value)) then
						respawnVehicle(value)
						setElementInterior(value, getElementData(value, "interior"))
						setElementDimension(value, getElementData(value, "dimension"))
					end
				end
				
				local hiddenAdmin = tonumber(getElementData(thePlayer, "hiddenadmin"))
				local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
				local username = getPlayerName(thePlayer):gsub("_"," ")
				
				for k,v in ipairs(getPlayersInTeam(theTeam)) do
					outputChatBox((hiddenAdmin == 0 and adminTitle .. " " .. username or "Gizli Admin") .. " tum birlik araclari respawn edildi.", v)
				end
				
				exports.global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. username .. " isimli yetkili " .. factionID .. " ID'li birliğin tüm araçlarını respawn etti.")
				exports.logs:dbLog(thePlayer, 4, theTeam, "FACTION RESPAWN for " .. factionID)
			else
				outputChatBox("Invalid faction ID.", thePlayer, 255, 0, 0, false)
			end
		else
			outputChatBox("SYNTAX: /" .. commandName .. " [Faction ID]", thePlayer, 255, 194, 14, false)
		end
	end
end
addCommandHandler("respawnfaction", respawnFactionVehicles, false, false)
function adminDutyStart()
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				dbQuery(
					function(qh, res)
						local res2, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							dutyAllow = {}
							dutyAllowChanges = {}
							i = 0

							maxIndex = tonumber(res2[1].id) or 0
							for index, row in ipairs(res) do
								table.insert(dutyAllow, { row.id, row.name, { --[[Duty information]] } })
								i = i+1
								local res = dbPoll(dbQuery(mysql:getConnection(), "SELECT * FROM duty_allowed WHERE faction="..tonumber(row.id)), -1)
								for index, row1 in ipairs(res) do
									table.insert(dutyAllow[i][3], { row1.id, tonumber(row1.itemID), row1.itemValue })
								end
								setElementData(resourceRoot, "maxIndex", maxIndex)
								setElementData(resourceRoot, "dutyAllowTable", dutyAllow)
								
							end
						end
					end,
				{res}, mysql:getConnection(), "SELECT id FROM duty_allowed ORDER BY id DESC LIMIT 0, 1")
			end
		end,
	mysql:getConnection(), "SELECT id, name FROM factions WHERE type >= 2 ORDER BY id ASC")
end
addEventHandler("onResourceStart", resourceRoot, adminDutyStart)

function getAllowList(factionID)
	local factionID = tonumber(factionID)
	if factionID then
		for k,v in pairs(dutyAllow) do
			if tonumber(v[1]) == factionID then
				key = k
				break
			end
		end
		return dutyAllow[key][3]
	end
end

function adminDuty(thePlayer)
	if (exports.integration:isPlayerSeniorAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer)) then
		if not getElementData(resourceRoot, "dutyadmin") and type(dutyAllow) == "table" then
			triggerClientEvent(thePlayer, "adminDutyAllow", resourceRoot, dutyAllow, dutyAllowChanges)
			setElementData( resourceRoot, "dutyadmin", true )
		elseif type(dutyAllow) ~= "table" then
			outputChatBox("There was a issue with the startup caching of this resource. Contact a Scripter.", thePlayer, 255, 0, 0)
		else
			outputChatBox("Oops! Someone is already editing duty permissions. Sorry!", thePlayer, 255, 0, 0) -- No time to set up proper syncing + kinda not needed.
		end
	end
end
addCommandHandler("dutyadmin", adminDuty, false, false)

function saveChanges()
	outputDebugString("[Factions] Saving duty allow changes...")
	local tick = getTickCount()

	for key,value in pairs(dutyAllowChanges) do
		if value[2] == 0 then -- Delete row
			dbExec(mysql:getConnection(),"DELETE FROM duty_allowed WHERE id="..(tonumber(value[3])))
		elseif value[2] == 1 then
			dbExec(mysql:getConnection(),"INSERT INTO duty_allowed SET id="..(tonumber(value[3]))..", faction="..(tonumber(value[1]))..", itemID="..(tonumber(value[4]))..", itemValue='"..(value[5]).."'")
		end
	end

	outputDebugString("[Factions] Completed in ".. math.floor((getTickCount()-tick)/60) .." seconds.")
end
addEventHandler("onResourceStop", resourceRoot, saveChanges)

function updateTable(newTable, changesTable)
	dutyAllow = newTable
	dutyAllowChanges = changesTable
	removeElementData(resourceRoot, "dutyadmin")
	setElementData(resourceRoot, "dutyAllowTable", dutyAllow)
end
addEvent("dutyAdmin:Save", true)
addEventHandler("dutyAdmin:Save", resourceRoot, updateTable)

function birlikOnayla(thePlayer, commandName, factionID, onay)
	if (exports.integration:isPlayerSeniorAdmin(thePlayer) or exports.integration:isPlayerScripter(thePlayer)) then
		if not (factionID) or not (onay)  then
			outputChatBox("SYNTAX: /" .. commandName .. " [Birlik ID] [1 / 0]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.pool:getElement("team", factionID)
				if (theTeam) then
					dbExec(mysql:getConnection(),"UPDATE factions SET onay='" .. tonumber(onay) .. "' WHERE id='" .. factionID .. "'")
					local oldName = getTeamName(theTeam)
					setElementData(theTeam, "birlik_onay", tonumber(onay) == 1 and true or false)
					
					if tonumber(onay) == 1 then
						exports.global:sendMessageToAdmins(exports.global:getPlayerFullIdentity(thePlayer).." '" .. oldName .. "' isimli birliği onayladı!")
					elseif tonumber(onay) == 0 then
						exports.global:sendMessageToAdmins(exports.global:getPlayerFullIdentity(thePlayer).." '" .. oldName .. "' isimli birliği onayını kaldırdı!")
					end
				else
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("birlikonay", birlikOnayla)

addCommandHandler("birlikaktif",
	function(player, cmd)
		if getElementData(player, "loggedin") == 1 and getElementData(player, "faction") > 0 then
			
		end
	end
)