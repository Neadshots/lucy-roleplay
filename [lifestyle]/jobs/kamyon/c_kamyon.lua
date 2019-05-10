-- ROTA --
local kamyonMarker = 0
local kamyonCreatedMarkers = {}
local kamyonRota = {
	{ 2227.8173828125, -2626.603515625, 13.87215423584, false },
	{ 2228.2099609375, -2574.4521484375, 13.862887382507, false },
	{ 2227.947265625, -2513.5927734375, 13.821146965027, false },
	{ 2227.9267578125, -2498.142578125, 13.808249473572, false },
	{ 2213.4072265625, -2492.7392578125, 13.862502098083, false },
	{ 2188.935546875, -2492.7861328125, 13.840003013611, false },
	{ 2177.611328125, -2478.609375, 13.83563041687, false },
	{ 2200.0546875, -2381.8193359375, 13.835325241089, false },
	{ 2269.6044921875, -2308.6396484375, 13.835696220398, false },
	{ 2361.115234375, -2217.9375, 13.8354139328, false },
	{ 2547.5634765625, -2173.255859375, 13.688656806946, false },
	{ 2695.3154296875, -2172.9716796875, 11.390135765076, false },
	{ 2782.9267578125, -2156.9833984375, 11.390103340149, false },
	{ 2826.48828125, -2111.107421875, 11.390097618103, false },
	{ 2840.5126953125, -1995.6220703125, 11.398133277893, false },
	{ 2842.5302734375, -1862.287109375, 11.380908966064, false },
	{ 2868.8251953125, -1697.3193359375, 11.34314250946, false },
	{ 2895.0234375, -1609.3671875, 11.335429191589, false },
	{ 2929.2197265625, -1453.41796875, 11.342630386353, false },
	{ 2904.091796875, -1254.5439453125, 11.33490562439, false },
	{ 2891.8212890625, -1026.5078125, 11.335249900818, false },
	{ 2898.8701171875, -693.1083984375, 11.302051544189, false },
	{ 2898.080078125, -593.8720703125, 11.612869262695, false },
	{ 2872.2548828125, -511.2734375, 15.645175933838, false },
	{ 2746.900390625, -364.5205078125, 25.694290161133, false },
	{ 2723.5693359375, -266.6611328125, 28.421558380127, false },
	{ 2773.607421875, -93.84765625, 35.945507049561, false },
	{ 2775.400390625, 24.166015625, 33.936721801758, false },
	{ 2775.966796875, 197.791015625, 20.725999832153, false },
	{ 2745.3564453125, 269.45703125, 20.725360870361, false },
	{ 2640.0009765625, 331.3125, 24.051095962524, false },
	{ 2553.8203125, 313.958984375, 29.179470062256, false },
	{ 2409.5693359375, 331.6142578125, 33.124298095703, false },
	{ 2327.1162109375, 328.185546875, 33.123889923096, false },
	{ 2276.14453125, 347.6796875, 33.157558441162, false },
	{ 2306.310546875, 401.7431640625, 28.928789138794, false },
	{ 2341.689453125, 340.95703125, 26.804410934448, false },
	{ 2341.6357421875, 230.6123046875, 26.796457290649, false },
	{ 2327.8427734375, 215.705078125, 26.704849243164, false },
	{ 2226.611328125, 225.1142578125, 15.073122024536, false },
	{ 2100.306640625, 250.93359375, 20.176828384399, false },
	{ 2062.1357421875, 258.9599609375, 25.580360412598, false },
	{ 2002.4853515625, 347.5068359375, 28.495071411133, false },
	{ 1938.447265625, 355.8720703125, 21.428701400757, false },
	{ 1812.4140625, 382.9140625, 19.249340057373, false },
	{ 1649.6318359375, 384.4306640625, 20.249370574951, false },
	{ 1504.7470703125, 394.91796875, 20.343193054199, false },
	{ 1418.9208984375, 428.328125, 20.351320266724, false },
	{ 1363.6669921875, 455.1611328125, 20.343828201294, false },
	{ 1236.23828125, 520.546875, 20.343229293823, false },
	{ 1090.384765625, 576.2333984375, 20.342985153198, false },
	{ 991.662109375, 426.408203125, 20.345029830933, false },
	{ 857.275390625, 350.51953125, 20.345155715942, false },
	{ 683.6435546875, 316.8408203125, 20.345161437988, false },
	{ 637.1298828125, 312.4208984375, 20.366621017456, false },
	{ 621.236328125, 328.6826171875, 20.017993927002, false },
	{ 568.796875, 408.7255859375, 19.390283584595, false },
	{ 525.1611328125, 473.59765625, 19.390068054199, false },
	{ 477.15234375, 540.5498046875, 19.386281967163, false },
	{ 412.5029296875, 630.380859375, 18.417882919312, false },
	{ 340.5048828125, 725.5263671875, 9.9450168609619, false },
	{ 253.271484375, 916.0400390625, 25.105464935303, false },
	{ 232.2216796875, 963.388671875, 28.569923400879, false },
	{ 252.0986328125, 978.751953125, 28.649328231812, false },
	{ 349.7470703125, 1006.2021484375, 28.918954849243, false },
	{ 480.7783203125, 1038.48828125, 28.894170761108, false },
	{ 625.990234375, 1077.037109375, 28.894599914551, false },
	{ 783.3056640625, 1122.80859375, 28.893003463745, false },
	{ 804.6279296875, 1133.9033203125, 28.886644363403, false },
	{ 841.255859375, 1099.8515625, 28.983255386353, false },
	{ 896.5673828125, 1002.75390625, 12.209259986877, false },
	{ 905.4541015625, 920.533203125, 13.811638832092, false },
	{ 853.64453125, 866.767578125, 13.812039375305, false },
	{ 810.0380859375, 844.63671875, 10.377347946167, false },
	{ 782.6572265625, 855.509765625, 4.6894664764404, false },
	{ 766.2734375, 889.0283203125, -0.79547387361526, false },
	{ 750.5908203125, 910.0234375, -3.7031035423279, false },
	{ 721.2568359375, 961.71484375, -6.9752779006958, false },
	{ 692.23828125, 954.3662109375, -15.049458503723, false },
	{ 713.89453125, 930.0634765625, -18.231986999512, false },
	{ 727.3251953125, 899.9130859375, -23.609415054321, false },
	{ 716.2255859375, 889.8974609375, -26.37865447998, false },
	{ 691.5576171875, 933.3896484375, -29.762359619141, false },
	{ 647.8291015625, 950.01953125, -34.333866119385, false },
	{ 622.7392578125, 916.14453125, -42.168907165527, false },
	{ 572.1728515625, 899.337890625, -42.794734954834, false },
	{ 517.2958984375, 907.8642578125, -38.191390991211, false },
	{ 498.4228515625, 895.9912109375, -31.733312606812, false },
	{ 510.21875, 870.44140625, -36.832530975342, false },
	{ 559.0986328125, 854.9697265625, -42.346324920654, false },
	
	{ 583.943359375, 844.9326171875, -41.977573394775, true },
	
	{ 621.12890625, 859.6123046875, -42.494647979736, false },
	{ 653.02734375, 882.7734375, -41.104187011719, false },
	{ 629.779296875, 933.376953125, -38.081958770752, false }, --1
	{ 651.5498046875, 948.9462890625, -34.407115936279, false },
	{ 713.443359375, 888.390625, -26.700296401978, false },
	{ 726.9384765625, 906.5634765625, -20.980897903442, false },
	{ 714.423828125, 936.7646484375, -18.248836517334, false },
	{ 693.6279296875, 957.27734375, -14.853946685791, false },
	{ 704.068359375, 969.943359375, -9.713173866272, false },
	{ 729.17578125, 944.0673828125, -6.9373092651367, false },
	{ 745.5712890625, 909.255859375, -3.8398873806, false },
	{ 765.8740234375, 884.3251953125, -0.79076439142227, false },
	{ 777.9833984375, 856.27734375, 4.4247364997864, false },
	{ 805.2099609375, 840.89453125, 9.6605195999146, false },
	{ 862.28125, 863.2587890625, 13.812948226929, false },
	{ 914.1591796875, 918.9697265625, 13.81188583374, false },
	{ 900.078125, 1011.0595703125, 12.698281288147, false },
	{ 865.6005859375, 1074.880859375, 25.426054000854, false },
	{ 822.982421875, 1133.8916015625, 29.821617126465, false },
	{ 796.216796875, 1135.330078125, 28.80459022522, false },
	{ 685.1162109375, 1099.9716796875, 28.799158096313, false },
	{ 499.279296875, 1049.841796875, 28.794729232788, false },
	{ 385.5595703125, 1020.9921875, 28.822343826294, false },
	{ 316.779296875, 1004.583984375, 28.799951553345, false },
	{ 237.8740234375, 978.830078125, 28.655641555786, false },
	{ 237.125, 939.0341796875, 27.606266021729, false },
	{ 281.1181640625, 838.974609375, 18.848173141479, false },
	{ 328.52734375, 736.6162109375, 10.638273239136, false },
	{ 411.0517578125, 622.6640625, 18.772296905518, false },
	{ 472.1474609375, 536.7294921875, 19.385931015015, false },
	{ 517.6220703125, 470.419921875, 19.390005111694, false },
	{ 537.966796875, 441.80859375, 19.390129089355, false },
	{ 563.775390625, 405.498046875, 19.389863967896, false },
	{ 616.0107421875, 325.0478515625, 20.058671951294, false },
	{ 637.990234375, 306.06640625, 20.342435836792, false },
	{ 772.2763671875, 323.9912109375, 20.343439102173, false },
	{ 932.53515625, 369.330078125, 20.343330383301, false },
	{ 1016.6865234375, 459.47265625, 20.343227386475, false },
	{ 1035.1181640625, 498.107421875, 20.343452453613, false },
	{ 1081.509765625, 563.375, 20.349077224731, false },
	{ 1153.8623046875, 553.5234375, 20.3483543396, false },
	{ 1299.7421875, 481.787109375, 20.343042373657, false },
	{ 1436.49609375, 414.1650390625, 20.342933654785, false },
	{ 1543.2470703125, 383.287109375, 20.34379196167, false },
	{ 1659.5048828125, 379.65234375, 20.239126205444, false },
	{ 1748.1015625, 384.13671875, 20.075826644897, false },
	{ 1840.263671875, 368.5712890625, 19.577634811401, false },
	{ 1946.169921875, 350.791015625, 21.918029785156, false },
	{ 1999.3935546875, 343.109375, 28.481845855713, false },
	{ 2049.2451171875, 264.5224609375, 25.598598480225, false },
	{ 2108.2109375, 245.5458984375, 18.517356872559, false },
	{ 2211.994140625, 223.2880859375, 15.033179283142, false },
	{ 2283.88671875, 211.76171875, 22.047370910645, false },
	{ 2328.251953125, 211.2822265625, 26.703054428101, false },
	{ 2346.02734375, 267.470703125, 26.796380996704, false },
	{ 2358.107421875, 280.771484375, 26.793109893799, false },
	{ 2445.703125, 298.5166015625, 32.778625488281, false },
	{ 2539.4111328125, 287.68359375, 29.633205413818, false },
	{ 2599.1689453125, 300.1552734375, 34.478828430176, false },
	{ 2682.0322265625, 291.041015625, 40.032238006592, false },
	{ 2752.8427734375, 185.123046875, 22.869791030884, false },
	{ 2756.76171875, 107.318359375, 24.10838508606, false },
	{ 2755.72265625, 38.7509765625, 30.293375015259, false },
	{ 2751.4052734375, -74.8115234375, 35.431346893311, false },
	{ 2721.1630859375, -194.3115234375, 30.990825653076, false },
	{ 2690.32421875, -303.4375, 30.115116119385, false },
	{ 2713.6220703125, -364.302734375, 27.673873901367, false },
	{ 2782.734375, -437.1455078125, 22.431612014771, false },
	{ 2864.517578125, -557.22265625, 13.281168937683, false },
	{ 2871.9931640625, -774.1865234375, 11.301795959473, false },
	{ 2867.9697265625, -968.412109375, 11.335234642029, false },
	{ 2873.7421875, -1223.5869140625, 11.336972236633, false },
	{ 2902.357421875, -1397.3193359375, 11.335964202881, false },
	{ 2881.189453125, -1573.732421875, 11.335538864136, false },
	{ 2839.140625, -1713.8896484375, 11.335551261902, false },
	{ 2823.7861328125, -1815.1484375, 11.335458755493, false },
	{ 2821.26171875, -1875.25390625, 11.439791679382, false },
	{ 2820.8544921875, -2002.01171875, 11.397966384888, false },
	{ 2821.080078125, -2032.630859375, 11.397912025452, false },
	{ 2806.7783203125, -2105.2197265625, 11.391719818115, false },
	{ 2731.751953125, -2152.2060546875, 11.393020629883, false },
	{ 2542.498046875, -2153.0009765625, 13.719185829163, false },
	{ 2406.3359375, -2163.9814453125, 13.834454536438, false },
	{ 2322.392578125, -2227.552734375, 13.835600852966, false },
	{ 2276.1767578125, -2274.474609375, 13.835346221924, false },
	{ 2195.775390625, -2354.9453125, 13.835403442383, false },
	{ 2169.0009765625, -2396.646484375, 13.834330558777, false },
	{ 2157.091796875, -2475.2060546875, 13.834728240967, false },
	{ 2165.71875, -2495.8662109375, 13.836856842041, false }, --2
	{ 2207.7470703125, -2498.1796875, 13.871305465698, false },
	{ 2222.3359375, -2509.990234375, 13.851477622986, false },
	{ 2222.0810546875, -2561.240234375, 13.853457450867, false },
	{ 2222.1904296875, -2633.775390625, 13.860281944275, false },
	{ 2225.44140625, -2671.884765625, 13.999391555786, false },
	{ 2239.3134765625, -2681.443359375, 14.009399414063, true, true }
}

