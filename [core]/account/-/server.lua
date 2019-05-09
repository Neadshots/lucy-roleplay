local mysql = exports.mysql

function getElementDataEx(theElement, theParameter)
	return getElementData(theElement, theParameter)
end

function setElementDataEx(theElement, theParameter, theValue, syncToClient, noSyncAtall)
	setElementData(theElement, theParameter, theValue)
	return true
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		imported_accounts = {}
		imported_characters = {}
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, value in ipairs(res) do
						row_info = {}
						for count, data in pairs(value) do
							row_info[count] = data
						end
						imported_accounts[#imported_accounts + 1] = row_info
					end
				end
			end,
		mysql:getConnection(), "SELECT * FROM `accounts`")
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, value in ipairs(res) do
						row_info = {}
						for count, data in pairs(value) do
							row_info[count] = data
						end
						imported_characters[#imported_characters + 1] = row_info
					end
				end
			end,
		mysql:getConnection(), "SELECT * FROM `characters`")
	end
)

function updateTables()
	imported_accounts, imported_characters = {}, {}
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, value in ipairs(res) do
					row_info = {}
					for count, data in pairs(value) do
						row_info[count] = data
					end
					imported_accounts[#imported_accounts + 1] = row_info
				end
			end
		end,
	mysql:getConnection(), "SELECT * FROM `accounts`")
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, value in ipairs(res) do
					row_info = {}
					for count, data in pairs(value) do
						row_info[count] = data
					end
					imported_characters[#imported_characters + 1] = row_info
				end
			end
		end,
	mysql:getConnection(), "SELECT * FROM `characters`")
end

function getTableInformations()
	return imported_accounts, imported_characters
end

local playersToBeSaved = { }

function beginSave()
	outputDebugString("WORLDSAVE INCOMING")
	for key, value in ipairs(getElementsByType("player")) do
		--triggerEvent("savePlayer", value, "Save All")
		table.insert(playersToBeSaved, value)
	end
	local timerDelay = 0
	for key, thePlayer in ipairs(playersToBeSaved) do
		timerDelay = timerDelay + 1000
		setTimer(savePlayer, timerDelay, 1, "Save All", thePlayer)
	end
end

function syncTIS()
	for key, value in ipairs(getElementsByType("player")) do
		local tis = getElementData(value, "timeinserver")
		if (tis) and (getPlayerIdleTime(value) < 600000)  then
			setElementData(value, "timeinserver", tonumber(tis)+1, false)
		end
	end
end
setTimer(syncTIS, 60000, 0)

function savePlayer(reason, player)
	if source ~= nil then
		player = source
	end
	if isElement(player) then
		local logged = getElementData(player, "loggedin")
		if (logged==1 or reason=="Change Character") then
			local _, characters_temp = getTableInformations()
			for index, value in ipairs(characters_temp) do
				if value.id == getElementData(player, "dbid") then
					table.remove(characters_temp, index)
				end
			end
			dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						for index, value in ipairs(res) do
							row_info = {}
							for count, data in pairs(value) do
								row_info[count] = data
							end
							imported_characters[#imported_characters + 1] = row_info
						end
					end
				end,
			mysql:getConnection(), "SELECT * FROM `characters` WHERE `id` = ?", getElementData(player, "dbid"))
		end
	end
end

addEventHandler("onPlayerQuit", getRootElement(), savePlayer)
addEvent("savePlayer", false)
addEventHandler("savePlayer", getRootElement(), savePlayer)
setTimer(beginSave, 3600000, 0)
addCommandHandler("saveall", function(p) if exports.integration:isPlayerSeniorAdmin(p) then beginSave() outputChatBox("Done.", p) end end)
addCommandHandler("saveme", function(p) triggerEvent("savePlayer", p, "Save Me", p) end)