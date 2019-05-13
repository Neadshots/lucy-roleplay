local mysql = exports.mysql

------------------ Onaylı Tamirci Yapma -------------------------
function tamirciver(thePlayer, commandName, targetPlayerName, tamirci)
local targetName = exports.global:getPlayerFullIdentity(thePlayer, 1)
	if getElementData(thePlayer,"account:username") == "pavlov" or getElementData(thePlayer,"account:username") == "Militan" then 
		if not targetPlayerName or not tonumber(tamirci)  then
			outputChatBox("Sözdizimi: #ffffff/" .. commandName .. " [İsim/ID] [Seviye]", thePlayer, 255, 194, 14, true)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if not targetPlayer then
				
			elseif getElementData( targetPlayer, "loggedin" ) ~= 1 then
				outputChatBox( "Oyuncu oyun'da değil.", thePlayer, 255, 0, 0 )
			else
			 if tonumber(tamirci) <= 2 then
				dbExec(mysql:getConnection(), "UPDATE `characters` SET `tamirci`="..(tamirci).." WHERE `id`='"..(getElementData(targetPlayer, "dbid")).."'")
				setElementData(targetPlayer, "tamirci", tonumber(tamirci))
				outputChatBox("[!]#ffffff".. targetPlayerName .. " adlı kişinin tamirci seviyesini " .. tamirci .. " yaptın.", thePlayer, 0, 255, 0, true)
			    outputChatBox("[!]#ffffff"..targetName.." tarafından tamirci seviyeniz " .. tamirci .. " yapıldı.", targetPlayer, 0, 255, 0,true)
				else
			    outputChatBox("[!]#ffffff "..tamirci.." seviye veremezsin 1-2 seviye arasında verebilirsin.", thePlayer, 255, 0, 0, true)
			    outputChatBox("[!]#ffffff [1-Normal] [2-İsbasi]", thePlayer, 0, 0, 255 ,true)
				end
			end
		end
	else
	    outputChatBox( "[!]#ffffffBu işlemi yapmaya yetkiniz yok.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("tamirciver", tamirciver)
------------- Satın Alma -----------------------------------
-- 41

	local isbasi = createColSphere(513.7880859375, 73.4033203125, 1043.9675292969, 3)
	local benzin = createColSphere(  528.1865234375, 71.626953125, 1044.458984375, 1)
	local tamir = createColSphere(536.46875, 87.4638671875, 1044.4675292969, 3)	
	local sprey = createColSphere( 524.20703125, 63.0126953125, 1044.458984375, 1)
function satinal (thePlayer, cmd, komut)
if (getElementData(thePlayer, "tamirci" ) == 2) then
   if isElementWithinColShape(thePlayer, sprey) then
 if not komut then
    outputChatBox("[!]#ffffff /"..cmd.." sprey", thePlayer, 255, 194, 14, true)
return end
    if komut == "sprey" then
	  local para = 50
	  local sprey = 41
	  if  (exports.global:takeMoney(thePlayer,para)) then
			local serial1 = tonumber(getElementData(thePlayer, "account:character:id"))
			local mySerial = exports.global:createWeaponSerial( 1, serial1)
			exports.global:giveItem(thePlayer, 115, sprey..":"..mySerial..":"..getWeaponNameFromID(sprey).."::")
	   outputChatBox("[!]#ffffff 1 Adet sprey satın aldınız. ("..para..")$", thePlayer, 0, 255, 0, true)
	    end 
    end
  end
  end
end
addCommandHandler("satinal", satinal)	

function benzinalma (thePlayer, cmd, miktar)
if (getElementData(thePlayer, "tamirci" ) == 2) then
   if isElementWithinColShape(thePlayer, benzin) then
    if not miktar then
        outputChatBox("[!]#ffffff /"..cmd.." [Miktar]", thePlayer, 255, 194, 14, true)
    return end   
	local miktar = tonumber(miktar)
	 local para = miktar*2
	  local item = 57
	  if  (exports.global:takeMoney(thePlayer,para)) then
	    if miktar >100 or miktar <1 then
		
	      outputChatBox("[!]#ffffff Maksimum 100lt benzin alabilirsiniz..", thePlayer, 0, 255, 0, true)
	      outputChatBox("[!]#ffffff Minumum 1lt benzin alabilirsiniz..", thePlayer, 0, 255, 0, true)
	    else
		   exports["item-system"]:giveItem(thePlayer, item, miktar)
	      outputChatBox("[!]#ffffff "..miktar.." lt benzin aldınız.", thePlayer, 0, 255, 0, true)
          end
	   end
	   end
	end
end
addCommandHandler("benzinal", benzinalma)


function tamiret (thePlayer, cmd)
if (getElementData(thePlayer, "tamirci" ) == 2) then
   if isElementWithinColShape(thePlayer, tamir) then
    local araba = getPedOccupiedVehicle( thePlayer )
	if (araba) then
    if (exports.global:takeMoney(thePlayer, 150)) then
   
	setElementHealth(araba, 1000)
	fixVehicle(araba)
	for i = 0, 5 do
				setVehicleDoorState(araba, i, 0)
			end
       end	 
   end
   end
   end
end
addCommandHandler("tamiret", tamiret)


-- eski kıyafetleri kaydetmek için ---
local oldSkinsTable = {}

local tamir = {}
function tamir_isbasi (thePlayer, cmd, komut)
	if isElementWithinColShape(thePlayer, isbasi) then
	if not komut then
	outputChatBox("[!]#ffffff /"..cmd.." [gir/cik]", thePlayer, 255, 194, 14, true)
	return end
	if komut == "gir" then
		if getElementData(thePlayer, "tamirci") == 1 then
		outputChatBox("[!]#ffffff Başarıyla iş başı yaptınız.", thePlayer, 0, 194, 0, true)
		local playerOldSkin = getElementModel(thePlayer)
		oldSkinsTable[thePlayer] = playerOldSkin
		setElementModel(thePlayer, 50)
		setElementData(thePlayer, "tamirci", 2)
		tamir[thePlayer] = true
	end
	end
	if komut == "cik" then
			if getElementData(thePlayer, "tamirci") == 2 then
			 local oldSkin = tonumber(oldSkinsTable[thePlayer])
			 setElementModel(thePlayer, oldSkin)
			 oldSkinsTable[thePlayer] = nil
			 tamir[thePlayer] = false
			 outputChatBox("[!]#ffffff Başarıyla iş başın dan ayrıldınız.", thePlayer, 0, 0, 194, true)
			 setElementData(thePlayer, "tamirci", 1)
				end
			end
		end
end
addCommandHandler("isbasi", tamir_isbasi)