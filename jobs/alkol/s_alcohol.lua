local miktar = 480
function pay(thePlayer)
	if getElementData(thePlayer, "vip") == 1 then
		miktar = 500
	elseif getElementData(thePlayer, "vip") == 2 then
		miktar = 530
	elseif getElementData(thePlayer, "vip") == 3 then
		miktar = 560
	end
	exports.global:giveMoney(thePlayer, miktar)
	outputChatBox("[!] #FFFFFFTebrikler, bu turdan $"..miktar.." kazandınız!", thePlayer, 0, 255, 0, true) -- 520
end
addEvent("alcohol:pay", true)
addEventHandler("alcohol:pay", getRootElement(), pay)

function stopJob(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	-- setElementPosition(thePlayer, 2579.0166015625, -2424.84765625, 13.635452270508)
	-- setElementRotation(thePlayer, 0, 0, 312.48065185547)
end
addEvent("alcohol:exitVeh", true)
addEventHandler("alcohol:exitVeh", getRootElement(), stopJob)