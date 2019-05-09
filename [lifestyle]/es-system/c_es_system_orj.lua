function playerDeath()
	if exports.global:hasItem(getLocalPlayer(), 115) or exports.global:hasItem(getLocalPlayer(), 116) then
		deathTimer = 200 -- Bekleme süresi // Sweetheart
		lowerTime = setTimer(lowerTimer, 1000, 200)
	else
		deathTimer = 50 -- Bekleme süresi // Sweetheart
		lowerTime = setTimer(lowerTimer, 1000, 50)
	end
	-- Setup the text
	
	local screenwidth, screenheight = guiGetScreenSize ()
	local scalew, scaleh = (screenwidth/1366), (screenheight/768)
	local width = 300
	local height = 200
	local x = (screenwidth - width)/2
	local y = screenheight - (screenheight/7 - (height/7))
	local deathLabel1 = guiCreateLabel(x, y, scalew*width, scaleh*height, deathTimer .. " Saniye", false)
	guiLabelSetColor(deathLabel1, 0, 0, 0)
	guiSetFont(deathLabel1, "sa-gothic")
	deathLabel = deathLabel1
end
addEvent("playerdeath", true)
addEventHandler("playerdeath", getLocalPlayer(), playerDeath)

function lowerTimer()
	deathTimer = deathTimer - 1
	
	if (deathTimer>1) then
		guiSetText(deathLabel, tostring(deathTimer) .. " Saniye")
	else
		if (isElement(deathLabel)) then
			if deathTimer <= 0 then
				guiSetText(deathLabel, "Ayiliyorsunuz...")
				triggerServerEvent("es-system:acceptDeath", getLocalPlayer(), getLocalPlayer(), victimDropItem)
				playerRespawn()
			else
				guiSetText(deathLabel, tostring(deathTimer) .. " Saniye")
			end
		end
	end
end

deathTimer = 10
deathLabel = nil

function playerRespawn()
	if (isElement(deathLabel)) then
		destroyElement(deathLabel)
	end
	killTimer(lowerTime)
	setCameraTarget(getLocalPlayer())
end

addEvent("bayilmaRevive", true)
addEventHandler("bayilmaRevive", root, playerRespawn)

addEvent("fadeCameraOnSpawn", true)
addEventHandler("fadeCameraOnSpawn", getLocalPlayer(),
	function()
		start = getTickCount()
	end
)

--[[
local bRespawn = nil
function showRespawnButton(victimDropItem)
	showCursor(true)
	local width, height = 201,54
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/1.1 - (height/2)
	bRespawn = guiCreateButton(x, y, width, height,"Respawn",false)
		guiSetFont(bRespawn,"sa-header")
	addEventHandler("onClientGUIClick", bRespawn, function () 
		if bRespawn then
			destroyElement(bRespawn)
			bRespawn = nil
			showCursor(false)
			guiSetInputEnabled(false)
		end
		triggerServerEvent("es-system:acceptDeath", getLocalPlayer(), getLocalPlayer(), victimDropItem)
		showCursor(false)
	end, false)
end
addEvent("es-system:showRespawnButton", true)
addEventHandler("es-system:showRespawnButton", getLocalPlayer(),showRespawnButton)
]]

function closeRespawnButton()
	if bRespawn then
		destroyElement(bRespawn)
		bRespawn = nil
		showCursor(false)
		guiSetInputEnabled(false)
	end
end
addEvent("es-system:closeRespawnButton", true)
addEventHandler("es-system:closeRespawnButton", getLocalPlayer(),closeRespawnButton)

function noDamageOnDeath ( attacker, weapon, bodypart )
	if ( getElementData(source, "dead") == 1 ) then
		cancelEvent()
	end
end
addEventHandler ( "onClientPlayerDamage", getLocalPlayer(), noDamageOnDeath )

function noKillOnDeath ( attacker, weapon, bodypart )
	if ( getElementData(source, "dead") == 1 ) then
		cancelEvent()
	end
end
addEventHandler ( "onClientPlayerWasted", getLocalPlayer(), noKillOnDeath )