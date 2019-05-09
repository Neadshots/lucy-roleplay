--[[
* ***********************************************************************************************************************
* Copyright (c) 2019 Lucy Project - Enes Akıllıok
* All rights reserved. This program and the accompanying materials are private property belongs to Lucy Project
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* https://www.github.com/yourpalenes
* ***********************************************************************************************************************
]]

local blipHolder = { }
local arr = { }
local arrayTimer = {}
addEvent("createBackupBlip", true)
addEvent("destroyBackupBlip", true)

function createBackupBlip( availableColourIndex, colourArray )
	triggerEvent("destroyBackupBlip", source, availableColourIndex)
	
	local x, y, z = getElementPosition(source)
	local tempBackupBlip = createBlip(x, y, z, 20, 3, colourArray[1], colourArray[2], colourArray[3], 255, 255, 32767)
	attachElements(tempBackupBlip, source)	
	blipHolder[availableColourIndex] = tempBackupBlip
	table.insert(arr, tempBackupBlip)
	arrayTimer[tempBackupBlip] = setTimer(
		function(blip)
			if isElement(blip) then
				if getBlipIcon(blip) == 30 then
					setBlipIcon(blip, 20)
				else
					setBlipIcon(blip, 30)
				end
			else
				killTimer(arrayTimer[blip])
			end
		end,
	600, 0, tempBackupBlip)
end
addEventHandler("createBackupBlip", getRootElement(), createBackupBlip)

function destroyBackupBlip( availableColourIndex )
	if blipHolder[availableColourIndex] and isElement(blipHolder[availableColourIndex] ) then
		for a, b in ipairs(arr) do
			if b == blipHolder[availableColourIndex] then
				table.remove(arr,a)
				break
			end
		end
		if isTimer(arrayTimer[tempBackupBlip]) then
			killTimer(arrayTimer[tempBackupBlip])
		end
		
		destroyElement( blipHolder[availableColourIndex] )
		blipHolder[availableColourIndex] = false
	end
end
addEventHandler("destroyBackupBlip", getRootElement(), destroyBackupBlip)

function dutyToggle( goingOnDuty )
	if not goingOnDuty then
		refreshBlips ( )
	end
end
addEventHandler("onPlayerDuty", getRootElement(), dutyToggle)

function refreshBlips ( )
	for a,b in ipairs(arr) do
		destroyElement(b)
	end
	arr = { }
	blipHolder = { }
end
addEventHandler("accounts:characters:spawn", getRootElement(), refreshBlips)