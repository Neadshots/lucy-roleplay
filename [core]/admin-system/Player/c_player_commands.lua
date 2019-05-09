function nudgeNoise()
   local sound = playSound("Player/nudge.wav")
   setSoundVolume(sound, 0.5) -- set the sound volume to 50%
end
addEvent("playNudgeSound", true)
addEventHandler("playNudgeSound", getLocalPlayer(), nudgeNoise)
addCommandHandler("playthenoise", nudgeNoise)

function doEarthquake()
	local x, y, z = getElementPosition(getLocalPlayer())
	createExplosion(x, y, z, -1, false, 3.0, false)
end
addEvent("doEarthquake", true)
addEventHandler("doEarthquake", getLocalPlayer(), doEarthquake)

function streamASound(link)
	playSound(link)
end
addEvent("playSound", true)
addEventHandler("playSound", getRootElement(), streamASound)

function develop()
	if exports.integration:isPlayerScripter(getLocalPlayer()) then
		if not devMode then
			setDevelopmentMode( true )
			devMode = true
			outputChatBox("Development Mode Enabled. /showcol, /showsound", 0, 255, 0)
		else
			setDevelopmentMode( false )
			devMode = false
			outputChatBox("Development Mode Disabled.", 255, 0, 0)
		end
	end
end
addCommandHandler("devmode", develop)

function seeFar(localPlayer, value)
	if not value then outputChatBox("SYNTAX: /seefar [value or -1 to reset it]") end
	if value and tonumber(value) >= 250 and tonumber(value) <= 20000 then
		setFarClipDistance(value)
		outputChatBox("Clip distance set to "..value..".")
	elseif value and tonumber(value) == -1 then
		resetFarClipDistance()
	else
		outputChatBox("Maximum value for render distance is 20000 and minimum is 250.")
	end
end
addCommandHandler("seefar", seeFar)

--CARGO GROUP
--[[
function cargoGroupGenericPed(button, state, absX, absY, wx, wy, wz, element)
    if (element) and (getElementType(element)=="ped") and (button=="right") and (state=="down") then --if it's a right-click on a object
		local pedName = getElementData(element, "name") or "The Storekeeper"
		pedName = tostring(pedName):gsub("_", " ")

        local rcMenu
        if(pedName == "Michael Dupont") then
            rcMenu = exports.rightclick:create(pedName)
            local row = exports.rightclick:addRow("Talk")
            addEventHandler("onClientGUIClick", row,  function (button, state)
                local allowedFactions = {56, 74, 104}
                local factionID = false
                for k,v in ipairs(allowedFactions) do
                    local isIn, _, leader = exports.factions:isPlayerInFaction(localPlayer, v)
                    if isIn and leader then
                        factionID = v
                        break
                    end
                end
            	if factionID and getElementData(localPlayer, "loggedin") == 1 then
                	triggerEvent("createCargoGUI", localPlayer)
                end
            end, false)

            local row2 = exports.rightclick:addRow("Close")
            addEventHandler("onClientGUIClick", row2,  function (button, state)
                exports.rightclick:destroy(rcMenu)
            end, false)
        end
    end
end
addEventHandler("onClientClick", getRootElement(), cargoGroupGenericPed, true)
--]]

