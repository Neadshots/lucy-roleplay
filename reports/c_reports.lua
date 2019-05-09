addCommandHandler("rapor",
	function(cmd, ...)
		if getElementData(localPlayer, "loggedin") == 1 then
			if not (...) then
				outputChatBox(exports.pool:getServerSyntax(false, "e").."/rapor <bilgi>", 255, 255, 255, true)
				return
			end
			local message = table.concat({...}, " ")
			--outputChatBox(exports.pool:getServerSyntax(false, "s").."Rapor başarıyla gönderildi. <"..message..">", 255, 255, 255, true)
			triggerServerEvent("clientSendReport", localPlayer,  localPlayer, message, 1)
		end
	end
)

addCommandHandler("sorusor",
	function(cmd, ...)
		if getElementData(localPlayer, "loggedin") == 1 then
			if not (...) then
				outputChatBox(exports.pool:getServerSyntax(false, "w").."/sorusor <soru içeriği>", 255, 255, 255, true)
				return
			end
			local message = table.concat({...}, " ")
			--outputChatBox(exports.pool:getServerSyntax(false, "s").."Rapor başarıyla gönderildi. <"..message..">", 255, 255, 255, true)
			triggerServerEvent("clientSendReport", localPlayer,  localPlayer, message, 2)
		end
	end
)