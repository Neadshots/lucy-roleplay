function trashparaVer(thePlayer)
	exports.global:giveMoney(thePlayer, 325)
	outputChatBox("[!] #FFFFFFTebrikler, bu turdan $325 kazandınız!", thePlayer, 0, 255, 0, true)
end
addEvent("trashparaVer", true)
addEventHandler("trashparaVer", getRootElement(), trashparaVer)

function trashBitir(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setElementPosition(thePlayer, 1661.994140625, -1882.75, 13.546875)
	setElementRotation(thePlayer, 0, 0, 270.43533325195)
end
addEvent("trashBitir", true)
addEventHandler("trashBitir", getRootElement(), trashBitir)