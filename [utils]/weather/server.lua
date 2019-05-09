
Weather = {
	url = "https://servis.mgm.gov.tr/api/sondurumlar?merkezid=93401",
	weathers = {
		['A'] = {desc='Açık',weatherID=1,temp=20,message="Hava bugün açık gözüküyor."}, 
		['AB'] = {desc='Az Bulutlu',weatherID=0,temp=0,message="Hava bugün az bulutlu gözüküyor."}, 
		['DMN'] = {desc='Duman',weatherID=9,temp=0,message="Hava bugün sisli gözüküyor."}, 
		['HY'] = {desc='Hafif Yağmurlu',weatherID=8,temp=0,message="Hava bugün hafif yağmurlu gözüküyor, şemsiyenizi alın."}, 
		['HSY'] = {desc='Hafif Sağanak Yağışlı',weatherID=8,temp=0,message="Hava bugün hafif sağanak yağışlı gözüküyor, şemsiyenizi alın."}, 
		['HKY'] = {desc='Hafif Kar Yağışlı',weatherID=8,temp=0,message="Hava bugün hafif kar yağışlı gözüküyor, sıkı giyinin."},
		['MSY'] = {desc='Yer Yer Sağanak Yağışlı',weatherID=8,temp=0,message="Hava bugün yer yer sağanak yağışlı gözüküyor, şemsiyenizi alın."}, 
		['KKY'] = {desc='Karla Karışık Yağmurlu',weatherID=8,temp=0,message="Hava bugün karla karışık yağmurlu gözüküyor, şemsiyenizi alın."},
		['GKR'] = {desc='Güneyli Kuvvetli Rüzgar',weatherID=4,temp=0,message="Santos'da rüzgarlar yükseliyor, sıkı giyinin!"}, 
		['SCK'] = {desc='Sıcak',weatherID=0,temp=0,message="Santos'da havalar ısınıyor, güneş yüzünü şehire gösterecek."}, 
		['PB'] = {desc='Parçalı Bulutlu',weatherID=4,temp=0,message="Gelen bilgilere göre hava parçalı bulutlu gözüküyor."}, 
		['PUS'] = {desc='Pus',weatherID=4,temp=0,message="Santos'da gün boyu pus gözükecek."}, 
		['Y'] = {desc='Yağmurlu',weatherID=8,temp=0,message="Santos'da hava bugünlerde yağmurlu, şemsiyenizi unutmayın."}, 
		['SY'] = {desc='Sağanak Yağışlı',weatherID=8,temp=0,message="Santos'da yağışlar devam ediyor, bugün sağanak yağışlı."}, 
		['K'] = {desc='Kar Yağışlı',weatherID=8,temp=0,message="Santos'a kar geliyor! Kar lastiklerini unutmayın."}, 
		['DY'] = {desc='Dolu',weatherID=8,temp=0,message="Santos'a dolu yağacak, dışarı çıkmanızı önermem."}, 
		['R'] = {desc='Rüzgarlı',weatherID=4,temp=0,message="Santos'da hava kızışıyor, bunun yanında rüzgar da etkisini gösterecek."}, 
		['KKR'] = {desc='Kuzeyli Kuvvetli Rüzgar',weatherID=4,temp=0, message="Santos'da Kuvvetli rüzgar etkisini gösterecek."}, 
		['SGK'] = {desc='Soğuk',weatherID=4,temp=0,message="Santos'da havalar soğuyor, sıkı giyinin."}, 
		['CB'] = {desc='Çok Bulutlu',weatherID=4,temp=0,message="Görünüşe göre Santos'da bugün üstümüzde kapalı bir örtü gibi birçok bulut görüceğiz."}, 
		['SIS'] = {desc='Sis',weatherID=9,temp=0,message="Santos'da hava sisli gibi duruyor, farlarınızı ve gözlerinizi açık tutun!"}, 
		['KY'] = {desc='Kuvvetli Yağmurlu',weatherID=8,temp=0,message="Santos'da hava bugünlerde yağmurlu, şemsiyenizi unutmayın."}, 
		['KSY'] = {desc='Kuvvetli Sağanak Yağışlı',weatherID=8,temp=0,message="Santos'da hava bugünlerde yağmurlu, şemsiyenizi unutmayın."}, 
		['YKY'] = {desc='Yoğun Kar Yağışlı',weatherID=8,temp=0,message="Santos'da hava bugünlerde yağmurlu, şemsiyenizi unutmayın."},
		['GSY'] = {desc='Gökgürültülü Sağanak Yağışlı',weatherID=8,temp=0,message="Santos'da hava bugünlerde yağmurlu, şemsiyenizi unutmayın."}, 
		['KF'] = {desc='Toz veya Kum Fırtınası',weatherID=19,temp=0,message="Santos'a Arizonadan gelen bir kum fırtınası var, dışarıya çıkmanızı pek önermiyoruz."}, 
		['KGY'] = {desc='Kuvvetli Gökgürültülü Sağanak Yağışlı',weatherID=8,temp=0,message="Santos'da hava bugünlerde yağmurlu, şemsiyenizi unutmayın."},  
	},

	update = function(self)
		instance = Weather;
		local realtime = getRealTime().hour
		setTime(realtime, 0)
		Timer(instance.update,1000*60,1)
	end,

	get = function(self)
		instance = Weather;

		options = {
			method = 'GET',
		};
		
		fetchRemote(instance.url,options,function(data,http)
			if http.success ~= true then outputDebugString("[HAVADURUMU-APİ] Hata Kodu: "..tostring(http.statusCode),0,255,255,255) end

			instance.data = decode(data);
			
			if #instance.data > 0 then 

				weather_code = instance.data[1]['hadiseKodu']
				setWeather(instance.weathers[weather_code]['weatherID'])
			
				outputChatBox("[BBC News] Flora Murphy : ** BBC News Hava Durumu Açılış Jeneriği **", root, 200, 100, 200)
	
				Timer(
					function()
						outputChatBox("[BBC News] Flora Murphy : Merhabalar Santos Halkı, ben sunucunuz Flora_Murphy.", root, 200, 100, 200)
						Timer(	
							function()
								outputChatBox("[BBC News] Flora Murphy : ".. (instance.weathers[weather_code]['message'] or "N/A"), root, 200, 100, 200)
								Timer(
									function()
										outputChatBox("[BBC News] Flora Murphy : ** BBC News Hava Durumu Kapanış Jeneriği **", root, 200, 100, 200)
									end,
								2500, 1)
							end,
						4500, 1)
					end,
				2500, 1)


				Timer(instance.get,1000*60*60,1)
			end
			
		end)
	end,
}
instance = new(Weather)
instance:get()
instance:update()