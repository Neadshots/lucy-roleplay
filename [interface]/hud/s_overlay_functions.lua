function sendBottomNotification(thePlayer, title, content, cooldown, widthNew, woffsetNew, hoffsetNew)
	if type(content) == "table" then 
		for i = 1, 20 do 
			if not content[i] then break end
			outputChatBox(content[i], thePlayer)
		end
	else
		outputChatBox(content, thePlayer)
	end
end

function sendTopRightNotification(thePlayer, contentArray, widthNew, posXOffset, posYOffset, cooldown) --Server-side
	triggerClientEvent(thePlayer, "hudOverlay:drawOverlayTopRight", thePlayer, contentArray, widthNew, posXOffset, posYOffset, cooldown)
end

local _outputChatBox = outputChatBox
local function outputChatBox(text, showPlayer)
	if not text then return end
	local syntax = exports.pool:getServerSyntax(false, "s")
	_outputChatBox(syntax..text, showPlayer, 255, 255, 255, true)
end