donatearaclar = { [502]=true,[503]=true,[411]=true,[494]=true,[451]=true,[458]=true,[542]=true,[540]=true,[418]=true,[496]=true,[490]=true}

addEventHandler("onClientVehicleStartEnter", root, function(player,seat,door)
	local myId = getElementData (localPlayer, "dbid")
	local aracSahibi = getElementData (source, "owner")
	
	if myId ~= aracSahibi then
		if (player == localPlayer and seat == 0) and (donatearaclar[getElementModel(source)]) and getElementData(source, "faction") == -1 then
		outputChatBox("#FF0000[!]".."#ffffff Özel aracın sahibi olmadığın için araca binemezsin.",255,255,255,true)
		cancelEvent()
		end
	end	
end)
