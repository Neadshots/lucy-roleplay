--MAXIME / 2015.1.8

function canPlayerAccessStaffManager(player)
	return exports.integration:isPlayerLeadAdmin(player)
end
	