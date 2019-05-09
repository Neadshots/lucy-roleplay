--MAXIME
local vehiculars = { }
local localPlayer = getLocalPlayer()
local viewDistance = 20
local heightOffset = 1.4
local refreshingInterval = 1
local showing = false
local timerRefresh = nil
local BizNoteFont18 = dxCreateFont ( "BizNote.ttf" , 18 )
local fonte = dxCreateFont ( "font.ttf" , 18 )
local plakaFont = dxCreateFont(":hud/nametags0.ttf", 15)
--local font = dxCreateFont ( "awesome.ttf" , 10 )

local noPlateVehs = {
	[481] = "BMX",
	[509] = "Bike",
	[510] = "Mountain Bike",
}

function bindVD()
	bindKey ( "ralt", "down", togglePinVD )
	addEventHandler("onClientRender", getRootElement(), showText)
end
addEventHandler ( "onClientResourceStart", resourceRoot, bindVD )

function removeVD ( key, keyState )
	--local enableOverlayDescription = getElementData(localPlayer, "enableOverlayDescription")
	--local enableOverlayDescriptionVeh = getElementData(localPlayer, "enableOverlayDescriptionVeh")
	--if enableOverlayDescription ~= "0" and enableOverlayDescriptionVeh ~= "0" then
		local enableOverlayDescriptionVehPin = getElementData(localPlayer, "enableOverlayDescriptionVehPin")
		if enableOverlayDescriptionVehPin == "1" then
			return false
		end
		if showing then
			--removeEventHandler ( "onClientRender", getRootElement(), showText )
			showing = false
		end
	--end
end

function showNearbyVehicleDescriptions()
	local enableOverlayDescription = getElementData(localPlayer, "enableOverlayDescription")
	local enableOverlayDescriptionVeh = getElementData(localPlayer, "enableOverlayDescriptionVeh")
	if enableOverlayDescription ~= "0" and enableOverlayDescriptionVeh ~= "0" then
		local enableOverlayDescriptionVehPin = getElementData(localPlayer, "enableOverlayDescriptionVehPin")
		if enableOverlayDescriptionVehPin == "1" then
			if showing then
				--removeEventHandler ( "onClientRender", getRootElement(), showText )
				showing = false
			end
		end
		
		if not showing then
			for index, nearbyVehicle in ipairs( exports.global:getNearbyElements(getLocalPlayer(), "vehicle") ) do
				if isElement(nearbyVehicle) then
					vehiculars[index] = nearbyVehicle
				end
			end
			
			showing = true
		end
	end
end

function togglePinVD()
	local enableOverlayDescription = getElementData(localPlayer, "enableOverlayDescription")
	local enableOverlayDescriptionVeh = getElementData(localPlayer, "enableOverlayDescriptionVeh")
	if enableOverlayDescription ~= "0" and enableOverlayDescriptionVeh ~= "0" then
		local enableOverlayDescriptionVehPin = getElementData(localPlayer, "enableOverlayDescriptionVehPin")
		if enableOverlayDescriptionVehPin == "1" then
			setElementData(localPlayer, "enableOverlayDescriptionVehPin", "0")
			--exports.hud:sendBottomNotification(localPlayer, "Property Description", "You have UNPINED property description from your screen.")
			--exports.account:appendSavedData("enableOverlayDescriptionVehPin", "0")
			if isTimer(timerRefresh) then
				killTimer(timerRefresh)
				timerRefresh = nil
			end
			if showing then
				--removeEventHandler ( "onClientRender", getRootElement(), showText )
				showing = false
			end
		else
			setElementData(localPlayer, "enableOverlayDescriptionVehPin", "1")
			--exports.hud:sendBottomNotification(localPlayer, "Property Description", "You have PINED property description on your screen.")
			--exports.account:appendSavedData("enableOverlayDescriptionVehPin", "1")
			
			timerRefresh = setTimer(refreshNearByVehs, 1000*refreshingInterval, 0)
			
			if not showing then
				for index, nearbyVehicle in ipairs( exports.global:getNearbyElements(getLocalPlayer(), "vehicle") ) do
					if isElement(nearbyVehicle) and (getElementDimension(nearbyVehicle) == getElementDimension(localPlayer)) then
						vehiculars[index] = nearbyVehicle
					end
				end
				--addEventHandler("onClientRender", getRootElement(), showText)
				showing = true
			end
		end
	end
