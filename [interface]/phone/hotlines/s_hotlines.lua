function routeHotlineCall(callingElement, callingPhoneNumber, outboundPhoneNumber, startingCall, message)
local callprogress = getElementData(callingElement, "callprogress")	
	if callingPhoneNumber == 911 then
		if startingCall then
			outputChatBox("[!] #90a3b6LSPD Operator [Telefon]: LSPD Hattı, konumunuzu belirtin.", callingElement, 0, 125, 250, true)
			exports.anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports.anticheat:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports.anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("[!] #90a3b6LSPD Operatorü [Telefon]: Evet, size nasıl yardımcı olabilirim?", callingElement, 0, 125, 250, true)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("[!] #90a3b6LSPD Operatorü [Telefon]: Aradığınız için teşekkürler, bir birimi yönlendiriyoruz.", callingElement, 0, 125, 250, true)
				local location = getElementData(callingElement, "call.location")

				local affectedElements = { }

				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Los Santos Police Department" ) ) ) do
					for _, itemRow in ipairs(exports['item-system']:getItems(value)) do
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end

				for _, player in ipairs(getPlayersInTeam(getTeamFromName("Los Santos Police Department")) or getPlayersInTeam(getTeamFromName("San Andreas Highway Patrol"))) do
				
					outputChatBox("[TELSIZ] Arayan kişinin numarası " .. outboundPhoneNumber .. " departmana iletilmiştir.", player, 0, 125, 255)
					outputChatBox("[TELSIZ] Açıklama: '" .. message .. "'.", player, 0, 125, 255)
					outputChatBox("[TELSIZ] Lokasyon: '" .. tostring(location) .. "'.", player, 0, 125, 255)
				end
				for _, player in ipairs(getPlayersInTeam(getTeamFromName("San Andreas Sheriff Department")) ) do
				
					outputChatBox("[TELSIZ] Arayan kişinin numarası " .. outboundPhoneNumber .. " departmana iletilmiştir.", player, 0, 125, 255)
					outputChatBox("[TELSIZ] Açıklama: '" .. message .. "'.", player, 0, 125, 255)
					outputChatBox("[TELSIZ] Lokasyon: '" .. tostring(location) .. "'.", player, 0, 125, 255)
				end
				triggerEvent("phone:cancelPhoneCall", callingElement)
				--triggerEvent("phone:cancelPhoneCall", callingElement)
			end
		end
	elseif callingPhoneNumber == 411 then
		if startingCall then
			outputChatBox("[!] #E67B9DLSFMD Operator [Telefon]: LSFMD Hattı, konumunuzu belirtin.", callingElement, 137, 0, 44, true)
			exports.anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports.anticheat:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports.anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("[!] #E67B9DLSFMD Operatorü [Telefon]: Evet, size nasıl yardımcı olabilirim?", callingElement, 137, 0, 44, true)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("[!] #E67B9DLSFMD Operatorü [Telefon]: Aradığınız için teşekkürler, bir birimi yönlendiriyoruz.", callingElement, 137, 0, 44, true)
				local location = getElementData(callingElement, "call.location")

				local affectedElements = { }

				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Los Santos Medical Department" ) ) ) do
					for _, itemRow in ipairs(exports['item-system']:getItems(value)) do
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end

				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Los Santos Fire Department" ) ) ) do
					for _, itemRow in ipairs(exports['item-system']:getItems(value)) do
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end

				for _, player in ipairs(getPlayersInTeam(getTeamFromName("Los Santos Medical Department"))) do
				
					outputChatBox("[TELSIZ] Arayan kişinin numarası #" .. outboundPhoneNumber .. " departmana iletilmiştir.", player, 230, 123, 157)
					outputChatBox("[TELSIZ] Açıklama: '" .. message .. "'.", player, 230, 123, 157)
					outputChatBox("[TELSIZ] Lokasyon: '" .. tostring(location) .. "'.", player, 230, 123, 157)
				end
				for _, player in ipairs(getPlayersInTeam(getTeamFromName("Los Santos Fire Department"))) do
				
					outputChatBox("[TELSIZ] Arayan kişinin numarası #" .. outboundPhoneNumber .. " departmana iletilmiştir.", player, 230, 123, 157)
					outputChatBox("[TELSIZ] Açıklama: '" .. message .. "'.", player, 230, 123, 157)
					outputChatBox("[TELSIZ] Lokasyon: '" .. tostring(location) .. "'.", player, 230, 123, 157)
				end
				triggerEvent("phone:cancelPhoneCall", callingElement)
				--triggerEvent("phone:cancelPhoneCall", callingElement)
			end
		end
	elseif callingPhoneNumber == 611 then
		if startingCall then
			outputChatBox("SASD Operator [Cellphone]: SASD Hotline. Please state your location.", callingElement)
			exports.anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports.anticheat:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports.anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("SASD Operator [Cellphone]: Can you please describe the reason for your call?", callingElement)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("SASD Operator [Cellphone]: Thanks for your call, we've dispatched a unit to your location.", callingElement)
				local location = getElementData(callingElement, "call.location")

				local affectedElements = { }

				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "San Andreas Highway Patrol" ) ) ) do
					for _, itemRow in ipairs(exports['item-system']:getItems(value)) do
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end

				for key, value in ipairs( affectedElements ) do
					outputChatBox("[RADIO] This is dispatch, We've got a report from #" .. outboundPhoneNumber .. " via the non-emergency line.", value, 245, 40, 135)
					outputChatBox("[RADIO] Reason: '" .. message .. "'.", value, 245, 40, 135)
					outputChatBox("[RADIO] Location: '" .. tostring(location) .. "'.", value, 245, 40, 135)
				end
				triggerEvent("phone:cancelPhoneCall", callingElement)
				triggerEvent("phone:cancelPhoneCall", callingElement)
			end
		end
	elseif callingPhoneNumber == 999999999999999999 then
		if startingCall then
			--outputChatBox("Operator [Cellphone]: LSFD Hotline. Please state your location.", callingElement)
			outputChatBox("[!] #E67B9DLSFD Operatorü [Telefon]: Evet, size nasıl yardımcı olabilirim?", callingElement, 137, 0, 44, true)
			exports.anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports.anticheat:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports.anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("Operator [Cellphone]: Arama sebebiniz nedir?", callingElement)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("Operator [Cellphone]: Aramanız için teşekkürler, en kısa sürede size ulaşacağız..", callingElement)
				local location = getElementData(callingElement, "call.location")

				local affectedElements = { }

				for key, value in ipairs( getPlayersInTeam( getTeamFromName("Los Santos Fire Department") ) ) do
					for _, itemRow in ipairs(exports['item-system']:getItems(value)) do
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end
				for key, value in ipairs( affectedElements ) do
					outputChatBox("[RADIO] This is dispatch, We've got a report from #" .. outboundPhoneNumber .. " via the non-emergency line, over.", value, 245, 40, 135)
					outputChatBox("[RADIO] Reason: '" .. message .. "', over.", value, 245, 40, 135)
					outputChatBox("[RADIO] Location: '" .. tostring(location) .. "', out.", value, 245, 40, 135)
				end
				--triggerEvent("phone:cancelPhoneCall", callingElement)
				triggerEvent("phone:cancelPhoneCall", callingElement)
			end
		end
	elseif callingPhoneNumber == 511 then
		if startingCall then
			outputChatBox("Gov Employee [Cellphone]: Government of Los Santos. How can we help you?", callingElement)
			exports.anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			outputChatBox("Gov Employee [Cellphone]: Thanks for your call.", callingElement)

			local affectedElements = { }

			for key, value in ipairs( getPlayersInTeam( getTeamFromName("Government of Los Santos") ) ) do
				for _, itemRow in ipairs(exports['item-system']:getItems(value)) do
					local setIn = false
					if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
						table.insert(affectedElements, value)
						setIn = true
						break
					end
				end
			end
			for key, value in ipairs( affectedElements ) do
				outputChatBox("[RADIO] We got a message from #" .. outboundPhoneNumber .. ".", value, 245, 40, 135)
				outputChatBox("[RADIO] Reason: '" .. message .. "', over.", value, 245, 40, 135)
			end
			--triggerEvent("phone:cancelPhoneCall", callingElement)
			triggerEvent("phone:cancelPhoneCall", callingElement)
		end
	
	elseif callingPhoneNumber == 9021 then
		if startingCall then
			local foundtow = false
			for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
				local faction = getElementData(value, "faction")
				if (faction == 4) then
					foundtow = true
				end
			end

			if foundtow == true then
			outputChatBox("Operator [Cellphone]: You've called Rapid Towing. Please state your name.", callingElement)
			exports.anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
			else
			outputChatBox("Operator [Cellphone]: Sorry, there are no units available. Call back later.", callingElement)
			outputChatBox("They hung up.", callingElement )
			--triggerEvent("phone:cancelPhoneCall", callingElement)
			triggerEvent("phone:cancelPhoneCall", callingElement)
			end
		else
			if (callprogress==1) then -- Requesting the location
				exports.anticheat:changeProtectedElementDataEx(callingElement, "call.name", message)
				exports.anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 2)
				outputChatBox("Operator [Cellphone]: Can you describe the situation please?", callingElement)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("Operator [Cellphone]: Thanks for your call, we've dispatched a unit to your location.", callingElement)
				local zonelocation = exports.global:getElementZoneName(callingElement)
				local streetlocation = getElementData(callingElement, "speedo:street")
				local name = getElementData(callingElement, "call.name")

				local affectedElements = { }

				for key, value in ipairs( getElementsByType("player") ) do
					if getElementData(value, "faction") == 4 then -- Tay Tow
						for _, itemRow in ipairs(exports['item-system']:getItems(value)) do
							local setIn = false
							if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
								table.insert(affectedElements, value)
								setIn = true
								break
							end
						end
					end
				end

				for key, value in ipairs( affectedElements ) do
					outputChatBox("[RADIO] This is dispatch, we've got an incident report from ".. name .." #" .. outboundPhoneNumber .. ", Over.", value, 0, 183, 239)
					outputChatBox("[RADIO] Situation: '" .. message .. "', Over.", value, 0, 183, 239)
					if streetlocation then
						outputChatBox("[RADIO] Location: '" .. streetlocation .. " in ".. zonelocation .. "', out.", value, 0, 183, 239)
					else
						outputChatBox("[RADIO] Location: '".. zonelocation .. "', out.", value, 0, 183, 239)
					end
				end
				--triggerEvent("phone:cancelPhoneCall", callingElement)
				triggerEvent("phone:cancelPhoneCall", callingElement)
			end
		end
	elseif callingPhoneNumber == 8294 then
		if startingCall then
			outputChatBox("Taxi Operator [Telefon]: Yellow Cab Company buyrun, nerede taksiye ihtiyacınız var?", callingElement)
			exports.anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			local founddriver = false
			for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
				local job = getElementData(value, "job")
				if (job == 2) then
					local car = getPedOccupiedVehicle(value)
					if car and (getElementModel(car)==438 or getElementModel(car)==420) then
						outputChatBox("[RADIO] Taxi Operator diyor ki: Tüm birimlerin dikkatine, " .. outboundPhoneNumber .. " numarasından taksi isteniyor. Verilen adres: " .. message .."." , value, 0, 183, 239)
						founddriver = true
					end
				end
			end

			if founddriver == true then
				outputChatBox("Taxi Operator [Telefon]: Pekala, hemen bir taksi gönderiyoruz.", callingElement)
			else
				outputChatBox("Taxi Operator [Telefon]: Malesef şu an uygun taksicimiz yok. Daha sonra tekrar arayabilirsiniz.", callingElement)
			end
			--triggerEvent("phone:cancelPhoneCall", callingElement)
			triggerEvent("phone:cancelPhoneCall", callingElement)
		end
	elseif callingPhoneNumber == 2552 then
		if startingCall then
			outputChatBox("RS Haul Operator [Cellphone]: RS Haul here. Please state your location.", callingElement)
			exports.anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			local founddriver = false
			for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
				local job = getElementData(value, "job")
				local hasPhone = exports.global:hasItem(value, 2)
				if (job == 1) and hasPhone then
					--local car = getPedOccupiedVehicle(value)
					outputChatBox("SMS from RS Haul: A customer has ordered a delivery at '" .. message .."'. Please contact #".. outboundPhoneNumber .." for details.", value, 120, 255, 80)
					founddriver = true
				end
			end

			if founddriver == true then
				outputChatBox("RS Haul Operator [Cellphone]: Thanks for your call, a truck of goods will be coming shortly.", callingElement)
			else
				outputChatBox("RS Haul Operator [Cellphone]: There is no trucker available at the moment, please try again later.", callingElement)
			end
			--triggerEvent("phone:cancelPhoneCall", callingElement)
			triggerEvent("phone:cancelPhoneCall", callingElement)
		end
	elseif callingPhoneNumber == 7331 then -- LSN Ads
		if startingCall then
			outputChatBox( "LSN Worker [Cellphone]: You can now access this service online!", callingElement )
			outputChatBox( "(( Please use /advertisements ))", callingElement, 255, 255, 255 )
			--[[
			outputChatBox("LSN Worker [Cellphone]: Thanks for calling the ad broadcasting service. What can we air for you?", callingElement)
			exports.anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if getElementData(callingElement, "adminjailed") then
				outputChatBox("LSN Worker [Cellphone]: Err.. Sorry. We're broadcasting too many ads during this timeslot. Try again later.", callingElement)
				triggerEvent("phone:cancelPhoneCall", callingElement)
				return
			end
			if (getElementData(callingElement, "ads") or 0) >= 2 then
				outputChatBox("LSN Worker [Cellphone]: Again you?! You can only place 2 ads every 5 minutes.", callingElement)
				triggerEvent("phone:cancelPhoneCall", callingElement)
				return
			end

			if message:sub(-1) ~= "." and message:sub(-1) ~= "?" and message:sub(-1) ~= "!" then
				message = message .. "."
			end

			if SAN_doesAdExist(message) then
				outputChatBox("LSN Worker [Cellphone]: Not this again...", callingElement)
				triggerEvent("phone:cancelPhoneCall", callingElement)
				return
			end

			local cost = math.ceil(string.len(message)/5) + 10
			if not exports.bank:updateBankMoney(callingElement, getElementData(callingElement, 'dbid'), cost, 'minus') then
				outputChatBox("LSN Worker [Cellphone]: We were unable to withdraw the money from your bank account.", callingElement)
				triggerEvent("phone:cancelPhoneCall", callingElement)

				return
			end

			local name = getPlayerName(callingElement):gsub("_", " ")
			outputChatBox("LSN Worker [Cellphone]: Thanks, " .. cost .. " dollar will be withdrawn from your account. We'll air it as soon as possible!", callingElement)
			exports.anticheat:changeProtectedElementDataEx(callingElement, "ads", ( getElementData(callingElement, "ads") or 0 ) + 1, false)
			exports.global:giveMoney(getTeamFromName"Los Santos Network", cost)
			setTimer(
				function(p)
					if isElement(p) then
						local c =  getElementData(p, "ads") or 0
						if c > 1 then
							exports.anticheat:changeProtectedElementDataEx(p, "ads", c-1, false)
						else
							exports.anticheat:changeProtectedElementDataEx(p, "ads", false, false)
						end
					end
				end, 300000, 1, callingElement
			)

			SAN_newAdvert(message, name, callingElement, cost, outboundPhoneNumber)
			]]
			triggerEvent("phone:cancelPhoneCall", callingElement)
			
		end
	elseif callingPhoneNumber == 7332 then -- LSN Hotline
		if startingCall then
			outputChatBox("LSN Worker [Cellphone]: Thanks for calling LSN. What message can I give through to our reporters?", callingElement)
			exports.anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			local languageslot = getElementData(callingElement, "languages.current")
			local language = getElementData(callingElement, "languages.lang" .. languageslot)
			local languagename = call(getResourceFromName("language-system"), "getLanguageName", language)
			if getElementData(callingElement, "adminjailed") then
				outputChatBox("LSN Worker [Cellphone]: Thanks for the message, we'll contact you back if needed.", callingElement)
			else
				outputChatBox("LSN Worker [Cellphone]: Thanks for the message, we'll contact you back if needed.", callingElement)

				for key, value in ipairs( getPlayersInTeam(getTeamFromName("Los Santos Network")) ) do
					local hasItem, index, number, dbid = exports.global:hasItem(value,2)
					if hasItem then
						local reconning2 = getElementData(value, "reconx")
						if not reconning2 then
							exports.global:sendLocalMeAction(value,"receives a text message.")
						end

						outputChatBox("[" .. languagename .. "] SMS from #7332 [#"..number.."]: Ph:".. outboundPhoneNumber .." " .. message, value, 120, 255, 80)
					end
				end
				triggerEvent("phone:cancelPhoneCall", callingElement)
			end
		end
	elseif callingPhoneNumber == 5555 then -- FAA Hotline
		if startingCall then
			outputChatBox("Operator [Cellphone]: You've reached the Federal Aviation Administration. How may we help you?", callingElement)
			exports.anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			local languageslot = getElementData(callingElement, "languages.current")
			local language = getElementData(callingElement, "languages.lang" .. languageslot)
			local languagename = call(getResourceFromName("language-system"), "getLanguageName", language)
			if getElementData(callingElement, "adminjailed") then
				outputChatBox("Operator [Cellphone]: Thanks for the message, we'll contact you back if needed.", callingElement)
			else
				outputChatBox("Operator [Cellphone]: Thanks for the message, we'll contact you back if needed.", callingElement)

				for key, value in ipairs( getPlayersInTeam(getTeamFromName("Federal Aviation Administration")) ) do
					local hasItem, index, number, dbid = exports.global:hasItem(value,2)
					if hasItem then
						local reconning2 = getElementData(value, "reconx")
						if not reconning2 then
							exports.global:sendLocalMeAction(value,"receives a text message.")
						end

						outputChatBox("[" .. languagename .. "] SMS from #5555 [#"..number.."]: Ph:".. outboundPhoneNumber .." " .. message, value, 120, 255, 80)
					end
				end
				triggerEvent("phone:cancelPhoneCall", callingElement)
			end
		end
	elseif callingPhoneNumber == 211 then -- Los Santos Courts
		if startingCall then
			outputChatBox("Operator [Cellphone]: Superior Court of San Andreas, please state your name.", callingElement)
			exports.anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the name
				exports.anticheat:changeProtectedElementDataEx(callingElement, "call.name", message, false)
				exports.anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("Operator [Cellphone]: What do you require?", callingElement)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("Operator [Cellphone]: Thanks for calling us, we'll get back to you as soon as possible.", callingElement)
				local name = getElementData(callingElement, "call.name")
				local affectedElements = { }

				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Superior Court of San Andreas" ) ) ) do
					for _, itemRow in ipairs(exports['item-system']:getItems(value)) do
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end

				for key, value in ipairs( affectedElements ) do
					outputChatBox("[RADIO] This is dispatch, We've got a report from #" .. outboundPhoneNumber .. " via the hotline, over.", value, 245, 40, 135)
					outputChatBox("[RADIO] Request: '" .. message .. "', over.", value, 245, 40, 135)
					outputChatBox("[RADIO] From: '" .. tostring(name) .. "', out.", value, 245, 40, 135)
				end
				triggerEvent("phone:cancelPhoneCall", callingElement)
			end
		end
	elseif callingPhoneNumber == 7233 then -- Cargo Group
		if startingCall then
			outputChatBox("Receptionist [Cellphone]: You've reached Cargo Group. Please state your name and message.", callingElement)
			exports.anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			local languageslot = getElementData(callingElement, "languages.current")
			local language = getElementData(callingElement, "languages.lang" .. languageslot)
			local languagename = call(getResourceFromName("language-system"), "getLanguageName", language)
			if getElementData(callingElement, "adminjailed") then
				outputChatBox("Receptionist [Cellphone]: Uh, right.", callingElement)
			else
				outputChatBox("Receptionist [Cellphone]: One of our employees will contact you shortly.", callingElement)
				local affectedElements = { }
				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Cargo Group" ) ) ) do
					local hasItem, index, number, dbid = exports.global:hasItem(value, 2)
					if hasItem then
						local reconning2 = getElementData(value, "reconx")
						if not reconning2 then
							exports.global:sendLocalMeAction(value,"receives a text message.")
						end
						outputChatBox("[" .. languagename .. "] SMS from Cargo group [#"..number.."]: INQUIRY | Ph: ".. outboundPhoneNumber .." | Message: " .. message, value, 0, 200, 255)
					end
				end
				triggerEvent("phone:cancelPhoneCall", callingElement)
			end
		end
	elseif callingPhoneNumber == 8800 then -- SAPT Hotline
		if startingCall then
			outputChatBox("Operator [Cellphone]: You've reached the San Andreas Public Transport company. How may we help you?", callingElement)
			exports.anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			local languageslot = getElementData(callingElement, "languages.current")
			local language = getElementData(callingElement, "languages.lang" .. languageslot)
			local languagename = call(getResourceFromName("language-system"), "getLanguageName", language)
			if getElementData(callingElement, "adminjailed") then
				outputChatBox("Operator [Cellphone]: Thanks for the message, we'll contact you back if needed.", callingElement)
			else
				outputChatBox("Operator [Cellphone]: Thanks for the message, we'll contact you back if needed.", callingElement)

				for key, value in ipairs( getPlayersInTeam(getTeamFromName("San Andreas Public Transport")) ) do
					local hasItem, index, number, dbid = exports.global:hasItem(value,2)
					if hasItem then
						local reconning2 = getElementData(value, "reconx")
						if not reconning2 then
							exports.global:sendLocalMeAction(value,"receives a text message.")
						end

						outputChatBox("[" .. languagename .. "] SMS from #8800 [#"..number.."]: Ph:".. outboundPhoneNumber .." " .. message, value, 120, 255, 80)
					end
				end
				triggerEvent("phone:cancelPhoneCall", callingElement)
			end
		end
	else
		--do nothing
	end
