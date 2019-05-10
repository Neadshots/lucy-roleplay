--[[
* ***********************************************************************************************************************
* Copyright (c) 2018 pavlov - All Rights Reserved
* Written by Erdem Keskin aka pavlov <www.facebook.com/erdemkeskinofficial>
* ***********************************************************************************************************************
]]
addEvent("satinalindiskinmarket", true)
function satinalindiskinmarket(client)
  outputChatBox("#4a72ee[!] #f7f7f7Tebrikler, harika bir skin satın aldınız!", client, 255, 255, 255, true)
  marketid = getElementData(client, "skinmarketid")
  exports['item-system']:giveItem(client, 16, tonumber(marketid))
  exports.global:takeMoney(client, 500)
end
addEventHandler("satinalindiskinmarket",getRootElement(), satinalindiskinmarket)

addEvent("yetersizbakiyeskinmarket", true)
function yetersizbakiyeskinmarket(client)
  outputChatBox("Yetersiz bakiye.", client, 255, 255, 255, true)
end
addEventHandler("yetersizbakiyeskinmarket",getRootElement(), yetersizbakiyeskinmarket)

addEvent("skinmarketbilgi", true)
function skinmarketbilgi(client)
  outputChatBox("#4a72ee[!] #f7f7f7Satın almak için 'Sol Ctrl' basabilirsiniz.", client, 255, 255, 255, true)
  outputChatBox("#4a72ee[!] #f7f7f7Çıkış yapmak için 'Sol Shift' basabilirsiniz.", client, 255, 255, 255, true)
  outputChatBox("#4a72ee[!] #f7f7f7Değiştirmek için 'Sol & Sağ Ok'  klavye tuşlarına basabilirsiniz.", client, 255, 255, 255, true)
end
addEventHandler("skinmarketbilgi",getRootElement(), skinmarketbilgi)