end

function showText()
	if not showing then
		if getKeyState('lalt') then
			showNearbyVehicleDescriptions()
		end
		return false
	end
	if not getKeyState('lalt') and getElementData(localPlayer, "enableOverlayDescriptionVehPin") ~= "1" then
		removeVD()
		return
	end
	for i = 1, #vehiculars, 1 do
		local theVehicle = vehiculars[i]
		if isElement(theVehicle) then
			local x,y,z = getElementPosition(theVehicle)			
			local cx,cy,cz = getCameraMatrix()
			if getDistanceBetweenPoints3D(cx,cy,cz,x,y,z) <= viewDistance then --Within radius viewDistance
				local px,py,pz = getScreenFromWorldPosition(x,y,z+heightOffset,0.05)
				if px and isLineOfSightClear(cx, cy, cz, x, y, z, true, false, false, true, true, false, false) then				
					--FETCH FONT IN REAL TIME
					local fontString = getElementData(localPlayer, "cFontVeh") or "default"
					local fontElement = fontString
					if fontElement == "BizNoteFont18" then
						if not BizNoteFont18 then
							BizNoteFont18 = dxCreateFont ( ":resources/BizNote.ttf" , 18 )
						end
						fontElement = BizNoteFont18
					end
					--INITIAL SHIT
					local toBeShowed = ""
					local vehicleBrand = ""
					local fontWidth = 90
					local toBeAdded = ""
					local lines = 0
					local textColor = tocolor(255,255,255,255)
					if getElementData(theVehicle, "carshop") then
						local brand, model, year = false, false, false
						brand = getElementData(theVehicle, "brand") or false
						if brand then
							model = getElementData(theVehicle, "maximemodel")
							year = getElementData(theVehicle, "year")
							local line = year.." "..brand.." "..model
							local len = dxGetTextWidth(line)
							if len > fontWidth then
								fontWidth = len
							end
							vehicleBrand = line
							--[[
							if toBeShowed == "" then
								toBeShowed = toBeShowed..line.."\n"
								lines = lines + 1
							else
								toBeShowed = toBeShowed.."-~-\n"..line.."\n"
								lines = lines + 2
							end]]
						else
							--[[if toBeShowed == "" then
								toBeShowed = toBeShowed..getVehicleName(theVehicle).."\n"
								lines = lines + 1
							else
								toBeShowed = toBeShowed.."-~-\n"..getVehicleName(theVehicle).."\n"
								lines = lines + 2
							end]]
							vehicleBrand = line
						end
						local price = getElementData(theVehicle, "carshop:cost") or 0
						local taxes = getElementData(theVehicle, "carshop:taxcost") or 0
						toBeShowed = toBeShowed.."Fiyat: "..exports.global:formatMoney(price).."$\n Vergi: "..exports.global:formatMoney(taxes) .. "$"
						lines = lines+ 1
					else
						--GET DESCRIPTIONS + SIZE
						local descToBeShown = ""
						local job = getElementData(theVehicle, "job")
						if job == 1 then
							descToBeShown = ""
							lines = lines + 1
						else
							for j = 1, 15 do
								local desc = getElementData(theVehicle, "description:"..j)
								if desc and desc ~= "" and desc ~= "\n" and desc ~= "\t" then
									local len = dxGetTextWidth(desc)
									if len > fontWidth then
										fontWidth = len
									end
									descToBeShown = descToBeShown..desc.."\n"
									lines = lines + 1
								end				
							end
						end
						
						if descToBeShown ~= "" then
							descToBeShown = "-~-\n"..descToBeShown
							lines = lines + 1
						end
					
												--GET BRAND, MODEL, YEAR
						local brand, model, year = false, false, false
						brand = getElementData(theVehicle, "brand") or false
						if brand then
							model = getElementData(theVehicle, "maximemodel")
							year = getElementData(theVehicle, "year")
							
							local line = year.." "..brand.." "..model
							
							-- toBeShowed = toBeShowed..line.."\n"
							-- lines = lines + 1
							vehicleBrand = line
							
							local len = dxGetTextWidth(vehicleBrand)
							if len > fontWidth then
								fontWidth = len
							end
							
						end
						
						--GET VIN+PLATE
						local plate = ""
						local vin = getElementData(theVehicle, "dbid")
						if vin < 0 then
							plate = getVehiclePlateText(theVehicle)
						else
							plate = getElementData(theVehicle, "plate")
						end

						--Following edited by Adams 27/01/14 to accomodate VIN/PLATE hiding.
						--[[
						if not noPlateVehs[getElementModel(theVehicle)] then
							if getElementData(theVehicle, "show_plate") == 0 then
								if getElementData(localPlayer, "duty_admin") == 1 then
									toBeShowed = toBeShowed.."((Plaka: "..plate.."))\n"
									lines = lines + 1
								else
									--toBeShowed = toBeShowed.."* NO PLATE *\n"
								end
							else
								toBeShowed = toBeShowed.."Plaka: "..plate.."\n"
								lines = lines + 1
							end
						end
						]]
						if getElementData(theVehicle, "show_plate") == 0 then
							if getElementData(localPlayer, "duty_admin") == 1 then
								toBeShowed = toBeShowed.."((Plaka: "..plate.."))\n"
								lines = lines + 1
							end
						end
						if getElementData(theVehicle, "show_vin") == 0 then
							if getElementData(localPlayer, "duty_admin") == 1 then
								toBeShowed = toBeShowed.."((ID: "..vin.."))"
								lines = lines + 1
							else
								--toBeShowed = toBeShowed.."* NO VIN *"
							end
						else
							toBeShowed = toBeShowed.."ID: "..vin
							lines = lines + 1
						end

						--GET IMPOUND
						if (exports["vehicle"]:isVehicleImpounded(theVehicle)) then
							local days = getRealTime().yearday-getElementData(theVehicle, "Impounded")
							toBeShowed = toBeShowed.."\n".."Çekili: " .. days .. " gündür çekili."
							lines = lines + 1
						end

						local vowner = getElementData(theVehicle, "owner") or -1
						local vfaction = getElementData(theVehicle, "faction") or -1
						if vowner == getElementData(localPlayer, "account:id") or exports.global:isStaffOnDuty(localPlayer) or exports.integration:isPlayerScripter(localPlayer) or exports.integration:isPlayerVCTMember(localPlayer) then
							toBeShowed = toBeShowed.."\nListe ID: "..(getElementData(theVehicle, "vehicle_shop_id") or "None")
							lines = lines + 1

							local ownerName = 'No-one'
							if vowner > 0 then
								ownerName = exports.cache:getCharacterNameFromID(vowner)
							elseif vfaction > 0 then
								ownerName = exports.cache:getFactionNameFromId(vfaction)
							end
							local line = "\nSahibi: "..(ownerName or "Yükleniyor..")
							local len = dxGetTextWidth(line)
							if len > fontWidth then
								fontWidth = len
							end
							toBeShowed = toBeShowed..line
							lines = lines + 1

