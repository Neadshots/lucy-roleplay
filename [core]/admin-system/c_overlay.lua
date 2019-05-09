local sx, sy = guiGetScreenSize()
local localPlayer = getLocalPlayer()

local openReports = 0
local handledReports = 0
local ckAmount = 0
local unansweredReports = {}
local ownReports = {}

-- dx stuff
local textString = ""
local admstr = ""
local show = false

-- Admin Titles
function getAdminTitle(thePlayer)
	return exports.global:getPlayerAdminTitle(thePlayer)
end

-- update the labels
local function updateGUI()
	if show then
		local reporttext = ""
		if #unansweredReports > 0 then
			reporttext = ": #" .. table.concat(unansweredReports, ", #")
		end
		
		local ownreporttext = ""
		if #ownReports > 0 then
			ownreporttext = ": #" .. table.concat(ownReports, ", #")
		end
		
		local onduty = getElementData( localPlayer, "admin_level" ) <= 7 and "Görev Dışında" or ""
		if getElementData( localPlayer, "duty_admin" ) == 1 or getElementData( localPlayer, "duty_supporter" ) == 1 then
			onduty = "Görevde" .. " :: "
		else
			onduty = ""
		end

		if exports.integration:isPlayerSupporter(localPlayer) or exports.integration:isPlayerTrialAdmin(localPlayer) then
			textString = getAdminTitle( localPlayer ) .. " :: " .. onduty .. admstr .. ( (getElementData( localPlayer, "admin_level" ) <= 10 )and ( " :: " .. ( openReports - handledReports ) .. " bekleyen raporlar" .. reporttext .. " :: " .. handledReports .. " alınan raporlar" .. ownreporttext .. " :: " .. ckAmount .. " bekleyen CK istekleri ::") or "" )
		else
			textString = getAdminTitle( localPlayer ) .. " :: " .. ( openReports - handledReports ) .. " bekleyen raporlar" .. reporttext .. " :: " .. handledReports .. " alınan raporlar" .. ownreporttext .. " :: "
		end
	end
end

-- create the gui
local function createGUI()
	show = false

	if exports.integration:isPlayerStaff(localPlayer) then
		show = true
		updateGUI()
	end
end

addEventHandler( "onClientResourceStart", getResourceRootElement(), createGUI, false )
addEventHandler( "onClientElementDataChange", localPlayer, 
	function(n)
		if n == "admin_level" or n == "hiddenadmin" or n=="account:gmlevel" or n=="duty_supporter" or n=="duty_admin" or n == "forum_perms" then
			createGUI()
		end
	end, false
)

addEvent( "updateReportsCount", true )
addEventHandler( "updateReportsCount", localPlayer,
	function( open, handled, unanswered, own, admst )
		openReports = open
		handledReports = handled
		unansweredReports = unanswered
		admstr = admst
		ownReports = own or {}
		updateGUI()
	end, false
)


addEvent( "addOneToCKCount", true )
addEventHandler("addOneToCKCount", localPlayer,
	function( )
		ckAmount = ckAmount + 1
		updateGUI()
	end, false
)

addEvent( "addOneToCKCountFromSpawn", true )
addEventHandler("addOneToCKCountFromSpawn", localPlayer,
	function( )
		if (ckAmount>=1) then
			return
		else
		ckAmount = ckAmount + 1
		updateGUI()
		end
	end, false
)

addEvent( "subtractOneFromCKCount", true )
addEventHandler("subtractOneFromCKCount", localPlayer,
	function( )
	if (ckAmount~=0) then
		ckAmount = ckAmount - 1
		updateGUI()
	else
		ckAmount = 0
	end
	end, false
)

addEventHandler( "onClientPlayerQuit", getRootElement(), updateGUI )