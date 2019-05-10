--[[function displayLocksmithJob()
	outputChatBox("#FF9933Use /copykey [key type][Anahtar ID] to duplicate keys.", 255, 194, 15, true)
	outputChatBox("#FF9933The key you want to duplicate must be in your inventory.", 255, 194, 15, true)
end]]

-- by anumaz, for owlgaming, on 2014-11-09
-- configs
local npcmodel = 161 -- skin ID of the ped
local x, y, z =  -2035.09375, -117.7099609375, 1035.171875 -- location of the ped
local rot = 266 -- rotation of the ped
local int = 3 -- interior of the ped
local dim = 2913 -- dimension of the ped
local name = "Georgio Dupont" -- first and last name of the ped
local cost = 50 -- cost in dollars per key
-- end of configs

local localPlayer = getLocalPlayer()
local inprocess = false

function createLocksmithNPC()
	local ped = createPed(npcmodel, x, y, z)
	setElementFrozen(ped, true)
	setElementRotation(ped, 0, 0, rot)
	setElementDimension(ped, dim)
	setElementInterior(ped, int)

	setElementData(ped, 'name', name, false)
	setElementData(ped, "talk", 1, true)

	addEventHandler( 'onClientPedWasted', ped,
		function()
			setTimer(
				function()
					destroyElement(ped)
					createShopPed()
				end, 30000, 1)
		end, false)

	addEventHandler( 'onClientPedDamage', ped, cancelEvent, false )
end

addEventHandler( 'onClientResourceStart', resourceRoot, createLocksmithNPC )



local GUIEditor = {
    edit = {},
    button = {},
    window = {},
    label = {},
    combobox = {}
}
function createGUI()
	if GUIEditor.window[1] and isElement(GUIEditor.window[1]) then destroyElement(GUIEditor.window[1]) end

	GUIEditor.window[1] = guiCreateWindow(656, 279, 292, 180, "Anahtar Kopyalayıcı  - Powered by Tree Technology", false)
	guiWindowSetSizable(GUIEditor.window[1], false)
	exports["global"]:centerWindow(GUIEditor.window[1])

	GUIEditor.label[1] = guiCreateLabel(0.03, 0.12, 0.93, 0.09, "Selam! Bugün hangi anahtarı kopyalayacaksın?", true, GUIEditor.window[1])
	GUIEditor.combobox[1] = guiCreateComboBox(0.03, 0.27, 0.47, 0.69, "", true, GUIEditor.window[1])
	guiComboBoxAddItem(GUIEditor.combobox[1], "Ev Anahtarı")
	guiComboBoxAddItem(GUIEditor.combobox[1], "Mülk Anahtarı")
	guiComboBoxAddItem(GUIEditor.combobox[1], "Araç Anahtarı")
	guiComboBoxAddItem(GUIEditor.combobox[1], "Garaj Kumandası")
	guiComboBoxAddItem(GUIEditor.combobox[1], "Kumanda")
	GUIEditor.edit[1] = guiCreateEdit(0.52, 0.41, 0.43, 0.13, "Anahtar ID", true, GUIEditor.window[1])
	GUIEditor.label[2] = guiCreateLabel(0.53, 0.29, 0.40, 0.12, "Anahtar ID", true, GUIEditor.window[1])
	GUIEditor.label[3] = guiCreateProgressBar(0.53, 0.60, 0.42, 0.10, true, GUIEditor.window[1])
	GUIEditor.button[1] = guiCreateButton(0.53, 0.75, 0.23, 0.18, "Kopyala", true, GUIEditor.window[1])
	addEventHandler("onClientGUIClick", GUIEditor.button[1], function ()
			if not inprocess then
				local type = guiGetText(GUIEditor.combobox[1]) or "Hata"
				local id = guiGetText(GUIEditor.edit[1]) or "ID Hatası"
				duplicateKey(type, id)
			end
		end, false)

	GUIEditor.button[2] = guiCreateButton(0.76, 0.75, 0.19, 0.18, "Kapat", true, GUIEditor.window[1])
	addEventHandler("onClientGUIClick", GUIEditor.button[2], function ()
			destroyElement(GUIEditor.window[1])
		end, false)
end
addEvent("locksmithGUI", true)
addEventHandler("locksmithGUI", localPlayer, createGUI)

