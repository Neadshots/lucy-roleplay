local santvPed = createPed(91, 1559.7177734375, 1569.109375, 13.106365203857)
setElementRotation(santvPed, 0, 0,89)
setElementDimension(santvPed, 1455)
setElementInterior(santvPed, 3)
setElementData(santvPed, "nametag", true)
setElementData(santvPed, "name", "Jessica Roberts")
setElementFrozen(santvPed, true)


addEventHandler("onClientClick", root,
	function(button, state, _, _, _, _, _, element)
		if (button == "right") then
			if element and isElement(element) and getElementType(element) == "ped" and element == santvPed then
				if not isElement(reklamWindow) then
					reklamGUI()
				end
			end
		end
	end
)

function reklamac ()
if getElementData(getLocalPlayer(), "vip") >= 2 then
reklamGUI()
end
end
addCommandHandler("reklam", reklamac)

local reklamGonderebilir = true
function reklamGUI()
	guiSetInputMode("no_binds_when_editing")
	local screenW, screenH = guiGetScreenSize()
	reklamWindow = guiCreateWindow((screenW - 484) / 2, (screenH - 183) / 2, 484, 183, "LUCY RPG - Reklam Verme Arayüzü", false)
	guiWindowSetSizable(reklamWindow, false)

	reklamLbl = guiCreateLabel(10, 24, 464, 26, "Reklamınız:", false, reklamWindow)
	guiLabelSetVerticalAlign(reklamLbl, "center")
	reklamEdit = guiCreateEdit(10, 50, 464, 29, "", false, reklamWindow)
	gonderBtn = guiCreateButton(10, 89, 464, 34, "Reklamı Gönder ($100)", false, reklamWindow)
	guiSetProperty(gonderBtn, "NormalTextColour", "FFAAAAAA")
	kapatBtn = guiCreateButton(10, 133, 464, 34, "Pencereyi Kapat", false, reklamWindow)
	guiSetProperty(kapatBtn, "NormalTextColour", "FFAAAAAA")
	addEventHandler("onClientGUIClick", guiRoot, btnFunctions)
end
addEvent("reklamGUI", true)
addEventHandler("reklamGUI", root, reklamGUI)
setElementData(getLocalPlayer(), "reklamGonderemez", false)
function btnFunctions()
	local reklamGonderemez = getElementData(getLocalPlayer(), "reklamGonderemez")
	if source == kapatBtn then
		destroyElement(reklamWindow)
	elseif source == gonderBtn then
		if not reklamGonderemez then
			if exports.global:hasMoney(getLocalPlayer(), 100) then
				triggerServerEvent("reklamGonder", getLocalPlayer(), getLocalPlayer(), guiGetText(reklamEdit))
				setElementData(getLocalPlayer(), "reklamGonderemez", false)
				setTimer(setElementData, 300000, 1, getLocalPlayer(), "reklamGonderemez", false)
			else
				outputChatBox("[!] #f0f0f0Reklam vermek için yeterli paranız yok.", 255, 0, 0, true)
			end
		else
			outputChatBox("[!] #f0f0f0Her 5 dakikada bir reklam gönderebilirsiniz.", 255, 0, 0, true)
		end
		destroyElement(reklamWindow)
	end
end