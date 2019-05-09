------------------------------------------
-- Author: Alern						--
-- Name: 3D Sound 				        --
-- Copyright 2018 ( C ) 	            --
------------------------------------------

local isSpeaker = false

function print ( player, message, r, g, b )
	outputChatBox ( message, player, r, g, b )
end

speakerBox = { }
textYazi = { }


addCommandHandler ( "muzikkutusu", function ( thePlayer  )
	local seviye = getElementData(thePlayer, "level")
    if seviye > 6 then

	if ( isElement ( speakerBox [ thePlayer] ) ) then isSpeaker = true end
	triggerClientEvent ( thePlayer, "onPlayerViewSpeakerManagment", thePlayer, isSpeaker )
		else
outputChatBox("[!] #f0f0f0Muzik kutusu kurabilmek için 6 seviye olmalısınız.", thePlayer, 255, 0, 0, true)
end 
end )

addEvent ( "onPlayerPlaceSpeakerBox", true )
addEventHandler ( "onPlayerPlaceSpeakerBox", root, function ( url, isCar ) 
	if ( url ) then
		if ( isElement ( speakerBox [ source ] ) ) then
			local x, y, z = getElementPosition ( speakerBox [ source ] ) 
			destroyElement ( speakerBox [ source ] )
			removeEventHandler ( "onPlayerQuit", source, destroySpeakersOnPlayerQuit )
		end
		if ( isElement ( textYazi [ source ] ) ) then
			local x, y, z = getElementPosition ( textYazi [ source ] ) 
			destroyElement ( textYazi [ source ] )
			removeEventHandler ( "onPlayerQuit", source, destroySpeakersOnPlayerQuit )
		end
		local x, y, z = getElementPosition ( source )
		local rx, ry, rz = getElementRotation ( source )
		speakerBox [ source ] = createObject ( 2229, x-0.5, y+0.5, z - 1, 0, 0, rx )
				local xx, yy, zz = getElementPosition ( speakerBox [ source ] )
			 textYazi [source] = createElement("text")
			setElementPosition(textYazi [ source ], xx-0.3, yy-0.2, zz+1.6)
			setElementData(textYazi [ source ], "scale", 1.2)
			setElementData(textYazi [ source ], "text", "#C5C803[Müzik Kutusu]\n Sahip: #FFFFFF"..getPlayerName(source).."\n#C5C803Komut: #FFFFFF''/muzikkutusu''")
		setElementData(speakerBox [ source ], "Sahibi", source)
		setElementDimension(speakerBox [ source ], getElementDimension(source))
		outputChatBox("[!] #f0f0f0 Müzik kutusu kuruldu.", source	, 255, 0, 0, true)
		addEventHandler ( "onPlayerQuit", source, destroySpeakersOnPlayerQuit )
		triggerClientEvent ( root, "onPlayerStartSpeakerBoxSound", root, source, url )
	end
end )

addEvent ( "onPlayerDestroySpeakerBox", true )
addEventHandler ( "onPlayerDestroySpeakerBox", root, function ( )
	if ( isElement ( speakerBox [ source ] ) ) then
		destroyElement ( speakerBox [ source ] )
		triggerClientEvent ( root, "onPlayerDestroySpeakerBox", root, source )
		removeEventHandler ( "onPlayerQuit", source, destroySpeakersOnPlayerQuit )
		outputChatBox("[!] #f0f0f0 Müzik kutusu kaldırıldı.", source, 255, 0, 0, true)
	else
		outputChatBox("[!] #f0f0f0 Müzik kutusu zaten kaldırıldı.", source, 255, 0, 0, true)
	end	
	if ( isElement ( textYazi [ source ] ) ) then
		destroyElement ( textYazi [ source ] )
		triggerClientEvent ( root, "onPlayerDestroySpeakerBox", root, source )
		removeEventHandler ( "onPlayerQuit", source, destroySpeakersOnPlayerQuit )
		outputChatBox("[!] #f0f0f0 Müzik kutusu kaldırıldı.", source, 255, 0, 0, true)
	else
		outputChatBox("[!] #f0f0f0 Müzik kutusu zaten kaldırıldı.", source, 255, 0, 0, true)
	end
end )

addEvent ( "onPlayerChangeSpeakerBoxVolume", true ) 
addEventHandler ( "onPlayerChangeSpeakerBoxVolume", root, function ( to )
	triggerClientEvent ( root, "onPlayerChangeSpeakerBoxVolumeC", root, source, to )
end )

function destroySpeakersOnPlayerQuit ( )
	if ( isElement ( speakerBox [ source ] ) ) then
		destroyElement ( speakerBox [ source ] )
		triggerClientEvent ( root, "onPlayerDestroySpeakerBox", root, source )
	end
	if ( isElement ( textYazi [ source ] ) ) then
		destroyElement ( textYazi [ source ] )
		triggerClientEvent ( root, "onPlayerDestroySpeakerBox", root, source )
	end
end