GUIEditor = {
    button = {},
    window = {},
    staticimage = {},
    label = {}
}

function createVIPCheckWindow(target)
	local skin = getElementModel(target)
	GUIEditor.window[1] = guiCreateWindow(0, 0, 494, 294, "Yetkili Paneli - "..getPlayerName(target).." karakterinin VIP bilgileri", false)
	guiWindowSetSizable(GUIEditor.window[1], false)
	exports.global:centerWindow(GUIEditor.window[1])

	GUIEditor.staticimage[1] = guiCreateStaticImage(15, 30, 85, 78, ":account/img/00"..skin..".png", false, GUIEditor.window[1])
	GUIEditor.label[1] = guiCreateLabel(10, 112, 474, 15, "------------------------------------------------------------------------------------------------------------------------------------------------------------------", false, GUIEditor.window[1])
	GUIEditor.label[2] = guiCreateLabel(100, 40, 384, 17, "Aşağıda karakterin VIP bilgileri yer almaktadır.", false, GUIEditor.window[1])
	guiLabelSetHorizontalAlign(GUIEditor.label[2], "center", false)
	GUIEditor.button[1] = guiCreateButton(9, 253, 475, 31, "Arayüzü Kapat", false, GUIEditor.window[1])
	addEventHandler("onClientGUIClick", GUIEditor.button[1],
		function(b)
			if b == "left" then
				destroyElement(GUIEditor.window[1])
			end
		end
	)
	if getElementData(target, "vip") > 0 then viptext = "Var" else viptext = "Yok" end
	GUIEditor.label[3] = guiCreateLabel(10, 135, 474, 108, "VIP: "..viptext.."\nVIP Seviye: "..getElementData(target, "vip").."\nVIP Kalan Gün: "..getElementData(target, "vip_day").."\nVIP Kalan Saat: "..getElementData(target, "vip_hour"), false, GUIEditor.window[1])
end

addCommandHandler("vipkontrol",
	function(cmd, targetID)
		if getElementData(localPlayer, "loggedin") == 1 and exports.integration:isPlayerTrialAdmin(localPlayer) then
			local target = findPlayer(targetID)
			if target then
				createVIPCheckWindow(target)
			end
		end
	end
)

function findPlayer(playerid)
	for index, value in ipairs(getElementsByType("player")) do
		if tonumber(getElementData(value, "playerid")) == tonumber(playerid) then
			return value
		end
	end
	return false
end