local cargogui = {}
function buildCargoGUI()

	cargogui._placeHolders = {}

	if cargogui["_root"] and isElement(cargogui["_root"]) then destroyElement(cargogui["_root"]) end

	guiSetInputMode("no_binds_when_editing")

	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 384, 210
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	cargogui["_root"] = guiCreateWindow(left, top, windowWidth, windowHeight, "Cargo Group Generic Maker v1.0", false)
	guiWindowSetSizable(cargogui["_root"], false)

	cargogui["pushButton"] = guiCreateButton(250, 165, 75, 23, "Close", false, cargogui["_root"])
	addEventHandler("onClientGUIClick", cargogui["pushButton"], function ()
		destroyElement(cargogui["_root"])
		showCursor(false)
		guiSetInputMode("allow_binds")
	end, false)

	cargogui["label"] = guiCreateLabel(20, 25, 301, 16, "This GUI is only availabe to Cargo Group faction leaders. ", false, cargogui["_root"])
	guiLabelSetHorizontalAlign(cargogui["label"], "left", false)
	guiLabelSetVerticalAlign(cargogui["label"], "center")

	cargogui["label_2"] = guiCreateLabel(20, 45, 371, 16, "Put in realistic prices. They are logged and notified to staff.", false, cargogui["_root"])
	guiLabelSetHorizontalAlign(cargogui["label_2"], "left", false)
	guiLabelSetVerticalAlign(cargogui["label_2"], "center")

	cargogui["lineEdit_name"] = guiCreateEdit(20, 85, 320, 21, "", false, cargogui["_root"])
	guiEditSetMaxLength(cargogui["lineEdit_name"], 32767)

	cargogui["lineEdit_price"] = guiCreateEdit(20, 129, 151, 21, "", false, cargogui["_root"])
	guiEditSetMaxLength(cargogui["lineEdit_price"], 32767)

	cargogui["label_3"] = guiCreateLabel(20, 66, 170, 16, "Item name (name:model)", false, cargogui["_root"])
	guiLabelSetHorizontalAlign(cargogui["label_3"], "left", false)
	guiLabelSetVerticalAlign(cargogui["label_3"], "center")

	cargogui["label_4"] = guiCreateLabel(20, 110, 36, 13, "Price", false, cargogui["_root"])
	guiLabelSetHorizontalAlign(cargogui["label_4"], "left", false)
	guiLabelSetVerticalAlign(cargogui["label_4"], "center")

	cargogui["label_5"] = guiCreateLabel(20, 152, 50, 15, "Quantity:", false, cargogui["_root"])
	guiLabelSetHorizontalAlign(cargogui["label_5"], "left", false)
	guiLabelSetVerticalAlign(cargogui["label_5"], "center")

	cargogui["lineEdit_quantity"] = guiCreateEdit(20, 170, 151, 21, "", false, cargogui["_root"])
	guiEditSetMaxLength(cargogui["lineEdit_quantity"], 2)

	cargogui["pushButton_2"] = guiCreateButton(220, 130, 131, 30, "Create", false, cargogui["_root"])
	addEventHandler("onClientGUIClick", cargogui["pushButton_2"], function ()
		local price = guiGetText(cargogui["lineEdit_price"]) -- these already return strings anumaz lol
		local name = guiGetText(cargogui["lineEdit_name"])
		local quantity = guiGetText(cargogui["lineEdit_quantity"])
		guiSetText(cargogui["lineEdit_price"], "")
		guiSetText(cargogui["lineEdit_name"], "")
		guiSetText(cargogui["lineEdit_quantity"], "")
		if tonumber(quantity) and tonumber(quantity) > 30 then
			outputChatBox("You can only spawn 30 items at a time.", 255, 0, 0)
			return
		end
		triggerServerEvent("createCargoGeneric", getResourceRootElement(), localPlayer, "cmg", price, quantity, name)
		end, false)

	return cargogui, windowWidth, windowHeight
end
addEvent("createCargoGUI", true)
addEventHandler("createCargoGUI", getRootElement(), buildCargoGUI)

function getCameraPosition(cmd)
	if exports.integration:isPlayerHeadAdmin(localPlayer) then
		x, y, z, lx, ly, lz = getCameraMatrix()
		setClipboard(x..","..y..","..z..","..lx..","..ly..","..lz)
	end
end
addCommandHandler("getcpos", getCameraPosition)


adminInterface = {
    edit = {},
    button = {},
    window = {},
    label = {},
    gridlist = {}
}

qPlayers = {};

addEvent("quitingPlayer:updateTable", true)
addEventHandler("quitingPlayer:updateTable", root,
	function(table, update)
		qPlayers = table
		if update then
			refuseControl_panel(table)
		end
	end
)

