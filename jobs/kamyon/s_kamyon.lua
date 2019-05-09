local miktar = 430

function kamyonparaVer(thePlayer)
	if getElementData(thePlayer, "vip") == 1 then
		miktar = 450
	elseif getElementData(thePlayer, "vip") == 2 then
		miktar = 480
	elseif getElementData(thePlayer, "vip") == 3 then
		miktar = 510
	end
	exports.global:giveMoney(thePlayer, miktar)
	outputChatBox("[!] #FFFFFFTebrikler, bu turdan $"..miktar.." kazandınız!", thePlayer, 0, 255, 0, true) -- 520
end
addEvent("kamyonparaVer", true)
addEventHandler("kamyonparaVer", getRootElement(), kamyonparaVer)

function kamyonBitir(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setVehicleLocked(pedVeh, false)
	setElementPosition(thePlayer, 2215.3779296875, -2656.1875, 13.546875)
	setElementRotation(thePlayer, 0, 0, 270.43533325195)
end
addEvent("kamyonBitir", true)
addEventHandler("kamyonBitir", getRootElement(), kamyonBitir)