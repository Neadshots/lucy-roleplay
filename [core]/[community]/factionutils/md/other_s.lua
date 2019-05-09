local shape = createColCircle( 1591.5261230469, 1798.5645751953, 2083.376953125, 5 )
shape.interior = 10
shape.dimension = 180


addCommandHandler("tedaviol",
	function(player, cmd)
		if getElementData(player, "loggedin") == 1 then
			if isElementWithinColShape(player, shape) then
				if exports.global:hasMoney(player, 50) then
					player.health = 100
					player:setData("injury", false)
					outputChatBox(exports.pool:getServerSyntax(false, "s").."Başarıyla tedavi oldun.", player, 255, 255, 255, true)
				else
					outputChatBox(exports.pool:getServerSyntax(false, "e").."Tedavi olabilmek için 50$'a ihtiyacın var.", player, 255, 255, 255, true)
				end
			end
		end
	end
)