function refuseControl_panel(table)
	triggerServerEvent("quitingPlayer:receiveTable", localPlayer, localPlayer)
	if isElement(adminInterface.window[1]) then
		destroyElement(adminInterface.window[1])
	end
	adminInterface.window[1] = guiCreateWindow(304, 207, 841, 542, "Yakın Bölgede Oyundan Ayrılan Oyuncular - LUCY RPG "..exports.global:getScriptVersion(), false)
	guiWindowSetSizable(adminInterface.window[1], false)
	guiSetEnabled(adminInterface.window[1], false)
	if not table then

	else
		guiSetEnabled(adminInterface.window[1], true)
		adminInterface.button[1] = guiCreateButton(537, 496, 294, 36, "Arayüzü Kapat", false, adminInterface.window[1])
		adminInterface.button[2] = guiCreateButton(9, 494, 512, 38, "Seçilen Oyuncuyu Cezalandır", false, adminInterface.window[1])
		guiSetProperty(adminInterface.button[2], "DisabledTextColour", "FFE84118")
		guiSetProperty(adminInterface.button[2], "Disabled", "True")
		adminInterface.gridlist[1] = guiCreateGridList(11, 28, 820, 374, false, adminInterface.window[1])
		guiGridListAddColumn(adminInterface.gridlist[1], "ID", 0.2)
		guiGridListAddColumn(adminInterface.gridlist[1], "Karakter Adı", 0.2)
		guiGridListAddColumn(adminInterface.gridlist[1], "Kullanıcı Adı", 0.2)
		guiGridListAddColumn(adminInterface.gridlist[1], "Çıkış Nedeni", 0.2)
		guiGridListAddColumn(adminInterface.gridlist[1], "Zaman", 0.2)
		for index, value in ipairs(table) do
			row = guiGridListAddRow(adminInterface.gridlist[1])
			guiGridListSetItemText(adminInterface.gridlist[1], row, 1, value[1], false, false)
			guiGridListSetItemText(adminInterface.gridlist[1], row, 2, value[2], false, false)
			guiGridListSetItemText(adminInterface.gridlist[1], row, 3, value[3], false, false)
			guiGridListSetItemText(adminInterface.gridlist[1], row, 4, value[4], false, false)
			guiGridListSetItemText(adminInterface.gridlist[1], row, 5, value[5], false, false)
		end
		
		adminInterface.edit[1] = guiCreateEdit(138, 455, 383, 29, "Refuse RP + /q", false, adminInterface.window[1])
		adminInterface.label[1] = guiCreateLabel(10, 455, 120, 27, "Cezalandırma Nedeni:", false, adminInterface.window[1])
		guiLabelSetHorizontalAlign(adminInterface.label[1], "center", false)
		guiLabelSetVerticalAlign(adminInterface.label[1], "center")
		adminInterface.label[2] = guiCreateLabel(12, 416, 118, 23, "Süre:", false, adminInterface.window[1])
		guiLabelSetHorizontalAlign(adminInterface.label[2], "center", false)
		guiLabelSetVerticalAlign(adminInterface.label[2], "center")
		adminInterface.edit[2] = guiCreateEdit(137, 416, 202, 29, "", false, adminInterface.window[1])

		addEventHandler("onClientGUIClick", root,
			function(b)
				if b == "left" then
					if source == adminInterface.button[1] then
						destroyElement(adminInterface.window[1])
					end
				end
			end
		)
	end
end

addCommandHandler("refusepanel", 
	function()
		if exports.integration:isPlayerTrialAdmin(localPlayer) then
			refuseControl_panel()
		end
	end
)

addEventHandler( "onClientPlayerQuit", root,
	function(reason)
		if getElementData(source, "loggedin") == 1 then
			local time = getRealTime()
			local hours = time.hour
			local minutes = time.minute
			local seconds = time.second
			local year = time.year
			local month = time.month
			local monthday = time.monthday

			quitedPlayer = {getElementData(source, "dbid"), getPlayerName(source), getElementData(source, "account:username"), reason, year.."-"..month.."-"..monthday.." "..hours..":"..minutes..":"..seconds}
		
			triggerServerEvent("quitingPlayer:addRow", root, quitedPlayer)
		end
	end
)

function copyPosToClipboard( prepairedText)
	setClipboard( prepairedText ) 
end
addEvent("copyPosToClipboard",true)
addEventHandler("copyPosToClipboard", getLocalPlayer(),copyPosToClipboard )