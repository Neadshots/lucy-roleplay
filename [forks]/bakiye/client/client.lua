marketListesi = {
	{0, "İsim Değişikliği", "10"},
	{1, "VIP 1 (30 Günlük)", "20"},
	{2, "VIP 2 (30 Günlük)", "40"},
	{3, "VIP 3 (30 Günlük)", "60"},
	{4, "Ek Karakter Slotu +1", "5"},
	{5, "Kullanıcı Adı Değişikliği", "10"},
	{6, "Araç Vergi Azaltıcı", "40"},
}

petListesi = {

	{1, "Sokak Kedisi", 30},
	{2, "Beyaz Pitbull", 30},
	{3, "Siyah-Beyaz Pitbull", 30},
	{4, "Beyaz-Gri Pitbull", 30},
	{5, "Beyaz-Turuncu Pitbull", 30},
	{6, "Doberman", 30},
	{7, "Kurt Köpeği", 30},

}

local sx, sy = guiGetScreenSize()
function marketSistemiAC()
	if getElementData(getLocalPlayer(), "loggedin") == 0 then outputChatBox("[!] #ffffffBu komutu karakterinizdeyken kullanabilirsiniz.", 255, 0, 0, true) return end
	setElementData(getLocalPlayer(), "marketSistemiAcik", 1)
	showCursor(true)
	guiSetInputEnabled(true)

	normalWindow = guiCreateWindow(sx/2-550/2,sy/2-400/2,550,400, "Lucy Roleplay - Market Sistemi", false)
	guiWindowSetSizable(normalWindow, false)
	guiWindowSetMovable(normalWindow, false)

	tab = guiCreateTabPanel(10,30,530,380,false, normalWindow)
	window = guiCreateTab("Kişisel Özellikler", tab)
	window2 = guiCreateTab("Private Araçlar", tab)
	guiSetEnabled(window2, false)
	window3 = guiCreateTab("Evcil Hayvanlar", tab)
	
	--------------------- BAKIYE YAZISI ---------------------

	bakiyeMiktari = guiCreateLabel(0.79, 0.01, 0.18, 0.04, ""..getElementData(getLocalPlayer(), "bakiyeMiktar").." TL", true, window)

	guiLabelSetHorizontalAlign(bakiyeMiktari, "right", false)

	bakiyeMiktari2 = guiCreateLabel(0.79, 0.01, 0.18, 0.04, ""..getElementData(getLocalPlayer(), "bakiyeMiktar").." TL", true, window2)

	guiLabelSetHorizontalAlign(bakiyeMiktari2, "right", false)

	bakiyeMiktari3 = guiCreateLabel(0.79, 0.01, 0.18, 0.04, ""..getElementData(getLocalPlayer(), "bakiyeMiktar").." TL", true, window3)

	guiLabelSetHorizontalAlign(bakiyeMiktari3, "right", false)
	---------------------------------------------------------

	
	--------------------- SATIS LISTESI ---------------------
	gridlist = guiCreateGridList(0.03, 0.07, 0.94, 0.80, true, window)
	guiGridListSetSortingEnabled(gridlist, false)
	guiGridListAddColumn(gridlist, "İsim", 0.75)
	guiGridListAddColumn(gridlist, "Fiyat", 0.20)
	--guiGridListAddRow(gridlist)
	
	for index, value in ipairs(marketListesi) do
		local row = guiGridListAddRow(gridlist)
		guiGridListSetItemText(gridlist, row, 1, value[2], false, false)
		guiGridListSetItemText(gridlist, row, 2, value[3].." TL", false, false)
	end
	

	
			
	--guiGridListSetItemText(gridlist, 0, 1, "-", false, false)
	--guiGridListSetItemText(gridlist, 0, 2, "10 TL", false, false)
	---------------------------------------------------------
	
	
	onaylaButonu = guiCreateButton(0.03, 0.90, 0.45, 0.07, "Seçileni Al", true, window)
	guiSetFont(onaylaButonu, "default-bold-small")

	
	kapatButonu = guiCreateButton(0.52, 0.90, 0.45, 0.07, "Kapat", true, window)
	guiSetFont(kapatButonu, "default-bold-small")



	--- ###### TAB 3 - PETLER ######---
	gridlist3 = guiCreateGridList(0.03, 0.07, 0.94, 0.80, true, window3)
	guiGridListSetSortingEnabled(gridlist3, false)
	guiGridListAddColumn(gridlist3, "İsim", 0.75)
	guiGridListAddColumn(gridlist3, "Fiyat", 0.20)
	--guiGridListAddRow(gridlist3)
	
	for index, value in ipairs(petListesi) do
		local row = guiGridListAddRow(gridlist3)
		guiGridListSetItemText(gridlist3, row, 1, "("..value[1]..") "..value[2], false, false)
		guiGridListSetItemText(gridlist3, row, 2, value[3].." TL", false, false)
	end
	


	onaylaButonu3 = guiCreateButton(0.03, 0.90, 0.45, 0.07, "Seçileni Al", true, window3)
	guiSetFont(onaylaButonu3, "default-bold-small")

	
	kapatButonu3 = guiCreateButton(0.52, 0.90, 0.45, 0.07, "Kapat", true, window3)
	guiSetFont(kapatButonu3, "default-bold-small")



	addEventHandler("onClientRender", root, 
	function()
		if getElementData(getLocalPlayer(), "marketSistemiAcik") == 1 then
			guiSetText(bakiyeMiktari,  "Bakiye: "..getElementData(getLocalPlayer(), "bakiyeMiktar").." TL")
			
			guiSetText(bakiyeMiktari3,  "Bakiye: "..getElementData(getLocalPlayer(), "bakiyeMiktar").." TL")
			
			
		end
	end
	)
	
