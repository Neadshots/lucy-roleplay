local function canAccessElement( player, element )
	if getElementData(player, "dead") == 1 then
		return false
	end
	if getElementType( element ) == "vehicle" then
		if not isVehicleLocked( element ) then
			return true
		else
			local veh = getPedOccupiedVehicle( player )
			local inVehicle = getElementData( player, "realinvehicle" )
			
			if veh == element and inVehicle == 1 then
				return true
			elseif veh == element and inVehicle == 0 then
				outputDebugString( "canAcccessElement failed (hack?): " .. getPlayerName( player ) .. " on Vehicle " .. getElementData( element, "dbid" ) )
				return false
			else
				outputDebugString( "canAcccessElement failed (locked): " .. getPlayerName( player ) .. " on Vehicle " .. getElementData( element, "dbid" ) )
				return false
			end
		end
	else
		return true
	end
end

--

local function openInventory( element, ax, ay )
	if canAccessElement( source, element ) then
		triggerEvent( "subscribeToInventoryChanges", source, element )
		triggerClientEvent( source, "openElementInventory", element, ax, ay )
	end
end

addEvent( "openFreakinInventory", true )
addEventHandler( "openFreakinInventory", getRootElement(), openInventory )

--

local function closeInventory( element )
	triggerEvent( "unsubscribeFromInventoryChanges", source, element )
end

addEvent( "closeFreakinInventory", true )
addEventHandler( "closeFreakinInventory", getRootElement(), closeInventory )

--

local function output(from, to, itemID, itemValue, evenIfSamePlayer)
	if from == to and not evenIfSamePlayer then
		return false
	end
	
	-- player to player
	if getElementType(from) == "player" and getElementType(to) == "player" then
		
		exports.global:sendLocalMeAction( from, ", " .. getPlayerName( to ):gsub("_", " ") .. " isimli kişiye bir adet " .. getItemName( itemID, itemValue ) .. " verir." )
	-- player to item
	elseif getElementType(from) == "player" then
		local name = getName(to)
		
		if itemID == 134 then
			triggerEvent('sendAme', from, "$" .. exports.global:formatMoney(itemValue) .. " parayı ".. name .."' ATM'ye koyar." )
		elseif itemID == 150 then --ATM card / MAXIME
			triggerEvent('sendAme',  from, ""..name.." ATM'ye kartını koyar." )
		else
			triggerEvent('sendAme',  from, "" .. getItemName( itemID, itemValue ) .. " eşyasını ".. name .." koyar." )
		end
	-- item to player
	elseif getElementType(to) == "player" then
		local name = getName(from)
		if itemID == 134 then
			triggerEvent('sendAme', to, "$" .. exports.global:formatMoney(itemValue) .. " parayı ".. name .."' ATM'den alır." )
		elseif itemID == 150 then --ATM card / MAXIME
			triggerEvent('sendAme',  to, ""..name.." ATM'den kartını alır." )
		else
			triggerEvent('sendAme',  to, "" .. getItemName( itemID, itemValue ) .. " eşyasını ".. name .." alır." )
		end
	end
	
	if itemID == 2 then
		triggerClientEvent(to, "phone:clearAllCaches", to, itemValue)
		triggerClientEvent(from, "phone:clearAllCaches", from, itemValue)
	end

	return true
end
function x_output_wrapper( ... ) return output( ... ) end

--

	