--Activity / MAXIME
							local protectedText, inactiveText = nil
							if vowner > 0 then 
								local protected, details = true, true, true--exports['vehicle']:isProtected(theVehicle) 
					            if protected then
					                textColor = tocolor(0, 255, 0,255)
					                -- protectedText = "[Inactivity protection remaining: "..details.."]"
					                -- local toBeAdded = "\n"..protectedText
									toBeShowed = toBeShowed..toBeAdded
									local len = dxGetTextWidth(toBeAdded)
									if len > fontWidth then
										fontWidth = len
									end
									lines = lines + 1
								else
					                local active, details2, secs = true, true, true --exports['vehicle']:isActive(theVehicle)
					                if active and (powner == getElementData(localPlayer, "dbid") or exports.integration:isPlayerStaff(localPlayer)) then
					                    --textColor = tocolor(150,150,150,255)
					                    inactiveText = "[Aktif | "
					                    -- local owner_last_login = getElementData(theVehicle, "owner_last_login")
										if owner_last_login and tonumber(owner_last_login) then
											local owner_last_login_text, owner_last_login_sec = exports.datetime:formatTimeInterval(owner_last_login)
											-- inactiveText = inactiveText.." Owner last seen "..owner_last_login_text.." "
										else
											-- inactiveText = inactiveText.." Owner last seen is irrelevant | "
										end
					                    local lastused = getElementData(theVehicle, "lastused")
										if lastused and tonumber(lastused) then
											local lastusedText, lastusedSeconds = exports.datetime:formatTimeInterval(lastused)
											-- inactiveText = inactiveText.."Last used "..lastusedText.."]"
										else
											-- inactiveText = inactiveText.."Last used is irrelevant]"
										end
						                -- local toBeAdded = "\n"..inactiveText
										-- toBeShowed = toBeShowed..toBeAdded
										local len = dxGetTextWidth(toBeAdded)
										if len > fontWidth then
											fontWidth = len
										end
										lines = lines + 1
									elseif not active then
										textColor = tocolor(150,150,150,255)
					                    -- inactiveText = "["..details2.."]"
						                -- local toBeAdded = "\n"..inactiveText
										-- toBeShowed = toBeShowed..toBeAdded
										local len = dxGetTextWidth(toBeAdded)
										if len > fontWidth then
											fontWidth = len
										end
										lines = lines + 1
					                end
					            end
						    end
						end
						if getElementData(theVehicle, "fiyat") then
					            textColor = tocolor(255,0,0,255)
					            inactiveText = "[SATILIK]"
								local toBeAdded = "\n"..inactiveText
								toBeShowed = toBeShowed..toBeAdded
								local len = dxGetTextWidth(toBeAdded)
								if len > fontWidth then
									fontWidth = len
								end
							lines = lines + 1
						end
						toBeShowed = toBeShowed.."\n"..descToBeShown
					end
					
					if fontWidth < 90 then
						fontWidth = 90
					end

					-- PLAKA (pavlov)
					if not noPlateVehs[getElementModel(theVehicle)] then
						if not (getElementData(theVehicle, "show_plate") == 0) then
							local plate = getElementData(theVehicle, "plate") or ""
							if getElementData(theVehicle, "carshop") then
								plate = "SATILIK"
							end
							if getElementData(theVehicle, "faizkilidi") then
							plate = "Faiz Kiliti"
							renk1, renk2, renk3 = 255, 0, 0
							buyukluk = 0.50
							else
							renk1, renk2, renk3 = 8, 54, 139
							buyukluk = 0.65
							end
							local vehID = getElementData(theVehicle, "dbid")
							local vehFactionID = getElementData(theVehicle, "faction")
							-- if vehID == 19000 then -- İBB ARACI
								-- dxDrawImage(px - 90, py, 180, 39, ":description/plaka_baskan.png", 0, 0, 0, tocolor(255, 255, 255, 150), false)
								-- dxDrawText(plate, px-90+15, py+5, px-90+175, py+33, tocolor(162, 157, 33, 255), 1.00, plakaFont, "center", "center", false, false, false, false, false)
							-- elseif vehFactionID == 2 or vehFactionID == 3 or vehFactionID == 20 then
								-- dxDrawImage(px - 90, py, 180, 39, ":description/plaka_devlet.png", 0, 0, 0, tocolor(255, 255, 255, 150), false)
								-- dxDrawText(plate, px-90+15, py+5, px-90+175, py+33, tocolor(255, 255, 255, 255), 1.00, plakaFont, "center", "center", false, false, false, false, false)
							-- elseif vehFactionID == 1 and vehID ~= 174 then
								-- dxDrawImage(px - 90, py, 180, 39, ":description/plaka_polis.png", 0, 0, 0, tocolor(255, 255, 255, 150), false)
								-- dxDrawText(plate, px-90, py+5, px-90+175, py+33, tocolor(255, 255, 255, 255), 1.00, plakaFont, "center", "center", false, false, false, false, false)
							-- else
								dxDrawImage(px - 65, py-150, 135, 60, "plaka.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
								dxDrawText(plate, px-90+5, py-250, px-90+175, py+33, tocolor(renk1, renk2, renk3, 255), buyukluk, fonte, "center", "center", false, false, false, false, false)
							-- end  
						end
					end
					
					local textColor2 = tocolor(255,255,255,200)
					local marg = 15
					local oneLineHeight = dxGetFontHeight(1, fontElement)
					local fontHeight = oneLineHeight * lines
					--fontWidth = fontWidth*fontType[fontString][2] --Fix custom fonts
					px = px-(fontWidth/2)
					local recuzunluk = nil
					local uzunluk = dxGetTextWidth(vehicleBrand,1,fontElement)
					local uzunluk2 = dxGetTextWidth(toBeShowed,1,fontElement)
					recuzunluk = uzunluk
					if uzunluk2 > uzunluk then
						recuzunluk = uzunluk2
					end	
					--START DRAWING
					--if getElementData(localPlayer, "bgVeh") ~= "0" then
					--	dxDrawRectangle(px-marg, py-marg, fontWidth+(marg*2), fontHeight+(marg*2), tocolor(0, 0, 0, 10))
					--end
					--if getElementData(localPlayer, "borderVeh") ~= "0" then
					--	dxDrawRectangleBorder(px-marg, py-marg, fontWidth+(marg*2), fontHeight+(marg*2), 1, tocolor(255, 255, 255, 10), true)
					--end
					--dxDrawText(toBeShowed, px, py, px + fontWidth, (py + fontHeight), textColor, 1, fontElement, "center")

					--dxDrawRectangle(px-marg, py+marg + 39, fontWidth+(marg*2), fontHeight+(marg*2), tocolor(0, 0, 0, 150))
					
					--[[	
					if getElementData(localPlayer, "bgVeh") ~= "0" then
						dxDrawRectangle(px-marg, py+marg + 39, fontWidth+(marg*2), fontHeight+(marg*2), tocolor(0, 0, 0, 50))
					end
					if getElementData(localPlayer, "borderVeh") ~= "0" then
						dxDrawRectangleBorder(px-marg, py+marg+39, fontWidth+(marg*2), fontHeight+(marg*2), 1, tocolor(255, 255, 255, 10), true)
					end]]
					
					-- VEHİCLE BRAND
					local renk = tocolor(0, 0, 0, 100) -- rectangle renkleri
					dxDrawRectangle(px+5, py+marg - 100, recuzunluk, 24, tocolor(0, 0, 0, 200))
					dxDrawRectangleBorder(px+5, py+marg - 100, recuzunluk, 24, 1, renk, true)
					dxDrawText(vehicleBrand, px, py+marg-95, px +fontWidth+marg, (py + 2000), textColor2, 1, fontElement, "center") -- burası
					local own = getElementData(theVehicle,"owner")
					if own == -2 then
					dxDrawText(getVehicleName(theVehicle), px, py+marg+44, px + fontWidth, (py + 20), textColor2, 1, fontElement, "center")
					end
					
					-- DESCRİPTİON
					dxDrawRectangle(px+5, py+marg - 75, recuzunluk, fontHeight+(marg*1) - 4, renk)
					dxDrawRectangleBorder(px+5, py+marg -75, recuzunluk, fontHeight+(marg*1) - 4, 1, renk, true)
					dxDrawText(toBeShowed, px+10, py+marg-70, px + fontWidth, (py + fontHeight)+24, textColor2, 1, fontElement, "center")
				end
			end
		end
	end
end

--MAXIME
function dxDrawRectangleBorder(x, y, width, height, borderWidth, color, out, postGUI)
	if out then
		--[[Left]]	dxDrawRectangle(x - borderWidth, y, borderWidth, height, color, postGUI)
		--[[Right]]	dxDrawRectangle(x + width, y, borderWidth, height, color, postGUI)
		--[[Top]]	dxDrawRectangle(x - borderWidth, y - borderWidth, width + (borderWidth * 2), borderWidth, color, postGUI)
		--[[Botm]]	dxDrawRectangle(x - borderWidth, y + height, width + (borderWidth * 2), borderWidth, color, postGUI)
	else
		local halfW = width / 2
		local halfH = height / 2
		--[[Left]]	dxDrawRectangle(x, y, math.clip(0, borderWidth, halfW), height, color, postGUI)
		--[[Right]]	dxDrawRectangle(x + width - math.clip(0, borderWidth, halfW), y, math.clip(0, borderWidth, halfW), height, color, postGUI)
		--[[Top]]	dxDrawRectangle(x + math.clip(0, borderWidth, halfW), y, width - (math.clip(0, borderWidth, halfW) * 2), math.clip(0, borderWidth, halfH), color, postGUI)
		--[[Botm]]	dxDrawRectangle(x + math.clip(0, borderWidth, halfW), y + height - math.clip(0, borderWidth, halfH), width - (math.clip(0, borderWidth, halfW) * 2), math.clip(0, borderWidth, halfH), color, postGUI)
	end
end



--MAXIME
local descriptionLines = {}

function showEditDescription()
	if not exports.integration:isPlayerTrialAdmin(getLocalPlayer()) then
		exports["vatanroleplay-bildirim"]:addNotification("Bu komutu sadece yetkililer kullanabilir. Yardım merkezinden rapor göndererek bir yetkiliden yardım alabilirsiniz.", "error")
		return
	end
	if getPedOccupiedVehicle(getLocalPlayer()) then
		local theVehicle = getPedOccupiedVehicle(getLocalPlayer())
		local dbid = getElementData(theVehicle, "dbid")
		local factionid = getElementData(theVehicle, "faction")
		if exports.global:hasItem(getLocalPlayer(), 3, dbid) or exports.global:hasItem(theVehicle, 3, dbid) or getElementData(getLocalPlayer(), "faction") == factionid or exports.integration:isPlayerTrialAdmin(getLocalPlayer()) and getElementData(getLocalPlayer(), "duty_admin") == 1 then
			if dbid > 0 then
				local scrWidth, scrHeight = guiGetScreenSize()
				local x = scrWidth/2 - (441/2)
				local y = scrHeight/2 - (212/2)
				showCursor(true)
				wEditDescription = guiCreateWindow(x,y,441,212,"Edit Vehicle Description",false)
				guiWindowSetSizable(wEditDescription, false)
				guiSetInputEnabled(true)
				description1 = getElementData(theVehicle, "description:1")
				description2 = getElementData(theVehicle, "description:2")
				description3 = getElementData(theVehicle, "description:3")
				description4 = getElementData(theVehicle, "description:4")
				description5 = getElementData(theVehicle, "description:5")
				descriptionLines[1] = guiCreateEdit(10,23,422,26,description1,false,wEditDescription)
				descriptionLines[2] = guiCreateEdit(9,51,422,26,description2,false,wEditDescription)
				descriptionLines[3] = guiCreateEdit(9,79,422,26,description3,false,wEditDescription)
				descriptionLines[4] = guiCreateEdit(9,107,422,26,description4,false,wEditDescription)
				descriptionLines[5] = guiCreateEdit(9,135,422,26,description5,false,wEditDescription)
				bSave = guiCreateButton(10,165,210,40,"Save",false,wEditDescription)
				bClose = guiCreateButton(220,165,210,40,"Close",false,wEditDescription)
				addEventHandler("onClientGUIClick", bSave, saveEditDescription)
				addEventHandler("onClientGUIClick", bClose, closeEditDescription)
			else
				exports.hud:sendBottomNotification(getLocalPlayer(), "Vehicle Description", "You cannot set descriptions on temporary vehicles.")
			end
		else
			exports.hud:sendBottomNotification(getLocalPlayer(), "Vehicle Description", "You are not the owner of this vehicle.")
		end
	else
		exports.hud:sendBottomNotification(getLocalPlayer(), "Vehicle Description", "You must be in the vehicle you wish to change the description of.")
	end
end
addCommandHandler("ed", showEditDescription, false, false)
addCommandHandler("editdescription", showEditDescription, false, false)
addEvent("editdescription", true)
addEventHandler("editdescription", getRootElement(), showEditDescription)

function saveEditDescription(button, state)
	if (source==bSave) and (button=="left") then
		local savedDescriptions = { }
		savedDescriptions[1] = guiGetText(descriptionLines[1])
		savedDescriptions[2] = guiGetText(descriptionLines[2])
		savedDescriptions[3] = guiGetText(descriptionLines[3])
		savedDescriptions[4] = guiGetText(descriptionLines[4])
		savedDescriptions[5] = guiGetText(descriptionLines[5])
		triggerServerEvent("saveDescriptions", getLocalPlayer(), savedDescriptions, getPedOccupiedVehicle(getLocalPlayer()))
		closeEditDescription()
	end
end

function closeEditDescription()
	destroyElement(wEditDescription)
	eLine1, eLine2, eLine3, eLine4, eLine5, bSave, bClose, wEditDescription = nil, nil, nil, nil, nil, nil, nil
	showCursor(false)
	guiSetInputEnabled(false)
end


function refreshNearByVehs()

	for index, nearbyVehicle in ipairs( exports.global:getNearbyElements(getLocalPlayer(), "vehicle") ) do
		if isElement(nearbyVehicle) then
			vehiculars[index] = nearbyVehicle
		end
	end
	removeEventHandler ( "onClientRender", getRootElement(), showText )
	addEventHandler("onClientRender", getRootElement(), showText)

end