--[[
* ***********************************************************************************************************************
* Copyright (c) 2018 pavlov - All Rights Reserved-- 158 105 312 207
* Written by Erdem Keskin aka pavlov <www.facebook.com/erdemkeskinofficial>
* ***********************************************************************************************************************
]]
 local ped = createPed ( 1, 208.53 , -155.0146484375, 1000.5234375, 180 )
setElementDimension(ped, 48)
setElementInterior(ped, 14)
setElementFrozen(ped, true)
setElementRotation(ped, 0,0,180)
setElementData(ped, "skinmarketnpc", true)

local marker = createMarker (204.564453125, -159.3505859375, 999.8, "cylinder", 1, 255, 255, 0, 0 )
setElementDimension(marker, 48)
setElementInterior(marker, 14)

function MarkerHit ( hitPlayer, matchingDimension )
	addCommandHandler("skinmarket", panel_goster)
end
addEventHandler ( "onClientMarkerHit", marker, MarkerHit )

function MarkerLeave ( leavePlayer, matchingDimension )
	removeCommandHandler("skinmarket", panel_goster)
end
addEventHandler ( "onClientMarkerLeave", marker, MarkerLeave)

kadinerkek = { 1, 2, 7, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 66, 67, 68, 69, 72, 73, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 264, 268, 269, 270, 271, 272, 290, 291, 292, 293, 294, 295, 296, 297, 299, 300, 303, 305, 306, 307, 308, 309, 312 }

erkekler = { 1, 2, 7, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60, 61, 62, 66, 67, 68, 72, 73, 78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 132, 133, 134, 135, 136, 137, 142, 143, 144, 146, 147, 153, 154, 155, 156, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 170, 171, 173, 174, 175, 176, 177, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 200, 202, 203, 204, 209, 210, 212, 213, 217, 220, 221, 222, 223, 227, 228, 220, 230, 234, 235, 236, 239, 240, 241, 242, 247, 248, 249, 250, 252, 253, 254, 255, 258, 259, 260, 261, 262, 264, 268, 269, 270, 271, 272, 290, 291, 292, 293, 294, 295, 296, 297, 299, 300, 303, 305, 306, 307, 308, 309, 312 }

kadinlar =  { 9, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 69, 75, 76, 77, 85, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 139, 140, 141, 145, 148, 150, 151, 152, 157, 169, 172, 178, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 201, 205, 207, 214, 215, 216, 218, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245, 246, 251, 256, 257, 263, }
local pednumara = 1
  --fadeCamera(getLocalPlayer(), true, 5)
	 setPedAnimation(ped, "crack", "bbalbat_idle_02")
	 function degistir_skin(key, keyState)
	 if getElementData(getLocalPlayer(), "skinmarket") == 1 then 
	 if key == "arrow_r" then
	  pednumara = pednumara + 1
	   if getElementData(getLocalPlayer(), "secim") == 3 and pednumara > 77 then
	   pednumara = 77
	 elseif getElementData(getLocalPlayer(), "secim") == 2 and pednumara > 192 then
		 pednumara = 192
	 elseif getElementData(getLocalPlayer(), "secim") == 1 and pednumara > 271 then
		pednumara = 271
	 end
		 if getElementData(getLocalPlayer(), "secim") == 1 then
	  setElementModel ( ped, kadinerkek[pednumara] )
		guiSetText(id, "Skin ID : "..pednumara.."")
	elseif getElementData(getLocalPlayer(), "secim") == 2 then
    setElementModel ( ped, erkekler[pednumara] )
		guiSetText(id, "Skin ID : "..pednumara.."")
	elseif getElementData(getLocalPlayer(), "secim") == 3 then
		  setElementModel ( ped, kadinlar[pednumara] )
			guiSetText(id, "Skin ID : "..pednumara.."")

	  end
	 end
	 if key == "arrow_l" then
	 pednumara = pednumara - 1
	 if pednumara < 1 then
	 pednumara = 1
	 else
		 if getElementData(getLocalPlayer(), "secim") == 1 then
	  setElementModel ( ped, kadinerkek[pednumara] )
		guiSetText(id, "Skin ID : "..pednumara.."")
	elseif getElementData(getLocalPlayer(), "secim") == 2 then
    setElementModel ( ped, erkekler[pednumara] )
		guiSetText(id, "Skin ID : "..pednumara.."")
	elseif getElementData(getLocalPlayer(), "secim") == 3 then
		  setElementModel ( ped, kadinlar[pednumara] )
			guiSetText(id, "Skin ID : "..pednumara.."")
	 end
	 end
	 end
	 end
	 end

	 bindKey ( "arrow_r", "down", degistir_skin)
	 bindKey ( "arrow_l", "down", degistir_skin)

	 function satinal_skin()
	 if getElementData(getLocalPlayer(), "skinmarket") == 1 then 
     guiSetVisible(onaypanel, true)
	 guiSetText(reid, "Satın Almak İstediğin Kıyafet ID : "..pednumara.."")
	 end
	 end
	 bindKey ( "lctrl", "down", satinal_skin)

	 function cikis_skin()
	 if getElementData(getLocalPlayer(), "skinmarket") == 1 then 
   guiSetVisible(cikispanel, true)
   end
	 end
	 bindKey ( "lshift", "down", cikis_skin)