end
addCommandHandler("market", marketSistemiAC)
addCommandHandler("oocmarket", marketSistemiAC)


addEventHandler("onColorPickerOK", root, function(id,hex,r,g,b)
	if isElement(previewObject) then
		setVehicleColor(previewObject, r,g,b)
		rgbTbl = {r,g,b}
		setElementData(localPlayer, "vehDonateColorTable", rgbTbl)
	end
end)

----------------------------- ISIM DEGISTIRME PANELI -----------------------------
function isimDegistirmePaneli()
	showCursor(true)
	guiSetInputEnabled(true)
    isimDegistirmeWINDOW = guiCreateWindow(0.35, 0.39, 0.30, 0.24, "Lucy Roleplay - İsim Değiştirme Paneli", true)
    guiWindowSetSizable(isimDegistirmeWINDOW, false)

    isimDegistirmeUyariYAZI = guiCreateLabel(0.02, 0.08, 0.97, 0.17, "Lütfen karakter Ad ve Soyadınızı aşağıdaki kutuya\nşu şekilde yazınız. \"Ad Soyad\"", true, isimDegistirmeWINDOW)
    guiSetFont(isimDegistirmeUyariYAZI, "default-bold-small")
    guiLabelSetHorizontalAlign(isimDegistirmeUyariYAZI, "center", false)
    guiLabelSetVerticalAlign(isimDegistirmeUyariYAZI, "center")
    isimDegistirmeEditBOX = guiCreateEdit(0.02, 0.26, 0.96, 0.16, "", true, isimDegistirmeWINDOW)
	
	isimDegistirmeComboBOX1 = guiCreateComboBox(0.17, 0.43, 0.31, 0.25, "Cinsiyet Seçin", true, isimDegistirmeWINDOW)
    guiComboBoxAddItem(isimDegistirmeComboBOX1, "Erkek")
    guiComboBoxAddItem(isimDegistirmeComboBOX1, "Bayan")
    isimDegistirmeComboBOX2 = guiCreateComboBox(0.50, 0.43, 0.31, 0.30, "Irk Seçin", true, isimDegistirmeWINDOW)
    guiComboBoxAddItem(isimDegistirmeComboBOX2, "Siyahi")
    guiComboBoxAddItem(isimDegistirmeComboBOX2, "Beyaz")
	guiComboBoxAddItem(isimDegistirmeComboBOX2, "Asyalı")
	
    isimDegistirmeCheckBOX = guiCreateCheckBox(0.05, 0.67, 0.91, 0.10, "Üstteki isimin doğru olduğunu onaylıyorum ve değiştirmek istiyorum.", false, true, isimDegistirmeWINDOW)
    isimDegistirmeOnaylaBUTON = guiCreateButton(0.02, 0.80, 0.46, 0.12, "ONAYLA", true, isimDegistirmeWINDOW)
    guiSetFont(isimDegistirmeOnaylaBUTON, "default-bold-small")
    isimDegistirmeKapatBUTON = guiCreateButton(0.51, 0.80, 0.47, 0.12, "KAPAT", true, isimDegistirmeWINDOW)
    guiSetFont(isimDegistirmeKapatBUTON, "default-bold-small")

 
