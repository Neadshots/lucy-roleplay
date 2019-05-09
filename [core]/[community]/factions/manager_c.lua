wFactionList, bFactionListClose,gridFactions = nil
local function togWindow( win, state )
	if win and isElement( win ) then
		guiSetEnabled( win, state )
	end
end

local function canEditFaction( thePlayer )
	return exports.integration:isPlayerLeadAdmin(thePlayer) or exports.integration:isPlayerFMTLeader(thePlayer)
end

local fGUI = {
    gridlist = {},
    window = {},
    button = {},
    label = {}
}

local factionTypes = {
	['0'] = "Gang",
	['1'] = "Mafia",
	['2'] = "Law",
	['3'] = "Government",
	['4'] = "Medical",
	['5'] = "Other",
	['6'] = "News",
	['7'] = "Dealership"
}

function getFactionTypes( type )
	return type and factionTypes[ tostring( type ) ] or factionTypes
end

local factions_tmp

local function getFactionTableFromId( id, table )	
	for _, fact in pairs( table ) do
		if fact.id == id then
			return fact
		end
	end
end

function showFactionList(factions)
factions_tmp = factions
	-- create window if not created.
	if not fGUI.window[1] and not isElement( fGUI.window[1] ) then
		triggerEvent( 'hud:blur', resourceRoot, 6, false, 0.5, nil )
		fGUI.window[1] = guiCreateWindow(115, 175, 850, 600, "Birlik Yönetim Arayüzü - LUCY RPG "..exports["global"]:getScriptVersion(), false)
		guiWindowSetSizable(fGUI.window[1], false)
		exports.global:centerWindow( fGUI.window[1] )
		fGUI.button[1] = guiCreateButton(766, 552, 116, 38, "Kapat", false, fGUI.window[1])
		fGUI.button[2] = guiCreateButton(10, 552, 116, 38, "Birlik Oluştur", false, fGUI.window[1])
		fGUI.button[3] = guiCreateButton(136, 552, 116, 38, "Birliği Düzenle", false, fGUI.window[1])
		fGUI.button[4] = guiCreateButton(262, 552, 116, 38, "Üyeleri Listele", false, fGUI.window[1])
		fGUI.button[5] = guiCreateButton(388, 552, 116, 38, "Birliği Sil", false, fGUI.window[1])
		fGUI.button[6] = guiCreateButton(514, 552, 116, 38, "Yenile", false, fGUI.window[1])
		fGUI.button[7] = guiCreateButton(640, 552, 116, 38, "Birliği Dinle", false, fGUI.window[1])
		local canEdit = canEditFaction( localPlayer )
		guiSetEnabled( fGUI.button[2], canEdit )
		guiSetEnabled( fGUI.button[3], canEdit )
		guiSetEnabled( fGUI.button[5], canEdit )
		addEventHandler( 'onClientGUIClick', fGUI.window[1], function()
			if source == fGUI.button[1] then
				closeFactionList()
			elseif source == fGUI.button[2] then
				editFaction()
			elseif source ==  fGUI.button[3] and fGUI.gridlist[1]  then
				local row, col = guiGridListGetSelectedItem( fGUI.gridlist[1] )
				if row ~= -1 and col ~= -1 then
					local gridID = guiGridListGetItemText( fGUI.gridlist[1] , row, 1 )
					editFaction( gridID )
				else
					exports.global:playSoundError()
					outputChatBox( "Öncelikle listeden bir birlik seçin.", 255, 0, 0 )
				end
			elseif source == fGUI.button[4] then
				local row, col = guiGridListGetSelectedItem( fGUI.gridlist[1] )
				if row ~= -1 and col ~= -1 then

					listMember( guiGridListGetItemText( fGUI.gridlist[1] , row, 1 ) )
				else
					exports.global:playSoundError()
					outputChatBox( "Öncelikle listeden bir birlik seçin.", 255, 0, 0 )
				end
			elseif source == fGUI.button[5] then
				local row, col = guiGridListGetSelectedItem( fGUI.gridlist[1] )
				if row ~= -1 and col ~= -1 then
					local gridID = guiGridListGetItemText( fGUI.gridlist[1] , row, 1 )
					delConfirm( gridID )
				else
					exports.global:playSoundError()
					outputChatBox( "Öncelikle listeden bir birlik seçin.", 255, 0, 0 )
				end
			elseif source == fGUI.button[6] then
				showFactionList()
				setTimer(function()
					closeFactionList()
					executeCommandHandler("showfactions")
				end, 1500, 1)
			elseif source == fGUI.button[7] then
				local row, col = guiGridListGetSelectedItem( fGUI.gridlist[1] )
				if row ~= -1 and col ~= -1 then
					local gridID = guiGridListGetItemText( fGUI.gridlist[1] , row, 1 )
					--executeCommandHandler("bigearsf", gridID)
					if getElementData(localPlayer, "bigearsfaction") then
						triggerServerEvent("factions:listenFaction", localPlayer, localPlayer, "bigearsf")
					else
						triggerServerEvent("factions:listenFaction", localPlayer, localPlayer, "bigearsf", gridID)
					end
				else
					exports.global:playSoundError()
					outputChatBox( "Öncelikle listeden bir birlik seçin.", 255, 0, 0 )
				end
			end
		end)
		addEventHandler( 'onClientGUIDoubleClick', fGUI.window[1], function ()
			if source == fGUI.gridlist[1] then
				local row, col = guiGridListGetSelectedItem( fGUI.gridlist[1] )
				if row ~= -1 and col ~= -1 then
					local text = guiGridListGetItemText( fGUI.gridlist[1] , row, col )
					if setClipboard( text ) then
						exports.global:playSoundSuccess()
						outputChatBox( "Copied '" .. text .. "'." )
					end
				end
			end
		end)
	end

	-- if data is not ready.
	if not factions then
		if not fGUI.label[1] then
			if fGUI.gridlist[1] and isElement( fGUI.gridlist[1] ) then
				destroyElement( fGUI.gridlist[1] )
				fGUI.gridlist[1] = nil
			end
			fGUI.label[1] = guiCreateLabel ( 0, 0, 1, 1, "Veritabanından birlik verileri alınıyor...", true, fGUI.window[1] )
			guiLabelSetHorizontalAlign( fGUI.label[1], 'center' )
			guiLabelSetVerticalAlign( fGUI.label[1], 'center' )
		--	triggerServerEvent( 'factions:fetchFactionList', resourceRoot )

			guiSetEnabled( fGUI.window[1], false )
		end
	else
		if isElement(fGUI.label[1]) then
			destroyElement( fGUI.label[1] )
			fGUI.label[1] = nil
		end
		fGUI.gridlist[1] = guiCreateGridList(9, 26, 781+50, 520, false, fGUI.window[1])
		guiGridListSetSelectionMode ( fGUI.gridlist[1], 2 )
		fGUI.gridlist.colID = guiGridListAddColumn(fGUI.gridlist[1], "ID", 0.08)
		fGUI.gridlist.colName = guiGridListAddColumn(fGUI.gridlist[1], "Birlik Adı", 0.23)
		fGUI.gridlist.colPlayers = guiGridListAddColumn(fGUI.gridlist[1], "Aktif Kullanıcı", 0.1)
		fGUI.gridlist.colType = guiGridListAddColumn(fGUI.gridlist[1], "Tip", 0.1)
		fGUI.gridlist.colInts = guiGridListAddColumn(fGUI.gridlist[1], "Evler", 0.07 )
		fGUI.gridlist.colVehs = guiGridListAddColumn(fGUI.gridlist[1], "Araçlar", 0.07 )
		fGUI.gridlist.colIntPerk = guiGridListAddColumn(fGUI.gridlist[1], "Özel Ev İzni", 0.14)
		fGUI.gridlist.colSkinPerk = guiGridListAddColumn(fGUI.gridlist[1], "Özel Kıyafet İzni", 0.18)
		guiSetEnabled( fGUI.window[1], true )
		for _, value in ipairs(factions) do
			local row = guiGridListAddRow(fGUI.gridlist[1])
			guiGridListSetItemText(fGUI.gridlist[1], row, fGUI.gridlist.colID, value.id, false, true)
			guiGridListSetItemData ( fGUI.gridlist[1], row, fGUI.gridlist.colID, value.id )
			guiGridListSetItemText(fGUI.gridlist[1], row, fGUI.gridlist.colName, value.name, false, false)
			guiGridListSetItemText(fGUI.gridlist[1], row, fGUI.gridlist.colPlayers, value.members, false, false)
			guiGridListSetItemText(fGUI.gridlist[1], row, fGUI.gridlist.colType, getFactionTypes( value.type ), false, false)
			guiGridListSetItemText(fGUI.gridlist[1], row, fGUI.gridlist.colInts, value.ints .. ' / ' .. value.max_interiors , false, false)
			guiGridListSetItemText(fGUI.gridlist[1], row, fGUI.gridlist.colVehs, value.vehs .. ' / ' .. value.max_vehicles , false, false)
			guiGridListSetItemText(fGUI.gridlist[1], row, fGUI.gridlist.colIntPerk, value.free_custom_ints == 1 and 'Evet' or 'Hayır', false, false)
			guiGridListSetItemText(fGUI.gridlist[1], row, fGUI.gridlist.colSkinPerk, value.free_custom_skins == 1 and 'Evet' or 'Hayır', false, false)
		end
	end
