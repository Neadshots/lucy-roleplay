--// The script streamed by Militan

local font_1 = "default-bold"--//dxCreateFont("fonts/Roboto.ttf" , 12)
local font_2 = dxCreateFont("fonts/Roboto.ttf" , 12)
local sx, sy = guiGetScreenSize()
local maxIconsPerLine = 6
local streamedPlayers = {}
local streamedPeds = {}
local masks, badges = {}, {}

addEventHandler("onClientElementStreamIn", root,
	function()
		if (localPlayer.interior == source.interior) and (localPlayer.dimension == source.dimension) and not streamedPlayers[source] then
			if source.type == "player" then
				createCache(source, "player")
			elseif source.type == "ped" then
				createCache(source, "ped")
			end
		end
	end
)

addEventHandler("onClientElementStreamOut", root,
	function()
		if (localPlayer.interior == source.interior) and (localPlayer.dimension == source.dimension) then
			if source.type == "player" then
				destroyCache(source, "player")
			elseif source.type == "ped" then
				destroyCache(source, "ped")
			end
		end
	end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		for key, value in pairs(exports['item-system']:getBadges()) do
			badges[value[1]] = { value[4][1], value[4][2], value[4][3], value[5], value.bandana or false }
		end

		masks = exports['item-system']:getMasks()

		for index, source in ipairs(getElementsByType("player")) do
			if isElementStreamedIn(source) and not streamedPlayers[source] then
				if (localPlayer.interior == source.interior) and (localPlayer.dimension == source.dimension) then
					createCache(source, "player")
				end
			end
		end
		for index, source in ipairs(getElementsByType("ped")) do
			if isElementStreamedIn(source) then
				if (localPlayer.interior == source.interior) and (localPlayer.dimension == source.dimension) then
					createCache(source, "ped")
				end
			end
		end
		
	end
)

function createCache(element, elementType)
	if elementType == "player" then
		if not streamedPlayers[element] then
			local firstDetails = getFirstDetails(element)
        	streamedPlayers[element] = firstDetails
        end
	elseif elementType == "ped" then
		local firstDetails = getFirstDetails(element)
        streamedPeds[element] = firstDetails
	end
end

function destroyCache(element, elementType)
	if elementType == "player" then
		if streamedPlayers[element] then
			streamedPlayers[element] = nil
		end
	elseif elementType == "ped" then
		if streamedPeds[element] then
			streamedPeds[element] = nil
		end
	end
end

function getFirstDetails(element)
	if element.type == "player" then
		local table = {
			['loggedin'] = getElementData(element, "loggedin"),
			['reconx'] = getElementData(element, "reconx") or false,
			['writting'] = getElementData(element, "writting"),
			['playerid'] = getElementData(element, "playerid"),
			['hiddenadmin'] = getElementData(element, "hiddenadmin"),
			['duty_admin'] = getElementData(element, "duty_admin"),
			['admin_level'] = getElementData(element, "admin_level"),
			['supporter_level'] = getElementData(element, "supporter_level"),
			['account:username'] = getElementData(element, "account:username"),
			['duty_supporter'] = getElementData(element, "duty_supporter"),
			['seatbelt'] = getElementData(element, "seatbelt"),
			['cellphoneGUIStateSynced'] = getElementData(element, "cellphoneGUIStateSynced"),
			['restrain'] = getElementData(element, "restrain"),
			['freecam:state'] = getElementData(element, "freecam:state"),
			['gasmask'] = getElementData(element, "gasmask"),
			['mask'] = getElementData(element, "mask"),
			['helmet'] = getElementData(element, "helmet"),
			['scuba'] = getElementData(element, "scuba"),
			['bikerhelmet'] = getElementData(element, "bikerhelmet"),
			['fullfacehelmet'] = getElementData(element, "fullfacehelmet"),
			['christmashat'] = getElementData(element, "christmashat"),
			['vip'] = getElementData(element, "vip")
		}
		for index, value in pairs(exports["item-system"]:getBadges()) do
			table[value[1]] = getElementData(element, value[1])
		end
		return table
	elseif element.type == "ped" then
		local table = {
			['nametag'] = getElementData(element, "nametag"),
			['talk'] = getElementData(element, "talk"),
			
		}
		return table
	end
end

