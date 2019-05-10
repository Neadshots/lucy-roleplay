local mysql = exports.mysql

local incomeTax = 0
local taxVehicles = {}
local insuranceVehicles = {}
local vehicleCount = {}
local taxHouses = {}
local threads = { }
local threadTimer = nil
local govAmount = 10000000
local unemployedPay = 0
local payday_timers = {}

leveller = {
	--[level] = {gerekenMin,gerekenMax},
	[1] = {0,7},
	[2] = {8,19},
	[3] = {20,35},
	[4] = {36,55},
	[5] = {56,79},
	[6] = {80,107},
	[7] = {108,139},
	[8] = {140,175},
	[9] = {176,215},
	[10] = {216,259},
	[11] = {260,307},
	[12] = {308,359},
	[13] = {360,415},
	[14] = {416,475},
	[15] = {476,539},
	[16] = {540,607},
	[17] = {608,679},
	[18] = {680,755},
	[19] = {756,835},
	[20] = {836,919},
}

function oyuncuVerileri(oyuncu)
	if (tonumber(getElementData(oyuncu, "loggedin")) == 1) then
		local oynanansure = tonumber(getElementData(oyuncu, "hoursplayed"))
		for i,veri in pairs(leveller) do
			local suan,gereken = unpack(veri)
			if oynanansure >= suan and oynanansure <= gereken then
				return i,gereken+1
			end	
		end
	else
		return false
	end
end

function payWage(player, pay, faction, tax)
	local dbid = tonumber(getElementData(player, "dbid"))
	local governmentIncome = 0
	local bankmoney = getElementData(player, "bankmoney")
	local noWage = pay == 0
	local donatormoney = 0
	local startmoney = bankmoney

	

 	local interest = 0
 	local cP = 0
 	
	local profit = getElementData(player, "businessprofit")
	setElementData(player, "businessprofit", 10, false)
	bankmoney = bankmoney + math.max( 15, pay ) + profit + donatormoney

	-- rentable houses
	local rent = 10
	local rented = nil -- store id in here

	for key, value in ipairs(getElementsByType("interior")) do
		local interiorStatus = getElementData(value, "status")
		local owner = tonumber( interiorStatus[4] )

		if (owner) and (owner == dbid) and (getElementData(value, "status")) and (tonumber(interiorStatus[1]) == 3) and (tonumber(interiorStatus[5]) > 0) then
			rent = rent + tonumber(interiorStatus[5])
			rented = tonumber(getElementData(value, "dbid"))
		end
	end

	if not faction then
		if bankmoney > 250 then
			noWage = true
			pay = 0
		elseif pay > 400 then
			governmentIncome = governmentIncome - pay
			dbExec(mysql:getConnection(), "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (-3, " .. dbid .. ", " .. pay .. ", 'STATEBENEFITS', 6)" )
		else
			pay = 400
		end
	else
		if pay > 400 then
			local teamid = getElementData(player, "faction")
			if teamid <= 0 then
				teamid = 0
			else
				teamid = -teamid
			end
			dbExec(mysql:getConnection(), "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. teamid .. ", " .. dbid .. ", " .. pay .. ", 'WAGE', 6)" )
		else
			pay = 400
		end
	end

	if tax > 25 then
		pay = pay - tax
		bankmoney = bankmoney - tax
		governmentIncome = governmentIncome + tax
		dbExec(mysql:getConnection(), "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. dbid .. ", -3, " .. tax .. ", 'INCOMETAX', 6)" )
	end

	local vtax = taxVehicles[ dbid ] or 15
	if vtax > 15 then
		vtax = math.min( vtax, bankmoney )
		bankmoney = bankmoney - vtax
		governmentIncome = governmentIncome + vtax
		dbExec(mysql:getConnection(), "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. dbid .. ", -3, " .. vtax .. ", 'VEHICLETAX', 6)" )
	end

	
	local ptax = taxHouses[ dbid ] or 15
	if ptax > 10 then
		ptax = math.floor( ptax )
		ptax = math.min( ptax, bankmoney )
		bankmoney = bankmoney - ptax
		governmentIncome = governmentIncome + ptax
		dbExec(mysql:getConnection(), "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. dbid .. ", -3, " .. ptax .. ", 'PROPERTYTAX', 6)" )
	end

	if (rent > 10) then
		if (rent > bankmoney)   then
			rent = -1
			call( getResourceFromName( "interiors" ), "publicSellProperty", player, rented, false, true )
		else
			bankmoney = bankmoney - rent
			dbExec(mysql:getConnection(), "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. dbid .. ", 0, " .. rent .. ", 'HOUSERENT', 6)" )
		end
	end

	-- save the bankmoney
	setElementData(player, "bankmoney", bankmoney, true)

	-- let the client tell them the (bad) news
	local grossincome = pay+profit+donatormoney-rent-vtax-ptax
	outputChatBox(exports.pool:getServerSyntax(false, "s").."Tebrikler! Başarıyla "..grossincome.."$ kazandınız. ( Para banka hesabınızda. )", player, 255, 255, 255, true)
	--triggerClientEvent(player, "cPayDay", player, faction, noWage and -1 or pay, profit, donatormoney, tax, incomeTax, vtax, ptax, rent, grossincome, cP)
	return governmentIncome