function kamyonBasla(cmd)
	if not getElementData(getLocalPlayer(), "kamyonSoforlugu") then
		local oyuncuArac = getPedOccupiedVehicle(getLocalPlayer())
		local oyuncuAracModel = getElementModel(oyuncuArac)
		local kacakciAracModel = 455
		
		if oyuncuAracModel == kacakciAracModel then
			setElementData(getLocalPlayer(), "kamyonSoforlugu", true)
			updateKamyonRota()
			addEventHandler("onClientMarkerHit", resourceRoot, kamyonRotaMarkerHit)
		end
	else
		outputChatBox("[!] #FFFFFFZaten mesleğe başladınız!", 255, 0, 0, true)
	end
end
addCommandHandler("kamyonbasla", kamyonBasla)

function updateKamyonRota()
	kamyonMarker = kamyonMarker + 1
	for i,v in ipairs(kamyonRota) do
		if i == kamyonMarker then
			if not v[4] == true then
				local rotaMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 0, 0, 255, getLocalPlayer())
				table.insert(kamyonCreatedMarkers, { rotaMarker, false })
			elseif v[4] == true and v[5] == true then 
				local bitMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				table.insert(kamyonCreatedMarkers, { bitMarker, true, true })	
			elseif v[4] == true then
				local malMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				table.insert(kamyonCreatedMarkers, { malMarker, true, false })			
			end
		end
	end
