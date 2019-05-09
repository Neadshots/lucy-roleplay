--
-- MODİFİYE v1
--

function colorSelectionGUI()
	local screenW, screenH = guiGetScreenSize()
	local Width = 250
	local Height = 360
	local X = (screenW - Width - 30)
	local Y = (screenH - Height) / 2
			local tamirci = getElementData(localPlayer, "job")
		if tamirci == 5 then
	
	if not (wColorSelection) then
		wColorSelection = guiCreateWindow(X, Y, Width, Height, "Modifiye Sistemi - Renk Seç © Pavlov ", false)
		
		bColor1 = guiCreateButton( 10, 30, 230, 40, "Renk 1", false, wColorSelection)
		addEventHandler("onClientGUIClick", bColor1,
			function()
				paintColor( 1 )
			end
		)
		
		bColor2 = guiCreateButton( 10, 85, 230, 40, "Renk 2", false, wColorSelection)
		addEventHandler("onClientGUIClick", bColor2,
			function()
				paintColor( 2 )
			end
		)
		
		bColor3 = guiCreateButton( 10, 140, 230, 40, "Renk 3", false, wColorSelection)
		addEventHandler("onClientGUIClick", bColor3,
			function()
				paintColor( 3 )
			end
		)
		
		bColor4 = guiCreateButton( 10, 195, 230, 40, "Renk 4", false, wColorSelection)
		addEventHandler("onClientGUIClick", bColor4,
			function()
				paintColor( 4 )
			end
		)
		
		bClose = guiCreateButton( 10, 250, 230, 40, "Kapat", false, wColorSelection)
		addEventHandler( "onClientGUIClick", bClose, closeSelectionWindow, false )
		
		bSave = guiCreateButton( 10, 305, 230, 40, "Kaydet", false, wColorSelection)
		addEventHandler( "onClientGUIClick", bSave, 
			function()
				triggerServerEvent( "modifiye:saveColor", getLocalPlayer(), color1, color2, color3)
				outputChatBox("Ayarları başarıyla kaydettiniz.")
				takePlayerMoney (source, 500)
				closeSelectionWindow()
			end, false )
		
		showCursor(true)
	end
end
end
addEvent("modifiye:colorSelectionGUI", true)
addEventHandler("modifiye:colorSelectionGUI", getRootElement(), colorSelectionGUI)

currentColor, color1, color2, color3, color4 = nil
function paintColor( colorIndex )
		-- local tamirci = getElementData(localPlayer, "tamirci")
		-- if tamirci == 1 then
	if exports.colorblender:isPickerOpened("renk") then
		outputChatBox("Zaten bir renk seçimindesiniz.", 255, 0 ,0)
		return
	end
	currentColor = colorIndex
	local r, g, b = 255, 255, 255
	exports.colorblender:openPicker("renk", string.format("#%02X%02X%02X", r, g, b) , "Renk " .. tostring(colorIndex) .. ":")
end
-- end
	
addCommandHandler("boya", colorSelectionGUI)

function closeSelectionWindow()
	destroyElement(wColorSelection)
	wColorSelection, bColor1, bColor2, bColor3, bColor4, bClose = nil
	
	exports.colorblender:closePicker("color1")
	exports.colorblender:closePicker("color2")
	exports.colorblender:closePicker("color3")
	exports.colorblender:closePicker("color4")
	showCursor(false)
end

addEventHandler("onColorPickerOK", root,
	function(id, hex, r, g, b)
		if id == 'renk' and currentColor then
			if currentColor == 1 then
				color1 = { r, g, b }
			elseif currentColor == 2 then
				color2 = { r, g, b }
			elseif currentColor == 3 then
				color3 = { r, g, b }
			elseif currentColor == 4 then
				color4 = { r, g, b }
			end
		end
	end)


function spray_StartPainting( weapon, ammo, ammoinclip, hitx, hity, hitz, element )
	if weapon == 41 then
		triggerServerEvent("mechanics:spray_PaintVehicle", getLocalPlayer(), element)
	end
end
addEventHandler("onClientPlayerWeaponFire", getLocalPlayer(), spray_StartPainting)

function updateSprayColor(r,g,b)
	local sprayShader = dxCreateShader("spray.fx")
	
    if r and g and b then
		engineApplyShaderToWorldTexture (sprayShader,"smoke")
        dxSetShaderValue (sprayShader, "gSprayColor", r, g, b )
    end
end
addEvent("modifiye:updateSprayColor", true)
addEventHandler("modifiye:updateSprayColor", getRootElement(), updateSprayColor)