addEventHandler("onClientElementDataChange", root,
	function(dataName)
		if source.type == "player" and streamedPlayers[source] then
			if streamedPlayers[source][dataName] then
				local new_data_value = getElementData(source, dataName)
				streamedPlayers[source][dataName] = new_data_value
			end
		elseif source.type == "ped" and streamedPeds[source] then
			if streamedPeds[source][dataName] then
				local new_data_value = getElementData(source, dataName)
				streamedPeds[source][dataName] = new_data_value
			end
		
		end
	end
)

function getPlayerIcons(name, player, forTopHUD, distance)
	local distance = distance or 0
	local tinted, masked = false, false
	local icons = {}
	if not forTopHUD then
		if streamedPlayers[player]["hiddenadmin"] ~= 1 then
			if streamedPlayers[player]["duty_admin"] == 1 then
				if streamedPlayers[player]["admin_level"] >= 5 then
					table.insert(icons, "developeradm")
				elseif streamedPlayers[player]["admin_level"] >= 1 and streamedPlayers[player]["admin_level"] <= 4  then
					table.insert(icons, "a"..getElementData(player, "admin_level").."_on")
				elseif streamedPlayers[player]["supporter_level"] >= 1 then
			    	table.insert(icons, "rehber_on")	
				end
			end
		end

		if streamedPlayers[player]["afk"] then
			table.insert(icons, "afk")
		end
	end

	local vehicle = getPedOccupiedVehicle(player)
	local windowsDown = vehicle and getElementData(vehicle, "vehicle:windowstat") == 1
	if vehicle and not windowsDown and vehicle ~= getPedOccupiedVehicle(localPlayer) and getElementData(vehicle, "tinted") then
		local seat0 = getVehicleOccupant(vehicle, 0) == player
		local seat1 = getVehicleOccupant(vehicle, 1) == player
		if seat0 or seat1 then
			if distance > 1.4 then
				name = "Bilinmeyen Kişi (Tint)"
				tinted = true
			end
		else
			name = "Bilinmeyen Kişi (Tint)"
			tinted = true
		end
	end
	for key, value in pairs(masks) do
		if streamedPlayers[player][value[1]] then
			table.insert(icons, value[1])
			if value[4] then
				masked = true
			end
		end
	end
	if getElementData(player, "seatbelt") then
		table.insert(icons, 'seatbelt')
	end
	if not tinted then
		
		for k, v in pairs(badges) do
			local title = getElementData(player, k)--streamedPlayers[player][k]
			if title then
				if v[5] then
					table.insert(icons, 'bandana')
					name = "Bilinmeyen Kişi (Bandana)"
					badge = true
				else
					table.insert(icons, "badge1")
					name = title .. "\n" .. name
					badge = true
				end
			end
		end
		if (streamedPlayers[player]["cellphoneGUIStateSynced"] or 0) > 0 then
			table.insert(icons, 'phone')
		end
		if not forTopHUD then
			local health = getElementHealth(player)
			local tick = math.floor(getTickCount () / 1000) % 2
			if health <= 10 and tick == 0 then
				table.insert(icons, 'bleeding')
			elseif (health <= 30) then
				table.insert(icons, 'lowhp')
			end

			if streamedPlayers[player]["restrain"] == 1 then
				table.insert(icons, "handcuffs")
			end
		end

		if getPedArmor(player) > 0 then
			table.insert(icons, 'armour')
		end
	end
	if not forTopHUD then
		if windowsDown then
			table.insert(icons, 'window2')
		end
	end
	if masked then
		name = "Bilinmeyen Kişi (Maske)"
	end
	if getElementData(player, "injury") then
		table.insert(icons, 'injury')
	end
	if (getElementData(player, "vip") or 0) > 0 then
		table.insert(icons, 'vip'..getElementData(player, "vip"))
	end
	return name, icons, tinted, badge
end

function getBadgeColor(player)
	for k, v in pairs(badges) do
		if streamedPlayers[player][k] then
			return unpack(badges[k])
		end
	end
end

function getVariableColor(variable)
	if (variable) > 50 then
		return "#009432"
	elseif (variable) >= 30 and (variable) <= 50 then
		return "#f1c40f"
	elseif (variable) <= 29 then
		return "#ff0000"
	end
end