end

function kamyonRotaMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 455 then
				for _, marker in ipairs(kamyonCreatedMarkers) do
					if source == marker[1] and matchingDimension then
						if marker[2] == false then
							destroyElement(source)
							updateKamyonRota()
						elseif marker[2] == true and marker[3] == true then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitVehicle, true)
							setElementFrozen(hitPlayer, true)
							toggleAllControls(false, true, false)
							kamyonMarker = 0
							triggerServerEvent("kamyonparaVer", hitPlayer, hitPlayer)
							outputChatBox("[!] #FFFFFFAracınıza yeni mallar yükleniyor, lütfen bekleyiniz. Eğer devam etmek istemiyorsanız, /kamyonbitir yazınız.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("[!] #FFFFFFAracınıza yeni mallar yüklenmiştir. Gidebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updateKamyonRota()
								end, 5000, 1, hitPlayer, hitVehicle, source
							)	
						elseif marker[2] == true and marker[3] == false then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitPlayer, true)
							setElementFrozen(hitVehicle, true)
							toggleAllControls(false, true, false)
							outputChatBox("[!] #FFFFFFAracınızdaki mallar indiriliyor, lütfen bekleyiniz.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("[!] #FFFFFFAracınızdaki mallar indirilmiştir, geri dönebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updateKamyonRota()
								end, 12000, 1, hitPlayer, hitVehicle, source
							)						
						end
					end
				end
			end
		end
	end
