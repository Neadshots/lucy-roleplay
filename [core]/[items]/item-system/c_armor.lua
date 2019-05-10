local last

--[[function onRender()
	if not last then
		last = math.ceil(tonumber(getPedArmor( localPlayer )))
	end
	if last ~= math.ceil(getPedArmor( localPlayer )) then -- ARMOR EKSİK
		--print("ARMOR DEĞİŞİMİ: "+(last-getPedArmor(localPlayer)))
		triggerServerEvent( "items.updateArmor", localPlayer, getPedArmor( localPlayer ) )
	end
end
addEventHandler("onClientRender",root,onRender)--]]