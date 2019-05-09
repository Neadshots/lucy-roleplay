--
-- MODİFİYE v1  pavlov ata
--

function saveColor(color1, color2, color3, color4)
	thePlayer = source
	if not color1 then
		color1 = { 0, 0, 0 }
	end
	if not color2 then
		color2 = color1
	end
	if not color3 then
		color3 = color1
	end
	if not color4 then
		color4 = color1
	end

	exports.global:takeMoney(source, 500)
	setElementData(thePlayer, "mechanics:newColor1", tonumber(color1[1]))
	setElementData(thePlayer, "mechanics:newColor2", tonumber(color1[2]))
	setElementData(thePlayer, "mechanics:newColor3", tonumber(color1[3]))
	setElementData(thePlayer, "mechanics:newColor4", tonumber(color2[1]))
	setElementData(thePlayer, "mechanics:newColor5", tonumber(color2[2]))
	setElementData(thePlayer, "mechanics:newColor6", tonumber(color2[3]))
	setElementData(thePlayer, "mechanics:newColor7", tonumber(color3[1]))
	setElementData(thePlayer, "mechanics:newColor8", tonumber(color3[2]))
	setElementData(thePlayer, "mechanics:newColor9", tonumber(color3[3]))
	setElementData(thePlayer, "mechanics:newColor10", tonumber(color4[1]))
	setElementData(thePlayer, "mechanics:newColor11", tonumber(color4[2]))
	setElementData(thePlayer, "mechanics:newColor12", tonumber(color4[3]))
	triggerClientEvent("modifiye:updateSprayColor", thePlayer, getElementData(thePlayer, "mechanics:newColor1"), getElementData(thePlayer, "mechanics:newColor2"), getElementData(thePlayer, "mechanics:newColor3"))
end
addEvent("modifiye:saveColor", true)
addEventHandler("modifiye:saveColor", root, saveColor)

local showWarn = true
local paintProcess = 0
function spray_PaintVehicle(theVehicle)
	if isElement(theVehicle) and getElementType(theVehicle) == "vehicle" then
		if paintProcess < 10000 then
			paintProcess = paintProcess + 1
		
			local vehColor1, vehColor2, vehColor3, vehColor4, vehColor5, vehColor6, vehColor7, vehColor8, vehColor9, vehColor10, vehColor11, vehColor12 = getVehicleColor(theVehicle, true) 
			
			local newColor1		= getElementData(source, "mechanics:newColor1")
			local newColor2		= getElementData(source, "mechanics:newColor2")
			local newColor3		= getElementData(source, "mechanics:newColor3")
			local newColor4		= getElementData(source, "mechanics:newColor4")
			local newColor5		= getElementData(source, "mechanics:newColor5")
			local newColor6		= getElementData(source, "mechanics:newColor6")
			local newColor7		= getElementData(source, "mechanics:newColor7")
			local newColor8		= getElementData(source, "mechanics:newColor8")
			local newColor9		= getElementData(source, "mechanics:newColor9")
			local newColor10	= getElementData(source, "mechanics:newColor10")
			local newColor11	= getElementData(source, "mechanics:newColor11")
			local newColor12	= getElementData(source, "mechanics:newColor12")
			
			local newCol1 = lerpColors(vehColor1, newColor1, paintProcess, 10000)
			local newCol2 = lerpColors(vehColor2, newColor2, paintProcess, 10000)
			local newCol3 = lerpColors(vehColor3, newColor3, paintProcess, 10000)
			local newCol4 = lerpColors(vehColor4, newColor4, paintProcess, 10000)
			local newCol5 = lerpColors(vehColor5, newColor5, paintProcess, 10000)
			local newCol6 = lerpColors(vehColor6, newColor6, paintProcess, 10000)
			local newCol7 = lerpColors(vehColor7, newColor7, paintProcess, 10000)
			local newCol8 = lerpColors(vehColor8, newColor8, paintProcess, 10000)
			local newCol9 = lerpColors(vehColor9, newColor9, paintProcess, 10000)
			local newCol10 = lerpColors(vehColor10, newColor10, paintProcess, 10000)
			local newCol11 = lerpColors(vehColor11, newColor11, paintProcess, 10000)
			local newCol12 = lerpColors(vehColor12, newColor12, paintProcess, 10000)
		


			setVehicleColor( theVehicle, newCol1, newCol2, newCol3, newCol4, newCol5, newCol6, newCol7, newCol8, newCol9, newCol10, newCol11, newCol12)
		else
			if showWarn then
				takeWeapon(source, 41)
				outputChatBox("Aracı başarıyla boyadınız.", source)
				showWarn = false
			end
			setTimer(
				function()
					paintProcess = 0
					showWarn = true
				end, 10000, 1)
		end
	end
end
addEvent("mechanics:spray_PaintVehicle", true)
addEventHandler("mechanics:spray_PaintVehicle", getRootElement(), spray_PaintVehicle)

function lerpColors (startValue, endValue, stepNumber, lastStepNumber)
	return (endValue - startValue) * stepNumber / lastStepNumber + startValue
end