end

function kamyonBitir()
	local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
	local pedVehModel = getElementModel(pedVeh)
	local kamyonSoforlugu = getElementData(getLocalPlayer(), "kamyonSoforlugu")
	if pedVeh then
		if pedVehModel == 455 then
			if kamyonSoforlugu then
				exports.global:fadeToBlack()
				setElementData(getLocalPlayer(), "kamyonSoforlugu", false)
				for i,v in ipairs(kamyonCreatedMarkers) do
					destroyElement(v[1])
				end
				kamyonCreatedMarkers = {}
				kamyonMarker = 0
				triggerServerEvent("kamyonBitir", getLocalPlayer(), getLocalPlayer())
				removeEventHandler("onClientMarkerHit", resourceRoot, kamyonRotaMarkerHit)
				removeEventHandler("onClientVehicleStartEnter", getRootElement(), kamyonAntiYabanci)
				setTimer(function() exports.global:fadeFromBlack() end, 2000, 1)
			end
		end
	end
end
addCommandHandler("kamyonbitir", kamyonBitir)

function kamyonAntiYabanci(thePlayer, seat, door) 
	local vehicleModel = getElementModel(source)
	local vehicleJob = getElementData(source, "job")
	local playerJob = getElementData(thePlayer, "job")
	
	if vehicleModel == 455 and vehicleJob == 11 then
		if thePlayer == getLocalPlayer() and seat ~= 0 then
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			outputChatBox("[!] #FFFFFFMeslek aracına binemezsiniz.", 255, 0, 0, true)
		elseif thePlayer == getLocalPlayer() and playerJob ~= 11 then
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			outputChatBox("[!] #FFFFFFBu araca binmek için Kamyon Şoförlüğü mesleğinde olmanız gerekmektedir.", 255, 0, 0, true)
		cancelEvent()
		end
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), kamyonAntiYabanci)

function kamyonAntiAracTerketme(thePlayer, seat)
	if thePlayer == getLocalPlayer() then
		local theVehicle = source
		if seat == 0 then
			kamyonBitir()
		end
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), kamyonAntiAracTerketme)


function kamyonBlip()
	blip = createBlip(2213.9912109375, -2650.8603515625, 13.54687, 0, 4, 255, 255, 0)  --0 0 1787.1259765625 -1903.591796875 13.394536972046
	exports.hud:sendBottomNotification(localPlayer, "Kamyon Şoförü", "Haritadaki sarı işarete giderek kamyon şoförlüğü mesleğinize başlayabilirsiniz.")
end