--[[
--	Copyright (C) Root Gaming - All Rights Reserved
--	Unauthorized copying of this file, via any medium is strictly prohibited
--	Proprietary and confidential
--	Written by Daniel Lett <me@lettuceboi.org>, June 2012
]]--

local SCREEN_X, SCREEN_Y = guiGetScreenSize()
local resourceName = getResourceName( getThisResource( ) )

------------------------------------------
function search_error ( )
	local window = { }
	local width = 210
	local height = 110
	local x = SCREEN_X / 2 - width / 2
	local y = SCREEN_Y / 2 - height / 2
	window.window = guiCreateWindow( x, y, width, height, "MDC Arama Hatasi", false )
	
	window.errorLabel = guiCreateLabel( 10, 30, width - 20, 20, "Arama türü seçmen gerekli!", false, window.window )
	
	
	window.closeButton = guiCreateButton( 10, 60, width - 20, 40, "Cikis", false, window.window )
	addEventHandler( "onClientGUIClick", window.closeButton, 
		function ()
			guiSetVisible( window.window, false )
			destroyElement( window.window )
			window = { }
			search( )
		end
	)
	triggerEvent("hud:convertUI", localPlayer, window.window)
end

------------------------------------------
addEvent( resourceName .. ":search_error", true )
addEventHandler( resourceName .. ":search_error", getRootElement(), search_error )