local yazitipi = guiCreateFont("fontlar/font.ttf", 12)
local yazitipi2 = guiCreateFont("fontlar/font.ttf", 10)
local yazitipi3 = guiCreateFont("fontlar/font.ttf", 8)
--[[
hat = guiCreateStaticImage(220,150,700,400,"resimler/bos.png",false,panel)
GUIEditor = {
    button = {},
    window = {},
    label = {}
}
addEventHandler("onClientResourceStart", resourceRoot,
    function()
local screenW, screenH = guiGetScreenSize()
        GUIEditor.window[1] = guiCreateWindow((screenW - 286) / 2, (screenH - 151) / 2, 286, 151, "Eminmisiniz ?", false)
        guiWindowSetSizable(GUIEditor.window[1], false)

        GUIEditor.button[1] = guiCreateButton(18, 102, 118, 37, "Onayla", false, GUIEditor.window[1])
        GUIEditor.button[2] = guiCreateButton(152, 102, 118, 37, "Reddet", false, GUIEditor.window[1])
        GUIEditor.label[1] = guiCreateLabel(45, 27, 199, 26, "Skin Shop ID : 1", false, GUIEditor.window[1])
        GUIEditor.label[2] = guiCreateLabel(45, 63, 199, 26, "Onaylıyormusun ?", false, GUIEditor.window[1])
    end
)--]]
function oklar()
local screenW, screenH = guiGetScreenSize()
--panel = true
 setElementData(getLocalPlayer(), "secim", 1)
 setElementData(getLocalPlayer(), "skinmarket", 1)
 setCameraMatrix ( 208.478515625, -158.3828125, 1000.5234375, 208,  158.3828125, 1000.5234375)
 --setCameraTarget ( -2409.29199, -599.65991, 132.64844, -2409.29199, -599.65991, 132.64844 )
        soldon = guiCreateStaticImage((screenW - 450) / 2, (screenH - 80) / 2, 68, 76, "resimler/soldon.png", false)
        sagdon = guiCreateStaticImage((screenW + 450) / 2, (screenH - 80) / 2, 68, 76, "resimler/sagdon.png", false)
		guiSetAlpha(soldon, 0)
		guiSetAlpha(sagdon, 0)
        solok = guiCreateStaticImage((screenW - 450) / 2, (screenH + 350) / 2, 75, 76, "resimler/solok.png", false)
        sagok = guiCreateStaticImage((screenW + 450) / 2, (screenH + 350) / 2, 68, 76, "resimler/sagok.png", false)
		okbilgi = guiCreateLabel((screenW - 200) / 2, (screenH + 700) / 2, 296, 18, "Sağ ve Sol ok klavye tuşları ile değiştirebilirsiniz.", false)
        okbilgi2 = guiCreateLabel((screenW - 240) / 2, (screenH + 750) / 2, 340, 20, "Dönen oklara mause ile basarak karakteri çevirebilirsiniz.", false)
		okbilgi3 = guiCreateLabel((screenW - 180) / 2, (screenH + 650) / 2, 296, 20, "Sol Ctrl tuşuna basarak satın alabilirsiniz.", false)
		okbilgi4 = guiCreateLabel((screenW - 160) / 2, (screenH + 800) / 2, 296, 20, "Sol Shift tuşuna basarak çıkabilirsiniz.", false)
		guiSetAlpha(okbilgi, 0)
		guiSetAlpha(okbilgi2, 0)
		guiSetAlpha(okbilgi3, 0)
		guiSetAlpha(okbilgi4, 0)
        fiyat = guiCreateLabel((screenW - 40) / 2, (screenH + 650) / 2, 90, 20, "Fiyat : 500$", false)
				id = guiCreateLabel((screenW - 40) / 2, (screenH + 600) / 2, 90, 20, "Skin ID : 1", false)
        guiSetFont (fiyat,yazitipi)
        guiSetFont (okbilgi,yazitipi)
        guiSetFont (okbilgi2,yazitipi)
        guiSetFont (okbilgi3,yazitipi)
		guiSetFont (okbilgi4,yazitipi)
				guiSetFont (id,yazitipi)
		erkek = guiCreateStaticImage((screenW - 300) / 2, (screenH - 700) / 2, 50, 25, "resimler/erkek.png", false)
		erkekbilgi = guiCreateLabel(10, 1.6, 72, 20, "Bay", false, erkek)
		guiSetFont (erkekbilgi,yazitipi2)
		kadin = guiCreateStaticImage((screenW - 10) / 2, (screenH - 700) / 2, 50, 25, "resimler/kadin.png", false)
		kadinbilgi = guiCreateLabel(4, 2, 72, 20, "Bayan", false, kadin)
		guiSetFont (kadinbilgi,yazitipi2)
        hepsi = guiCreateStaticImage((screenW + 300) / 2, (screenH - 700) / 2, 50, 25, "resimler/hepsi.png", false)
		hepsibilgi = guiCreateLabel(5, 1.6, 72, 20, "Karma", false, hepsi)
		guiSetFont (hepsibilgi,yazitipi2)
		
		onaypanel = guiCreateStaticImage((screenW - 220) / 2, (screenH - 151) / 2,286, 151,"resimler/bos.png",false)
	ust_cizgi = guiCreateStaticImage(0, 0, 286, 18, "resimler/bos.png", false, onaypanel)
	ince = guiCreateStaticImage(0, 17, 286, 1, "resimler/bos.png", false, ust_cizgi)
	baslik = guiCreateLabel(0, -3, 199, 26, "                         Venom Roleplay - Market Sistemi", false, ust_cizgi)
	
		onayla = guiCreateStaticImage(18, 102, 118, 37, "resimler/bos.png", false, onaypanel)
		reddet = guiCreateStaticImage(152, 102, 118, 37, "resimler/bos.png", false, onaypanel)
	    reid = guiCreateLabel(5, 21, 295, 95, "Satın Almak İstediğin Kıyafet ID : 1", false, onaypanel)
		onayyazi = guiCreateLabel(5, 63, 199, 26, "Skini satın almak istiyor musun?", false, onaypanel)
		guiSetFont (reid,yazitipi2)
		guiSetFont (onayyazi,yazitipi2)
		onaylayazi = guiCreateLabel(30, 107, 199, 26, "Onaylıyorum", false, onaypanel)
		guiSetFont (onaylayazi,yazitipi2)
		guiSetFont (baslik,yazitipi3)
		reddetyazi = guiCreateLabel(162, 107, 199, 26, "Redediyorum", false, onaypanel)
		guiSetFont (reddetyazi,yazitipi2)
		guiSetProperty(ince, "ImageColours", "tl:BB9b0909 tr:BB9b0909 bl:BB9b0909 br:BB9b0909")
		guiSetProperty(ust_cizgi, "ImageColours", "tl:BB000000 tr:BB000000 bl:BB000000 br:BB000000")
		guiSetProperty(onaypanel, "ImageColours", "tl:BB000000 tr:BB000000 bl:BB000000 br:BB000000")
		guiSetProperty(onayla, "ImageColours", "tl:BB000000 tr:BB000000 bl:BB000000 br:BB000000")
		guiSetProperty(reddet, "ImageColours", "tl:BB000000 tr:BB000000 bl:BB000000 br:BB000000")
	--	guiSetAlpha ( onaypanel, 0.9 )
		guiSetVisible(onaypanel, false)

