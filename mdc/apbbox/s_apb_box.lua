local mysql = exports.mysql

addEvent("RemovePlayerFromTableEvent", true)
addEventHandler("RemovePlayerFromTableEvent", root,
	function()

	end
)

local allowedFactions = {
	[1] = true,
}

addCommandHandler("apblist",
	function(player, cmd)
		if getElementData(player, "loggedin") == 1 and allowedFactions[getElementData(player, "faction")] then
			vehicle = getPedOccupiedVehicle(player)

			if vehicle and allowedFactions[getElementData(vehicle, "faction")] then
				apbStandTable = {}

				dbQuery(
					function(qh, player)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							for index, value in ipairs(res) do
								apbStandTable[#apbStandTable + 1] = {value.person_involved, value.description}
							end
						
							triggerClientEvent(player, "drawAPB", player, apbStandTable)
						end
					end,
				{player}, mysql:getConnection(), "SELECT * FROM `mdc_apb`")
			end
		end
	end
)