function renderNametags()
	local lx, ly, lz = getElementPosition(localPlayer)
	local dim = getElementDimension(localPlayer)
	if (getElementData(localPlayer, "loggedin") == 0) or getElementData(localPlayer, "screenshot:mode") then
		return
	end
	local interface_mode = getPlayerInterfaceMode()
	if interface_mode ~= 1 then
		font = font_1
	else
		font = font_2
	end
	for player, data in pairs(streamedPlayers) do
		if not isElement(player) then
			streamedPlayers[player] = nil
			break
		end

		local rx, ry, rz = getElementPosition(player)
		local distance = getDistanceBetweenPoints3D(lx, ly, lz, rx, ry, rz)
		local limitdistance = 20
		local reconx = false--local reconx = (streamedPlayers[localPlayer]['reconx'] or false) and (data['admin_level'] >= 2)
		local shown_player = true
		if (player == localPlayer) then
			if interface_mode ~= 1 then
				shown_player = true
			else
				shown_player = false
			end
		end
		if isElementOnScreen(player) and (shown_player) then
			if (aimsAt(player) or distance<limitdistance or reconx) then
				if not data['reconx'] and not data["freecam:state"] and getElementAlpha(player) >= 255 then
					local lx, ly, lz = getCameraMatrix()
					local vehicle = getPedOccupiedVehicle(player) or nil
					local collision, cx, cy, cz, element = processLineOfSight(lx, ly, lz, rx, ry, rz+1, true, true, true, true, false, false, true, false, vehicle)
					if not (collision) or aimsSniper() or (reconx) then
						local x, y, z = getElementPosition(player)
						local alpha = 0
						if not (isPedDucked(player)) then
							z = z + 1
						else
							z = z + 0.5
						end
						local sx, sy = getScreenFromWorldPosition(x, y, z+0.30, 100, false)
						local oldsy = nil
					
						local badge = false
						local tinted = false

						local name = getPlayerName(player):gsub("_", " ")
						if (sx) and (sy) then
							distance = distance / 5

							if (reconx or aimsAt(player)) then distance = 1
							elseif (distance<1) then distance = 1
							elseif (distance>2) then distance = 2 end

							--DRAW BG
							name, icons, tinted, theBadge = getPlayerIcons(name, player, false, distance)

							if not theBadge then theBadge = false end
							oldsy = sy
							if interface_mode == 1 then
								picxsize = 48 / 2 --/distance
								picysize = 48 / 2 --/distance
								ypos = 25
							else
								picxsize = 48 / 2 --/distance
								picysize = 48 / 2 --/distance
								if theBadge then
									ypos = 40
								else
									ypos = 34
								end
							end
							local xpos = 0

							ypos = ypos - (distance/36)
								
							local expectedIcons = math.min(#icons, maxIconsPerLine)
							local iconsThisLine = 0
							local newY = 0
							local offset = 16 * expectedIcons
							if interface_mode ~= 1 then
								local hpx, hpy, hpw, hph = sx-52/2-7, 3+oldsy+ypos/distance, 52, 8
								if (tonumber(interface_mode) == 2) then

										dxDrawText("HP: "..math.floor(getElementHealth(player)), hpx+1, hpy, hpw+hpx+1, hph+hpy, tocolor(0, 0, 0), 1, "default-bold", "center", "center", false, false, false, true)
										dxDrawText("HP: "..math.floor(getElementHealth(player)), hpx-1, hpy, hpw+hpx-1, hph+hpy, tocolor(0, 0, 0), 1, "default-bold", "center", "center", false, false, false, true)
										dxDrawText("HP: "..math.floor(getElementHealth(player)), hpx, hpy+1, hpw+hpx, hph+hpy+1, tocolor(0, 0, 0), 1, "default-bold", "center", "center", false, false, false, true)
										dxDrawText("HP: "..math.floor(getElementHealth(player)), hpx, hpy-1, hpw+hpx, hph+hpy-1, tocolor(0, 0, 0), 1, "default-bold", "center", "center", false, false, false, true)
										dxDrawText("HP: "..getVariableColor(math.floor(getElementHealth(player)))..math.floor(getElementHealth(player)), hpx, hpy, hpw+hpx, hph+hpy, tocolor(255, 255, 255), 1, "default-bold", "center", "center", false, false, false, true)

								elseif tonumber(interface_mode) == 3 then
									dxDrawRectangle(hpx, hpy, hpw, hph, tocolor(0,0,0,180))
									dxDrawRectangle(sx-50/2-7, 3+oldsy+ypos/distance+1, (50)*getElementHealth(player)/100, 6, tocolor(255, 0, 0,170))
								end
								if getPedArmor(player) > 0 then
									local hpx, hpy, hpw, hph = sx-52/2-7, 3+oldsy+ypos/distance+12, 52, 8
									if (tonumber(interface_mode) == 2) then
										dxDrawText("Armor: "..math.floor(getElementHealth(player)), hpx+1, hpy, hpw+hpx+1, hph+hpy, tocolor(0, 0, 0), 1, "default-bold", "center", "center", false, false, false, true)
										dxDrawText("Armor: "..math.floor(getElementHealth(player)), hpx-1, hpy, hpw+hpx-1, hph+hpy, tocolor(0, 0, 0), 1, "default-bold", "center", "center", false, false, false, true)
										dxDrawText("Armor: "..math.floor(getElementHealth(player)), hpx, hpy+1, hpw+hpx, hph+hpy+1, tocolor(0, 0, 0), 1, "default-bold", "center", "center", false, false, false, true)
										dxDrawText("Armor: "..math.floor(getElementHealth(player)), hpx, hpy-1, hpw+hpx, hph+hpy-1, tocolor(0, 0, 0), 1, "default-bold", "center", "center", false, false, false, true)
										dxDrawText("Armor: "..getVariableColor(math.floor(getPedArmor(player)))..math.floor(getPedArmor(player)), hpx, hpy, hpw+hpx, hph+hpy, tocolor(255, 255, 255), 1, "default-bold", "center", "center", false, false, false, true)
									elseif tonumber(interface_mode) == 3 then
										dxDrawRectangle(hpx, hpy, hpw, hph, tocolor(0,0,0,180))
										dxDrawRectangle(hpx+1, hpy+1, (hpw-2)*getPedArmor(player)/100, hph-2, tocolor(210, 210, 210,180))
									end
									newY = newY + 10
								end
							end
							newY = newY + 12
							if getElementData(player,"writting") then
								if interface_mode == 1 then
									dxDrawImage(sx+23,oldsy+ypos/distance+12/distance,48/2,48/2,"images/samp/writing.png")
								else
									dxDrawImage(sx+23,oldsy+ypos/distance,48/2,48/2,"images/samp/writing.png")
								end
							end
						
							newY = newY/distance
									
							for k, v in ipairs(icons) do
								dxDrawImage(sx-offset+xpos,3+oldsy+newY+ypos/distance,picxsize,picysize,"images/samp/" .. v .. ".png")
								
								iconsThisLine = iconsThisLine + 1
								if iconsThisLine == expectedIcons then
									expectedIcons = math.min(#icons - k, maxIconsPerLine)
									offset = 16 * expectedIcons
									iconsThisLine = 0
									xpos = 0
									ypos = ypos + 32
								else
									if not isNewtyle then
										xpos = xpos + 25
									else
										xpos = xpos + 32
									end
								end
							end
										
							if (distance<=2) then
								sy = math.ceil( sy + ( 2 - distance ) * 20 )
							end
							sy = sy + 10
							if (sx) and (sy) then
								if (6>5) then
									local offset = 45 / distance
								end
							end

							if (distance<=2) then
								sy = math.ceil( sy - ( 2 - distance ) * 40 )
							end
							sy = sy - 20
							if (distance < 1) then distance = 1 end
							if (distance > 2) then distance = 2 end
							local offset = 75 / distance
							local r, g, b = getBadgeColor(player)
							if not r or tinted then
								r, g, b = getPlayerNametagColor(player)
							end
							local id = data["playerid"]
							if badge then
								sy = sy - dxGetFontHeight(scale, font) * scale + 2.5
							end
							if interface_mode ~= 1 then
								name = name.." ("..id..")"
							else
								if getKeyState("lctrl") then
									name = name.." ("..id..")"
								end
							end
							sy = sy - distance*3

							tx, ty, tw, th = sx-offset, sy, (sx-offset)+130 / distance, sy+120 / distance
							if interface_mode ~= 1 then			
								dxDrawText(RemoveHEXColorCode(name), tx+1, ty, tw+1, th, tocolor(0, 0, 0, 255), scale, font, "center", "center", false, false, false, false, false)
								dxDrawText(RemoveHEXColorCode(name), tx-1, ty, tw-1, th, tocolor(0, 0, 0, 255), scale, font, "center", "center", false, false, false, false, false)
								dxDrawText(RemoveHEXColorCode(name), tx, ty+1, tw, th+1, tocolor(0, 0, 0, 255), scale, font, "center", "center", false, false, false, false, false)
								dxDrawText(RemoveHEXColorCode(name), tx, ty-1, tw, th-1, tocolor(0, 0, 0, 255), scale, font, "center", "center", false, false, false, false, false)
							else
								dxDrawText(RemoveHEXColorCode(name), tx+1, ty+1, tw, th, tocolor(0, 0, 0, 255), scale, font, "center", "center", false, false, false, false, false)
							end
							dxDrawText(name, tx, ty, tw, th, tocolor(r, g, b, 255), scale, font, "center", "center", false, false, false, false, false)
						end
					end
				end
			end
		end
	end
	for player, data in ipairs(streamedPeds) do
		if isElement(player) and  (player~=localPlayer) and (isElementOnScreen(player)) then
			if (data['talk'] == 1) or (data['nametag']) then
				local lx, ly, lz = getElementPosition(localPlayer)
				local rx, ry, rz = getElementPosition(player)
				local distance = getDistanceBetweenPoints3D(lx, ly, lz, rx, ry, rz)
				local limitdistance = 20
	

				if (aimsAt(player) or distance<limitdistance or reconx) then
					local lx, ly, lz = getCameraMatrix()
					local vehicle = getPedOccupiedVehicle(player) or nil
					local collision, cx, cy, cz, element = processLineOfSight(lx, ly, lz, rx, ry, rz+1, true, true, true, true, false, false, true, false, vehicle)
					if not (collision) or aimsSniper() or (reconx) then
					local x, y, z = getElementPosition(player)

					if not (isPedDucked(player)) then
						z = z + 1
					else
						z = z + 0.5
					end

					local sx, sy = getScreenFromWorldPosition(x, y, z+0.1, 100, false)
					local oldsy = nil
					-- HP
					if (sx) and (sy) then
						if (1>0) then
							distance = distance / 5

							if (aimsAt(player)) then distance = 1
							elseif (distance<1) then distance = 1
							elseif (distance>2) then distance = 2 end

							local offset = 45 / distance

							oldsy = sy
						end
					end

					if (sx) and (sy) then
						if (distance<=2) then
							sy = math.ceil( sy + ( 2 - distance ) * 20 )
						end
						sy = sy + 10
						if (distance<=2) then
							sy = math.ceil( sy - ( 2 - distance ) * 40 )
						end
						sy = sy - 20

							if (sx) and (sy) then
								if (distance < 1) then distance = 1 end
								if (distance > 2) then distance = 2 end
								local offset = 75 / distance
								local scale = 1 / distance
								
								local r,g,b
								r, g, b = getBadgeColor(player)
								if not r or tinted then
									r = 255
									g = 255
									b = 255--getPlayerNametagColor(player)
								end
							
								dxDrawText(pedName, sx-offset+1, sy, (sx-offset)+131 / distance, sy+20 / distance, tocolor(0, 0, 0, 220), scale, font, "center", "center", false, false, false)
								dxDrawText(pedName, sx-offset, sy+1, (sx-offset)+130 / distance, sy+21 / distance, tocolor(0, 0, 0, 220), scale, font, "center", "center", false, false, false)
								dxDrawText(pedName, sx-offset-1, sy, (sx-offset)+129 / distance, sy+20 / distance, tocolor(0, 0, 0, 220), scale, font, "center", "center", false, false, false)
								dxDrawText(pedName, sx-offset, sy-1, (sx-offset)+130 / distance, sy+19 / distance, tocolor(0, 0, 0, 220), scale, font, "center", "center", false, false, false)
								dxDrawText(pedName, sx-offset, sy, (sx-offset)+130 / distance, sy+20 / distance, tocolor(r, g, b, 255), scale, font, "center", "center", false, false, false)
							end
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", root, renderNametags, true, "low-5")
function aimsSniper()
	return getPedControlState(localPlayer, "aim_weapon") and ( getPedWeapon(localPlayer) == 34 or getPedWeapon(localPlayer) == 43 )
end

function aimsAt(player)
	return getPedTarget(localPlayer) == player and aimsSniper()
end