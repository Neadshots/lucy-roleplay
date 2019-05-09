local screenW, screenH = guiGetScreenSize()
local scaleW, scaleH = (1366/screenW), (768/screenH)
local reklamlar = {}

function reklamOnayGUI( reklamlar )
    reklamOnayWindow = guiCreateWindow(scaleW * 391, scaleH * 215, scaleW * 584, scaleH * 338, "LUCY RPG - Advertisements Control Panel", false)
    guiWindowSetSizable(reklamOnayWindow, false)

    reklamListesi = guiCreateGridList(scaleW * 10, scaleH * 25, scaleW * 564, scaleH * 245, false, reklamOnayWindow)
    guiGridListAddColumn(reklamListesi, "#", 0.1)
    guiGridListAddColumn(reklamListesi, "Reklam", 0.3)
    guiGridListAddColumn(reklamListesi, "Gönderen", 0.3)
    guiGridListAddColumn(reklamListesi, "Gönderenin İsmi", 0.3)
	for index, value in ipairs(reklamlar) do
		guiGridListAddRow(reklamListesi)
		guiGridListSetItemText(reklamListesi, index - 1, 1, index, false, false)
		guiGridListSetItemText(reklamListesi, index - 1, 2, value[1], false, false)  
		guiGridListSetItemText(reklamListesi, index - 1, 3, value[5], false, false)   
		guiGridListSetItemText(reklamListesi, index - 1, 4, value[2], false, false)  
	end
    kabulEtBtn = guiCreateButton(scaleW * 10, scaleH * 280, scaleW * 191, scaleH * 48, "Kabul Et", false, reklamOnayWindow)
	addEventHandler("onClientGUIClick", kabulEtBtn, function() local row, col = guiGridListGetSelectedItem(reklamListesi) triggerServerEvent("reklamOnayla", getLocalPlayer(), row + 1) destroyElement(reklamOnayWindow) end)
    reddetBtn = guiCreateButton(scaleW * 211, scaleH * 280, scaleW * 191, scaleH * 48, "Reddet", false, reklamOnayWindow)
	addEventHandler("onClientGUIClick", reddetBtn, function() local row, col = guiGridListGetSelectedItem(reklamListesi) triggerServerEvent("reklamReddet", getLocalPlayer(), row + 1) destroyElement(reklamOnayWindow) end)
    kapatBtn = guiCreateButton(scaleW * 411, scaleH * 280, scaleW * 163, scaleH * 48, "Kapat", false, reklamOnayWindow)
	addEventHandler("onClientGUIClick", kapatBtn, function() destroyElement(reklamOnayWindow) end)
end
addEvent("reklamOnayGUI", true)
addEventHandler("reklamOnayGUI", root, reklamOnayGUI)

function reklamlarTablo( )
	if exports.integration:isPlayerSeniorAdmin(getLocalPlayer()) or getElementData(getLocalPlayer(), "faction") == 20 and getElementData(getLocalPlayer(), "factionleader") == 1 then
		triggerServerEvent("clientReklam", getLocalPlayer())
	end
end
addEvent("reklamlarTablo", true)
addEventHandler("reklamlarTablo", getRootElement(), reklamlarTablo)