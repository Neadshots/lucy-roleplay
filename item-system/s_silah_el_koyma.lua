--Added by Ozulus
function elKoy(thePlayer, commandName, targetName, weaponSerial)
	if exports["integration"]:isPlayerDeveloper(thePlayer) or getElementData(thePlayer, "faction") == 1 or getElementData(thePlayer, "faction") == 59 then
		if not (targetName) or (not weaponSerial) then
			return outputChatBox("|| Lucy Roleplay || /" .. commandName .. " [Oyuncu İsmi/ID] [Silah Seriali]", thePlayer, 255, 194, 14)
		end
		local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetName)
		if not targetPlayer then
			return outputChatBox("[!] #ffffffKişi bulunamadı.", thePlayer, 255, 0, 0, true)
		end
		local itemSlot = getItems(targetPlayer)
		for i, v in ipairs(itemSlot) do			
			--if v[1] == 115 and not restrictedWeapons[tonumber(explode(":", v[2])[1])] then
				if explode(":", v[2])[2] and (explode(":", v[2])[2] == weaponSerial) then
					if not v[1] == 115 or restrictedWeapons[tonumber(explode(":", v[2])[1])] then
						return outputChatBox("[!] #ffffffBu komut sadece silahlar için kullanılabilir!", thePlayer, 255, 0, 0, true)
					end
					if v[1] == 116 then
						return outputChatBox("[!] #ffffffBu komut sadece silahlar için kullanılabilir!", thePlayer, 255, 0, 0, true)
					end
					local checkString = string.sub(explode(":", v[2])[3], -4) == " (D)"
					if checkString then
						return outputChatBox("[!] #ffffffBu komut Duty silahlarında kullanılamaz!", thePlayer, 255, 0, 0, true)
					end
				
					takeItem(targetPlayer, 115, v[2])
					local silahHak = #tostring(explode(":", v[2])[6])>0 and tonumber(explode(":", v[2])[6]) or 3
					if (silahHak-1) >= 1 then
						giveItem(targetPlayer, 115, tonumber(explode(":", v[2])[1])..":"..tostring(explode(":", v[2])[2])..":"..tostring(explode(":", v[2])[3])..":"..tostring(explode(":", v[2])[4])..":"..tostring(explode(":", v[2])[5])..":"..tostring(silahHak-1))
						
						local suffix = "kişi"
						if exports["integration"]:isPlayerDeveloper(thePlayer) then
							suffix = "yetkili"
						end
						outputChatBox("[!] #ffffff"..targetPlayerName.." adlı kişinin, "..explode(":", v[2])[3].." silahına el koydunuz. Kalan silah hakkı: "..(silahHak-1).."", thePlayer, 0, 55, 255, true)
						outputChatBox("[!] #ffffff"..getPlayerName(thePlayer).." adlı "..suffix..", "..explode(":", v[2])[3].." silahınıza el koydu. Kalan silah hakkınız: "..(silahHak-1).."", targetPlayer, 0, 55, 255, true)
						return
					else
						outputChatBox("[!] #ffffff"..targetPlayerName.." adlı kişinin, "..explode(":", v[2])[3].." silahına el koydunuz. Silah silindi.", thePlayer, 0, 55, 255, true)		
						outputChatBox("[!] #ffffff"..getPlayerName(thePlayer).." adlı "..suffix..", "..explode(":", v[2])[3].." silahınıza el koydu. GG EASY BOY!", targetPlayer, 0, 55, 255, true)		
						return
					end
				end
			--end
		end
	end
end
addCommandHandler("elkoy", elKoy)

function setHak(thePlayer, commandName, targetName, weaponSerial, yeniHak)
	if exports["integration"]:isPlayerDeveloper(thePlayer) then
		local yeniHak = tonumber(yeniHak)
		if not (targetName) or (not weaponSerial) or not yeniHak or (yeniHak and yeniHak > 3 or yeniHak < 0) then
			return outputChatBox("|| Lucy Roleplay || /" .. commandName .. " [Oyuncu İsmi/ID] [Silah Seriali] [Yeni Hak 1-3]", thePlayer, 255, 194, 14)
		end
		local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetName)
		if not targetPlayer then
			return outputChatBox("[!] #ffffffKişi bulunamadı.", thePlayer, 255, 0, 0, true)
		end
		local itemSlot = getItems(targetPlayer)
		for i, v in ipairs(itemSlot) do
			--if v[1] == 115 and not restrictedWeapons[tonumber(explode(":", v[2])[1])] then
				if explode(":", v[2])[2] and (explode(":", v[2])[2] == weaponSerial) then
					if not v[1] == 115 or restrictedWeapons[tonumber(explode(":", v[2])[1])] then
						return outputChatBox("[!] #ffffffBu komut sadece silahlar için kullanılabilir!", thePlayer, 255, 0, 0, true)
					end
					local checkString = string.sub(explode(":", v[2])[3], -4) == " (D)"
					if checkString then
						return outputChatBox("[!] #ffffffBu komut Duty silahlarında kullanılamaz!", thePlayer, 255, 0, 0, true)
					end
					
					takeItem(targetPlayer, 115, v[2])
					giveItem(targetPlayer, 115, tonumber(explode(":", v[2])[1])..":"..tostring(explode(":", v[2])[2])..":"..tostring(explode(":", v[2])[3])..":"..tostring(explode(":", v[2])[4])..":"..tostring(explode(":", v[2])[5])..":"..tostring(yeniHak))
						
					local suffix = "kişi"
					if exports["integration"]:isPlayerDeveloper(thePlayer) then
						suffix = "yetkili"
					end
					outputChatBox("[!] #ffffff"..targetPlayerName.." adlı kişinin, "..explode(":", v[2])[3].." silahının hakkı "..yeniHak.." olarak değiştirildi.", thePlayer, 0, 55, 255, true)
					outputChatBox("[!] #ffffff"..getPlayerName(thePlayer).." adlı "..suffix..", "..explode(":", v[2])[3].." silahınızın hakkını "..yeniHak.." olarak değiştirdi.", targetPlayer, 0, 55, 255, true)
					return
				end
			--end
		end
		outputChatBox("[!] #ffffffSilah seriali bulunamadı!", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("sethak", setHak)