end
addEvent("bakiye-sistemi:isimDegistirmePaneli", true)
addEventHandler("bakiye-sistemi:isimDegistirmePaneli", root, isimDegistirmePaneli)

function isimDegistirmePanelAC()
	if getElementData(getLocalPlayer(), "account:username") == "Query" then
		triggerEvent("bakiye-sistemi:isimDegistirmePaneli", getLocalPlayer())
	end
end
addCommandHandler("isimac", isimDegistirmePanelAC)
----------------------------------------------------------------------------------

----------------------------- ISIM DEGISTIRME PANELI -----------------------------
function kisimDegistirmePaneli()
	showCursor(true)
	guiSetInputEnabled(true)
    isimDegistirmeWINDOW = guiCreateWindow(0.35, 0.39, 0.30, 0.24, "Lucy Roleplay - Kullanıcı Adı Değiştirme Paneli", true)
    guiWindowSetSizable(isimDegistirmeWINDOW, false)

    isimDegistirmeUyariYAZI = guiCreateLabel(0.02, 0.08, 0.97, 0.17, "Lütfen yeni bir kullanıcı adı belirleyin.", true, isimDegistirmeWINDOW)
    guiSetFont(isimDegistirmeUyariYAZI, "default-bold-small")
    guiLabelSetHorizontalAlign(isimDegistirmeUyariYAZI, "center", false)
    guiLabelSetVerticalAlign(isimDegistirmeUyariYAZI, "center")
    isimDegistirmeEditBOX = guiCreateEdit(0.02, 0.26, 0.96, 0.16, "", true, isimDegistirmeWINDOW)
	
    isimDegistirmeCheckBOX = guiCreateCheckBox(0.05, 0.67, 0.91, 0.10, "Üstteki isimin doğru olduğunu onaylıyorum ve değiştirmek istiyorum.", false, true, isimDegistirmeWINDOW)
    kisimDegistirmeOnaylaBUTON = guiCreateButton(0.02, 0.80, 0.46, 0.12, "ONAYLA", true, isimDegistirmeWINDOW)
    guiSetFont(kisimDegistirmeOnaylaBUTON, "default-bold-small")
    isimDegistirmeKapatBUTON = guiCreateButton(0.51, 0.80, 0.47, 0.12, "KAPAT", true, isimDegistirmeWINDOW)
    guiSetFont(isimDegistirmeKapatBUTON, "default-bold-small")
 	
end
addEvent("bakiye-sistemi:kisimDegistirmePaneli", true)
addEventHandler("bakiye-sistemi:kisimDegistirmePaneli", root, kisimDegistirmePaneli)

function kisimDegistirmePanelAC()
	if getElementData(getLocalPlayer(), "account:username") == "Query" then
		triggerEvent("bakiye-sistemi:kisimDegistirmePaneli", getLocalPlayer())
	end
end
addCommandHandler("kisimac", kisimDegistirmePanelAC)
----------------------------------------------------------------------------------


