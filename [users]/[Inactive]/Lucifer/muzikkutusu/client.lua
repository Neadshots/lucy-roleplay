------------------------------------------
-- Author: Alern						--
-- Name: 3D Sound 				        --
-- Copyright 2018 ( C ) 	            --
------------------------------------------

-- Variables				--
------------------------------
local subTrackOnSoundDown = 0.1	-- The volume that goes down, when the player clicks "Volume -"
local subTrackOnSoundUp = 0.1	-- The volume that goes up, when the player clicks "Volume +"


function print ( message, r, g, b )
	outputChatBox ( message, r, g, b )
end

------------------------------
-- The GUI					--
------------------------------

local sx, sy = guiGetScreenSize ( )
local pg, pu = 300,250
local x,y = (sx-pg)/2, (sy-pu)/2
button = { }
window = guiCreateWindow(x,y,pg,pu, "Müzik Kutusu", false)
guiSetVisible ( window, false )

CurrentSpeaker = guiCreateLabel(10, 33, 254, 17, "Ses sistemi varmı: Hayır", false, window)
volume = guiCreateLabel(10, 50, 252, 17, "Ses: 100%", false, window)
guiCreateLabel(11, 81, 251, 15, "Link:", false, window)
url = guiCreateEdit(10, 96, pg-20, 23, "", false, window)  
button["place"] = guiCreateButton(10, 129, pg-20, 20, "Oluştur", false, window)
button["remove"] = guiCreateButton(10, 159, pg-20, 20, "Kaldır", false, window)
button["v-"] = guiCreateButton(10, 189, 130, 20, "Sesi Alçalt", false, window)
button["v+"] = guiCreateButton(pg-140, 189, 130, 20, "Sesi Yükselt", false, window)

 

--------------------------
-- My sweet codes		--
--------------------------

local isSound = false
addEvent ( "onPlayerViewSpeakerManagment", true )
addEventHandler ( "onPlayerViewSpeakerManagment", root, function ( current )
	local toState = not guiGetVisible ( window ) 
	guiSetVisible ( window, toState )
	showCursor ( toState )	
	if ( toState == true ) then
		guiSetInputMode ( "no_binds_when_editing" )
		local x, y, z = getElementPosition ( localPlayer )
		if ( current ) then guiSetText ( CurrentSpeaker, "Ses sistemi varmı: Evet" ) isSound = true
		else guiSetText ( CurrentSpeaker, "Ses sistemi varmı: Hayır" ) end
	end
end )

addEventHandler ( "onClientGUIClick", root, function ( )
	if ( source == button["place"] ) then
		if ( isURL ( ) ) then
			triggerServerEvent ( "onPlayerPlaceSpeakerBox", localPlayer, guiGetText ( url ), isPedInVehicle ( localPlayer ) )
			guiSetText ( CurrentSpeaker, "Ses sistemi kurulumu: Evet" )
			isSound = true
			guiSetText ( volume, "Ses: 100%" )
		else
			-- print ( "bir URL girin", 255, 0, 0 )
		end
	elseif ( source == button["remove"] ) then
		triggerServerEvent ( "onPlayerDestroySpeakerBox", localPlayer )
		guiSetText ( CurrentSpeaker, "Müzik kutusu kurulumu: Hayır" )
		isSound = false
		guiSetText ( volume, "Ses: 100%" )
	elseif ( source == button["v-"] ) then
		if ( isSound ) then
			local toVol = math.round ( getSoundVolume ( speakerSound [ localPlayer ] ) - subTrackOnSoundDown, 2 )
			if ( toVol > 0.0 ) then
				-- print ( "Ses seviyesi düşürüldü "..math.floor ( toVol * 100 ).."%!", 0, 255, 0 )
				triggerServerEvent ( "onPlayerChangeSpeakerBoxVolume", localPlayer, toVol )
				guiSetText ( volume, "Ses: "..math.floor ( toVol * 100 ).."%" )
			else
				-- print ( "Daha fazla sesini kısamazsın", 255, 0, 0 )
			end
		end
	elseif ( source == button["v+"] ) then
		if ( isSound ) then
			local toVol = math.round ( getSoundVolume ( speakerSound [ localPlayer ] ) + subTrackOnSoundUp, 2 )
			if ( toVol < 1.1 ) then
				-- print ( "Ses seviyesi arttırıldı "..math.floor ( toVol * 100 ).."%!", 0, 255, 0 )
				triggerServerEvent ( "onPlayerChangeSpeakerBoxVolume", localPlayer, toVol )
				guiSetText ( volume, "Ses: "..math.floor ( toVol * 100 ).."%" )
			else
				-- print ( "Daha fazla sesini yükseltemezsin", 255, 0, 0 )
			end
		end
	end
end )

-- addEventHandler ( "onClientClick", getRootElement(),function( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, tiklanan )
	-- if ( tiklanan ) then
		-- local elementType = getElementType ( tiklanan )
		-- if elementType == "object" and getElementModel(tiklanan) == 2229 then
			-- triggerServerEvent ( "onPlayerDestroySpeakerBox", getElementData(tiklanan, "Sahibi") )
		-- end
	-- end
-- end)

speakerSound = { }
addEvent ( "onPlayerStartSpeakerBoxSound", true )
addEventHandler ( "onPlayerStartSpeakerBoxSound", root, function ( who, url )
	if ( isElement ( speakerSound [ who ] ) ) then destroyElement ( speakerSound [ who ] ) end
	local x, y, z = getElementPosition ( who )
	speakerSound [ who ] = playSound3D ( ""..url, x, y, z, true )
	setElementData(speakerSound [ who ], "Sahibi", who)
	setSoundVolume ( speakerSound [ who ], 1 )
	setSoundMinDistance ( speakerSound [ who ], 15 )
	setSoundMaxDistance ( speakerSound [ who ], 20 )
	setElementDimension(speakerSound [ who ], getElementDimension(getLocalPlayer()))
end )

addEvent ( "onPlayerDestroySpeakerBox", true )
addEventHandler ( "onPlayerDestroySpeakerBox", root, function ( who ) 
	if ( isElement ( speakerSound [ who ] ) ) then 
		destroyElement ( speakerSound [ who ] ) 
	end
end )

--------------------------
-- Volume				--
--------------------------
addEvent ( "onPlayerChangeSpeakerBoxVolumeC", true )
addEventHandler ( "onPlayerChangeSpeakerBoxVolumeC", root, function ( who, vol ) 
	if ( isElement ( speakerSound [ who ] ) ) then
		setSoundVolume ( speakerSound [ who ], tonumber ( vol ) )
	end
end )

function isURL ( )
	if ( guiGetText ( url ) ~= "" ) then
		return true
	else
		return false
	end
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end