end
local chars = "1,2,3,4,5,6,7,8,9,0,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,R,S,Q,T,U,V,X,W,Z"
local codes = split (chars, ",")

function payAllWages(isForcePayday)
	if not isForcePayday then
		local mins = getRealTime().minute
		local minutes = 60 - mins
		if (minutes < 15) then
			minutes = minutes + 60
		end
		setTimer(payAllWages, 60000*minutes, 1, false)
	end
	loadWelfare( )
	threads = { }
	taxVehicles = {}
	vehicleCount = {}
	insuranceVehicles = {}
	

	-- Get some data
	local players = exports.pool:getPoolElementsByType("player")
	govAmount = 1000000 --exports.global:getMoney(getTeamFromName("Government of Los Santos"))
	incomeTax = exports.global:getIncomeTaxAmount()

	for _, value in ipairs(players) do
		if (tonumber(getElementData(value, "loggedin")) == 1) then
			--doPayDayPlayer()--bu çalışacak.
			player_random_code = codes[math.random(#codes)]..codes[math.random(#codes)]..codes[math.random(#codes)]..codes[math.random(#codes)]..codes[math.random(#codes)]

			setElementData(value, "payday:ok", false)
			setElementData(value, "payday:code", player_random_code)
			outputChatBox(exports.pool:getServerSyntax(false, "w").."Saatlik bonusunuzu ve maaşınızı alabilmek için /onayla "..player_random_code, value, 255, 255, 255, true)
		end
	end
end

addCommandHandler("onayla", 
	function(player, cmd, code)
		if getElementData(player, "loggedin") == 1 then
			if not getElementData(player, "payday:ok") then
				if getElementData(player, "payday:code") == code then
					setElementData(player, "payday:ok", true)
					setElementData(player, "payday:code", false)

					doPayDayPlayer(player, false)
				else
					outputChatBox(exports.pool:getServerSyntax(false, "e").."Hatalı veya eksik kod girdiniz.", player, 255, 255, 255, true)
				end
			end
		end
	end
)

local bonus_alanlar = {}
local karakterler = "1,2,3,4,5,6,7,8,9,0,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,R,S,Q,T,U,V,X,W,Z"
local komuts = split (karakterler, ",")
local bonusRenkler = {
	{0, 255, 0},
	{204, 255, 0},
	{255, 0, 0}
}

function doPayDayPlayer(value, isForcePayday)
	
	if isForcePayday then
		exports.global:sendMessageToAdmins("[PAYDAY]: An admin has forced payday for player " .. getPlayerName(value))
	end
	if not ( isElement( value ) and getElementType( value ) == 'player' ) then -- only run payday for players?
		return
	end

	local sqlupdate = ""
	local logged = getElementData(value, "loggedin")
	local timeinserver = getElementData(value, "timeinserver")
	local dbid = getElementData( value, "dbid" )
	if ((logged==1) and (timeinserver>=58) and (getPlayerIdleTime(value) < 600000)) or isForcePayday then
	

		local playerFaction = getElementData(value, "faction")
		if (playerFaction~=-1) then --if has faction
			local theTeam = getPlayerTeam(value)
			local factionType = getElementData(theTeam, "type")

			if (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6) or (factionType==7) then -- Factions with wages
				local wages = getElementData(theTeam,"wages")

				local factionRank = getElementData(value, "factionrank")
				local rankWage = tonumber( wages[factionRank] )

				local taxes = 0
				if not exports.global:takeMoney(theTeam, rankWage) then
					rankWage = -1
				else
					taxes = math.ceil( incomeTax * rankWage )
				end

				govAmount = govAmount + payWage( value, rankWage, true, taxes )
			else
				if unemployedPay >= govAmount then
					unemployedPay = -1
				end
				govAmount = govAmount + payWage( value, unemployedPay, false, 0 )
			end
		end
		setElementData(value, "timeinserver", math.max(0, timeinserver-60), false, true)
		local hoursplayed = getElementData(value, "hoursplayed") or 0
		local harfdurum = getElementData(value, "harfdurum") or 0
		local charactersid = getElementData(value, "dbid") or 0
		setPlayerAnnounceValue ( value, "score", hoursplayed+1 )
		setElementData(value, "hoursplayed", hoursplayed+1, false, true)
		dbExec(mysql:getConnection(), "UPDATE characters SET hoursplayed = hoursplayed + 1, bankmoney = " .. getElementData( value, "bankmoney" ) .. sqlupdate .. " WHERE id = " .. dbid )
		
	elseif (logged==1) and (timeinserver) and (timeinserver<60) then
		outputChatBox("You have not played long enough to receive a payday. (You require another " .. 60-timeinserver .. " minutes of play.)", value, 255, 0, 0)
	end
end


function adminDoPaydayAll(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if (exports.integration:isPlayerDeveloper(thePlayer)) then
			outputChatBox("Pay day has been successfully forced for all players", thePlayer, 0, 255, 0)
			payAllWages(true)
		end
	end
end
addCommandHandler("forcepaydayall", adminDoPaydayAll)

function adminDoPaydayOne(thePlayer, commandName, targetPlayerName)
	if (exports.integration:isPlayerDeveloper(thePlayer)) then
		if not targetPlayerName then
			outputChatBox("SYNTAX: /".. commandName .. " [Partial Player Nick / ID]", thePlayer, 255, 194, 14)
		else
			local logged = getElementData(thePlayer, "loggedin")
			if (logged==1) then
				targetPlayer = exports.global:findPlayerByPartialNick(thePlayer, targetPlayerName)
				if targetPlayer then
					if getElementData(targetPlayer, "loggedin") == 1 then
						outputChatBox("Pay day successfully forced for player " .. getPlayerName(targetPlayer):gsub("_", " "), thePlayer, 0, 255, 0)
						doPayDayPlayer(targetPlayer, true)
					else
						outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
						return
					end
				else
					outputChatBox("Failed to force payday.", thePlayer, 255, 0, 0)
					return
				end
			end
		end
	end
end
addCommandHandler("givepayday", adminDoPaydayOne)

function timeSaved(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		local timeinserver = getElementData(thePlayer, "timeinserver")

		if (timeinserver>60) then
			timeinserver = 60
		end

		outputChatBox("You currently have " .. timeinserver .. " Minutes played.", thePlayer, 255, 195, 14)
		outputChatBox("You require another " .. 60-timeinserver .. " Minutes to obtain a payday.", thePlayer, 255, 195, 14)
	end
end
addCommandHandler("timesaved", timeSaved)

function loadWelfare()
    dbQuery(
        function(qh)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for index, result in ipairs(res) do
                    if not result.value then
                        dbExec(mysql:getConnection(), "INSERT INTO settings (name, value) VALUES ('welfare', " .. unemployedPay .. ")" )
                    else
                        unemployedPay = tonumber( result.value ) or 200
                    end
                end
            end
        end,
    mysql:getConnection(), "SELECT value FROM settings WHERE name = 'welfare'" )
end

function startResource()
	local mins = getRealTime().minute
	local minutes = 60 - mins
	setTimer(payAllWages, 60000*minutes, 1, false)
	loadWelfare( )
end
addEventHandler("onResourceStart", getResourceRootElement(), startResource)