VIPNUMARA = nil
----------------------------- VIP SATIN ALMA PANEL -----------------------------
function vipSatinAlmaPANEL(vipNumara)
VIPNUMARA = vipNumara
	if getElementData(getLocalPlayer(), "vip") == vipNumara or getElementData(getLocalPlayer(), "vip") == 0 then
	
		setElementData(getLocalPlayer(), "vipSatinAlmaPanel", 1)
		showCursor(true)
		guiSetInputEnabled(true)
		
		vipSatinAlmaWINDOW = guiCreateWindow(0.36, 0.37, 0.29, 0.19, "Lucy Roleplay - VIP ["..vipNumara.."] Satın Alma Paneli", true)
        guiWindowSetSizable(vipSatinAlmaWINDOW, false)
		
		vipSatinAlmaYazi1 = guiCreateLabel(0.03, 0.15, 0.38, 0.19, "Kaç günlük VIP istiyorsun?", true, vipSatinAlmaWINDOW)
        guiSetFont(vipSatinAlmaYazi1, "default-bold-small")
        guiLabelSetHorizontalAlign(vipSatinAlmaYazi1, "center", false)
        guiLabelSetVerticalAlign(vipSatinAlmaYazi1, "center")   
        vipSatinAlmaEditBOX = guiCreateEdit(0.43, 0.14, 0.12, 0.20, "", true, vipSatinAlmaWINDOW)
		
        vipSatinAlmaYazi2 = guiCreateLabel(0.02, 0.34, 0.95, 0.18, "- TL karşılığında, - günlük VIP ["..vipNumara.."] alacaksınız. \nOnaylıyor musunuz?", true, vipSatinAlmaWINDOW)
		
		addEventHandler("onClientRender", root, 
		function()
			if getElementData(getLocalPlayer(), "vipSatinAlmaPanel") == 1 then
				local gunSayisi = math.floor(tonumber(guiGetText(vipSatinAlmaEditBOX)))
				if not gunSayisi or gunSayisi < 0 then
					guiSetText(vipSatinAlmaEditBOX,"")
				end
				if vipNumara == 1 then
					if gunSayisi ~= nil then
						vipFiyat = 20 / 30 * gunSayisi
					end
				elseif vipNumara == 2 then
					if gunSayisi ~= nil then
						vipFiyat = 40 / 30 * gunSayisi
					end
				elseif vipNumara == 3 then
					if gunSayisi ~= nil then
						vipFiyat = 60 / 30 * gunSayisi
					end
				end
				if gunSayisi == nil then
					guiSetText(vipSatinAlmaYazi2, "- TL karşılığında, - günlük VIP ["..vipNumara.."] alacaksınız. \nOnaylıyor musunuz?")
				else
					guiSetText(vipSatinAlmaYazi2, math.ceil(vipFiyat).." TL karşılığında, "..gunSayisi.." günlük VIP ["..vipNumara.."] alacaksınız. \nOnaylıyor musunuz?")
				end
			end
		end
		)
		
        guiSetFont(vipSatinAlmaYazi2, "default-bold-small")
        guiLabelSetHorizontalAlign(vipSatinAlmaYazi2, "center", false)
        guiLabelSetVerticalAlign(vipSatinAlmaYazi2, "center")
        vipSatinAlmaOnaylaBUTON = guiCreateButton(0.02, 0.55, 0.47, 0.38, "ONAYLA", true, vipSatinAlmaWINDOW)
        guiSetFont(vipSatinAlmaOnaylaBUTON, "default-bold-small")
        vipSatinAlmaKapatBUTON = guiCreateButton(0.51, 0.55, 0.47, 0.38, "KAPAT", true, vipSatinAlmaWINDOW)
        guiSetFont(vipSatinAlmaKapatBUTON, "default-bold-small")
	else
		outputChatBox("[!] #ffffffAncak sadece sahip olduğunuz VIP seviyesinin aynısını satın alabilir ve süre uzatabilirsiniz.", 255, 0, 0, true)
	end
end
addEvent("bakiye-sistemi:vipSatinAlma", true)
addEventHandler("bakiye-sistemi:vipSatinAlma", root, vipSatinAlmaPANEL)

addEventHandler("onClientGUIChanged", guiRoot, function() 
	if not(source == vipSatinAlmaEditBOX) then return false end
	local text = guiGetText(source) or "" 
	if not tonumber(text) then --if the text isn't a number (statement needed to prevent infinite loop) 
		guiSetText(source, string.gsub(text, "%a", "")) --Remove all letters 
	end
end)
function vipAlmaPanelAC()
	if getElementData(getLocalPlayer(), "account:username") == "Query" then
		triggerEvent("bakiye-sistemi:vipSatinAlma", getLocalPlayer(), 3)
	end
end
addCommandHandler("vipac", vipAlmaPanelAC)
----------------------------------------------------------------------------------

