local miktar = 600
function tirparaVer(thePlayer)
	if getElementData(thePlayer, "vip") == 1 then
		miktar = 620
	elseif getElementData(thePlayer, "vip") == 2 then
		miktar = 650
	elseif getElementData(thePlayer, "vip") == 3 then
		miktar = 680
	end
	exports.global:giveMoney(thePlayer, miktar)
	outputChatBox("[!] #FFFFFFTebrikler, bu turdan $"..miktar.." kazandınız!", thePlayer, 0, 255, 0, true) -- 520
end
addEvent("tirparaVer", true)
addEventHandler("tirparaVer", getRootElement(), tirparaVer)

function tirBitir(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setVehicleLocked(pedVeh, false)
	setElementPosition(thePlayer, 2273.498046875, -2348.6064453125, 13.546875)
	setElementRotation(thePlayer, 0, 0, 316)
end
addEvent("tirBitir", true)
addEventHandler("tirBitir", getRootElement(), tirBitir)

function dorseOlustur()
	local vehShopData = exports["vehicle_manager"]:getInfoFromVehShopID(1012)
	local veh = createVehicle(435, 2267.8115234375, -2401.49609375, 14.040822982788, 0, 0, 312.48352050781)
	exports.anticheat:changeProtectedElementDataEx(veh, "dbid", -1, true)
	exports.anticheat:changeProtectedElementDataEx(veh, "fuel", exports["fuel-system"]:getMaxFuel(veh), false)
	exports.anticheat:changeProtectedElementDataEx(veh, "plate", "TIR", true)
	exports.anticheat:changeProtectedElementDataEx(veh, "Impounded", 0)
	exports.anticheat:changeProtectedElementDataEx(veh, "engine", 0, false)
	exports.anticheat:changeProtectedElementDataEx(veh, "oldx", x, false)
	exports.anticheat:changeProtectedElementDataEx(veh, "oldy", y, false)
	exports.anticheat:changeProtectedElementDataEx(veh, "oldz", z, false)
	exports.anticheat:changeProtectedElementDataEx(veh, "faction", -1)
	exports.anticheat:changeProtectedElementDataEx(veh, "job", 6, false)
	exports.anticheat:changeProtectedElementDataEx(veh, "handbrake", 0, true)
	exports.anticheat:changeProtectedElementDataEx(veh, "tirMeslek", 1, true)
	
	exports.anticheat:changeProtectedElementDataEx(veh, "brand", vehShopData.vehbrand, true)
	exports.anticheat:changeProtectedElementDataEx(veh, "maximemodel", vehShopData.vehmodel, true)
	exports.anticheat:changeProtectedElementDataEx(veh, "year", vehShopData.vehyear, true)
	exports.anticheat:changeProtectedElementDataEx(veh, "vehicle_shop_id", vehShopData.id, true)
	
	return veh
end
addEvent("tir:dorseOlustur", true)
addEventHandler("tir:dorseOlustur", root, dorseOlustur)


function dorseOlustur2()
	local vehShopData = exports["vehicle_manager"]:getInfoFromVehShopID(1012)
	local veh = createVehicle(435, -1687.44921875, 25.59375, 4.0749635696411, 0, 0, 47.428588867188)
	exports.anticheat:changeProtectedElementDataEx(veh, "dbid", -1, true)
	exports.anticheat:changeProtectedElementDataEx(veh, "fuel", exports["fuel-system"]:getMaxFuel(veh), false)
	exports.anticheat:changeProtectedElementDataEx(veh, "plate", "TIR", true)
	exports.anticheat:changeProtectedElementDataEx(veh, "Impounded", 0)
	exports.anticheat:changeProtectedElementDataEx(veh, "engine", 0, false)
	exports.anticheat:changeProtectedElementDataEx(veh, "oldx", x, false)
	exports.anticheat:changeProtectedElementDataEx(veh, "oldy", y, false)
	exports.anticheat:changeProtectedElementDataEx(veh, "oldz", z, false)
	exports.anticheat:changeProtectedElementDataEx(veh, "faction", -1)
	exports.anticheat:changeProtectedElementDataEx(veh, "job", 6, false)
	exports.anticheat:changeProtectedElementDataEx(veh, "handbrake", 0, true)
	exports.anticheat:changeProtectedElementDataEx(veh, "tirMeslek", 1, true)
	
	exports.anticheat:changeProtectedElementDataEx(veh, "brand", vehShopData.vehbrand, true)
	exports.anticheat:changeProtectedElementDataEx(veh, "maximemodel", vehShopData.vehmodel, true)
	exports.anticheat:changeProtectedElementDataEx(veh, "year", vehShopData.vehyear, true)
	exports.anticheat:changeProtectedElementDataEx(veh, "vehicle_shop_id", vehShopData.id, true)
	
	return veh
end
addEvent("tir:dorseOlustur2", true)
addEventHandler("tir:dorseOlustur2", root, dorseOlustur2)


function dorseSil()
	if getElementData(source, "tirMeslek") == 1 then
		destroyElement(source)
	end
end
addEventHandler("onTrailerDetach", getRootElement(), dorseSil)