function duplicateKey(type, id)
	local keytype = nil

	if not tonumber(id) then -- checks if its an actual number
		guiSetText( GUIEditor.label[1], "Geçerli ID girmediniz." )
		guiLabelSetColor( GUIEditor.label[1], 255, 0, 0 )
		setTimer(function ()
				if isElement(GUIEditor.label[1]) then
					guiSetText(GUIEditor.label[1], "Selam! Bugün hangi anahtarı kopyalayacaksın?")
					guiLabelSetColor(GUIEditor.label[1], 255, 255, 255)
				end
			end, 2000, 1)
		return
	end

	if type == "Ev Anahtarı" then keytype = 4 end
	if type == "Mülk Anahtarı" then keytype = 5 end
	if type == "Araç Anahtarı" then keytype = 3 end
	if type == "Garaj Kumandası" then keytype = 98 end
	if type == "Kumanda" then keytype = 73 end
	if not tonumber(keytype) then -- if hasn't chosen any key type from dropdown menu
		guiSetText( GUIEditor.label[1], "Anahtar türünü seçmemişsin." )
		guiLabelSetColor( GUIEditor.label[1], 255, 0, 0 )
		setTimer(function ()
				if isElement(GUIEditor.label[1]) then
					guiSetText(GUIEditor.label[1], "Selam! Bugün hangi anahtarı kopyalayacaksın?")
					guiLabelSetColor(GUIEditor.label[1], 255, 255, 255)
				end
			end, 2000, 1)
		return
	end

	if not exports.pool:getElement("vehicle", tonumber(id)) then
		guiSetText( GUIEditor.label[1], "Kopyalamak istediğin anahtarın aracı sana ait değil." )
		guiLabelSetColor( GUIEditor.label[1], 255, 0, 0 )
		setTimer(function ()
				if isElement(GUIEditor.label[1]) then
					guiSetText(GUIEditor.label[1], "Selam! Bugün hangi anahtarı kopyalayacaksın?")
					guiLabelSetColor(GUIEditor.label[1], 255, 255, 255)
				end
			end, 2000, 1)
		return
	end

	if getElementData(localPlayer, exports.pool:getElement("vehicle", tonumber(id)), "owner")  ~= getElementData(localPlayer,"dbid") then -- checks if you actually have the key on you
		guiSetText( GUIEditor.label[1], "Kopyalamak istediğin anahtardan sende bulunmuyor." )
		guiLabelSetColor( GUIEditor.label[1], 255, 0, 0 )
		setTimer(function ()
				if isElement(GUIEditor.label[1]) then
					guiSetText(GUIEditor.label[1], "Selam! Bugün hangi anahtarı kopyalayacaksın?")
					guiLabelSetColor(GUIEditor.label[1], 255, 255, 255)
				end
			end, 2000, 1)
		return
	end

	if not exports.global:hasMoney(getLocalPlayer(), cost) then -- checks if the player has enough money to get it duplicated
		guiSetText( GUIEditor.label[1], "Anahtar kopyalamak için 50$ gereklidir!" )
		guiLabelSetColor( GUIEditor.label[1], 255, 0, 0 )
		setTimer(function ()
				if isElement(GUIEditor.label[1]) then
					guiSetText(GUIEditor.label[1], "Selam! Bugün hangi anahtarı kopyalayacaksın?")
					guiLabelSetColor(GUIEditor.label[1], 255, 255, 255)
				end
			end, 2000, 1)
		return
	end

	guiSetText(GUIEditor.label[1], "Kopyalanıyor...")
	guiLabelSetColor(GUIEditor.label[1], 0, 255, 0)

	guiProgressBarSetProgress(GUIEditor.label[3], 0)
	inprocess = true
	setTimer( function()
		if isElement(GUIEditor.label[3]) then
			guiProgressBarSetProgress (GUIEditor.label[3], guiProgressBarGetProgress(GUIEditor.label[3]) + 5 )
		end
	end, 500, 20)
	setTimer(function ()
		if isElement(GUIEditor.window[1]) then
			guiSetText(GUIEditor.label[1], "Kopyalandı!")
			inprocess = false

			triggerServerEvent("locksmithNPC:givekey", resourceRoot, getLocalPlayer(), keytype, id, cost)
		end
	end, 10000, 1)
end
