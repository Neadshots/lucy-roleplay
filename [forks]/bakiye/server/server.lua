mysql = exports.mysql
function bakiyeEkle(thePlayer, commandName, targetPlayer, bakiyeMiktari)
	if (exports.integration:isPlayerDeveloper(thePlayer)) then
		if (not tonumber(bakiyeMiktari)) then
			outputChatBox("[!] #ffffffBirşey yazmadınız. /bakiyever <id> <miktar>", thePlayer, 255, 0, 0, true)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local dbid = getElementData(targetPlayer, "account:id")
				local escapedID = (dbid)
				outputChatBox("[!] #ffffff"..targetPlayerName.." isimli oyuncuya başarıyla ["..bakiyeMiktari.." TL] bakiye eklediniz.", thePlayer, 0, 255, 0, true)
				outputChatBox("[!] #ffffff"..getPlayerName(thePlayer).." isimli yetkili size ["..bakiyeMiktari.." TL] bakiye ekledi.", targetPlayer, 0, 255, 0, true)
				setElementData(targetPlayer, "bakiyeMiktar", tonumber(getElementData(targetPlayer, "bakiyeMiktar") + bakiyeMiktari))
				dbExec(mysql:getConnection(), "UPDATE accounts SET bakiyeMiktari = bakiyeMiktari + " ..bakiyeMiktari.. " WHERE id = '" .. escapedID .. "'")
			end
		end
	else 
		outputChatBox("[!] #ffffffBu işlemi yapmak için yetkiniz yok.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("bakiyever", bakiyeEkle)

function bakiyeCikar(thePlayer, commandName, targetPlayer, bakiyeMiktari)
	if (exports.integration:isPlayerDeveloper(thePlayer)) then
		if (not tonumber(bakiyeMiktari)) then
			outputChatBox("[!] #ffffffBirşey yazmadınız. /bakiyecikar <id> <miktar>", thePlayer, 255, 0, 0, true)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local dbid = getElementData(targetPlayer, "account:id")
				local escapedID = (dbid)
				outputChatBox("[!] #ffffff"..targetPlayerName.." isimli oyuncunun başarıyla ["..bakiyeMiktari.." TL] bakiyesini eksilttiniz.", thePlayer, 0, 255, 0, true)
				outputChatBox("[!] #ffffff"..getPlayerName(thePlayer).." isimli yetkili sizden ["..bakiyeMiktari.." TL] bakiye eksiltti.", targetPlayer, 0, 255, 0, true)
				setElementData(targetPlayer, "bakiyeMiktar", tonumber(getElementData(targetPlayer, "bakiyeMiktar") - bakiyeMiktari))
				dbExec(mysql:getConnection(), "UPDATE accounts SET bakiyeMiktari = bakiyeMiktari - " ..bakiyeMiktari.. " WHERE id = '" .. escapedID .. "'")
			end
		end
	else 
		outputChatBox("[!] #ffffffBu işlemi yapmak için yetkiniz yok.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("bakiyeal", bakiyeCikar)

function bakiyeGoster(thePlayer)
	bakiyeBilgim = getElementData(thePlayer, "bakiyeMiktar")
	outputChatBox("[!] #ffffffBakiye bilginiz: ["..bakiyeBilgim.." TL] olarak görüntüleniyor.", thePlayer, 0, 0, 255, true)
end
addCommandHandler("bakiyem", bakiyeGoster)

function bakiyeKontrol(thePlayer, commandName, targetPlayer, bakiyeBilgim)
	if exports.integration:isPlayerTrialAdmin(thePlayer) then
		local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
		if targetPlayer then
		bakiyeBilgim = getElementData(targetPlayer, "bakiyeMiktar")
		outputChatBox("[!] #ffffff"..targetPlayerName.." Isimli oyuncunun bakiye bilgisi ["..bakiyeBilgim.." TL] olarak görüntüleniyor.", thePlayer, 0, 0, 255, true)
		end
	else
		outputChatBox("[!] #ffffffBu işlemi yapmak için yetkiniz yok.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("bakiyekontrol", bakiyeKontrol)

function bakiyeTransfer(thePlayer, commandName, targetPlayer, bakiyeMiktari)
	if getElementData(thePlayer, "loggedin") == 0 then outputChatBox("[!] #ffffffBu komutu karakterinizdeyken kullanabilirsiniz.", thePlayer, 255, 0, 0, true) return end

	local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
	if (tonumber(bakiyeMiktari) < 1 or tonumber(bakiyeMiktari) > 500) then
		outputChatBox("[!] #ffffffBirşey yazmadınız, - bakiye girdiniz veya 0 TL transfer yapmayı denediniz. /bakiyetransfer <id> <miktar>", thePlayer, 255, 0, 0, true)
		return
	end
		if targetPlayer then
		local karsiDbid = getElementData(targetPlayer, "account:id")
		local benDbid = getElementData(thePlayer, "account:id")
		local escapedIDkarsi = (karsiDbid)
		local escapedIDben = (benDbid)
			bakiyeBilgim = getElementData(thePlayer, "bakiyeMiktar")
			if tonumber(bakiyeBilgim) >= tonumber(bakiyeMiktari) then
			-- BAKIYE YOLLAYAN --
			outputChatBox("[!] #ffffff"..targetPlayerName.." isimli oyuncuya ["..bakiyeMiktari.." TL] bakiye aktarımı yaptınız.", thePlayer, 0, 255, 0, true)
			setElementData(thePlayer, "bakiyeMiktar", tonumber(getElementData(thePlayer, "bakiyeMiktar") - bakiyeMiktari))
			dbExec(mysql:getConnection(), "UPDATE accounts SET bakiyeMiktari = bakiyeMiktari - " ..bakiyeMiktari.. " WHERE id = '" .. escapedIDben .. "'")
			-- BAKIYE ALAN --
			outputChatBox("[!] #ffffff"..getPlayerName(thePlayer).." isimli oyuncu size ["..bakiyeMiktari.." TL] bakiye aktardı.", targetPlayer, 0, 0, 255, true)
			setElementData(targetPlayer, "bakiyeMiktar", tonumber(getElementData(targetPlayer, "bakiyeMiktar") + bakiyeMiktari))
			dbExec(mysql:getConnection(), "UPDATE accounts SET bakiyeMiktari = bakiyeMiktari + " ..bakiyeMiktari.. " WHERE id = '" .. escapedIDkarsi .. "'")
			else
				outputChatBox("[!] #ffffffYeterli bakiyeniz yok.", thePlayer, 255, 0, 0, true)
			end
		end

end
addCommandHandler("bakiyetransfer", bakiyeTransfer)

-------------------------------------------------------------------------------------------------------------------------------------------------

function BorcbakiyeEkle(thePlayer, commandName, targetPlayer, BorcBakiyeMiktari)
	if (exports.integration:isPlayerDeveloper(thePlayer)) then
		if (not tonumber(BorcBakiyeMiktari)) then
			outputChatBox("[!] #ffffffBirşey yazmadınız. /borcbakiyever <id> <miktar>", thePlayer, 255, 0, 0, true)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local charID = getElementData(thePlayer, "dbid")
				outputChatBox("[!] #ffffff"..targetPlayerName.." isimli oyuncuya başarıyla ["..BorcBakiyeMiktari.." $] Borç bakiye eklediniz.", thePlayer, 0, 255, 0, true)
				outputChatBox("[!] #ffffff"..getPlayerName(thePlayer).." isimli yetkili size ["..BorcBakiyeMiktari.." $] Borç bakiye ekledi.", targetPlayer, 0, 255, 0, true)
				setElementData(targetPlayer, "BorcbakiyeMiktar", tonumber(getElementData(targetPlayer, "BorcbakiyeMiktar") + BorcBakiyeMiktari))
				dbExec(mysql:getConnection(), "UPDATE characters SET BorcbakiyeMiktari = BorcbakiyeMiktari + " ..BorcBakiyeMiktari.. " WHERE id = '" .. charID .. "'")
			end
		end
	else 
		outputChatBox("[!] #ffffffBu işlemi yapmak için yetkiniz yok.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("borcbakiyever", BorcbakiyeEkle)

function BorcbakiyeCikar(thePlayer, commandName, targetPlayer, BorcBakiyeMiktari)
	if (exports.integration:isPlayerDeveloper(thePlayer)) then
		if (not tonumber(BorcBakiyeMiktari)) then
			outputChatBox("[!] #ffffffBirşey yazmadınız. /borcbakiyeal <id> <miktar>", thePlayer, 255, 0, 0, true)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local charID = getElementData(thePlayer, "dbid")
				outputChatBox("[!] #ffffff"..targetPlayerName.." isimli oyuncunun başarıyla ["..BorcBakiyeMiktari.." $] bakiyesini eksilttiniz.", thePlayer, 0, 255, 0, true)
				outputChatBox("[!] #ffffff"..getPlayerName(thePlayer).." isimli yetkili sizden ["..BorcBakiyeMiktari.." $] bakiye eksiltti.", targetPlayer, 0, 255, 0, true)
				setElementData(targetPlayer, "BorcbakiyeMiktar", tonumber(getElementData(targetPlayer, "BorcbakiyeMiktar") - BorcBakiyeMiktari))
				dbExec(mysql:getConnection(), "UPDATE characters SET BorcBakiyeMiktari = BorcBakiyeMiktari - " ..BorcBakiyeMiktari.. " WHERE id = '" .. charID .. "'")
			end
		end
	else 
		outputChatBox("[!] #ffffffBu işlemi yapmak için yetkiniz yok.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("borcbakiyeal", BorcbakiyeCikar)

function BorcbakiyeGoster(thePlayer)
	bakiyeBilgim = getElementData(thePlayer, "BorcbakiyeMiktar")
	outputChatBox("[!] #ffffffBorç bakiye bilginiz: ["..bakiyeBilgim.." $] olarak görüntüleniyor.", thePlayer, 0, 125, 255, true)
end
addCommandHandler("borcbakiyem", BorcbakiyeGoster)

function BorcbakiyeKontrol(thePlayer, commandName, targetPlayer, bakiyeBilgim)
	if exports.integration:isPlayerTrialAdmin(thePlayer) then
		local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick(thePlayer, targetPlayer)
		if targetPlayer then
		local bakiyeBilgim = tonumber(getElementData(targetPlayer, "BorcbakiyeMiktar"))
		outputChatBox("[!] #ffffff"..targetPlayerName.." Isimli oyuncunun Borç Bakiye bilgisi ["..bakiyeBilgim.." $] olarak görüntüleniyor.", thePlayer, 0, 0, 255, true)
		end
	else
		outputChatBox("[!] #ffffffBu işlemi yapmak için yetkiniz yok.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("borcbakiyekontrol", BorcbakiyeKontrol)

function BorcBakiyeOde(thePlayer, commandName, BorcBakiyeMiktari)
		if (not tonumber(BorcBakiyeMiktari)) then
			outputChatBox("[!] #ffffffBirşey yazmadınız. /borcbakiyeparaver <miktar>", thePlayer, 255, 0, 0, true)
		else
			local para = exports.global:getMoney(thePlayer)
			if tonumber(BorcBakiyeMiktari) < 0 then
				outputChatBox("[!] #ffffffMalesef, - Miktar giremezsiniz.", thePlayer, 255, 0, 0, true)
			return
			end
			if tonumber(BorcBakiyeMiktari)-1 >= para then
				outputChatBox("[!] #ffffffYeterli miktarda paranız yok.", thePlayer, 255, 0, 0, true)
			return
			end
			local bakiyeBilgim = getElementData(thePlayer, "BorcbakiyeMiktar")
			if bakiyeBilgim == 0 then
				outputChatBox("[!] #ffffffBorç bakiyeniz yok.", thePlayer, 255, 0, 0, true)
			return
			end
			
			local charID = getElementData(thePlayer, "dbid")
			outputChatBox("[!] #ffffffBaşarıyla Borç Bakiyenizden ["..BorcBakiyeMiktari.." $] bakiye eksilttiniz.", thePlayer, 0, 255, 0, true)
			setElementData(thePlayer, "BorcbakiyeMiktar", tonumber(getElementData(thePlayer, "BorcbakiyeMiktar") - BorcBakiyeMiktari))
			dbExec(mysql:getConnection(), "UPDATE characters SET BorcBakiyeMiktari = BorcBakiyeMiktari - " ..BorcBakiyeMiktari.. " WHERE id = '" .. charID .. "'")
			exports.global:takeMoney(thePlayer, BorcBakiyeMiktari)
		end
end
addCommandHandler("borcbakiyeparaver", BorcBakiyeOde)

-- bakiye.isimDegistirOnayla

function isimDegistirOnayla(isim)
	local stat,errort = checkValidCharacterName(isim)
	if not stat then
		outputChatBox("[!] #ffffff"..errort, source, 255, 0, 0, true)
		return false
	end
	isim = string.gsub(tostring(isim), " ", "_")
	local accounts, characters = exports.auth:getTableInformations()
	for index, value in ipairs(characters) do
		if value.charactername == isim then 
			
			outputChatBox("[!] #ffffffBu isim zaten kullanımda.", source, 255, 0, 0, true)
			--setElementData(source, "bakiyeMiktar", tonumber(getElementData(source, "bakiyeMiktar") + 10))
			
			return false
		end
	end
	local bakiyeCek = tonumber(getElementData(source, "bakiyeMiktar"))
	if bakiyeCek < 10 then
		outputChatBox("[!] #ffffffBu işlem için 10 TL bakiyeniz olması gerekmektedir.", source,255, 0, 0, true)
		return false
	end
	

	
	setElementData(source, "bakiyeMiktar", bakiyeCek - 10)
	triggerClientEvent( source, "bakiye.isimDegistirmeAsama", source, 1 )
	outputChatBox("[!] #ffffffBaşarıyla isim değiştirdiniz.", source, 0, 255, 0, true)
	setElementData(source, "OOCHapisKontrol", 0)
	
	setElementPosition(source, 2092.373046875, -1779.6650390625, 13.746875)
	setElementRotation(source, 0, 0, 75.315185546875)
	setElementInterior(source, 0)
	setElementDimension(source, 0)
	-------------- LOG SISTEMI --------------
	local hours = getRealTime().hour
	local minutes = getRealTime().minute
	local seconds = getRealTime().second
	local day = getRealTime().monthday
	local month = getRealTime().month+1
	local year = getRealTime().year+1900
	local alinanUrun = "Isim Degisikligi"
	local ucret = "10"
	dbExec(mysql:getConnection(), "INSERT INTO `market_logs` SET `accountid` = '"..getElementData(source, "account:id").."', `accountUsername` = '"..getElementData(source, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
	-----------------------------------------
	outputChatBox("(( " ..getPlayerName(source):gsub("_", " ").. " sunucudan yasaklandı. Sure: Sınırsız Gerekce: İsim Değişikliği - " ..string.format("%02d", hours)..":"..string.format("%02d", minutes).. " ))", arrarPlayer, 255, 0, 0)
	exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(source) .. "' isimli oyuncu ismini '" .. isim .. "' olarak değiştirildi.")
	outputChatBox("[!] #ffffff'"..getPlayerName(source) .. "' olan isminizi '" .. tostring(isim) .. "' olarak değiştirdiniz.", source, 0, 255, 0, true)
	changeName(source, isim)
end
addEvent("bakiye.isimDegistirOnayla",true)
addEventHandler("bakiye.isimDegistirOnayla", root, isimDegistirOnayla)

-- bakiye.isimDegistirOnayla

function kisimDegistirOnayla(isim)
	local stat,errort = checkValidUsername(isim)
	if not stat then
		outputChatBox("[!] #ffffff"..errort, source, 255, 0, 0, true)
		return false
	end
	--isim = string.gsub(tostring(isim), " ", "_")

	local accounts, characters = exports.auth:getTableInformations()
	for index, value in ipairs(accounts) do
		if value.username == isim then 
			
			outputChatBox("[!] #ffffffBu isim zaten kullanımda.", source, 255, 0, 0, true)
			--setElementData(source, "bakiyeMiktar", tonumber(getElementData(source, "bakiyeMiktar") + 10))
			
			return false
		end
	end
	

	local bakiyeCek = tonumber(getElementData(source, "bakiyeMiktar"))
	if bakiyeCek < 10 then
		outputChatBox("[!] #ffffffBu işlem için 10 TL bakiyeniz olması gerekmektedir.", source,255, 0, 0, true)
		return false
	end
	
	
	setElementData(source, "bakiyeMiktar", bakiyeCek - 10)
	outputChatBox("[!] #ffffffBaşarıyla isim değiştirdiniz.", source, 0, 255, 0, true)
	setElementData(source, "OOCHapisKontrol", 0)

	-------------- LOG SISTEMI --------------
	local hours = getRealTime().hour
	local minutes = getRealTime().minute
	local seconds = getRealTime().second
	local day = getRealTime().monthday
	local month = getRealTime().month+1
	local year = getRealTime().year+1900
	local alinanUrun = "Kullanici adi Degisikligi"
	local ucret = "10"
	--dbExec(mysql:getConnection(), "INSERT INTO `market_logs` SET `accountid` = '"..getElementData(source, "account:id").."', `accountUsername` = '"..getElementData(source, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..ucret.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
	-----------------------------------------
	outputChatBox("(( " ..getPlayerName(source):gsub("_", " ").. " sunucudan yasaklandı. Sure: Sınırsız Gerekce: Kullanıcı Adı Değişikliği - " ..string.format("%02d", hours)..":"..string.format("%02d", minutes).. " ))", arrarPlayer, 255, 0, 0)
	exports.global:sendMessageToAdmins("[MARKET] '" .. getElementData(source, "account:username") .. "' isimli oyuncu ismini '" .. isim .. "' olarak değiştirildi.")
	outputChatBox("[!] #ffffff'"..getElementData(source, "account:username") .. "' olan isminizi '" .. tostring(isim) .. "' olarak değiştirdiniz.", source, 0, 255, 0, true)
	
	local dbid = getElementData(source, "account:id")
	setElementData(source, "account:username", isim)
	dbExec(mysql:getConnection(), "UPDATE accounts SET username='" .. (isim) .. "' WHERE id = " .. (dbid))
	setElementData(source, "account:username", isim)

end
addEvent("bakiye.kisimDegistirOnayla",true)
addEventHandler("bakiye.kisimDegistirOnayla", root, kisimDegistirOnayla)

function changeName(targetPlayer,newName)
	exports.anticheat:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 1, false)
	local name = setPlayerName(targetPlayer, tostring(newName))
	local dbid = getElementData(targetPlayer, "dbid")
	local targetPlayerName = getPlayerName(targetPlayer)
	if (name) then
		exports['cache']:clearCharacterName( dbid )
		dbExec(mysql:getConnection(), "UPDATE characters SET charactername='" .. (newName) .. "' WHERE id = " .. (dbid))

		local adminTitle = "[MARKET]"
		local processedNewName = string.gsub(tostring(newName), "_", " ")
		

		exports.anticheat:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 0, false)

		exports.logs:dbLog(thePlayer, 4, targetPlayer, "MARKET ISIM DEGISIKLIGI "..targetPlayerName.." -> "..tostring(newName))
		triggerClientEvent(targetPlayer, "updateName", targetPlayer, getElementData(targetPlayer, "dbid"))
	else
		outputChatBox("[!] #ffffffBaşarısız oldu.", thePlayer, 255, 0, 0, true)
	end
	exports.anticheat:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 0, false)
end

function vipVerdirtme(vipSeviye, vipGun, vipFiyat)
	exports["vip"]:addVIP(source, vipSeviye, vipGun)
	outputChatBox("[!] #ffffffTebrikler, başarıyla "..vipGun.." günlük VIP ["..vipSeviye.."] aldınız.", source, 0, 255, 0, true)
	exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(source) .. "' isimli oyuncu "..vipGun.." günlük VIP [" .. vipSeviye .. "] aldı.")
	-------------- LOG SISTEMI --------------
	local hours = getRealTime().hour
	local minutes = getRealTime().minute
	local seconds = getRealTime().second
	local day = getRealTime().monthday
	local month = getRealTime().month+1
	local year = getRealTime().year+1900
	local alinanUrun = ""..vipGun.." gunluk VIP ["..vipSeviye.."]"
	dbExec(mysql:getConnection(), "INSERT INTO `market_logs` SET `accountid` = '"..getElementData(source, "account:id").."', `accountUsername` = '"..getElementData(source, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..vipFiyat.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
	-----------------------------------------
end
addEvent("bakiye-sistemi:vip", true)
addEventHandler("bakiye-sistemi:vip", root, vipVerdirtme)

function karakterSlotArttirmaLOG(gunSayisi)
	exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(source) .. "' isimli oyuncu +1 karakter slotu arttırma aldı.")
	-------------- LOG SISTEMI --------------
	local hours = getRealTime().hour
	local minutes = getRealTime().minute
	local seconds = getRealTime().second
	local day = getRealTime().monthday
	local month = getRealTime().month+1
	local year = getRealTime().year+1900
	local alinanUrun = "Karakter Slotu Arttirma"
	dbExec(mysql:getConnection(), "INSERT INTO `market_logs` SET `accountid` = '"..getElementData(source, "account:id").."', `accountUsername` = '"..getElementData(source, "account:username").."', `alinanUrun` = '"..alinanUrun.."', `ucret` = '"..gunSayisi.." TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")
	-----------------------------------------
end
addEvent("bakiye-sistemi:karakterSlotLOG", true)
addEventHandler("bakiye-sistemi:karakterSlotLOG", root, karakterSlotArttirmaLOG)

function SmallestID() -- finds the smallest ID in the SQL instead of auto increment
	local result = dbPoll(dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM vehicles AS e1 LEFT JOIN vehicles AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL"),-1)
	if result then
		local id = tonumber(result["nextID"]) or 1
		return id
	end
	return false
end

function orderPet(player, petID)
	local hours = getRealTime().hour
	local minutes = getRealTime().minute
	local seconds = getRealTime().second
	local day = getRealTime().monthday
	local month = getRealTime().month+1
	local year = getRealTime().year+1900
	exports.global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu marketten pet satın aldı.")
	dbExec(mysql:getConnection(), "INSERT INTO `market_logs` SET `accountid` = '"..getElementData(player, "account:id").."', `accountUsername` = '"..getElementData(player, "account:username").."', `alinanUrun` = 'PET', `ucret` = '30 TL', `tarih` = '"..string.format("%02d/%02d/%02d", day, month, year).." / "..string.format("%02d:%02d:%02d", hours, minutes, seconds).."'")

	setElementData(player, "bakiyeMiktar", getElementData(player, "bakiyeMiktar")-30)
	outputChatBox("[!]#ffffff Başarıyla evcil hayvan satın aldınız, evcil hayvanı beslemezseniz bayılır ve kullanamazsınız.", player, 0, 255, 0, true)

	targetPlayer = player
	if tonumber(petID) == 1 then
		triggerClientEvent(targetPlayer, "hayvan:namePet", targetPlayer, 178)
	elseif tonumber(petID) == 2 then
		triggerClientEvent(targetPlayer, "hayvan:namePet", targetPlayer, 310)
	elseif tonumber(petID) == 3 then
		triggerClientEvent(targetPlayer, "hayvan:namePet", targetPlayer, 311)
	elseif tonumber(petID) == 4 then
		triggerClientEvent(targetPlayer, "hayvan:namePet", targetPlayer, 304)
	elseif tonumber(petID) == 5 then
		triggerClientEvent(targetPlayer, "hayvan:namePet", targetPlayer, 298)
	elseif tonumber(petID) == 6 then
		triggerClientEvent(targetPlayer, "hayvan:namePet", targetPlayer, 302)
	elseif tonumber(petID) == 7 then
		triggerClientEvent(targetPlayer, "hayvan:namePet", targetPlayer, 301)
	end
end
addEvent("bakiye-sistemi:petSatinAl", true)
addEventHandler("bakiye-sistemi:petSatinAl", root, orderPet)