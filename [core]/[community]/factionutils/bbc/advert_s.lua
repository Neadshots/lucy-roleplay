reklamlar = {}
function reklamGonder(thePlayer, reklamText)
	exports.global:takeMoney(thePlayer, 100)
	exports.global:giveMoney(getTeamFromName("BBC News"), 100)
	local playerItems = exports["item-system"]:getItems(thePlayer)
	local telefonNumarasi
	for index, value in ipairs(playerItems) do
		if value[1] == 2 then
			telefonNumarasi = value[2]
		end
	end

	outputChatBox("[!] Reklam: #ffffff "..reklamText, root, 255,0,0,true)
	outputChatBox("[!] İletişim Bilgileri: #ffffff "..telefonNumarasi, root, 255,0,0,true)
	--outputChatBox("[!] #f0f0f0Reklamınız başarıyla gönderilmiştir! Lütfen onaylanana kadar bekleyin!", thePlayer, 0, 255, 0, true)
end
addEvent("reklamGonder", true)
addEventHandler("reklamGonder", root, reklamGonder)