end
addEvent("showFactionList", true)
addEventHandler("showFactionList", getRootElement(), showFactionList)

function closeFactionList(button, state)
	if (source==bFactionListClose) and (button=="left") and (state=="up") then
		guiSetInputEnabled(false)
		destroyElement(wFactionList)
		wFactionList, bFactionListClose = nil, nil
	end
end

local maxElementTable = {
	--level, max_element
	["vehicle"] = {
		[0] = 0,
		[1] = 7,
		[2] = 14,
		[3] = 21,
		[4] = 28,
		[5] = 35,
		[6] = 42,
	},
	["interior"] = {
		[0] = 0,
		[1] = 5,
		[2] = 10,
		[3] = 15,
		[4] = 20,
		[5] = 25,
		[6] = 30,
	}
}
function showFactionListCmd()
	if exports.integration:isPlayerTrialAdmin( localPlayer ) or exports.integration:isPlayerSupporter( localPlayer ) or exports.integration:isPlayerScripter( localPlayer ) or exports.integration:isPlayerFMTMember( localPlayer ) then
		local factions = {}
		for index, value in ipairs(getElementsByType("team")) do
			--calculate vehs

			activeVehicle, activeInterior = 0, 0
			for _, vehicle in ipairs(getElementsByType("vehicle")) do
				if (tonumber(getElementData(vehicle, "faction")) == tonumber(getElementData(value, "id"))) then
					activeVehicle = activeVehicle + 1
				end
			end
			for _, interior in ipairs(getElementsByType("interior")) do
				if (tonumber(getElementData(interior, "faction")) == tonumber(getElementData(value, "id"))) then
					activeInterior = activeInterior + 1
				end
			end

			if (getElementData(value, "id") or -1) > 0 then
				factions[#factions + 1] = {
					["id"] = getElementData(value, "id"), 
					["name"] = getElementData(value, "name"), 
					["type"] = getElementData(value, "type"), 
					["members"] = (getTeamFromName( getElementData(value, "name") ) and #getPlayersInTeam( getTeamFromName( getElementData(value, "name") ) ) or "?"),
					--Jesse
					["ints"] = activeInterior,
					["vehs"] = activeVehicle,
					--Synchoronous in faction level // Jesse
					["max_interiors"] = maxElementTable["interior"][getElementData(value, "birlik_level")],
					["max_vehicles"] = maxElementTable["vehicle"][getElementData(value, "birlik_level")],
					["free_custom_ints"] = 0,
					["free_custom_skins"] = 0,
				}
			end
		end
		showFactionList(factions)
	end
end
addCommandHandler( "showfactions", showFactionListCmd, false, false )
addCommandHandler( "factions", showFactionListCmd, false, false )
addCommandHandler( "makefaction", showFactionListCmd, false, false )
addCommandHandler( "renamefaction", showFactionListCmd, false, false )
addCommandHandler( "delfaction", showFactionListCmd, false, false )

function closeFactionList()
	if fGUI.window[1] and isElement( fGUI.window[1] ) then
		destroyElement( fGUI.window[1] )
		fGUI.window[1] = nil
		closeEditFaction()
		closeDelConfirm()
		closeListMember()
		triggerEvent( 'hud:blur', resourceRoot, 'off' )
	end
end


local editFact = {
    checkbox = {},
    edit = {},
    button = {},
    window = {},
    label = {},
    combobox = {}
}

function editFaction( fact_id )
	closeEditFaction()
	guiSetInputEnabled( true )
	local data = fact_id and getFactionTableFromId( tonumber(fact_id), factions_tmp ) or nil
    editFact.window[1] = guiCreateWindow(155, 453, 385, 268, fact_id and "Edit Faction" or "Create new faction", false)
    guiWindowSetSizable(editFact.window[1], false)
    exports.global:centerWindow( editFact.window[1] )
    togWindow( fGUI.window[1], false )

    editFact.label[1] = guiCreateLabel(20, 36, 97, 29, "Faction Name:", false, editFact.window[1])
    guiLabelSetVerticalAlign(editFact.label[1], "center")
    editFact.edit.name = guiCreateEdit(117, 36, 246, 29, data and data.name or "", false, editFact.window[1])
    guiEditSetMaxLength( editFact.edit.name, 200 )
    editFact.label[2] = guiCreateLabel(20, 75, 97, 29, "Faction ID:", false, editFact.window[1])
    guiLabelSetVerticalAlign(editFact.label[2], "center")
    editFact.combobox[1] = guiCreateComboBox(117, 114, 245, 29, "Select a faction type", false, editFact.window[1])
    local types = getFactionTypes()
    for id, name in pairs( types ) do
    	guiComboBoxAddItem( editFact.combobox[1], name )
    end
    exports.global:guiComboBoxAdjustHeight( editFact.combobox[1], #types )
    if data then
    	guiSetText( editFact.combobox[1], types[ tostring(data.type or 5) ] )
    end
    editFact.edit.id = guiCreateEdit(117, 75, 246, 29, data and data.id or "auto", false, editFact.window[1])
    guiSetEnabled( editFact.edit.id, false )
    guiEditSetMaxLength( editFact.edit.id, 10 )
    editFact.label[3] = guiCreateLabel(20, 114, 97, 29, "Birlik Tipi:", false, editFact.window[1])
    guiLabelSetVerticalAlign(editFact.label[3], "center")
    editFact.label[4] = guiCreateLabel(20, 153, 97, 29, "Max Interiors:", false, editFact.window[1])
    guiLabelSetVerticalAlign(editFact.label[4], "center")
    editFact.edit.max_interiors = guiCreateEdit(117, 153, 62, 29, data and data.max_interiors or "20", false, editFact.window[1])
    guiEditSetMaxLength( editFact.edit.max_interiors, 10 )
    editFact.label[5] = guiCreateLabel(204, 153, 97, 29, "Max Vehicles:", false, editFact.window[1])
    guiLabelSetVerticalAlign(editFact.label[5], "center")
    editFact.edit.max_vehicles = guiCreateEdit( 301, 153, 62, 29, data and data.max_vehicles or "40", false, editFact.window[1] )
    guiEditSetMaxLength( editFact.edit.max_vehicles, 10 )
    editFact.checkbox[1] = guiCreateCheckBox(20, 192, 144, 29, "Free custom interiors", data and data.free_custom_ints == 1 or false, false, editFact.window[1])
    editFact.checkbox[2] = guiCreateCheckBox(20, 221, 144, 29, "Free custom skins", data and data.free_custom_skins == 1 or false, false, editFact.window[1])
    editFact.button[1] = guiCreateButton(179, 206, 88, 40, "İptal", false, editFact.window[1])
    editFact.button[2] = guiCreateButton(277, 206, 88, 40, "Tamam", false, editFact.window[1])
    addEventHandler( 'onClientGUIClick', editFact.window[1], function()
    	if source == editFact.button[1] then
    		closeEditFaction()
    	elseif source == editFact.button[2] then
    		local submit_data = {}
    		submit_data.name = guiGetText( editFact.edit.name )
    		submit_data.type = nil
    		for type_id, type_name in pairs( types ) do
    			if guiGetText( editFact.combobox[1] ) == type_name then
    				submit_data.type = tonumber( type_id )
    				break
    			end
    		end
    		submit_data.max_interiors = tonumber( guiGetText( editFact.edit.max_interiors ) )
    		submit_data.max_vehicles = tonumber( guiGetText( editFact.edit.max_vehicles ) )
    		submit_data.free_custom_ints = guiCheckBoxGetSelected( editFact.checkbox[1] ) and 1 or 0
    		submit_data.free_custom_skins = guiCheckBoxGetSelected( editFact.checkbox[2] ) and 1 or 0
    		if string.len( submit_data.name ) < 3 then
    			exports.global:playSoundError()
    			return not outputChatBox( "Faction name must be in 3 characters length or longer.", 255, 0, 0 )
    		elseif not submit_data.type then
    			exports.global:playSoundError()
    			return not outputChatBox( "Invalid faction type.", 255, 0, 0 )
    		elseif not submit_data.max_interiors or submit_data.max_interiors < 0 then 
    			exports.global:playSoundError()
    			return not outputChatBox( "Max interiors must be positive. ", 255, 0, 0 )
    		elseif not submit_data.max_vehicles or submit_data.max_vehicles < 0 then
    			exports.global:playSoundError()
    			return not outputChatBox( "Max vehicles must be positive. ", 255, 0, 0 )
    		else
    			triggerServerEvent( 'factions:editFaction', localPlayer, localPlayer, submit_data, fact_id )
    			togWindow( editFact.window[1], false )
    			exports.global:playSoundSuccess()
				closeEditFaction()
				closeFactionList()
				showFactionList()
				setTimer(
					function()
						executeCommandHandler("showfactions")
					end,
				1500, 1)
    		end
    	end
    end)    
end

function closeEditFaction()
	if editFact.window[1] and isElement( editFact.window[1] ) then
		destroyElement( editFact.window[1] )
		editFact.window[1] = nil
		togWindow( fGUI.window[1], true )
		guiSetInputEnabled( false )
	end
end

addEvent( 'factions:editFaction:callback', true )
addEventHandler( 'factions:editFaction:callback', resourceRoot, function ( response )
	if response == 'ok' then
		exports.global:playSoundSuccess()
		closeEditFaction()
		showFactionList()
	else
		exports.global:playSoundError()
		outputChatBox( response, 255, 0, 0 )
		togWindow( editFact.window[1], true )
	end
end )


local delGUI = {
    button = {},
    window = {},
    label = {}
}
function delConfirm( fact_id )
	closeDelConfirm()
	togWindow( fGUI.window[1], false )
	local fact = getFactionTableFromId( tonumber(fact_id), factions_tmp )
    delGUI.window[1] = guiCreateWindow(429, 298, 437, 206, "Birlik Silme Arayüzü", false)
    guiWindowSetSizable(delGUI.window[1], false)
    exports.global:centerWindow( delGUI.window[1] )

    delGUI.label[1] = guiCreateLabel(15, 43, 412, 110, "Şu anda bu birliği silmek üzeresin: ID #" .. fact.id .. " (" .. fact.name .. ").\n\nBirlikle ilgili herşey sunucudan kaldırılacak ( Araçlar, mülkler, eşyalar, birlik parası ).\nİşlemin geri dönüşü olmayacak.\n\nBu işlemi yapmak istediğine emin misin?", false, delGUI.window[1])
    guiLabelSetHorizontalAlign(delGUI.label[1], "left", true)
    delGUI.button[1] = guiCreateButton(17, 158, 200, 33, "İptal", false, delGUI.window[1])
    delGUI.button[2] = guiCreateButton(223, 158, 200, 33, "Onayla", false, delGUI.window[1])    
    addEventHandler( 'onClientGUIClick', delGUI.window[1], function ()
    	if source == delGUI.button[1] then
    		closeDelConfirm()
    	elseif source == delGUI.button[2] then
    		closeDelConfirm()
    		triggerServerEvent( 'factions:delete', resourceRoot, fact_id )
			showFactionList()
			setTimer(
				function()
					executeCommandHandler("showfactions")
				end,
			1500, 1)
    	end
    end)
end

function closeDelConfirm()
	if delGUI.window[1] and isElement( delGUI.window[1] ) then
		destroyElement( delGUI.window[1] )
		delGUI.window[1] = nil
		togWindow( fGUI.window[1], true )
	end
end


local listMemberGUI = {
    gridlist = {},
    window = {},
    button = {},
    label = {},
    col={},
}

local fact_id_tmp
function listMember( fact_id, response, data )
	closeListMember()

	togWindow( fGUI.window[1], false )
	local wExtend = 45
    listMemberGUI.window[1] = guiCreateWindow(519, 255, 555+wExtend, 372, "Üye Listesi - LUCY RPG "..exports["global"]:getScriptVersion(), false)
    guiWindowSetSizable(listMemberGUI.window[1], false)
    exports.global:centerWindow( listMemberGUI.window[1] )

    if data then
    	if listMemberGUI.label[1] and isElement( listMemberGUI.label[1] ) then
    		destroyElement( listMemberGUI.label[1] )
    		listMemberGUI.label[1] = nil
    	end
	    listMemberGUI.gridlist[1] = guiCreateGridList(9, 26, 536+wExtend, 299, false, listMemberGUI.window[1])
	    listMemberGUI.col.faction_leader = guiGridListAddColumn(listMemberGUI.gridlist[1], "Lider", 0.1)
	    listMemberGUI.col.faction_rank = guiGridListAddColumn(listMemberGUI.gridlist[1], "Rütbe", 0.33)
	    listMemberGUI.col.charactername = guiGridListAddColumn(listMemberGUI.gridlist[1], "Kullanıcı", 0.27)
		listMemberGUI.col.username = guiGridListAddColumn(listMemberGUI.gridlist[1], "Hesap", 0.15)
		listMemberGUI.col.duty = guiGridListAddColumn(listMemberGUI.gridlist[1], "Duty", 0.08)
	    for _, member in ipairs( data ) do
			local row = guiGridListAddRow( listMemberGUI.gridlist[1] )
			guiGridListSetItemText(listMemberGUI.gridlist[1], row, listMemberGUI.col.faction_leader, member.faction_leader == 1 and 'Evet' or 'Hayır', false, false)
			guiGridListSetItemText(listMemberGUI.gridlist[1], row, listMemberGUI.col.faction_rank, member.faction_rank_name or '', false, false)
			guiGridListSetItemText(listMemberGUI.gridlist[1], row, listMemberGUI.col.charactername, member.charactername and string.gsub( member.charactername, '_', ' ') or '', false, false)
			guiGridListSetItemText(listMemberGUI.gridlist[1], row, listMemberGUI.col.username, member.username or '', false, false)
			guiGridListSetItemColor ( listMemberGUI.gridlist[1], row, listMemberGUI.col.charactername, member.online == 1 and 0 or 255, 255, member.online == 1 and 0 or 255 , member.online == 1 and 255 or 200 )
			guiGridListSetItemText(listMemberGUI.gridlist[1], row, listMemberGUI.col.duty, member.duty and "Evet" or "Hayır", false, false)
			guiGridListSetItemColor ( listMemberGUI.gridlist[1], row, listMemberGUI.col.duty, member.duty and 0 or 255, 255, member.duty and 0 or 255, member.duty and 255 or 200 )
			--guiGridListSetItemColor ( listMemberGUI.gridlist[1], row, listMemberGUI.col.charactername, 255, member.faction_leader == 1 and 0 or 255, member.faction_leader == 1 and 0 or 255 , 255 )
		end
		addEventHandler( 'onClientGUIDoubleClick', listMemberGUI.gridlist[1], function ()
			local row, col = guiGridListGetSelectedItem( listMemberGUI.gridlist[1] )
			if row ~= -1 and col ~= -1 then
				local text = guiGridListGetItemText( listMemberGUI.gridlist[1] , row, 2 ) .. ' - ' .. guiGridListGetItemText( listMemberGUI.gridlist[1] , row, 3 ) .. ' (' .. guiGridListGetItemText( listMemberGUI.gridlist[1] , row, 4 ) .. ')'
				if setClipboard( text ) then
					outputChatBox( "Copied '" .. text .. "'.")
					exports.global:playSoundSuccess()
				end
			end
		end)
	    togWindow( listMemberGUI.window[1], true )
	else
		if response then
			if listMemberGUI.gridlist[1] and isElement( listMemberGUI.gridlist[1] ) then
	    		destroyElement( listMemberGUI.gridlist[1] )
	    		listMemberGUI.gridlist[1] = nil
	    	end
			if listMemberGUI.label[1] and isElement( listMemberGUI.label[1] ) then
    			guiSetText( listMemberGUI.label[1], response )
    		end
    		togWindow( listMemberGUI.window[1], true )
    	else
    		if listMemberGUI.gridlist[1] and isElement( listMemberGUI.gridlist[1] ) then
	    		destroyElement( listMemberGUI.gridlist[1] )
	    		listMemberGUI.gridlist[1] = nil
	    	end
	    	listMemberGUI.label[1] = guiCreateLabel ( 0, 0, 1, 1, "Veritabanından birlik verileri alınıyor...", true, listMemberGUI.window[1] )
			guiLabelSetHorizontalAlign( listMemberGUI.label[1], 'center' )
			guiLabelSetVerticalAlign( listMemberGUI.label[1], 'center' )
			--outputChatBox( tostring(fact_id))
	    	triggerServerEvent( 'factions:listMember', localPlayer, localPlayer, fact_id )
	    	setTimer(
	    		function()
	    			--theTeam = exports.pool:getElement("team", fact_id)
	    			for i,v in ipairs(getElementsByType("team")) do
	    				if tonumber(getElementData(v, "id")) == tonumber(fact_id) then
	    					listMember(fact_id, "", getElementData(v, "receivePlayers"))
	    				end
	    			end
	    			
	    		end,
	    	2500, 1)
			togWindow( listMemberGUI.window[1], false )
			fact_id_tmp = fact_id
    	end
    end

    listMemberGUI.button[1] = guiCreateButton(451+wExtend, 332, 94, 30, "Kapat", false, listMemberGUI.window[1])
    listMemberGUI.button[2] = guiCreateButton(350+wExtend, 332, 94, 30, "Yenile", false, listMemberGUI.window[1])    
    addEventHandler( 'onClientGUIClick', listMemberGUI.window[1], function()
    	if source == listMemberGUI.button[1] then
    		closeListMember()
    	elseif source == listMemberGUI.button[2] then
    		listMember( fact_id_tmp )
    	end
    end)
end
addEvent( 'factions:listMember', true )
addEventHandler( 'factions:listMember', resourceRoot, listMember )

function closeListMember()
	if listMemberGUI.window[1] and isElement( listMemberGUI.window[1] ) then
		destroyElement( listMemberGUI.window[1] )
		listMemberGUI.window[1] = nil
		togWindow( fGUI.window[1], true )
	end
end


function centerWindow (center_window)
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = guiGetSize(center_window, false)
    local x, y = (screenW - windowW) /2,(screenH - windowH) /2
    guiSetPosition(center_window, x, y, false)
end

DutyAllow = {
    label = {},
    edit = {},
    button = {},
    window = {},
    gridlist = {},
    combobox = {}
}

weapBanList = {
	[-8] = true, -- Katana
	[-35] = true, -- RPG
	[-36] = true, -- Homing RPG
	[-37] = true, -- Flamethrower
	[-38] = true, -- Minigun
	[-39] = true, -- C4 Charge
	[-40] = true, -- C4 Det
}

function createAdminDuty(factionT, dutyT)
	if isElement(DutyAllow.window[1]) then
		destroyElement(DutyAllow.window[1])
	end

	factionTable = factionT
	dutyChanges = dutyT

    DutyAllow.window[1] = guiCreateWindow(562, 250, 564, 351, "Admin Duty Settings", false)
    centerWindow(DutyAllow.window[1])
    guiWindowSetSizable(DutyAllow.window[1], false)
    guiWindowSetMovable(DutyAllow.window[1], true)
    guiSetInputEnabled(true)

	DutyAllow.gridlist[1] = guiCreateGridList(9, 75, 545, 224, false, DutyAllow.window[1])
    guiGridListAddColumn(DutyAllow.gridlist[1], "ID", 0.1)
    guiGridListAddColumn(DutyAllow.gridlist[1], "Name", 0.3)
    guiGridListAddColumn(DutyAllow.gridlist[1], "Description", 0.6)
    DutyAllow.label[1] = guiCreateLabel(10, 308, 73, 21, "Item ID:", false, DutyAllow.window[1])
    guiLabelSetVerticalAlign(DutyAllow.label[1], "center")
    DutyAllow.edit[1] = guiCreateEdit(83, 308, 78, 21, "", false, DutyAllow.window[1])
    DutyAllow.button[1] = guiCreateButton(318, 303, 108, 30, "Allow", false, DutyAllow.window[1])
    guiSetProperty(DutyAllow.button[1], "NormalTextColour", "FFAAAAAA")
    DutyAllow.button[2] = guiCreateButton(436, 303, 108, 30, "Remove", false, DutyAllow.window[1])
    guiSetProperty(DutyAllow.button[2], "NormalTextColour", "FFAAAAAA")
    DutyAllow.label[2] = guiCreateLabel(11, 59, 543, 16, "Allowed Items", false, DutyAllow.window[1])
    guiLabelSetHorizontalAlign(DutyAllow.label[2], "center", false)
    DutyAllow.label[3] = guiCreateLabel(9, 348, 74, 24, "View:", false, DutyAllow.window[1])
    guiLabelSetVerticalAlign(DutyAllow.label[3], "center")
    DutyAllow.label[4] = guiCreateLabel(163, 308, 68, 20, "Item Value:", false, DutyAllow.window[1])
    guiLabelSetVerticalAlign(DutyAllow.label[4], "center")
    DutyAllow.edit[2] = guiCreateEdit(230, 308, 78, 21, "1", false, DutyAllow.window[1])   
    DutyAllow.combobox[1] = guiCreateComboBox(1, 25, 242, 998, "Make a faction selection.", false, DutyAllow.window[1])
    exports.global:guiComboBoxAdjustHeight(DutyAllow.combobox[1], #factionT)
    DutyAllow.button[3] = guiCreateButton(442, 25, 102, 35, "Done", false, DutyAllow.window[1])
    guiSetProperty(DutyAllow.button[3], "NormalTextColour", "FFAAAAAA")
    DutyAllow.combobox[2] = guiCreateComboBox(255, 25, 124, 19, "", false, DutyAllow.window[1])
    exports.global:guiComboBoxAdjustHeight(DutyAllow.combobox[2], 2)
    guiComboBoxAddItem(DutyAllow.combobox[2], "Items")
    guiComboBoxAddItem(DutyAllow.combobox[2], "Weapons")  
    guiComboBoxSetSelected( DutyAllow.combobox[2], 0 )

    local row = guiGridListAddRow( DutyAllow.gridlist[1] )
    guiGridListSetItemText ( DutyAllow.gridlist[1], row, 2, "Make a faction selection...", false, false )

    for k,v in pairs(factionT) do
    	guiComboBoxAddItem( DutyAllow.combobox[1], "(".. v[1] ..") " .. v[2] )
    end
    addEventHandler("onClientGUIComboBoxAccepted", DutyAllow.combobox[1], toggleFaction) 
    addEventHandler("onClientGUIComboBoxAccepted", DutyAllow.combobox[2], toggleView)

    addEventHandler("onClientGUIClick", DutyAllow.button[1], allowItem, false)
    addEventHandler("onClientGUIClick", DutyAllow.button[2], removeItem, false)
    addEventHandler("onClientGUIClick", DutyAllow.button[3], closeGUI, false)
end
addEvent("adminDutyAllow", true)
addEventHandler("adminDutyAllow", resourceRoot, createAdminDuty)

function populateList(key) -- Type 1 is weapons, 0 is items
	local selection = guiComboBoxGetSelected (DutyAllow.combobox[2])
	guiGridListClear( DutyAllow.gridlist[1] )
	if selection == 0 then -- Items
		for k,v in pairs(factionTable[key][3]) do
			if tonumber(v[2]) > 0 then
				local row = guiGridListAddRow(DutyAllow.gridlist[1])

				guiGridListSetItemText(DutyAllow.gridlist[1], row, 1, v[2], false, true)
				guiGridListSetItemText(DutyAllow.gridlist[1], row, 2, exports["item-system"]:getItemName(v[2]), false, false)
				guiGridListSetItemText(DutyAllow.gridlist[1], row, 3, exports["item-system"]:getItemDescription(v[2], v[3]), false, false)
				guiGridListSetItemData(DutyAllow.gridlist[1], row, 1, tonumber(v[1]))
			end
		end
	elseif selection == 1 then -- Weapons
		for k,v in pairs(factionTable[key][3]) do
			if tonumber(v[2]) < 0 then
				local row = guiGridListAddRow(DutyAllow.gridlist[1])
				if tonumber(v[2]) == -100 then
					guiGridListSetItemText(DutyAllow.gridlist[1], row, 1, v[2], false, true)
					guiGridListSetItemText(DutyAllow.gridlist[1], row, 2, "Armor", false, false)
					guiGridListSetItemText(DutyAllow.gridlist[1], row, 3, v[3], false, false)
				else
					guiGridListSetItemText(DutyAllow.gridlist[1], row, 1, v[2], false, true)
					guiGridListSetItemText(DutyAllow.gridlist[1], row, 2, exports["item-system"]:getItemName(v[2]), false, false)
					guiGridListSetItemText(DutyAllow.gridlist[1], row, 3, v[3], false, false)
				end
				guiGridListSetItemData(DutyAllow.gridlist[1], row, 1, tonumber(v[1]))
			end
		end
	end
	guiSetText(DutyAllow.edit[1], "")
	guiSetText(DutyAllow.edit[2], "")
end

function toggleView()
	local item = guiComboBoxGetSelected (DutyAllow.combobox[2])
    guiGridListClear( DutyAllow.gridlist[1] )

	if item == 1 then -- Weapons
		guiSetText(DutyAllow.label[2], "Allowed Weapons")

        guiGridListSetColumnTitle(DutyAllow.gridlist[1], 2, "Name")
        guiGridListSetColumnTitle(DutyAllow.gridlist[1], 3, "Max Ammo")

        guiSetText(DutyAllow.label[1], "Weapon ID:")
        guiSetText(DutyAllow.label[4], "Max Ammo:")
	elseif item == 0 then -- Items
		guiSetText(DutyAllow.label[2], "Allowed Items")

        guiGridListSetColumnTitle(DutyAllow.gridlist[1], 2, "Name")
        guiGridListSetColumnTitle(DutyAllow.gridlist[1], 3, "Description")

        guiSetText(DutyAllow.label[1], "Item ID:")
        guiSetText(DutyAllow.label[4], "Item Value:")
	end
	if guiComboBoxGetSelected(DutyAllow.combobox[1]) and guiComboBoxGetSelected(DutyAllow.combobox[1]) > -1 then
		populateList(guiComboBoxGetSelected(DutyAllow.combobox[1])+1)
	end
end

function toggleFaction()
	local selected = guiComboBoxGetSelected(DutyAllow.combobox[1])
	if selected and selected > -1 then
		populateList(selected+1)
	end
end

function closeGUI()
	destroyElement(DutyAllow.window[1])
	guiSetInputEnabled(false)
	triggerServerEvent("dutyAdmin:Save", resourceRoot, factionTable, dutyChanges)
end

function allowItem()
	local itemID = guiGetText(DutyAllow.edit[1])
	local itemValue = guiGetText(DutyAllow.edit[2])
	local selection = guiComboBoxGetSelected (DutyAllow.combobox[2])
	local faction = guiComboBoxGetSelected (DutyAllow.combobox[1])+1
	local maxIndex = getElementData(resourceRoot, "maxIndex")+1
	if not tonumber(itemID) then return end

	if not exports['item-system']:isItem(itemID) and selection == 0 then
		outputChatBox("That's not even a item...", 255, 0, 0)
		return
	elseif not getWeaponNameFromID(itemID) and selection == 1 and tonumber(itemID) ~= 100 then
		outputChatBox("That's not even a weapon...", 255, 0, 0)
		return
	end

	if faction and faction > 0 then
		--[[for k,v in pairs(factionTable[faction][3]) do
			if tonumber(v[2]) == tonumber(selection == 1 and -itemID or itemID) then
				outputChatBox("You already allow this item.", 255, 0, 0)
				return
			end
		end]]

		if tonumber(itemID) then
			if selection == 0 then -- Item
				table.insert(factionTable[faction][3], { maxIndex, tonumber(itemID), itemValue })
				table.insert(dutyChanges, { faction, 1, maxIndex, tonumber(itemID), itemValue })
				setElementData(resourceRoot, "maxIndex", maxIndex)
			elseif selection == 1 then -- Weapon
				if tonumber(itemValue) then
					if not weapBanList[-tonumber(itemID)] then -- Check if its banned.
						table.insert(factionTable[faction][3], { maxIndex, -tonumber(itemID), itemValue })
						table.insert(dutyChanges, { faction, 1, maxIndex, -tonumber(itemID), itemValue })
						setElementData(resourceRoot, "maxIndex", maxIndex)
					else
						outputChatBox("This weapon is banned from being added.", 255, 0, 0)
					end
				else
					outputChatBox("The Max Ammo must be a number!", 255, 0, 0)
				end
			end
			populateList(faction)
		else
			outputChatBox("The Item ID must be a number!", 255, 0, 0)
		end
	else
		outputChatBox("Please make a selection first.", 255, 0, 0)
	end
end

function removeItem()
	local r, c = guiGridListGetSelectedItem ( DutyAllow.gridlist[1] )
	local faction = guiComboBoxGetSelected(DutyAllow.combobox[1])+1
    if r and r>=0 and c and c>=0 and faction and faction > 0 then
    	local id = guiGridListGetItemData(DutyAllow.gridlist[1], r, 1)
    	for k,v in pairs(factionTable[faction][3]) do
    		if tonumber(id) == tonumber(v[1]) then
    			table.insert(dutyChanges, { faction, 0, k })
    			table.remove(factionTable[faction][3], k)
    			populateList(faction)
    		end
    	end
    else
    	outputChatBox("Please make a selection first.", 255, 0, 0)
    end
end