-- Created With Ramsey
fuellessVehicle = { [594]=true, [537]=true, [538]=true, [569]=true, [590]=true, [606]=true, [607]=true, [610]=true, [590]=true, [569]=true, [611]=true, [584]=true, [608]=true, [435]=true, [450]=true, [591]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [497]=true, [509]=true, [510]=true, [481]=true }
enginelessVehicle = { [510]=true, [509]=true, [481]=true }
local fuel = 0
local width, height = guiGetScreenSize()
local font = dxCreateFont("font.ttf",20)
local font2 = dxCreateFont("font2.ttf",10)
local font3 = dxCreateFont("font2.ttf",11)
local sx,sy = guiGetScreenSize()
local gearTable = {{"R"}, {"N"}, {"1"}, {"2"}, {"3"}, {"4"}, {"5"},}

local texture = dxCreateTexture("dashboard.png")
function drawSpeedo()
	local isNewtyle = (getElementData(localPlayer, "settings_hud_style") ~= "0")
	if getElementData(localPlayer,"speedo") ~= "0" and not isPlayerMapVisible() and isNewtyle then
		local theVehicle = getPedOccupiedVehicle(localPlayer)
		if (theVehicle) then

			speed = exports.global:getVehicleVelocity(theVehicle, getLocalPlayer())
			local x = sx-310
			local y = sy-290
			if speed < 40 then
				carAlpha = 190
			else
				carAlpha = (170+speed)/1.5
				if carAlpha > 254 then carAlpha = 255 end
			end
	
			dxDrawImage(x, y, 300,300, texture)
			dxDrawImage(x, y, 300,300, "arrow.png", (-116)+(speed/1.3), 0, 0, tocolor(255, 255, 255, 200))

			if getVehicleEngineState((getPedOccupiedVehicle(getLocalPlayer()))) then
				gearText = ""
				gearText1 = ""
				gearText2 = ""
				if getElementSpeed(getPedOccupiedVehicle(getLocalPlayer())) == 0 then 
					gearText = gearTable[2][1]
					gearText1 = gearTable[1][1]
					gearText2 = gearTable[3][1]
				end
				if getVehicleCurrentGear((getPedOccupiedVehicle(getLocalPlayer()))) > 0 then
					gearText = gearTable[getVehicleCurrentGear((getPedOccupiedVehicle(getLocalPlayer())))+2][1]
					gearText1 = gearTable[getVehicleCurrentGear((getPedOccupiedVehicle(getLocalPlayer())))+1][1]
					if getVehicleCurrentGear((getPedOccupiedVehicle(getLocalPlayer()))) < 5 then 
						gearText2 = gearTable[getVehicleCurrentGear((getPedOccupiedVehicle(getLocalPlayer())))+3][1]
					else
						gearText2 = ""
					end
				else
					gearText = gearTable[1][1]
					gearText1 = ""
					gearText2 = gearTable[2][1]
				end
			
			else
				gearText = gearTable[2][1]
				gearText1 = ""
				gearText2 = ""
			end
			dxDrawText(gearText,x,y-124,300+x,300+y+20,tocolor(255,255,255),1,font3,"center","center")
			--dxDrawText(gearText1,x,y-124,300+x,300+y+20,tocolor(255,255,255),1,font3,"center","center")
			--dxDrawText(gearText2,x,y-124,300+x,300+y+20,tocolor(255,255,255),1,font3,"center","center")

			dxDrawText(tostring(math.floor(speed)).."KM",x,y,300+x,300+y,tocolor(255,255,255),1,font,"center","center")
			dxDrawText(tostring(math.floor(getDistanceTraveled()/1000)).." mil",x,y+67,300+x,300+y+20,tocolor(255,255,255),1,font2,"center","center")
			local driver = getVehicleOccupant(theVehicle, 0)

			if getElementData(driver, "seatbelt") then

			end
		end
	end
end
function getGearValue(value)

end
function getVehicleSpeed()
	local vehicle = getPedOccupiedVehicle(localPlayer)
    if isPedInVehicle(localPlayer) then
        local vx, vy, vz = getElementVelocity(getPedOccupiedVehicle(localPlayer))
        return math.sqrt(vx^2 + vy^2 + vz^2) * 161		
	end
    return 0
end


local alpha = 0
function drawFuel()
	local isNewtyle = (getElementData(localPlayer, "settings_hud_style") ~= "0")
	if getElementData(localPlayer,"speedo") ~= "0" and not isPlayerMapVisible() and isNewtyle then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		if (vehicle) then
			local fuel = getElementData(vehicle, "fuel")
			local x = sx-310
			local y = sy-275

			local FuelPer = (fuel/exports["vehicle_fuel"]:getMaxFuel(vehicle))*100

			if FuelPer > 100 then
				FuelPer = fuel 
			end
			--FuelPer == fuelvalue
			dxDrawText(tostring(math.floor(FuelPer)).." lt",x,y+130,310+x,310+y+20,tocolor(255,255,255),1,font2,"center","center")
		end
	end
end



function onVehicleEnter(thePlayer, seat)
	if (thePlayer==getLocalPlayer()) then
		if (seat<2) then
			local id = getElementModel(source)

			if not (enginelessVehicle[id]) then
				--addEventHandler("onClientRender", getRootElement(), drawSpeedo)
				if not (fuellessVehicle[id]) then
					--addEventHandler("onClientRender", getRootElement(), drawFuel)
				end
			end
		end
	end
end
addEventHandler("onClientVehicleEnter", getRootElement(), onVehicleEnter)

-- Check if the vehicle is engineless or fuelless when a player exits. If not, stop drawing the speedo and fuel needles.
function onVehicleExit(thePlayer, seat)
	if (thePlayer==getLocalPlayer()) then
		if (seat<2) then
			local id = getElementModel(source)
			if seat == 0 and not (fuellessVehicle[id]) then
				removeEventHandler("onClientRender", getRootElement(), drawFuel)
			end
			if not(enginelessVehicle[id]) then
				removeEventHandler("onClientRender", getRootElement(), drawSpeedo)
				--removeEventHandler("onClientRender", getRootElement(), drawWindow)
			end
		end
	end
end
addEventHandler("onClientVehicleExit", getRootElement(), onVehicleExit)

function hideSpeedo()
	removeEventHandler("onClientRender", getRootElement(), drawSpeedo)
	removeEventHandler("onClientRender", getRootElement(), drawFuel)
	--removeEventHandler("onClientRender", getRootElement(), drawWindow)
end

function showSpeedo()
	source = getPedOccupiedVehicle(getLocalPlayer())
	if source then
		if getVehicleOccupant( source ) == getLocalPlayer() then
			onVehicleEnter(getLocalPlayer(), 0)
		elseif getVehicleOccupant( source, 1 ) == getLocalPlayer() then
			onVehicleEnter(getLocalPlayer(), 1)
		end
	end
end

-- If player is not in vehicle stop drawing the speedo needle.
function removeSpeedo()
	if not (isPedInVehicle(getLocalPlayer())) then
		hideSpeedo()
	end
end
setTimer(removeSpeedo, 1000, 0)

addEventHandler( "onClientResourceStart", getResourceRootElement(), showSpeedo )
