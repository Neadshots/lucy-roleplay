function fly(thePlayer, commandName)
	if (exports.integration:isPlayerTrialAdmin(thePlayer)) then
		triggerClientEvent(thePlayer, "onClientFlyToggle", thePlayer)
	end
end
addCommandHandler("fly", fly, false, false)