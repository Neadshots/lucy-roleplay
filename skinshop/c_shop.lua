local skinshopPeds = {
	{
		x = "210.3583984375",
		y = "-98.7041015625",
		z = "1005.2578125",
		int = 15,
		dim = 67,
		rotation = "175",
	},
}

local firstName = { "Michael","Christopher","Matthew","Joshua","Jacob","Andrew","Daniel","Nicholas","Tyler","Joseph","David","Brandon","James","John","Ryan","Zachary","Justin","Anthony","William","Robert", "Dean", "George", "Norman", "Lloyd", "Dennis", "Seymour", "Willie", "Richard", "Bobby", "Jody", "Danny ", "Seth", "Tommy", "Timothy", "Ashley", "Junior"}
local lastName = { "Johnson","Williams","Jones","Brown","Davis","Miller","Wilson","Moore","Taylor","Anderson","Thomas","Jackson","White","Harris","Martin","Thompson","Garcia","Martinez","Robinson","Clark", "Hummer", "Smith", "Touchet", "Trotter", "Nagle", "Dunbar", "Davis", "Grenier", "Duff", "Alston", "Winslow", "Borunda", "Duncan", "Heath", "Keeler", "Skinner", "Daniel", "Layfield", "Decker", "Ames", "Christie" }

function createRandomMaleName()
    local random1 = math.random(1, #firstName)
    local random2 = math.random(1, #lastName)
    local name = firstName[random1].." "..lastName[random2]
    return name
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		for index, value in ipairs(skinshopPeds) do
			ped = createPed(exports["global"]:getRandomSkin(), value.x, value.y, value.z)
			setPedRotation(ped, value.rotation)
			setElementInterior(ped, value.int)
			setElementDimension(ped, value.dim)
			setElementData(ped, "name", createRandomMaleName())
			setElementData(ped, "nametag", true)
			setElementData(ped, "skinshop-system:ped", true)
		end
	end
)

addEventHandler("onClientClick", root,
	function(button, state, _, _, _, _, _, element)
		if (button == "right") then
			if element and isElement(element) and getElementType(element) == "ped" and getElementData(element, "skinshop-system:ped") then
				if not isElement(window) then
					createExclusiveGUI(getElementData(element, "name"), {getElementDimension(element), getElementInterior(element)})
				end
			end
		end
	end
)

function createExclusiveGUI(wName, data)
	window = guiCreateWindow(0, 0, 550, 300, "Kıyafet Mağazası Arayüzü - "..wName.." - "..exports["global"]:getScriptVersion(), false)
	exports["global"]:centerWindow(window)
	gridlist = guiCreateGridList(10, 25, 550/2, 230, false, window)
	guiGridListAddColumn(gridlist, "ID", 0.75)
	guiGridListAddColumn(gridlist, "Fiyat", 0.20)
	
	local skinsTable = exports["mods"]:getModdedSkins()
	table.sort(skinsTable, function(a, b)
		return tonumber(a) < tonumber(b)
	end)

	for index, value in ipairs(skinsTable) do
		local row = guiGridListAddRow(gridlist)
		guiGridListSetItemText(gridlist, row, 1, value, false, false)
		guiGridListSetItemText(gridlist, row, 2, 50, false, false)
	end
	local previewSkin = createPed(60, 0, 0, 4)
	setElementDimension(previewSkin, data[1])
	setElementInterior(previewSkin, data[2])
	local x, y = guiGetPosition(window, false)
	preview_skin = exports["object-preview"]:createObjectPreview(previewSkin, 0, 0, 180, x+10+(550/2), y+25, 550/2, 230, false, false)
	local scrollbar = guiCreateScrollBar(10+(550/2), 235, 550/2, 20, true, false, window)
	guiSetProperty(scrollbar, "StepSize", "0.0028")
	addEventHandler('onClientGUIScroll', scrollbar,
		function()
			local rotation = tonumber(guiGetProperty(source, "ScrollPosition"))
			--setElementRotation(previewObject, 0, 0, 155 + rotation * 360)
			exports["object-preview"]:setRotation(preview_skin,0, 0, 155 + rotation * 360)
		end, false)

	addEventHandler("onClientRender", root,
		function()
			if isElement(window) and isElement(previewSkin) then
				selectedID = guiGridListGetSelectedItem(gridlist)
				skinID = guiGridListGetItemText(gridlist, selectedID, 1) or 60
				if selectedID ~= -1 then
					setElementModel(previewSkin, skinID)
				end
			end
		end
	)

	okButton = guiCreateButton(10, 260, 530/2, 25, "Seçileni Satın Al", false, window)
	addEventHandler("onClientGUIClick", okButton,
		function(b)
			if (b == "left") then
				selectedID = guiGridListGetSelectedItem(gridlist)

				if tonumber(selectedID) == -1 then
					guiSetText(window, "Lütfen bir kıyafet seçin. - "..wName)
					return
				end
				skinID = guiGridListGetItemText(gridlist, selectedID, 1)
				price = guiGridListGetItemText(gridlist, selectedID, 2)
				if not exports["global"]:hasMoney(localPlayer, tonumber(price)) then
					guiSetText(window, "Yeterli paranız bulunmuyor. - "..wName)
					return
				end
				destroyElement(window)
				exports["object-preview"]:destroyObjectPreview(preview_skin)
				destroyElement(previewSkin)
				triggerServerEvent("skinshop-system:buySkin", localPlayer, localPlayer, skinID, price)
			end
		end
	)
	denyButton = guiCreateButton(10+(530/2), 260, 530/2, 25, "Arayüzü Kapat", false, window)
	addEventHandler("onClientGUIClick", denyButton,
		function(b)
			if (b == "left") then
				destroyElement(window)
				exports["object-preview"]:destroyObjectPreview(preview_skin)
				destroyElement(previewSkin)
			end
		end
	)
end

addEventHandler("onClientResourceStop", resourceRoot,
	function()
		if isElement(previewSkin) then
			if preview_skin then
				exports["object-preview"]:destroyObjectPreview(preview_skin)
			end
		end
	end
)