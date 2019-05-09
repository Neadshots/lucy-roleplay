local connection = exports.mysql:getConnection()
addEventHandler("onResourceStart", root,
	function(startedRes)
		if getResourceName(startedRes) == "mysql" then
			connection = exports.mysql:getConnection()
			restartResource(getThisResource())
		end
	end
)

local lotterysCache = {}
local lotteryItemID = 211

addEventHandler("onResourceStart", resourceRoot,
	function()
		dbQuery(
			function(qh)
				local queryHandler, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, value in ipairs(queryHandler) do
						lotterysCache[#lotterysCache + 1] = {
							["owner"] = value["owner"],
							["value"] = value["itemValue"],
						}
					end
				end
			end,
		connection, "SELECT * FROM items WHERE itemID = ?", lotteryItemID)
	end
)

addCommandHandler("lotteryrandom",
	function(player, cmd)
		if getElementData(player, "loggedin") == 1 then
			if exports["integration"]:isPlayerHeadAdmin(player) then
				if #lotterysCache > 0 then
					randomIndexForTable = math.random(1, #lotterysCache)
					findingTable = lotterysCache[randomIndexForTable]
					if findingTable then
						outputChatBox("#1 : "..findingTable.value, player, 255, 255, 255, true)
					end
				end
			end
		end
	end
)

addCommandHandler("countlottery",
	function(player, cmd)
		if getElementData(player, "loggedin") == 1 then
			if exports["integration"]:isPlayerHeadAdmin(player) then
				if #lotterysCache > 0 then
					outputChatBox("Toplam : "..(#lotterysCache), player, 255, 255, 255, true)
				end
			end
		end
	end
)

addEvent("lottery-system:giveItem", true)
addEventHandler("lottery-system:giveItem", root,
	function(player, generatedValue)
		if exports["global"]:hasMoney(player, 1000) then
			exports["global"]:giveItem(player, 211, generatedValue)
			exports["global"]:takeMoney(player, 1000)
			outputChatBox("Piyango biletinden başarıyla satın aldınız, bilet numaranız: "..generatedValue, player, 0, 255, 0)
		end
	end
)

