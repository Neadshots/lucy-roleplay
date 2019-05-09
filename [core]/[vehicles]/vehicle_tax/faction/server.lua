local mysql = exports.mysql
local thePed = createPed(186, -14.3701171875, -141.31640625, 1043.9045410156, 180)
setElementDimension(thePed, 247)
setElementInterior(thePed, 18)
setElementRotation(thePed,  0, 0, 88.993347167969)
setElementFrozen(thePed, true)
setElementData(thePed, "talk", 1)
setElementData(thePed, "name", "Rick Nicholas")


function sVergiGUI(thePlayer)
	if thePlayer then
		source = thePlayer
	end
	local playerID = getElementData(source, "dbid")
	local factID = getElementData(source, "faction")
	dbQuery(
		function(qh, thePlayer)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				local playerVehs = {}
				for index, row in ipairs(res) do
					local vehicle = exports.pool:getElement("vehicle", row.id)
					local brand = getElementData(vehicle, "brand")
					local model = getElementData(vehicle, "maximemodel")
					local year = getElementData(vehicle, "year")
					local vergi = getElementData(vehicle, "toplamvergi") or 0
					table.insert(playerVehs, { row.id, year.." "..brand.." "..model, tonumber(vergi) })
				end
				triggerClientEvent(source, "vergi:VergiGUIf", source, playerVehs)
			end
		end,
	{thePlayer}, mysql:getConnection(), "SELECT * FROM vehicles WHERE faction = '"..factID.."' AND deleted=0")
end
addEvent("vergi:sVergiGUIf", true)
addEventHandler("vergi:sVergiGUIf", root, sVergiGUI)

function VergiOde(aracID, miktar)
	if aracID and miktar then
		local arac = exports.pool:getElement("vehicle", aracID)
		if arac then
			local vergi = getElementData(arac, "toplamvergi")
			if miktar > vergi then
				outputChatBox("[!] #f0f0f0Ödemeye çalıştığınız miktar aracın vergi borcundan fazladır.", source, 255, 0, 0, true)
				return false
			end
			-- if miktar < vergi then
				-- outputChatBox("[!] #f0f0f0Ödemeye çalıştığınız miktar aracın vergi borcuna yetmiyor.", source, 255, 0, 0, true)
				-- return false
			-- end
			local playerMoney = getElementData(source, "money")
			if not exports.global:hasMoney(source, miktar) then
				outputChatBox("[!] #f0f0f0Yeterli paranız olmadığından vergi borcunu ödeyemezsiniz.", source, 255, 0, 0, true)
				return false			
			end
			local kalanvergi = vergi - miktar
			if getElementData(arac, "faizkilidi") then -- eğer faizkilidi varsa
				if kalanvergi <= 0 then -- eğer kalan vergi 0 isElement
					setElementData(arac, "faizkilidi", false) -- faiz kaldır
				end
			end	
			setElementData(arac, "toplamvergi", kalanvergi)
			exports.global:takeMoney(source, miktar)
			outputChatBox("[!] #f0f0f0Toplam $" .. exports.global:formatMoney(miktar) .. " ödediniz. Aracınızın kalan vergi borcu: $" .. exports.global:formatMoney(kalanvergi), source, 0, 255, 0, true)
			triggerEvent("saveVehicle", arac, arac)
		end
	end
end
addEvent("vergi:VergiOdef", true)
addEventHandler("vergi:VergiOdef", root, VergiOde)