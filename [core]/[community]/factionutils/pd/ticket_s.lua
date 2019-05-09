addEvent("givePlayerTicket", true)
addEventHandler("givePlayerTicket", root,
	function(found, amount, reason, time)
		amount = tonumber(amount)
		local money = exports.global:getMoney(found)
		local bankmoney = getElementData(found, "bankmoney")
		local tax = exports.global:getTaxAmount()
		local takeFromCash = math.min( money, amount )
		local takeFromBank = amount - takeFromCash
		local targetPlayerName = getPlayerName(found):gsub("_", " ")
		exports.global:takeMoney(found, takeFromCash)
		exports.global:giveMoney( getTeamFromName("Government of Los Santos"), math.ceil(tax*amount) )

		outputChatBox(exports.pool:getServerSyntax(false, "s")..targetPlayerName .. " adlı şahısa " .. exports.global:formatMoney(amount) .. "$ ceza kestin. Sebep: " .. reason, source, 255, 255, 255, true)
		outputChatBox(exports.pool:getServerSyntax(false, "e")..exports.global:formatMoney(amount) .. " ceza aldınız. (" .. getPlayerName(source) .. " tarafından) Sebep: " .. reason, found, 255, 255, 255, true)

		if takeFromBank > 0 then
			outputChatBox(exports.pool:getServerSyntax(false, "w").."Yanında para olmadığı için, $" .. exports.global:formatMoney(takeFromBank) .. " banka hesabından çekildi.", found, 255, 255, 255, true)
			setElementData(found, "bankmoney", bankmoney - takeFromBank, false)
		end
	end
)

addEvent("giveVehicleTicket", true)
addEventHandler("giveVehicleTicket", root,
	function(foundVehicle, amount, reason, time)
		thePlayer = source
		theVehicle = foundVehicle

		local logged = getElementData(thePlayer, "loggedin")
		if (logged==1) then
			local issuerID = getElementData(thePlayer, "account:character:id")
			local team = getPlayerTeam(thePlayer)
			if ((getTeamName(team) == "Los Santos Police Department")) then
				dbExec(mysql:getConnection(), "INSERT INTO `pd_tickets` (`reason`, `vehid`, `amount`, `issuer`, `time`) VALUES ('".. (reason) .."', "..(theVehicle)..", "..(amount)..", "..(issuerID)..", NOW() - interval 1 hour)")
				outputChatBox(exports.pool:getServerSyntax(false, "s").."Seçili araca başarıyla ceza kesildi. Sebep: " .. reason, source, 255, 255, 255, true)
				local teamMembers = getPlayersInTeam(team)
				local charname = getPlayerName(thePlayer):gsub("_", " ")
				local factionID = getElementData(thePlayer, "faction")
				local factionRank = getElementData(thePlayer, "factionrank")
				local factionRanks = getElementData(team, "ranks")
				local factionRankTitle = factionRanks[factionRank]
				for key, value in ipairs(teamMembers) do
					outputChatBox("" .. factionRankTitle .. " " .. charname .." has issued a vehicle ticket to VIN " ..tonumber(theVehicle).. " with the amount $" ..tonumber(amount).." for the reason: " ..reason.. ".", value, 0, 102, 255)
				end
			end
		end
	end
)


function ticketVehicle(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local theTeam = getPlayerTeam(thePlayer)
		local factionType = getElementData(theTeam, "type")
		local factionID = getElementData(theTeam, "id")
		
		if (factionID==1 or factionID==59) then
			local targetVehicle = findBestVehicle(thePlayer)
			if (targetVehicle) then
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetVehicle)
				
				local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
				
				if (distance<=4) then
					triggerClientEvent(thePlayer, "showTicketGUI", thePlayer, targetVehicle)
				end
			else
				triggerClientEvent(thePlayer, "showTicketGUI", thePlayer, false)
			end
		end
	end
end
addCommandHandler("ticket", ticketVehicle, false, false)

function findBestVehicle(player)
	local x, y, z = getElementPosition(player)
	for index, value in ipairs(getElementsByType("vehicle")) do
		local tx, ty, tz = getElementPosition(value)
		local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
		if distance <= 4 then
			return value
		end
	end
	return false
end