cikispanel = guiCreateStaticImage((screenW - 220) / 2, (screenH - 151) / 2,286, 151,"resimler/bos.png",false)
		cikis_ust = guiCreateStaticImage(0, 0, 286, 18, "resimler/bos.png", false, cikispanel)
		ince = guiCreateStaticImage(0, 17, 286, 1, "resimler/bos.png", false, cikis_ust)
		baslik = guiCreateLabel(0, -3, 3000, 3000, "                         Venom Roleplay - Market Sistemi", false, cikis_ust)
		cikisonayla = guiCreateStaticImage(18, 102, 118, 37, "resimler/bos.png", false, cikispanel)
		cikisreddet = guiCreateStaticImage(152, 102, 118, 37, "resimler/bos.png", false, cikispanel)
		cikisreid = guiCreateLabel(5, 27, 199, 26, "Çıkmak istiyorsunuz.", false, cikispanel)
		cikisonayyazi = guiCreateLabel(5, 63, 204, 26, "Skini satın almak istiyor musun?", false, cikispanel)
		guiSetFont (cikisreid,yazitipi2)
		guiSetFont (cikisonayyazi,yazitipi2)
		cikisonaylayazi = guiCreateLabel(30, 107, 199, 26, "Onaylıyorum", false, cikispanel)
		guiSetFont (cikisonaylayazi,yazitipi2)
		guiSetFont (baslik,yazitipi3)
		cikisreddetyazi = guiCreateLabel(162, 107, 199, 26, "Redediyorum", false, cikispanel)
		guiSetFont (cikisreddetyazi,yazitipi2)
		guiSetProperty(ince, "ImageColours", "tl:BB9b0909 tr:BB9b0909 bl:BB9b0909 br:BB9b0909")
		guiSetProperty(ust_cizgi, "ImageColours", "tl:BB000000 tr:BB000000 bl:BB000000 br:BB000000")
		guiSetProperty(cikispanel, "ImageColours", "tl:BB000000 tr:BB000000 bl:BB000000 br:BB000000")
		guiSetProperty(cikis_ust, "ImageColours", "tl:BB000000 tr:BB000000 bl:BB000000 br:BB000000")
		guiSetProperty(cikisonayla, "ImageColours", "tl:BB000000 tr:BB000000 bl:BB000000 br:BB000000")
		guiSetProperty(cikisreddet, "ImageColours", "tl:BB000000 tr:BB000000 bl:BB000000 br:BB000000")
		guiSetVisible(cikispanel, false)
		 triggerServerEvent("skinmarketbilgi", getLocalPlayer(), getLocalPlayer())
		showCursor(true)
    end
	
	addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), function()
	local screenW, screenH = guiGetScreenSize()
	
	end)

