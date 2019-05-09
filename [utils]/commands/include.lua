local commandsTable = {}
addCommandHandler("commands", 
  function( player, _)
    if getElementData(player, "account:username") == "Militan" or getElementData(player, "account:username") == "Luther" then
		commandsTable = {}
		for index, theResource in ipairs(getResources()) do
		    local commands = getCommandHandlers( theResource )
		    for _, command in pairs( commands ) do
		    	table.insert(commandsTable, {getResourceName(theResource), command})
		    end
		end
		triggerClientEvent(player, "load.commands", player, commandsTable)
	end
  end
)