local function moveToElement( element, slot, ammo, event ) 
	if not canAccessElement( source, element ) and not exports.integration:isPlayerDeveloper(source) then
		outputChatBox("[!] #ffffffBunu yapmaya yetkiniz yok.", source, 255, 0, 0, true)
		triggerClientEvent( source, event or "finishItemMove", source )
		return
	end 
	
	local name = getName(element)
			
	if not ammo then  
		local item = getItems( source )[ slot ]
		if item then
			if item[1] == 116 then
				outputChatBox("[!] #ffffffMermi transferi yasaklanmıştır.", source, 255, 0, 0, true)
				triggerClientEvent( source, event or "finishItemMove", source )
			return false
			end
			-- ANTI ALT-ALT FOR NON AMMO ITEMS, CHECK THIS FUNCTION FOR AMMO ITEM BELOW AND FOR WORLD ITEM CHECK s_world_items.lua/ MAXIME
			--31 -> 43  = DRUGS
			if ( (item[1] >= 31 and item[1] <= 43) or itemBannedByAltAltChecker[item[1]]) and not (getElementModel(element) == 2942 and item[1] == 150) then 
				local hoursPlayedFrom = getElementData( source, "hoursplayed" )
				local hoursPlayedTo = 99
				if isElement(element) and getElementType(element) == "player" then
					hoursPlayedTo = getElementData( element, "hoursplayed" ) 
				end
				
				if not exports.global:isStaffOnDuty(source) and not exports.global:isStaffOnDuty(element) then
					if hoursPlayedFrom < 10 then
						--outputChatBox("You require 10 hours of playing time to move a "..getItemName( item[1] ).." to a "..name..".", source, 255, 0, 0)
						outputChatBox("[!] #ffffffBu işlemi yapabilmek için sunucuda 10 saatiniz olması gerekmektedir.", source, 255, 0, 0, true)
						triggerClientEvent( source, event or "finishItemMove", source )
						return false
					end
					
					if hoursPlayedTo < 10 then
						--outputChatBox(string.gsub(getPlayerName(element), "_", " ").." requires 10 hours of playing time to receive a "..getItemName( item[1] ).." from you.", source, 255, 0, 0)
						outputChatBox("[!] #ffffffBu işlemi yapabilmek için sunucuda 10 saatiniz olması gerekmektedir.", source, 255, 0, 0, true)
						--outputChatBox("You require 10 hours of playing time to receive a "..getItemName( item[1] ).." from "..string.gsub(getPlayerName(source), "_", " ")..".", element, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return false
					end
				end
				--outputDebugString(hoursPlayedFrom.." "..hoursPlayedTo)
			end

			if getElementType(element) == "ped" and getElementData(element, "type") == "pet" then
				-- PET SYSTEM - KOZANOĞLU
				local THIRST = math.random(20,25)
				local HUNGER = math.random(20,25)
				--local ispet = getElementData(element,"type") == "pet"
				if (item[1] == 341) then -- SU KABI
					local petthirst = getElementData(element,"thirst")
					local foundItem, slot, itemValue = exports.global:hasItem(thePlayer, 341)
					if tonumber(petthirst) then
						if petthirst + THIRST <= 100 then
							setElementData(element,"thirst",petthirst + THIRST)
						else
							setElementData(element,"thirst",100)
						end
						triggerEvent('sendAme',  source, " su kabını yere koyar ve evcil hayvanına içirmeye başlar." )
						exports.global:takeItem(source, 341, itemValue) 
					end
					triggerClientEvent( source, event or "finishItemMove", source )
					return
				elseif (item[1] == 339) and getElementModel(element) == 178 then -- KEDİ
					local pethunger = getElementData(element,"hunger")
					local foundItem, slot, itemValue = exports.global:hasItem(thePlayer, 339)
					if tonumber(pethunger) then
						if pethunger + HUNGER <= 100 then
							setElementData(element,"hunger",pethunger + HUNGER)
						else
							setElementData(element,"hunger",100)
						end
						exports.global:takeItem(source, 339, itemValue) 
						triggerEvent('sendAme',  source, " kedi mamasını yere koyar ve kedisine yedirmeye başlar." )
					end
					triggerClientEvent( source, event or "finishItemMove", source )
					return
				elseif (item[1] == 340) and getElementModel(element) ~= 178 then
					local foundItem, slot, itemValue = exports.global:hasItem(thePlayer, 340)
					local pethunger = getElementData(element,"hunger")
					if tonumber(pethunger) then
						if pethunger + HUNGER <= 100 then
							setElementData(element,"hunger",pethunger + HUNGER)
						else
							setElementData(element,"hunger",100)
						end
						exports.global:takeItem(source, 340, itemValue) 
						triggerEvent('sendAme',  source, " köpek mamasını yere koyar ve köpeğine yedirmeye başlar." )
					end
					triggerClientEvent( source, event or "finishItemMove", source )
					return
				end					
			end
		
			if (getElementType(element) == "ped") and getElementData(element,"shopkeeper") then
				--[[if item[1] == 121 and not getElementData(element,"customshop") then-- supplies box
					triggerEvent("shop:handleSupplies", source, element, slot, event)
					return true
				end]] -- Removed by MAXIME 
				if getElementData(element,"customshop") then
					if item[1] == 134 then -- money
						triggerClientEvent( source, event or "finishItemMove", source )
						return false
					end
					triggerEvent("shop:addItemToCustomShop", source, element, slot, event)
					return true
				end
				triggerClientEvent( source, event or "finishItemMove", source )
				return false
			end
				
			if not (getElementModel( element ) == 2942) and not hasSpaceForItem( element, item[1], item[2] ) then --Except for ATM Machine / MAXIME
				outputChatBox( "The inventory is full.", source, 255, 0, 0 )
			else
				if (item[1] == 115) then -- Weapons
					local itemCheckExplode = exports.global:explode(":", item[2])
					-- itemCheckExplode: [1] = gta weapon id, [2] = serial number, [3] = weapon name
					local weaponDetails = exports.global:retrieveWeaponDetails( itemCheckExplode[2]  )
					if (tonumber(weaponDetails[2]) and tonumber(weaponDetails[2]) == 2)  then -- /duty
						outputChatBox("You can't put your duty weapon in a " .. name .. " while being on duty.", source, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
					
				elseif (item[1] == 116) then -- Ammo
					local ammoDetails = exports.global:explode( ":", item[2]  )
					-- itemCheckExplode: [1] = gta weapon id, [2] = serial number, [3] = weapon name
					local checkString = string.sub(ammoDetails[3], -4)
					if (checkString == " (D)")  then -- /duty
						outputChatBox("You can't put your duty ammo in a " .. name .. " while being on duty.", source, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
				elseif (item[1] == 179 and getElementType(element) == "vehicle") then --vehicle texture
					outputDebugString("vehicle texture")
					local vehID = getElementData(element, "dbid")
					local veh = element
					if(exports.global:isStaffOnDuty(source) or exports.integration:isPlayerScripter(source) or exports.global:hasItem(source, 3, tonumber(vehID)) or (getElementData(veh, "faction") > 0 and exports.factions:isPlayerInFaction(source, getElementData(veh, "faction"))) ) then
						outputDebugString("access granted")
						local itemExploded = exports.global:explode(";", item[2])
						local url = itemExploded[1]
						local texName = itemExploded[2]
						if url and texName then
							local res = exports["item-texture"]:addVehicleTexture(source, veh, texName, url)
							if res then
								takeItemFromSlot(source, slot)
								outputDebugString("success")
								outputChatBox("success", source)
							else
								outputDebugString("item-system/s_move_items: Failed to add vehicle texture")
							end
							triggerClientEvent(source, event or "finishItemMove", source)
							return
						end
					end
				end


				
				if (item[1] == 137) then -- Snake cam
					outputChatBox("You cannot move this item.", source, 255, 0, 0)
					triggerClientEvent( source, event or "finishItemMove", source )
					return		
				elseif item[1] == 138 then
					if not exports.integration:isPlayerAdmin(source) then
						outputChatBox("It requires an admin to move this item.", source, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
				elseif item[1] == 139 then
					if not exports.integration:isPlayerTrialAdmin(source) then
						outputChatBox("It requires a trial administrator to move this item.", source, 255, 0, 0)
						triggerClientEvent(source, event or "finishItemMove", source)
						return
					end
				end
				
				if (item[1] == 134) then -- Money
					if not exports.global:isStaffOnDuty(source) and not exports.global:isStaffOnDuty(element) then
						local hoursPlayedFrom = getElementData( source, "hoursplayed" ) or 99
						local hoursPlayedTo = getElementData( element, "hoursplayed" ) or 99
						if (getElementType(element) == "player") and (getElementType(source) == "player") then
							if hoursPlayedFrom < 10 or hoursPlayedTo < 10 then
								outputChatBox("You require 10 hours of playing time to give money to another player.", source, 255, 0, 0)
								outputChatBox(exports.global:getPlayerName(source).." requires 10 hours of playing time to give money to you.", element, 255, 0, 0)
								triggerClientEvent( source, event or "finishItemMove", source )

								outputChatBox("You require 10 hours of playing time to receive money from another player.", element, 255, 0, 0)
								outputChatBox(exports.global:getPlayerName(element).." requires 10 hours of playing time to receive money from you.", source, 255, 0, 0)
								triggerClientEvent( source, event or "finishItemMove", source )
								return false
							end
						elseif (getElementType(element) == "vehicle") and (getElementType(source) == "player") then
							if hoursPlayedFrom < 10 then
								outputChatBox("You require 10 hours of playing time to store money in a vehicle.", source, 255, 0, 0)
								triggerClientEvent( source, event or "finishItemMove", source )
								return false
							end
						elseif (getElementType(element) == "object") and (getElementType(source) == "player") then
							if hoursPlayedFrom < 10 then
								outputChatBox("You require 10 hours of playing time to store money in that.", source, 255, 0, 0)
								triggerClientEvent( source, event or "finishItemMove", source )
								return false
							end
						end
					end
					
					if exports.global:takeMoney(source, tonumber(item[2])) then
						if getElementType(element) == "player" then
							if exports.global:giveMoney(element, tonumber(item[2])) then
								triggerEvent('sendAme', source, "gives $" .. exports.global:formatMoney(item[2]) .. " to ".. exports.global:getPlayerName(element) .."." ) 
							end
						else
							if exports.global:giveItem(element, 134, tonumber(item[2])) then
								triggerEvent('sendAme', source, "puts $" .. exports.global:formatMoney(item[2]) .. " inside the "..  name .."." ) 
							end
						end
					end
				else -- not money
					if getElementType( element ) == "object" then
						local elementModel = getElementModel(element)
						local elementItemID = getElementData(element, "itemID")
						if elementItemID then
							if elementItemID == 166 then --video player
								if item[1] ~= 165 then --if item being moved to video player is not a valid video item
									exports.hud:sendBottomNotification(source, "Video Player", "That is not a valid disc.")
									triggerClientEvent( source, event or "finishItemMove", source )
									return									
								end
							end
						end
						if ( getElementDimension( element ) < 19000 and ( item[1] == 4 or item[1] == 5 ) and getElementDimension( element ) == item[2] ) or ( getElementDimension( element ) >= 20000 and item[1] == 3 and getElementDimension( element ) - 20000 == item[2] ) then -- keys to that safe as well
							if countItems( source, item[1], item[2] ) < 2 then
								outputChatBox("You can't place your only key to that safe in the safe.", source, 255, 0, 0)
								triggerClientEvent( source, event or "finishItemMove", source )
								return
							end
						end
						
						if (item[1] == 337 and getElementModel(element) == 2203) then -- irp-plant / OzulusTR
							triggerClientEvent( source, event or "finishItemMove", source )
							triggerEvent("plant-system:addSeed", source, source, element, item)
							return
						end
					end
					
					local success, reason = moveItem( source, element, slot )
					if not success then
						if not elementItemID then elementItemID = getElementData(element, "itemID") end
						local fakeReturned = false
						if elementItemID then
							if elementItemID == 166 then --video system
								exports.hud:sendBottomNotification(source, "Video Player", "There is already a disc inside. Eject old disc first.")
								fakeReturned = true
							end
						end
						if not fakeReturned then --only check by model IDs if we didnt already find a match on itemID
							if getElementModel(element) == 2942 then
								exports.hud:sendBottomNotification(source, "ATM Machine", "There is another ATM stuck inside the ATM machine's slot. Right-click for interactions.")
							end
						end
						outputDebugString( "Item Moving failed: " .. tostring( reason ))
					else
						if getElementModel(element) == 2942 then
							exports.bank:playAtmInsert(element)
						
						end
						--exports.logs:logMessage( getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( item[1] ) .. " - " .. item[2], 17)
						--exports.logs:dbLog(source, 39, source, getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( item[1] ) .. " - " .. item[2] )
						doItemGiveawayChecks( source, item[1] )
						output(source, element, item[1], item[2])

						if item[1] == 115 then
							triggerEvent( "st.destroyAll", source )
							triggerClientEvent(source, "st.updateWeapons", source)
						end
					end
				end
				exports.logs:dbLog(source, 39, source, getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( item[1] ) .. " - " .. item[2] )
			end
		end
	else -- IF AMMO
		if not ( ( slot == -100 and hasSpaceForItem( element, slot ) ) or ( slot > 0 and hasSpaceForItem( element, -slot ) ) ) then
			outputChatBox( "The Inventory is full.", source, 255, 0, 0 )
		else
			if tonumber(getElementData(source, "duty")) > 0 then
				outputChatBox("You can't put your weapons in a " .. name .. " while being on duty.", source, 255, 0, 0)
			elseif tonumber(getElementData(source, "job")) == 4 and slot == 41 then
				outputChatBox("You can't put this spray can into a " .. name .. ".", source, 255, 0, 0)
			else
				if slot == -100 then 	
					local ammo = math.ceil( getPedArmor( source ) )
					if ammo > 0 then
						setPedArmor( source, 0 )
						giveItem( element, slot, ammo )
						--exports.logs:logMessage( getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( slot ) .. " - " .. ammo, 17)
						exports.logs:dbLog(source, 39, source, getPlayerName(source) .. " moved " .. getItemName(slot) " - " .. ammo .. " #" .. getElementID(element) )
						output(source, element, -100)
					end
				else
					local getCurrentMaxAmmo = exports.global:getWeaponCount(source, slot)
					if ammo > getCurrentMaxAmmo then
						exports.global:sendMessageToAdmins("[items\moveToElement] Possible duplication of gun from '"..getPlayerName(source).."' // " .. getItemName( -slot ) )
						--exports.logs:logMessage( getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( -slot ) .. " - " .. ammo .. " BLOCKED DUE POSSIBLE DUPING", 17)
						exports.logs:dbLog(source, 39, source, getPlayerName(source) .. " moved " .. getItemName(-slot) " -  #" .. getElementID(element) .. " - BLOCKED DUE POSSIBLE DUPING" )
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end

					exports.global:takeWeapon( source, slot )
					if ammo > 0 then
						giveItem( element, -slot, ammo )
						--exports.logs:logMessage( getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( -slot ) .. " - " .. ammo, 17)
						exports.logs:dbLog(source, 39, source, getPlayerName(source) .. " moved " .. getItemName(-slot) " - " .. ammo .. " #" .. getElementID(element) )
						output(source, element, -slot)
					end
				end
			end
		end
	end
	outputDebugString("moveToElement")
	triggerClientEvent( source, event or "finishItemMove", source )
	
end

addEvent( "moveToElement", true )
addEventHandler( "moveToElement", getRootElement(), moveToElement )

--

local function moveWorldItemToElement( item, element )
	if true then
		return outputDebugString("[ITEM] moveWorldItemToElement / Disabled ")
	end

	if not isElement( item ) or not isElement( element ) or not canAccessElement( source, element ) then
		return
	end
	
	local id = tonumber(getElementData( item, "id" ))
	if not id then 
		outputChatBox("Error: No world item ID. Notify a scripter. (s_move_items)",source,255,0,0)
		destroyElement(element)
		return
	end
	local itemID = getElementData( item, "itemID" )
	local itemValue = getElementData( item, "itemValue" ) or 1
	local name = getName(element)
	
	-- ANTI ALT-ALT  MAXIME
	--31 -> 43  = DRUGS
	if ((itemID >= 31) and (itemID <= 43)) or itemBannedByAltAltChecker[itemID] then 
		outputChatBox(getItemName(itemID).." can only moved directly from your inventory to this "..name..".", source, 255, 0, 0)
		return false
	end

	
	if (getElementType(element) == "ped") and getElementData(element,"shopkeeper") then
		return false
	end
	
	if not canPickup(source, item) then
		outputChatBox("You can not move this item. Contact an admin via F2.", source, 255, 0, 0)
		return
	end
	
	if itemID == 138 then
		if not exports.integration:isPlayerAdmin(source) then
			outputChatBox("Only a full admin can move this item.", source, 255, 0, 0)
			return
		end
	end

	if itemID == 169 then
		--outputChatBox("Nay.")
		return
	end

	if giveItem( element, itemID, itemValue ) then
		
		output(source, element, itemID, itemValue, true)
		--exports.logs:logMessage( getPlayerName( source ) .. " put item #" .. id .. " (" .. itemID .. ":" .. getItemName( itemID ) .. ") - " .. itemValue .. " in " .. name .. " #" .. getElementID(element), 17)
		dbExec(mysql:getConnection(),"DELETE FROM worlditems WHERE id='" .. id .. "'")
		
		while #getItems( item ) > 0 do
			moveItem( item, element, 1 )
		end
		destroyElement( item )
	else
		outputChatBox( "The Inventory is full.", source, 255, 0, 0 )
	end
end

addEvent( "moveWorldItemToElement", true )
addEventHandler( "moveWorldItemToElement", getRootElement(), moveWorldItemToElement )

--

local function moveFromElement( element, slot, ammo, index )
	if false then
		return outputDebugString("[ITEM] moveFromElement / Disabled ")
	end
	
	if not canAccessElement( source, element ) then
		return false
	end
	local item = getItems( element )[slot]
	if not canPickup(source, item) then
		outputChatBox("You can not move this item. Contact an admin via F2.", source, 255, 0, 0)
		return 
	end
	
	
	local name = getName(element)
	
	if item and item[3] == index then
		-- ANTI ALT-ALT FOR NON AMMO ITEMS, CHECK THIS FUNCTION FOR AMMO ITEM BELOW AND FOR WORLD ITEM CHECK s_world_items.lua/ MAXIME
			--31 -> 43  = DRUGS
		
		if ( (item[1] >= 31 and item[1] <= 43) or itemBannedByAltAltChecker[item[1]]) and not (getElementModel(element) == 2942 and item[1] == 150) then 
			local hoursPlayedTo = nil
			
			if isElement(source) and getElementType(source) == "player" then
				hoursPlayedTo = getElementData( source, "hoursplayed" ) 
			end
			
			if not exports.global:isStaffOnDuty(source) and not exports.global:isStaffOnDuty(element) then
				if hoursPlayedTo < 10 then
					outputChatBox("You require 10 hours of playing time to receive a "..getItemName( item[1] ).." from a "..name..".", source, 255, 0, 0)
					triggerClientEvent( source, "forceElementMoveUpdate", source )
					triggerClientEvent( source, "finishItemMove", source )
					return false
				end
			end
		end



		if not hasSpaceForItem( source, item[1], item[2] ) then
			outputChatBox( "The inventory is full.", source, 255, 0, 0 )
		else
		if not exports.integration:isPlayerTrialAdmin( source ) and getElementType( element ) == "vehicle" and ( item[1] == 61 or item[1] == 85  or item[1] == 117 or item[1] == 140) then
			outputChatBox( "Please contact an admin via F2 to move this item.", source, 255, 0, 0 )
		elseif not exports.integration:isPlayerAdmin(source) and (item[1] == 138) then
			outputChatBox("This item requires a regular admin to be moved.", source, 255, 0, 0)
		elseif not exports.integration:isPlayerTrialAdmin(source) and (item[1] == 139) then
			outputChatBox("This item requires an admin to be moved.", source, 255, 0, 0)
		elseif item[1] > 0 then			
			if moveItem( element, source, slot ) then
				output( element, source, item[1], item[2])
				exports.logs:dbLog(source, 39, source, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. item[2])
				doItemGivenChecks(source, tonumber(item[1]))
			end
		elseif item[1] == -100 then
			local armor = math.max( 0, ( ( getElementData( source, "faction" ) == 1 or ( getElementData( source, "faction" ) == 3 and ( getElementData( source, "factionrank" ) == 4 or getElementData( source, "factionrank" ) == 5 or getElementData( source, "factionrank" ) == 13 ) ) ) and 100 or 50 ) - math.ceil( getPedArmor( source ) ) )
			
			if armor == 0 then
				outputChatBox( "You can't wear any more armor.", source, 255, 0, 0 )
			else
				output( element, source, item[1])
				takeItemFromSlot( element, slot )
				
				local leftover = math.max( 0, item[2] - armor )
				if leftover > 0 then
					giveItem( element, item[1], leftover )
				end
				
				setPedArmor( source, math.ceil( getPedArmor( source ) + math.min( item[2], armor ) ) )
				--exports.logs:logMessage( name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. ( math.min( item[2], armor ) ), 17)
				exports.logs:dbLog(source, 39, source, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. ( math.min( item[2], armor ) ))
			end
			triggerClientEvent( source, "forceElementMoveUpdate", source )
		else
			takeItemFromSlot( element, slot )
			output( element, source, item[1])
			if ammo < item[2] then
				exports.global:giveWeapon( source, -item[1], ammo )
				giveItem( element, item[1], item[2] - ammo )
				--exports.logs:logMessage( name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. ( item[2] - ammo ), 17)
				exports.logs:dbLog(source, 39, source, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. ( item[2] - ammo ))
			else
				exports.global:giveWeapon( source, -item[1], item[2] )
				--exports.logs:logMessage( name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. item[2], 17)
				exports.logs:dbLog(source, 39, {source, element}, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. item[2])
			end
			triggerClientEvent( source, "forceElementMoveUpdate", source )
		end
	end
	elseif item then
		outputDebugString( "Index mismatch: " .. tostring( item[3] ) .. " " .. tostring( index ) )
	end
	outputDebugString("moveFromElement")
	triggerClientEvent( source, "finishItemMove", source )
end
addEvent( "moveFromElement", true )
addEventHandler( "moveFromElement", getRootElement(), moveFromElement )

function getName(element)
	if getElementModel( element ) == 2942 then
		return "ATM Machine"
	elseif getElementModel( element ) == 2147 then
		return "fridge" 
	elseif getElementModel(source) == 3761 then
		return "shelf"
	end

	if getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("item-world")) then
		local itemID = tonumber(getElementData(element, "itemID")) or 0
		--local itemValue = getElementData(element, "itemValue")
		if itemID == 166 then --video player
			return "video player"
		end
	end

	if getElementType( element ) == "vehicle" then
		--[[local brand, model, year = (getElementData(element, "brand") or false), false, false
		
		if brand then
			model = getElementData(element, "maximemodel") or ""
			year = getElementData(element, "year") or ""
			return brand.." "..model.." "..year
		end
		
		local mtamodel = getElementModel(element)
		return getVehicleNameFromModel(mtamodel)]]
		return exports.global:getVehicleName(element)
	end

	if getElementType( element ) == "interior" then
		return getElementData(element, "name").."'s Mailbox"
	end
	
	if getElementType( element ) == "player" then
		return "player" 
	end
	
	return "safe"
end