addEventHandler ("onClientGUIClick",root,
    function()
       if (source == soldon) then
      local rotX, rotY, rotZ = getElementRotation(ped)
      setElementRotation(ped,0,0,rotZ+10,"default",true)
    elseif (source == sagdon) then
      local rotX, rotY, rotZ = getElementRotation(ped)
      setElementRotation(ped,0,0,rotZ-10,"default",true)
      end
    end )

		addEventHandler ("onClientGUIClick",root,
		    function()
		       if (source == onayla) or (source == onaylayazi) then
						 if getElementData(getLocalPlayer(), "secim") == 1 then
						  if exports.global:getMoney(getLocalPlayer()) < 500 then
						  triggerServerEvent("yetersizbakiyeskinmarket", getLocalPlayer(), getLocalPlayer())
						  return end
							 guiSetVisible(onaypanel, false)
							 setElementData(getLocalPlayer(), "skinmarketid", kadinerkek[pednumara])
							 	 setTimer ( function()
		                    setElementData(getLocalPlayer(), "skinmarketid", false)
							guiSetVisible(cikispanel, false)
							guiSetVisible(soldon, false)
							guiSetVisible(sagdon, false)
							guiSetVisible(solok, false)
							guiSetVisible(sagok, false)
							guiSetVisible(okbilgi, false)
							guiSetVisible(okbilgi2, false)
							guiSetVisible(okbilgi3, false)
							guiSetVisible(okbilgi4, false)
							guiSetVisible(id, false)
							guiSetVisible(fiyat, false)
							guiSetVisible(erkek, false)
							guiSetVisible(erkekbilgi, false)
							guiSetVisible(kadin, false)
							guiSetVisible(kadinbilgi, false)
							guiSetVisible(hepsi, false)
							guiSetVisible(hepsibilgi, false)
							setCameraMatrix ( false )
							setCameraTarget ( getLocalPlayer() )
							showCursor(false)
							setElementData(getLocalPlayer(), "skinmarket", 0)
							pednumara = 1
							setElementModel(ped,1)
	                               end, 1000, 1 )
							triggerServerEvent("satinalindiskinmarket", getLocalPlayer(), getLocalPlayer())
					elseif getElementData(getLocalPlayer(), "secim") == 2 then
					 if exports.global:getMoney(getLocalPlayer()) < 500 then
						  triggerServerEvent("yetersizbakiyeskinmarket", getLocalPlayer(), getLocalPlayer())
						  return end
						guiSetVisible(onaypanel, false)
						setElementData(getLocalPlayer(), "skinmarketid", erkekler[pednumara])
							 setTimer ( function()
		                    setElementData(getLocalPlayer(), "skinmarketid", false)
							guiSetVisible(cikispanel, false)
							guiSetVisible(soldon, false)
							guiSetVisible(sagdon, false)
							guiSetVisible(solok, false)
							guiSetVisible(sagok, false)
							guiSetVisible(okbilgi, false)
							guiSetVisible(okbilgi2, false)
							guiSetVisible(okbilgi3, false)
							guiSetVisible(okbilgi4, false)
							guiSetVisible(id, false)
							guiSetVisible(fiyat, false)
							guiSetVisible(erkek, false)
							guiSetVisible(erkekbilgi, false)
							guiSetVisible(kadin, false)
							guiSetVisible(kadinbilgi, false)
							guiSetVisible(hepsi, false)
							guiSetVisible(hepsibilgi, false)
							setCameraMatrix ( false )
							setCameraTarget ( getLocalPlayer() )
							showCursor(false)
							setElementData(getLocalPlayer(), "skinmarket", 0)
							pednumara = 1
							setElementModel(ped,1)
	                               end, 1000, 1 )
						triggerServerEvent("satinalindiskinmarket", getLocalPlayer(), getLocalPlayer())
					elseif getElementData(getLocalPlayer(), "secim") == 3 then
					 if exports.global:getMoney(getLocalPlayer()) < 500 then
						  triggerServerEvent("yetersizbakiyeskinmarket", getLocalPlayer(), getLocalPlayer())
						  return end
						guiSetVisible(onaypanel, false)
						setElementData(getLocalPlayer(), "skinmarketid", kadinlar[pednumara])
							 setTimer ( function()
		                    setElementData(getLocalPlayer(), "skinmarketid", false)
							guiSetVisible(cikispanel, false)
							guiSetVisible(soldon, false)
							guiSetVisible(sagdon, false)
							guiSetVisible(solok, false)
							guiSetVisible(sagok, false)
							guiSetVisible(okbilgi, false)
							guiSetVisible(okbilgi2, false)
							guiSetVisible(okbilgi3, false)
							guiSetVisible(okbilgi4, false)
							guiSetVisible(id, false)
							guiSetVisible(fiyat, false)
							guiSetVisible(erkek, false)
							guiSetVisible(erkekbilgi, false)
							guiSetVisible(kadin, false)
							guiSetVisible(kadinbilgi, false)
							guiSetVisible(hepsi, false)
							guiSetVisible(hepsibilgi, false)
							setCameraMatrix ( false )
							setCameraTarget ( getLocalPlayer() )
							showCursor(false)
							setElementData(getLocalPlayer(), "skinmarket", 0)
							pednumara = 1
							setElementModel(ped,1)
	                               end, 1000, 1 )
								  
                         triggerServerEvent("satinalindiskinmarket", getLocalPlayer(), getLocalPlayer())
						end
		    elseif (source == reddet) or (source == reddetyazi) then
		     guiSetVisible(onaypanel, false)
		      end
		    end )

				addEventHandler ("onClientGUIClick",root,
						function()
							 if (source == cikisonayla) or (source == cikisonaylayazi) then
							guiSetVisible(cikispanel, false)
							guiSetVisible(soldon, false)
							guiSetVisible(sagdon, false)
							guiSetVisible(solok, false)
							guiSetVisible(sagok, false)
							guiSetVisible(okbilgi, false)
							guiSetVisible(okbilgi2, false)
							guiSetVisible(okbilgi3, false)
							guiSetVisible(okbilgi4, false)
							guiSetVisible(id, false)
							guiSetVisible(fiyat, false)
							guiSetVisible(erkek, false)
							guiSetVisible(erkekbilgi, false)
							guiSetVisible(kadin, false)
							guiSetVisible(kadinbilgi, false)
							guiSetVisible(hepsi, false)
							guiSetVisible(hepsibilgi, false)
							setCameraMatrix ( false )
							setCameraTarget ( getLocalPlayer() )
							showCursor(false)
							setElementData(getLocalPlayer(), "skinmarket", 0)
							pednumara = 1
							setElementModel(ped,1)
						elseif (source == cikisreddet) or (source == cikisreddetyazi) then
						 guiSetVisible(cikispanel, false)
							end
						end )


	addEventHandler ("onClientGUIClick",root,
		    function()
		       if (source == erkek) or (source == erkekbilgi) then
		      setElementData(getLocalPlayer(), "secim", 2)
					setElementModel ( ped, erkekler[1] )
					guiSetText(id, "Skin ID : 1")
					pednumara = 1
		    elseif (source == kadin) or (source == kadinbilgi)then
					setElementModel ( ped, kadinlar[1] )
		      setElementData(getLocalPlayer(), "secim", 3)
					guiSetText(id, "Skin ID : 1")
					pednumara = 1
				elseif (source == hepsi) or (source == hepsibilgi)then
					setElementModel ( ped, kadinerkek[1] )
					guiSetText(id, "Skin ID : 1")
					pednumara = 1
					setElementData(getLocalPlayer(), "secim", 1)
		      end
		    end )