end

--[[function broadcastSANAd(name, message)
	exports.logs:logMessage("ADVERT: " .. message, 2)
	for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
		if (getElementData(value, "loggedin")==1 and not getElementData(value, "disableAds")) then
			if exports.integration:isPlayerTrialAdmin(value) then
				outputChatBox("   ADVERT: " .. message .. " ((" .. name .. "))", value, 0, 255, 64)
			else
				outputChatBox("   ADVERT: " .. message , value, 0, 255, 64)
			end
		end
	end
end]]

function log911( message )
	local logMeBuffer = getElementData(getRootElement(), "911log") or { }
	local r = getRealTime()
	table.insert(logMeBuffer,"["..("%02d:%02d"):format(r.hour,r.minute).. "] " ..  message)
	
	if #logMeBuffer > 30 then
		table.remove(logMeBuffer, 1)
	end
	setElementData(getRootElement(), "911log", logMeBuffer)
end

function read911Log(thePlayer)
	local theTeam = getPlayerTeam(thePlayer)
	local factiontype = getElementData(theTeam, "type")
	if exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer) then
		local logMeBuffer = getElementData(getRootElement(), "911log") or { }
		outputChatBox("Recent 911 calls:", thePlayer)
		for a, b in ipairs(logMeBuffer) do
			outputChatBox("- "..b, thePlayer)
		end
		outputChatBox("  END", thePlayer)
	end
end
addCommandHandler("show911", read911Log)

function checkService(callingElement)
	t = { "both",
		  "pd",
		  "police",
		  "lspd",
		  "sahp",
		  "sasd", -- PD ends here
		  "es",
		  "medic",
		  "ems",
		  "lsfd",
	}
	local found = false
	for row, names in ipairs(t) do
		if names == string.lower(getElementData(callingElement, "call.service")) then
			if row == 1 then
				local found = true
				return 1 -- Both!
			elseif row >= 2 and row <= 6 then
				local found = true
				return 2 -- Just the PD please
			elseif row >= 7 and row <= 10 then
				local found = true
				return 3 -- ES
			end
		end
	end
	if not found then
		return 4 -- Not found!
	end
end
