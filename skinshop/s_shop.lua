local syntaxTable = {
	["s"] = "#00a8ff[LUCY RPG]#ffffff ",
	["e"] = "#e84118[LUCY RPG]#ffffff ",
	["w"] = "#fbc531[LUCY RPG]#ffffff ",
}

addEvent("skinshop-system:buySkin", true)
addEventHandler("skinshop-system:buySkin", root,
	function(player, skinID, price)
		if exports["global"]:hasMoney(player, tonumber(price)) then
			exports["global"]:takeMoney(player, tonumber(price))
			outputChatBox(syntaxTable["s"].."Kıyafet başarıyla satın alındı.",player,255,255,255,true)
			exports["global"]:giveItem(player, 16, tonumber(skinID))
			setElementModel(player, tonumber(skinID))
		end
	end
)