 -- MAXIME
 
--ATM SERVICE PED
local localPlayer = getLocalPlayer()
local atmPed = createPed( 113, 1864.0712890625, -1700.8001708984, 14.6953125 )
setPedRotation( atmPed, 267 )
setElementDimension( atmPed, 0)
setElementInterior( atmPed , 0)
setElementData( atmPed, "talk", 1, false )
setElementData( atmPed, "name", "Maxime Du Trieux", false )
setElementFrozen(atmPed, true)


--GENERAL SERVICE PED
local localPlayer = getLocalPlayer()
local generalServicePed = createPed( 290, 1864.0830078125, -1704.1712646484, 14.6953125)
setPedRotation( generalServicePed, 274 )
setElementDimension( generalServicePed, 0)
setElementInterior( generalServicePed , 0)
setElementData( generalServicePed, "talk", 1, false )
setElementData( generalServicePed, "name", "Jonathan Smith", false )
setElementData( generalServicePed, "depositable", 1 , true )
setElementData( generalServicePed, "limit", 0 , true )
--setPedAnimation ( generalServicePed, "INT_OFFICE", "OFF_Sit_Type_Loop", -1, true, false, false )
setElementFrozen(generalServicePed, true)

createBlip(1862.353515625, -1696.0267333984, 14.6953125, 52, 2, 255, 0, 0, 255, 0, 300) -- Star tower

local wGui = nil
function bankerInteraction() 
	if getElementData(getLocalPlayer(), "exclusiveGUI") or not isCameraOnPlayer() then
		return false
	end
	
	
	setElementData(getLocalPlayer(), "exclusiveGUI", true, false)
	
	local verticalPos = 0.1
	local numberOfButtons = 6*1.1
	local Width = 350
	local Height = 330
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	local option = {}
	if not (wGui) then
		showCursor(true)
		--NEW CARD
		wGui = guiCreateWindow(X, Y, Width, Height, "'Sizin için ne yapabilirim bayım?'", false )
		option[1] = guiCreateButton( 0.05, verticalPos, 0.9, 1/numberOfButtons, "Yeni bir ATM kartı için başvurmak istiyorum, lütfen.", true, wGui )
		addEventHandler( "onClientGUIClick", option[1], function()
			closeBankerInteraction()
			triggerServerEvent("bank:applyForNewATMCard", localPlayer)
		end, false )
		verticalPos = verticalPos + 1/numberOfButtons
		--LOCK CARD
		option[2] = guiCreateButton( 0.05, verticalPos, 0.9, 1/numberOfButtons, "ATM kartımı kaybettim\nUyarıları kilitli tutmak istiyorum, lütfen ($ 0)", true, wGui )
		addEventHandler( "onClientGUIClick", option[2], function()
			closeBankerInteraction()
			triggerServerEvent("bank:lockATMCard", localPlayer)
		end, false )
		verticalPos = verticalPos + 1/numberOfButtons
		--UNLOCK CARD
		option[3] = guiCreateButton( 0.05, verticalPos, 0.9, 1/numberOfButtons, "ATM kartımı buldum\nYeniden etkinleştirebilir misin lütfen? ($ 0)", true, wGui )
		addEventHandler( "onClientGUIClick", option[3], function()
			closeBankerInteraction()
			triggerServerEvent("bank:unlockATMCard", localPlayer)
		end, false )
		verticalPos = verticalPos + 1/numberOfButtons
		--RECOVER CARD
		option[4] = guiCreateButton( 0.05, verticalPos, 0.9, 1/numberOfButtons, "ATM Kartımı kurtarmam gerekiyor\nVe ayrıca bana PIN kodunu söyleyebilirseniz, harika olur (50 $)", true, wGui )
		addEventHandler( "onClientGUIClick", option[4], function()
			closeBankerInteraction()
			triggerServerEvent("bank:recoverATMCard", localPlayer)
		end, false )
		verticalPos = verticalPos + 1/numberOfButtons
		--DELETE CARD
		option[5] = guiCreateButton( 0.05, verticalPos, 0.9, 1/numberOfButtons, "ATM Kartımı iptal etmek istiyorum\nDaha sonra artık kullanmıyorum ($ 0)", true, wGui )
		addEventHandler( "onClientGUIClick", option[5], function()
			closeBankerInteraction()
			triggerServerEvent("bank:cancelATMCard", localPlayer)
		end, false )
		verticalPos = verticalPos + 1/numberOfButtons
		--CANCEL CARD
		option[6] = guiCreateButton( 0.05, verticalPos, 0.9, 1/numberOfButtons, "Ah, unut gitsin.", true, wGui )
		addEventHandler( "onClientGUIClick", option[6], function()
			closeBankerInteraction()
		end, false )
		verticalPos = verticalPos + 1/numberOfButtons
		triggerEvent("hud:convertUI", localPlayer, wGui)
	end
end
addEvent( "bank-system:bankerInteraction", true )
addEventHandler( "bank-system:bankerInteraction", getRootElement(), bankerInteraction )

function closeBankerInteraction()
	if wGui then
		destroyElement(wGui)
		wGui = nil
	end
	showCursor(false)
	setElementData(getLocalPlayer(), "exclusiveGUI", false, false)
end