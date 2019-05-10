local screenW, screenH = guiGetScreenSize()

addEvent("vendorSystem.showWindow",true)
addEventHandler("vendorSystem.showWindow", root, function(sellerName, foodData)
	if not sellerName or not foodData then return end
	if isElement(sellerWindow) then return end

	local foodName = foodData.name
	local foodPrice = foodData.price

	sellerWindow = guiCreateWindow((screenW - 425) / 2, (screenH - 120) / 2, 425, 120, "Tezgah Sistemi v1.0", false)
	guiWindowSetSizable(sellerWindow, false)
	showCursor(true)

	sellerLabel = guiCreateLabel(10, 26, 405, 40, string.gsub(sellerName, "_", " ").." adlı tezgahtar size $"..foodPrice.." karşılığında "..foodName.." satmak istiyor,\nsatın almak istiyor musun?", false, sellerWindow)

	sellerAnswerYes = guiCreateButton(10, 70, 200, 39, "Evet, almak istiyorum.", false, sellerWindow)
	guiSetProperty(sellerAnswerYes, "NormalTextColour", "FFAAAAAA")
	sellerAnswerNo = guiCreateButton(215, 70, 200, 39, "Hayır, teşekkürler.", false, sellerWindow)
	guiSetProperty(sellerAnswerNo, "NormalTextColour", "FFAAAAAA")
	setWindowFlashing(true,3)
end)


function destroyDealerWindow()
	if isElement(sellerWindow) then
		destroyElement(sellerWindow)
		showCursor(false)
	end
end

addEventHandler("onClientGUIClick", root,
	function()
		if source == sellerAnswerYes then
			triggerServerEvent("vendorSystem.answer", localPlayer, "yes")
			destroyDealerWindow()
		elseif source == sellerAnswerNo then
			triggerServerEvent("vendorSystem.answer", localPlayer, "no")
			destroyDealerWindow()
		end
	end
)	