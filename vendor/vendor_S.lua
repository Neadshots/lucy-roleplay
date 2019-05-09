local vendors = {}
local requestTable = {}

local allowedVendors = {
	--[id] = {aktiflik, obje id, açıklama, kısaltma, fiyat}
	[1] = {true, 1340, "Sosisli Tezgahı", "sosisli", 15},
	[2] = {true, 1341, "Dondurma Tezgahı", "dondurma", 5},
	[3] = {true, 1342, "Çin Yemeği Tezgahı", "çin yemeği", 10}
}
-- eklenilecek..
local itemTable = {
	--["yemek ismi"] = {TEZGAH_ITEM_ID, YEMEK_ITEM_ID}
	["sosisli"] = {275, 1},
	["dondurma"] = {276, 241},
	["çin yemeği"] = {277, 240},
}

function createVendor(thePlayer, command, vendorID)
	local logged = getElementData(thePlayer, "loggedin")
	if not (logged==1) then return end

	local vendorID = tonumber(vendorID)
	if not vendorID or not type(vendorID) == "number" or not allowedVendors[vendorID] then 
		return outputChatBox("[!] #ffffffKullanım: /tezgahkur <tür> Tür listesi için /tezgahtür", thePlayer, 255, 0, 0, true)
	end
	
	local vendorName = tostring(allowedVendors[vendorID][4])
	if not (exports.global:hasItem(thePlayer, itemTable[vendorName][1])) then -- oyuncu tezgaha sahip mi?
		return outputChatBox("[!] #ffffffÖnce bir "..vendorName.." tezgahı satın alın.", thePlayer, 255, 0, 0, true)
	end

	if allowedVendors[vendorID][1] then
		if not vendors[thePlayer] then
			if isPedInVehicle(thePlayer) then return false end
			local x, y, z = getPositionInfront(thePlayer)
			local rotX, rotY, rotZ = getElementRotation(thePlayer)
			local dimension = getElementDimension(thePlayer)

			-- creating object..
			local objectID = allowedVendors[vendorID][2]
			local element = createObject(objectID, x, y, z)
			if not element then return outputChatBox("[!] #ffffffTezgah kurulamadı, tekrar deneyin.", thePlayer, 0, 255, 0, true) end
			-- dimension
			setElementDimension(element, dimension)
			
			setElementRotation(element,rotX,rotY,rotZ)
			-- vendor id
			local id = getVendorID()
			local text = createElement("text")
			setElementPosition(text, x, y, z)
			setElementData(text, "scale", 1.2)
			setElementData(text, "text", "#598ED7Tezgah "..id.."\n Sahip: #FFFFFF"..getPlayerName(thePlayer))

			setElementDimension(text, dimension)

			-- save vendor
			vendors[thePlayer] = {element = element, id = vendorID, text = text}

			setElementData(element, "owner", thePlayer)
			outputChatBox("[!] #ffffffTezgahınızı kurdunuz. Satışa başlayabilirsiniz. (/fastfood)", thePlayer, 0, 255, 0, true)
		else
			outputChatBox("[!] #ffffffÖnce kurduğunuz tezgahı kaldırmanız gerekiyor. (/tezgahkaldir)", thePlayer, 255, 0, 0, true)
		end
	end
end
addCommandHandler("tezgahkur", createVendor)

local itemx, itemy, itemz = 1352.3515625, -1759.037109375, 13.5078125
local satinalCol = createColSphere(itemx, itemy, itemz, 2)
local satinalPickup = createPickup(itemx,itemy,itemz, 3,2222)
setElementData(satinalPickup,"informationicon:information","/satinal tezgah (sosisli, dondurma, cin)")


function buyVendorForPlayer( player, commandName, type )
	if isElementWithinColShape(player, satinalCol) then
		if itemTable[type] then
			itemID = itemTable[type][1]
			if exports.global:takeMoney( player, 5000 ) then
				outputChatBox( "#A9C4E4 Sunucu: #b9c9bf Başarıyla bir tezgah satın aldınız, kurmak için /tezgahkur, kaldırmak için /tezgahkaldir.", player, 100, 255, 100, true )
				exports["item-system"]:giveItem(player, itemID, 1)
			else
				outputChatBox( '#A9C4E4 Sunucu: #b9c9bf Tezgah satın almak için 5.000 dolara ihtiyacın var.', player, 255, 100, 100, true )
			end
		else
			outputChatBox("Kullanım: #ffffff/satınal (TEZGAH ISMI (sosisli, dondurma))", thePlayer, 255, 194, 14, true)
		end
	end    
end
addCommandHandler("satinal", buyVendorForPlayer, false, false)
addCommandHandler("satınal", buyVendorForPlayer, false, false)


function getVendorID()
	local id = 1
	if type(vendors) == "table" then
		id = #vendors + 1
	end
	return id
end