addEventHandler("onClientGUIClick", guiRoot, function()
	------------------ MARKET ------------------

	if source == araciSatinAlmaButonu then

		-- araç satın alma

		if guiGetText(infoLabel) == "Araç Hız Limiti: ..." then
			outputChatBox("[!] #ffffffAlacak bir araba seçmediniz, ayrıca unutmayın alacağınız arabanın rengini ayarlayabilirsiniz.", 255, 0, 0, true)
			return false
		end
		local selectedVehID = guiGridListGetSelectedItem(gridlist2)
		selectedVehID = selectedVehID + 1
		exportedTable = aracListesi[selectedVehID] or false	-- vehname, price, model, owlmodel, maxspeed, tax

		if exportedTable then
			bakiye = getElementData(localPlayer, "bakiyeMiktar")
			alincakMiktar = exportedTable[2]
			if guiCheckBoxGetSelected(plate) then
				plateState = true
				alincakMiktar = alincakMiktar + 10
				if isElement(plateEdit) then
					plateText = guiGetText(plateEdit)
				else
					plateText = ""
					alincakMiktar = exportedTable[2]
				end
			else
				playerteState = false
				alincakMiktar = exportedTable[2]
				plateText = ""
			end

			if bakiye < alincakMiktar then
				outputChatBox("[!] #ffffffYeterli bakiyeniz bulunmadığı için aracı alamazsınız. [ Senin "..alincakMiktar-bakiye.." TL'ye daha ihtiyacın var. ]", 255, 0, 0, true)
				return
			end

			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				if oPrevElement then
					exports["irp_opreview"]:destroyObjectPreview(oPrevElement)
				end
			end
			showCursor(false)
			guiSetInputEnabled(false)
			setElementData(getLocalPlayer(), "marketSistemiAcik", 0)

			--fonksiyon çıktısı: player, araçid, owlid, renk, kesilcek bakiye
			rgbTble = getElementData(localPlayer,"vehDonateColorTable")
			triggerServerEvent("bakiye-sistemi:donateSatinAl", getLocalPlayer(), exportedTable[3], exportedTable[4], rgbTble or {255, 255, 255}, alincakMiktar, exportedTable[1], plateState, plateText)
		else
			outputChatBox("[!] #ffffffAlacak bir araba seçmediniz, ayrıca unutmayın alacağınız arabanın rengini ayarlayabilirsiniz.", 255, 0, 0, true)
		end
	elseif source == kapatButonu or source ==kapatButonu2 or source == kapatButonu3 then
		destroyElement(normalWindow)
		if isElement(previewObject) then
			destroyElement(previewObject)
			if oPrevElement then
				exports["irp_opreview"]:destroyObjectPreview(oPrevElement)
			end
		end
		showCursor(false)
		guiSetInputEnabled(false)
		setElementData(getLocalPlayer(), "marketSistemiAcik", 0)
	elseif source == vehColorCBox then
		openPicker(1,"FFFFFF","Araç Rengini Ayarlayın")
	elseif source == onaylaButonu then
		local siraCek = guiGridListGetSelectedItem(gridlist)
		local isimCek = guiGridListGetItemText(gridlist, siraCek, 1)
		local fiyatCek = guiGridListGetItemText(gridlist, siraCek, 2)
		
		if siraCek == 0 then --isimDegisikligi
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				if oPrevElement then
					exports["irp_opreview"]:destroyObjectPreview(oPrevElement)
				end
			end
			setElementData(getLocalPlayer(), "marketSistemiAcik", 0)
			
			local bakiyeCek = tonumber(getElementData(getLocalPlayer(), "bakiyeMiktar"))
			if bakiyeCek < 10 then
				outputChatBox("[!] #ffffffBu işlem için 10 TL bakiyeniz olması gerekmektedir.", 255, 0, 0, true)
				showCursor(false)
				guiSetInputEnabled(false)
			return false
			end
			triggerEvent("bakiye-sistemi:isimDegistirmePaneli", getLocalPlayer())
		return false
		elseif siraCek == 1 then --VIP 1
			triggerEvent("bakiye-sistemi:vipSatinAlma", getLocalPlayer(), 1)
		return false
		elseif siraCek == 2 then --VIP 2
			triggerEvent("bakiye-sistemi:vipSatinAlma", getLocalPlayer(), 2)
		return false
		elseif siraCek == 3 then --VIP 3
			triggerEvent("bakiye-sistemi:vipSatinAlma", getLocalPlayer(), 3)
		return false
		elseif siraCek == 4 then -- Karakter Limit Arttırma
			local bakiyeCek = tonumber(getElementData(getLocalPlayer(), "bakiyeMiktar"))
			if bakiyeCek < 5 then
				outputChatBox("[!] #ffffffBu işlemi yapabilmek için 5 TL bakiyeniz olmalıdır.", 255, 0, 0, true)
			return false
			end
			
			local karakterLimit = getElementData(getLocalPlayer(), "karakterlimit")
			setElementData(getLocalPlayer(), "karakterlimit", karakterLimit + 1)
			setElementData(getLocalPlayer(), "bakiyeMiktar", bakiyeCek - 5)
			outputChatBox("[!] #ffffffTebrikler, başarıyla 5 TL karşılığı Karakter Limiti arttırma satın aldınız.", 0, 255, 0, true)
			triggerServerEvent("bakiye-sistemi:karakterSlotLOG", getLocalPlayer(), 5)
			return false
		elseif siraCek == 5 then --Kullanıcı Adı Değişikliği
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				exports["irp_opreview"]:destroyObjectPreview(oPrevElement)
			end
			setElementData(getLocalPlayer(), "marketSistemiAcik", 0)
			
			local bakiyeCek = tonumber(getElementData(getLocalPlayer(), "bakiyeMiktar"))
			if bakiyeCek < 10 then
				outputChatBox("[!] #ffffffBu işlem için 10 TL bakiyeniz olması gerekmektedir.", 255, 0, 0, true)
				showCursor(false)
				guiSetInputEnabled(false)
			return false
			end
			--triggerEvent("donators:showUsernameChange", getLocalPlayer(), 16)
			triggerEvent("bakiye-sistemi:kisimDegistirmePaneli", getLocalPlayer())

			return
		end


	elseif source == onaylaButonu3 then
		--pet satın alma.
		--pet'in idsini çekme
		local selectedPetID = guiGridListGetSelectedItem(gridlist3)
		if selectedPetID == -1 then
			outputChatBox("[!] #ffffffAlacak bir evcil hayvan seçmediniz.", 255, 0, 0, true)
			return
		end

		selectedPetID = selectedPetID + 1 -- tabloya eşitleme.

		petTable = petListesi[selectedPetID]-- petTable[1] = pet'in idsi, petTable[2] = pet'adı önemsiz, petTable[3] = fiyatı yanii 30

	    bakiyeCek = tonumber(getElementData(getLocalPlayer(), "bakiyeMiktar"))
		if bakiyeCek < petTable[3] then
			outputChatBox("[!] #ffffffBu işlem için "..petTable[3].." TL bakiyeniz olması gerekmektedir.", 255, 0, 0, true)
			return false
		end

		triggerServerEvent("bakiye-sistemi:petSatinAl", localPlayer, localPlayer, selectedPetID)

	------------------ ISIM DEGISTIRME PANEL ------------------
	elseif source == isimDegistirmeKapatBUTON then
		destroyElement(isimDegistirmeWINDOW)
		showCursor(false)
		guiSetInputEnabled(false)
	elseif source == kisimDegistirmeOnaylaBUTON then
		local editBOX = tostring(guiGetText(isimDegistirmeEditBOX))
		if editBOX == "" then
			outputChatBox("[!] #ffffffLütfen bir kullanıcı adı girin.", 255, 0, 0, true)
		return
		end
		if guiCheckBoxGetSelected(isimDegistirmeCheckBOX) then
			triggerServerEvent( "bakiye.kisimDegistirOnayla", localPlayer, editBOX )
			destroyElement(isimDegistirmeWINDOW)
			guiSetInputEnabled(false)
			showCursor(false)
		else
			outputChatBox("[!] #ffffffKutucuğu işaretlemeniz gerekmektedir.", 255, 0, 0, true)
		end
	elseif source == isimDegistirmeOnaylaBUTON then
		local editBOX = tostring(guiGetText(isimDegistirmeEditBOX))
		if editBOX == "" then
			outputChatBox("[!] #ffffffKarakter Ad ve Soyad giriniz.", 255, 0, 0, true)
		return
		end


		
		--local bakiyeCek = tonumber(getElementData(getLocalPlayer(), "bakiyeMiktar"))
		--if bakiyeCek <= 10 then
		--	outputChatBox("[!] #ffffffBu işlem için 10 TL bakiyeniz olması gerekmektedir.", 255, 0, 0, true)
		--	return
		--end
		local secim1 = guiComboBoxGetSelected(isimDegistirmeComboBOX1)
		local text1 = guiComboBoxGetItemText(isimDegistirmeComboBOX1, secim1)
		
		if text1 == "Cinsiyet Seçin" then
			outputChatBox("[!] #ffffffLütfen Cinsiyet seçimi yapınız.", 255, 0, 0, true)
		return
		end
		
		local secim2 = guiComboBoxGetSelected(isimDegistirmeComboBOX2)
		local text2 = guiComboBoxGetItemText(isimDegistirmeComboBOX2, secim2)
		
		if text2 == "Irk Seçin" then
			outputChatBox("[!] #ffffffLütfen Irk seçimi yapınız.", 255, 0, 0, true)
		return
		end
		
		if guiCheckBoxGetSelected(isimDegistirmeCheckBOX) then
			if text1 == "Erkek" then
				setElementData(localPlayer, "gender", 0)
			elseif text1 == "Bayan" then
				setElementData(localPlayer, "gender", 1)
			end
			
			if text2 == "Siyahi" then
				setElementData(localPlayer, "race", 0)
			elseif text2 == "Beyaz" then
				setElementData(localPlayer, "race", 1)
			elseif text2 == "Asyalı" then
				setElementData(localPlayer, "race", 2)
			end
			
			triggerServerEvent( "bakiye.isimDegistirOnayla", localPlayer, editBOX )
			destroyElement(isimDegistirmeWINDOW)
			guiSetInputEnabled(false)
		else
			outputChatBox("[!] #ffffffKutucuğu işaretlemeniz gerekmektedir.", 255, 0, 0, true)
		end
	------------------ VIP ALMA PANEL ------------------
	elseif source == vipSatinAlmaKapatBUTON then
		setElementData(getLocalPlayer(), "vipSatinAlmaPanel", 0)
		destroyElement(vipSatinAlmaWINDOW)
		showCursor(false)
		guiSetInputEnabled(false)
	elseif source == vipSatinAlmaOnaylaBUTON then
		--triggerServerEvent("bakiye-sistemi:vip", localPlayer, vipSeviye, vipGun)
		local gunSayisi = math.floor(tonumber(guiGetText(vipSatinAlmaEditBOX)))
				if not gunSayisi or gunSayisi < 0 then
					guiSetText(vipSatinAlmaEditBOX,"")
					gunSayisi = 0
				end
		if VIPNUMARA == 1 then
			if gunSayisi ~= nil then
				vipFiyat = 20 / 30 * gunSayisi
			end
		elseif VIPNUMARA == 2 then
			if gunSayisi ~= nil then
				vipFiyat = 40 / 30 * gunSayisi
			end
		elseif VIPNUMARA == 3 then
			if gunSayisi ~= nil then
				vipFiyat = 60 / 30 * gunSayisi
			end
		end
		if VIPNUMARA >= 1 and VIPNUMARA <= 3 then
			local bakiyeCek = tonumber(getElementData(getLocalPlayer(), "bakiyeMiktar"))
			if bakiyeCek < math.ceil(vipFiyat) then
				outputChatBox("[!] #ffffffBu işlem için "..math.ceil(vipFiyat).." TL bakiyeniz olması gerekmektedir.", 255, 0, 0, true)
				showCursor(false)
				guiSetInputEnabled(false)
				destroyElement(vipSatinAlmaWINDOW)
				setElementData(getLocalPlayer(), "vipSatinAlmaPanel", 0)
			return false
			end
			if gunSayisi == 0 then
				outputChatBox("[!] #ffffffGün sayısı 0 olamaz.", 255, 0, 0, true)
			return
			end
			
			if gunSayisi < 3 then
				outputChatBox("[!] #ffffffGün sayısı 3'ten küçük olamaz.", 255, 0, 0, true)
			return
			end
			setElementData(getLocalPlayer(), "bakiyeMiktar", bakiyeCek - math.ceil(vipFiyat))
			setElementData(getLocalPlayer(), "vipSatinAlmaPanel", 0)
			triggerServerEvent("bakiye-sistemi:vip", localPlayer, VIPNUMARA, gunSayisi, math.ceil(vipFiyat))
			outputChatBox("[!] #ffffffTebrikler, "..math.ceil(vipFiyat).." TL karşılığında "..gunSayisi.." günlük VIP ["..VIPNUMARA.."] satın aldınız.", 0, 255, 0, true)
			showCursor(false)
			guiSetInputEnabled(false)
			destroyElement(vipSatinAlmaWINDOW)
		end
	end
	-----------------------------------------------------
end)

function isimnextStage(stage)
	if stage == 1 then
		if isElement(isimDegistirmeWINDOW) then
			destroyElement(isimDegistirmeWINDOW)
		end
		triggerEvent("ulkePaneliniAc", getLocalPlayer())
		showCursor(false)
	end
end
addEvent("bakiye.isimDegistirmeAsama",true)
addEventHandler("bakiye.isimDegistirmeAsama",root,isimnextStage)