function panel_goster ()
getir_goster = guiGetVisible (soldon)
if (getir_goster == false) then
	oklar()
	showCursor (true)

  	end
end

function tikladikarakater ( button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement )
        if ( clickedElement ) then
		 if getElementData(getLocalPlayer(), "skinmarket") == 1 then 
		 if (state=="down") then
		   if getElementData(getLocalPlayer(), "pedceviriyor") == 0 or getElementData(getLocalPlayer(), "pedceviriyor") == false then
                local elementTipi = getElementType ( clickedElement )
				local skinmarketnpc = getElementData( clickedElement, "skinmarketnpc")
				if skinmarketnpc==true then
				if elementTipi=="ped" then
                 setElementData(getLocalPlayer(), "skinmarketbas", 1)
                 setElementData(getLocalPlayer(), "pedceviriyor", 1)				 
             end
			 end
		else
		                local elementTipi = getElementType ( clickedElement )
				local skinmarketnpc = getElementData( clickedElement, "skinmarketnpc")
				if skinmarketnpc==true then
				if elementTipi=="ped" then
                 setElementData(getLocalPlayer(), "skinmarketbas", 0)
                 setElementData(getLocalPlayer(), "pedceviriyor", 0)				 
             end
			 end
		end
		end
		end
		end
end
addEventHandler ( "onClientClick", getRootElement(), tikladikarakater )

addEventHandler( "onClientCursorMove", getRootElement( ),
    function ( _, _, x, y )
	if getElementData(getLocalPlayer(), "skinmarket") == 1 then 
	if getElementData(getLocalPlayer(), "skinmarketbas")==1 then
		local rotX, rotY, rotZ = getElementRotation(ped)
      setElementRotation(ped,0,0,rotZ+5,"default",true)
	  end
		end
    end
)