function sellStuffs(thePlayer, command, buyer)
	local sellerPlayer = thePlayer

	if not vendors[sellerPlayer] then
		return outputChatBox("[!] #ffffffÖnce tezgah kurmalısınız. (/tezgahkur)", sellerPlayer, 255, 0, 0, true)
	end
	if not isPlayerNearObject(sellerPlayer, vendors[sellerPlayer].element) then 
		return outputChatBox("[!] #ffffffÖnce tezgahınızın yanına gidin.", sellerPlayer, 255, 0, 0, true)
	end
	if not buyer then
		return outputChatBox("[!] #ffffffKullanım: /fastfood <oyuncu adı>", sellerPlayer, 255, 0, 0, true)
	end

	local buyerPlayer = exports.global:findPlayerByPartialNick(sellerPlayer, buyer)
	if not isElement(buyerPlayer) then
		return outputChatBox("[!] #ffffffOyuncu bulunamadı.", sellerPlayer, 255, 0, 0, true)
	end
	if (thePlayer == buyerPlayer) then
		return outputChatBox("[!] #ffffffBu işlemi kendinize uygulayamazsınız.", sellerPlayer, 255, 0, 0, true)
	end
	if not isPlayerNearObject(buyerPlayer, vendors[sellerPlayer].element) then 
		return outputChatBox("[!] #ffffffOyuncu tezgahınızın yanında değil.", sellerPlayer, 255, 0, 0, true)
	end
	if requestTable[buyerPlayer] and isElement(requestTable[buyerPlayer][1]) then
		return outputChatBox("[!] #ffffffOyuncu zaten bir alışveriş yapıyor.", sellerPlayer, 255, 0, 0, true)
	end

	local vendorID = vendors[sellerPlayer].id
	local foodName = allowedVendors[vendorID][4]
	local foodPrice = allowedVendors[vendorID][5]
	-- defining the food data..
	local foodData = {name = foodName, price = foodPrice}

	requestTable[buyerPlayer] = {sellerPlayer, foodData}

	triggerClientEvent(buyerPlayer, "vendorSystem.showWindow", buyerPlayer, getPlayerName(sellerPlayer), foodData)
	outputChatBox("[!] #ffffffOyuncuya istek gönderildi.", sellerPlayer, 0, 0, 255, true)
end
addCommandHandler( "fastfood", sellStuffs)

function destroyVendor(thePlayer)
	if vendors[thePlayer] then
		if not isPlayerNearObject(thePlayer, vendors[thePlayer].element) then 
			return outputChatBox("[!] #ffffffÖnce tezgahınızın yanına gidin.", thePlayer, 255, 0, 0, true)
		end
		if isElement(vendors[thePlayer].element) then
			destroyElement(vendors[thePlayer].element)
		end
		if isElement(vendors[thePlayer].text) then
			destroyElement(vendors[thePlayer].text)
		end
		vendors[thePlayer] = nil
		outputChatBox("[!] #ffffffTezgahınızı kaldırdınız.", thePlayer, 0, 255, 0, true)
	end
end
addCommandHandler("tezgahkaldir", destroyVendor)
-- events
addEventHandler("onPlayerWasted", root, destroyVendor)
addEventHandler("onPlayerLogout", root, destroyVendor)
addEventHandler("onPlayerQuit", root, destroyVendor)
-- trigger
addEvent('vendorSystem.destroyVendor', true)
addEventHandler('vendorSystem.destroyVendor', root, destroyVendor)


function vendorTypes(thePlayer)
	for i, data in ipairs(allowedVendors) do
		outputChatBox(i..") "..data[3], thePlayer)
	end
end
addCommandHandler("tezgahtür", vendorTypes)

function completeSellingStuff(answer)
	local buyer = client
	if isElement(requestTable[buyer][1]) then
		local seller = requestTable[buyer][1]
		if isElement(buyer) and isElement(seller) and vendors[seller] then
			local foodPrice = requestTable[buyer][2].price
			local foodName = requestTable[buyer][2].name
			if tostring(answer) == "yes" then
				if exports.global:hasMoney(buyer, foodPrice) then
					local food_item_id = tonumber(itemTable[foodName][2])
					exports.global:takeMoney(buyer, foodPrice)
					exports.global:giveMoney(seller, foodPrice)
					exports.global:giveItem(buyer, 1, food_item_id)
					outputChatBox("[!] #ffffff"..getPlayerName(buyer)..", sizden $"..foodPrice.." karşılığında "..foodName.." satın aldı.", seller, 0, 0, 255, true)
					outputChatBox("[!] #ffffff"..getPlayerName(seller).." adlı kişiden $"..foodPrice.." karşılığında bir "..foodName.." satın aldınız.", buyer, 0, 0, 255, true)
				else
					outputChatBox("[!] #ffffff"..getPlayerName(buyer)..", parası yetmediği için sizden "..foodName.." satın alamadı.", seller, 255, 0, 0, true)
					outputChatBox("[!] #ffffffYemek satın almak için üstünüzde yeterli miktarda para bulunmamaktadır.", buyer, 255, 0, 0, true)
				end
				requestTable[buyer] = nil
			elseif tostring(answer) == "no" then
				outputChatBox("[!] #ffffff"..getPlayerName(buyer)..", sizden "..foodName.." satın almayı kabul etmedi.", seller, 255, 0, 0, true)
				requestTable[buyer] = nil
			end
		else
			outputChatBox("[!] #ffffff"..getPlayerName(seller)..", tezgahını kaldırdığı için "..foodName.." satın alamadınız.", seller, 255, 0, 0, true)
		end
	end
end
addEvent('vendorSystem.answer', true)
addEventHandler('vendorSystem.answer', root, completeSellingStuff)