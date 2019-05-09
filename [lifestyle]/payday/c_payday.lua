function cPayDay(faction, pay, profit,  donatormoney, tax, incomeTax, vtax, ptax, rent, grossincome, Perc)
	local cPayDaySound = playSound("mission_accomplished.mp3")
	local bankmoney = getElementData(getLocalPlayer(), "bankmoney")
	local moneyonhand = getElementData(getLocalPlayer(), "money")
	local wealthCheck = moneyonhand + bankmoney
	setSoundVolume(cPayDaySound, 0.7)
	local info = {}
	-- output payslip
	--outputChatBox("-------------------------- PAY SLIP --------------------------", 255, 194, 14)
	table.insert(info, {"Payslip"})	
	table.insert(info, {""})
	--table.insert(info, {""})
	-- state earnings/money from faction
	if not (faction) then
		if (pay + tax > 200) then
			--outputChatBox(, 255, 194, 14, true)
			table.insert(info, {"  Devlet Yararları: $" .. exports.global:formatMoney(pay+tax)})	
		end
	else
		if (pay + tax > 250) then
			--outputChatBox(, 255, 194, 14, true)
			table.insert(info, {"  Maaş Ücret: $" .. exports.global:formatMoney(pay+tax)})
		end
	end
	
	-- business profit
	if (profit > 200) then
		--outputChatBox(, 255, 194, 14, true)
		table.insert(info, {"  Business Profit: $" .. exports.global:formatMoney(profit)})
	end
	
	-- bank interest
	-- if (interest > 0) then
		-- outputChatBox(,255, 194, 14, true)
		-- table.insert(info, {"  Bank Interest: $" .. exports.global:formatMoney(interest) .. " (≈" ..("%.2f"):format(Perc) .. "%)"})
	-- end
	
	-- donator money (nonRP)
	if (donatormoney > 50) then
		--outputChatBox(, 255, 194, 14, true)
		table.insert(info, {"  Donator Money: $" .. exports.global:formatMoney(donatormoney)})
	end
	
	-- Above all the + stuff
	-- Now the - stuff below
	
	-- income tax
	if (tax > 20) then
		--outputChatBox(, 255, 194, 14, true)
		table.insert(info, {"  Income Tax of " .. (math.ceil(incomeTax*100)) .. "%: $" .. exports.global:formatMoney(tax)})
	end
	
	if (vtax > 15) then
		--outputChatBox(, 255, 194, 14, true)
		table.insert(info, {"  Vehicle Tax: $" .. exports.global:formatMoney(vtax)})
	end
	
	if (ptax > 5) then
		--outputChatBox(, 255, 194, 14, true )
		table.insert(info, {"  Property Expenses: $" .. exports.global:formatMoney(ptax)})
	end
	
	if (rent > 10) then
		--outputChatBox(, 255, 194, 14, true)
		table.insert(info, {"  Apartment Rent: $" .. exports.global:formatMoney(rent)})
	end
	
	--outputChatBox("------------------------------------------------------------------", 255, 194, 14)
	
	if grossincome == 350 then
		-- outputChatBox(,255, 194, 14, true)
		table.insert(info, {"  Brüt Gelir: $0"})
	elseif (grossincome > 350) then
		-- outputChatBox(,255, 194, 14, true)
		-- outputChatBox(, 255, 194, 14)
		table.insert(info, {"  Brüt Gelir: $" .. exports.global:formatMoney(grossincome)})
		table.insert(info, {"  Açıklama: Banka hesabınıza aktarıldı."})
	else
		-- outputChatBox(, 255, 194, 14, true)
		-- outputChatBox(, 255, 194, 14)
		table.insert(info, {"  Brüt Gelir: $" .. exports.global:formatMoney(grossincome)})
		table.insert(info, {"  Açıklama: Banka hesabınıza aktarıldı."})
	end
	
	
	if (pay + tax == 50) then
		if not (faction) then
			--outputChatBox(, 255, 0, 0)
			table.insert(info, {"  The government could not afford to pay you your state benefits."})
		else
			--outputChatBox(, 255, 0, 0)
			table.insert(info, {"  Your employer could not afford to pay your wages."})
		end
	end
	
	if (rent == -1) then
		--outputChatBox(, 255, 0, 0)
		table.insert(info, {"  You were evicted from your apartment, as you can't pay the rent any longer."})
	end
	
	outputChatBox(exports.pool:getServerSyntax(false, "e").."Saatlik bonusunuzu başarıyla aldınız! ($200)", 255, 255, 255, true)
	if faction then
		outputChatBox(exports.pool:getServerSyntax(false, "e").."İçinde olduğunuz birlikten saatlik $"..(pay+tax).." kazadınız.", 255, 255, 255, true)
	end
	triggerEvent("updateWaves", getLocalPlayer())
end
addEvent("cPayDay", true)
addEventHandler("cPayDay", getRootElement(), cPayDay)