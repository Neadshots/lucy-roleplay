local miktar = 420

function cpay(thePlayer)
	if getElementData(thePlayer, "vip") == 1 then
		miktar = 440
	elseif getElementData(thePlayer, "vip") == 2 then
		miktar = 470
	elseif getElementData(thePlayer, "vip") == 3 then
		miktar = 500
	end
	exports.global:giveMoney(thePlayer, miktar)
	outputChatBox("[!] #FFFFFFTebrikler, bu turdan $"..miktar.." kazandınız!", thePlayer, 0, 255, 0, true) -- 520
end
addEvent("cigar:pay", true)
addEventHandler("cigar:pay", getRootElement(), cpay)

function cstopJob(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setElementPosition(thePlayer, 2455.34765625, -2643.5400390625, 13.662845611572)
	setElementRotation(thePlayer, 0, 0, 267.11743164063)
end
addEvent("cigar:exitVeh", true)
addEventHandler("cigar:exitVeh", getRootElement(), cstopJob)