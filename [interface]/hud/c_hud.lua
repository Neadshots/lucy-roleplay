local sx, sy = guiGetScreenSize()
local colors = {
	[1] = {207,170,81},
	[2] = {58,175,223},
	[3] = {200,200,200},
}
local color_mta = {
    [1] = {231, 76, 60},
    [2] = {230, 126, 34},
    [3] = {52, 152, 219},
    [4] = {68, 189, 50},
}
local icons = {
	[1] = "hunger", [2] = "thirst", [3] = "level",
}

SAMP = {
    screen = Vector2(guiGetScreenSize()),
    extraY = -1,
    moneyY = 0,
    opened_1 = false,
	opened_2 = false,
    opened_3 = false,
    
    _rectangle = function(x, y, rx, ry, color, radius)
	    rx = rx - radius * 2
	    ry = ry - radius * 2
	    x = x + radius
	    y = y + radius

	    if (rx >= 0) and (ry >= 0) then
	        dxDrawRectangle(x, y, rx, ry, color)
	        dxDrawRectangle(x, y - radius, rx, radius, color)
	        dxDrawRectangle(x, y + ry, rx, radius, color)
	        dxDrawRectangle(x - radius, y, radius, ry, color)
	        dxDrawRectangle(x + rx, y, radius, ry, color)

	        dxDrawCircle(x, y, radius, 180, 270, color, color, 7)
	        dxDrawCircle(x + rx, y, radius, 270, 360, color, color, 7)
	        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 7)
	        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 7)
	    end
	end,

    dxDrawShadowText = function(self,text, x1, y1, x2, y2, color, scale, font, alignX, alignY)

        dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
        dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
        dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
        dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
 
        dxDrawText(text, x1 - 2, y1, x2 - 2, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
        dxDrawText(text, x1 + 2, y1, x2 + 2, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
        dxDrawText(text, x1, y1 - 2, x2, y2 - 2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
        dxDrawText(text, x1, y1 + 2, x2, y2 + 2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)

        dxDrawText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY)
    end,

    _speed = function()
		
		if isPedInVehicle(localPlayer) then
			local vx, vy, vz = getElementVelocity(getPedOccupiedVehicle(localPlayer))

		return math.sqrt(vx^2 + vy^2 + vz^2) * 161
		end

	return 0
	end,

    drawhealth = function(instance)
    SAMP = instance

        local health = localPlayer:getHealth()
        local max_health = localPlayer:getStat(24)
        local max_health = (((max_health-569)/(1000-569))*100)+100
        local health_stat = health/max_health
        
        local r1,g1,b1, r2,g2,b2, a
        if (health_stat > 0.25) then
            r1,g1,b1 = 180,25,29
            r2,g2,b2 = 90,12,14
            a = 200
        else
            r1,g1,b1 = 180,25,29
            r2,g2,b2 = 90,12,14
            
            local aT = getTimerDetails(healthTimer)
            if (aT > 500) then
                a = (aT-500)/500*200
            else
                a = (500-aT)/500*200
            end
        end
        
        local dX,dY,dW,dH = instance.screen.x - 150,0 + 55,150,15
        local dX,dY,dW,dH = instance.screen.x - 150 - instance.zone.x, dY + instance.zone.y + 55, dW, dH
        dxDrawRectangle( dX + 10 - 110,dY + instance.extraY,dW - 10,dH, tocolor(0,0,0,255) )

        local dX,dY,dW,dH = instance.screen.x - 147,3 + 55,144,9
        local dX,dY,dW,dH = instance.screen.x - 147 - instance.zone.x, dY + instance.zone.y + 55, dW, dH
        dxDrawRectangle( dX + 10 - 110, dY + instance.extraY,dW - 10, dH, tocolor(r2,g2,b2,255) )
        dxDrawRectangle( dX + 10 - 110 + dW - (health_stat * dW),dY + instance.extraY, health_stat * dW - 10, dH, tocolor(231, 76, 60,a) )

    end,

    drawmoney = function(instance)
        
        local cash = localPlayer:getData('money')
        cash = "$"..cash
            
        local dX,dY,dW,dH = instance.screen.x - 6, 35 + instance.moneyY,instance.screen.x - 6, 30
        local dX,dY,dW,dH = dX - instance.zone.x, dY + instance.zone.y, dW - instance.zone.x, dH + instance.zone.y
        
        instance:dxDrawShadowText(cash, dX + 6 - 111,dY,dW + 6 - 111,dH, tocolor(54,104,44,255), 1.35, "pricedown", "right")
    end,

    drawhunger = function(self)
        local thirst = localPlayer:getData('hunger')
        
            
        local dX,dY,dW,dH = self.screen.x - 38, self.screen.y - 115,self.screen.x - 38, self.screen.y - 115
        local dX,dY,dW,dH = dX - self.zone.x, dY + self.zone.y, dW - self.zone.x, dH + self.zone.y
        
        self:dxDrawShadowText(math.floor(thirst)..'%', dX ,dY,dW ,dH, tocolor(240,204,90,255), 1, "pricedown", "right")
    end,

    drawthirst = function(self)
        local thirst = localPlayer:getData('thirst')
        
            
        local dX,dY,dW,dH = self.screen.x - 38, self.screen.y - 72,self.screen.x - 38, self.screen.y - 72
        local dX,dY,dW,dH = dX - self.zone.x, dY + self.zone.y, dW - self.zone.x, dH + self.zone.y
        
        instance:dxDrawShadowText(math.floor(thirst)..'%', dX ,dY,dW ,dH, tocolor(248,88,125,255), 1, "pricedown", "right")

        local img = "images/samp/thirst.png"
        local dX,dY,dW,dH = self.screen.x - 30, self.screen.y - 83 - 45,45,90
        local dX,dY,dW,dH = dX-self.zone.x, dY+self.zone.y, dW, dH
        dxDrawImage(dX, dY, dW, dH, img,0,0,0,tocolor(245,245,245,240))
    end,

    drawsamp = function()
    SAMP = instance 

        local weapon = localPlayer:getWeapon()
        local clip = localPlayer:getAmmoInClip()
        local ammo = localPlayer:getTotalAmmo()

        if weapon == 1 or weapon == 0 then
            instance.moneyY = 20
            instance.extraY = -15
        else 
            instance.moneyY = 35
            instance.extraY = -1
        end
            
        local len = #tostring(clip)
        if string.find(tostring(clip), 1) then len = len - 0.5 end
        local xoff = (len*17)
        
        local len2 = #tostring(ammo-clip)
        if string.find(tostring(ammo-clip), 1) then len2 = len2 - 0.5 end
        local weapLen = ((len+len2)*17) + 20
        
        if (weapon >= 15 and weapon ~= 40 and weapon <= 44 or weapon >= 46) then
           
            local dX,dY,dW,dH = instance.screen.x-6,35,instance.screen.x-6,30
            local dX,dY,dW,dH = dX-instance.zone.x, dY+instance.zone.y, dW-instance.zone.x, dH+instance.zone.y
            instance:dxDrawShadowText(clip, dX - 105,dY + 10,dW - 105,dH + 10, tocolor(110,110,110,255), 1, "pricedown", "right")
         
            local dX,dY,dW,dH = instance.screen.x-6-xoff,35,instance.screen.x-6-xoff,30
            local dX,dY,dW,dH = dX-instance.zone.x, dY+instance.zone.y, dW-instance.zone.x, dH+instance.zone.y
            instance:dxDrawShadowText(ammo-clip, dX - 105,dY + 10,dW - 105,dH + 10, tocolor(220,220,220,255), 1, "pricedown", "right")
        else
            xoff = 0
            weapLen = 0
        end
    
        local img = "components/weapon/"..weapon..".png"
        local dX,dY,dW,dH = instance.screen.x - 95,35,100,100
        local dX,dY,dW,dH = dX-instance.zone.x, dY+instance.zone.y, dW, dH
        dxDrawImage(dX, dY, dW, dH, img)	

        instance:drawmoney()
        instance:drawhealth()
        if not localPlayer:getData('f10') then
            instance:drawthirst()
            instance:drawhunger()
        return end
    end,

    drawhud = function()
    SAMP = instance
    	local x, y = sx*0.715,sy*0.022
    	local w, h = sx*0.0567,sy*0.022
    	for i=1, 3 do

    		dxDrawRectangle(x+((w+5)*i), y, w, h, tocolor(0, 0, 0, 200))


    		dxDrawRectangle(x+((w+5)*i)+3, y+3, w-6, h-6, tocolor(colors[i][1], colors[i][2], colors[i][3], 80))
    		if (i == 1) then data = localPlayer:getData('hunger') or 100 elseif (i == 2) then data = localPlayer:getData('thirst') or 100 elseif (i == 3) then data = 1 end
    		dxDrawRectangle(x+((w+5)*i)+3, y+3, (w-6)*data/100, h-6, tocolor(colors[i][1], colors[i][2], colors[i][3], 160))
    		dxDrawImage(x+((w+5)*i)-5, y, 16, 16, "images/"..icons[i]..".png")
    	end
    	local vehicle = localPlayer.vehicle
    	local x, y = sx*0.770, sy*0.35
    	if vehicle then
    		instance:dxDrawShadowText("Hız: "..math.floor(instance:_speed()).." km/h\nYakıt: "..vehicle:getData("fuel").." lt", x, y, w, h, tocolor(58,115,43), 1, "pricedown", "left", "top")
    	end
    end,
    
    drawmta = function()
    SAMP = instance;
        for i=1, 4 do
            SAMP._rectangle(sx-198, (i*22), 195, 15, tocolor(220, 220, 220, 70), 7)
            if i == 1 then data = localPlayer.health elseif i == 2 then data = localPlayer.armor elseif i == 3 then data = localPlayer:getData('hunger') elseif i == 4 then data = localPlayer:getData('thirst') end
            SAMP._rectangle(sx-198, (i*22), 195*data/100, 15, tocolor(color_mta[i][1], color_mta[i][2], color_mta[i][3], 170), 7)
        end
    end,

    create = function(self,id)
        if (id == 1) then
            if not self.opened_1 then 
                addEventHandler("onClientRender", root, self.drawmta,true,"low-10")

                self.opened_1 = true
            end
        elseif (id == 2) then
			if not self.opened_2 then 
				addEventHandler("onClientRender", root, self.drawsamp,true,"low-10")

				self.opened_2 = true
			end
		elseif (id == 3) then
			if not self.opened_3 then
				addEventHandler("onClientRender", root, self.drawhud,true,"low-10")

				self.opened_3 = true
			end
		end
    end,

    destroy = function(self)
        if self.opened_1 then
            removeEventHandler("onClientRender", root, self.drawmta,true,"low-10")

            self.opened_1 = false
        elseif self.opened_2 then
			removeEventHandler("onClientRender", root, self.drawsamp,true,"low-10")
			
			self.opened_2 = false
		elseif self.opened_3 then
			removeEventHandler("onClientRender", root, self.drawhud,true,"low-10")

			self.opened_3 = false
		end
    end,

    index = function(self)
        self.zone = Vector2(self.screen.x * 0.03, self.screen.y * 0.01)

    end,

}
instance = new(SAMP)
instance:index()



local saveJSON = {}
saveJSON["mode"] = 1
--// Default: MTA (1), Custom: SAMP-1 (2), SAMP-2 (2) 
function jsonGET(file)
    local fileHandle
    local jsonDATA = {}
    if not fileExists(file) then
        fileHandle = fileCreate(file)
        fileWrite(fileHandle, toJSON({["mode"] = 1}))
        fileClose(fileHandle)
        fileHandle = fileOpen(file)
    else
        fileHandle = fileOpen(file)
    end
    if fileHandle then
        local buffer
        local allBuffer = ""
        while not fileIsEOF(fileHandle) do
            buffer = fileRead(fileHandle, 500)
            allBuffer = allBuffer..buffer
        end
        jsonDATA = fromJSON(allBuffer)
        fileClose(fileHandle)
    end
    return jsonDATA
end
 
function jsonSAVE(file, data)
    if fileExists(file) then
        fileDelete(file)
    end
    local fileHandle = fileCreate(file)
    fileWrite(fileHandle, toJSON(data))
    fileFlush(fileHandle)
    fileClose(fileHandle)
    return true
end

addEventHandler("onClientResourceStart", resourceRoot,
    function()
        local data = jsonGET("@variable.json")
        saveJSON = data
        --triggerEvent('hud:changeInterface', localPlayer, saveJSON['mode'])
    end
)

function load()
    if tonumber(saveJSON['mode']) == 1 then 
        local mode = 1
		saveJSON['mode'] = mode
		outputChatBox(exports.pool:getServerSyntax(false, "s").."Arayüz modu başarıyla seçildi. ("..mode..")", 255, 255, 255, true)
        triggerEvent('hud:changeInterface', localPlayer, mode)
        
    elseif tonumber(saveJSON['mode']) == 2 then 
        local mode = 2
        saveJSON['mode'] = mode
		outputChatBox(exports.pool:getServerSyntax(false, "s").."Arayüz modu başarıyla seçildi. ("..mode..")", 255, 255, 255, true)
        triggerEvent('hud:changeInterface', localPlayer, mode)
        
    elseif tonumber(saveJSON['mode']) == 3 then 
        local mode = 3
        saveJSON['mode'] = mode
		outputChatBox(exports.pool:getServerSyntax(false, "s").."Arayüz modu başarıyla seçildi. ("..mode..")", 255, 255, 255, true)
		triggerEvent('hud:changeInterface', localPlayer, mode)
    
    end
end
addEvent('hud:load',true)
addEventHandler('hud:load',root,load)

addCommandHandler("samp",
	function(cmd, mode)
		if localPlayer:getData("loggedin") == 1 then
			if mode and (tonumber(mode) >= 2 and tonumber(mode) <= 3) then
				saveJSON['mode'] = mode
				outputChatBox(exports.pool:getServerSyntax(false, "s").."Arayüz modu başarıyla seçildi. ("..mode..")", 255, 255, 255, true)
				triggerEvent('hud:changeInterface', localPlayer, mode)
			else
				outputChatBox(exports.pool:getServerSyntax(false, "s").."Aktif SAMP Arayüz Modları: /samp 2, /samp 3", 255, 255, 255, true)
			end
		end
	end
)

addCommandHandler("mta",
	function(cmd)
		if localPlayer:getData("loggedin") == 1 then
			local mode = 1
			saveJSON['mode'] = mode
			outputChatBox(exports.pool:getServerSyntax(false, "s").."Arayüz modu başarıyla seçildi. ("..mode..")", 255, 255, 255, true)
			triggerEvent('hud:changeInterface', localPlayer, mode)
		end
	end
)

addEventHandler("onClientResourceStop", resourceRoot,
    function()
        jsonSAVE("@variables.json", saveJSON)
    end
)

function getPlayerInterfaceMode()
	return saveJSON['mode']
end

function RemoveHEXColorCode( s )
    return s:gsub( '#%x%x%x%x%x%x', '' ) or s
end

function bindSomeHotKey()
	bindKey("z", "down", function()
		if getElementData(localPlayer, "vehicle_hotkey") == "0" then 
			return false
		end
		triggerServerEvent('realism:seatbelt:toggle', localPlayer, localPlayer)
	end) 

	bindKey("x", "down", function() 
		if getElementData(localPlayer, "vehicle_hotkey") == "0" then 
			return false
		end
		triggerServerEvent('vehicle:togWindow', localPlayer)
	end)
end
addEventHandler("onClientResourceStart", resourceRoot, bindSomeHotKey)

function isInSlot(dX, dY, dSZ, dM)
	if isCursorShowing() then
		local cX ,cY = getCursorPosition()
		cX,cY = cX*_x , cY*_y
	    if(cX >= dX and cX <= dX+dSZ and cY >= dY and cY <= dY+dM) then
	        return true, cX, cY
	    else
	        return false
	    end
	end
end

local components = { "weapon", "ammo", "health", "clock", "money", "breath", "armour", "wanted", "radar"}
addEvent('hud:changeInterface', true)
addEventHandler('hud:changeInterface', root, function(data)
	if (tonumber(data) == 1) then
        for i, v in ipairs(components) do
            setPlayerHudComponentVisible(v, false)
        end
        setPlayerHudComponentVisible("radar", true)
        instance:destroy()
        instance:create(1)
	elseif (tonumber(data) == 2) then 
		for i, v in ipairs(components) do
            setPlayerHudComponentVisible(v, false)
        end
        setPlayerHudComponentVisible("radar", true)

		instance:destroy()
		instance:create(2)
	elseif (tonumber(data) == 3) then 
  		for i, v in ipairs(components) do
            setPlayerHudComponentVisible(v, true)
		end
		
		instance:destroy()
		instance:create(3)
	end
end)