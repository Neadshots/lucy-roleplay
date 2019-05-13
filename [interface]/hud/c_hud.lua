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
    font = DxFont('fonts/BentonSansRegural.otf', 8),
    
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
        
        
        local dX,dY,dW,dH = instance.screen.x - 150,0 + 55,150,15
        local dX,dY,dW,dH = instance.screen.x - 150 - instance.zone.x, dY + instance.zone.y + 55, dW, dH
        dxDrawRectangle( dX + 10 - 110,dY + instance.extraY,dW - 10,dH, tocolor(0,0,0,255) )

        local dX,dY,dW,dH = instance.screen.x - 147,3 + 55,144,9
        local dX,dY,dW,dH = instance.screen.x - 147 - instance.zone.x, dY + instance.zone.y + 55, dW, dH
        dxDrawRectangle( dX + 10 - 110, dY + instance.extraY,dW - 10, dH, tocolor(255, 195, 88,150) )
        dxDrawRectangle( dX + 10 - 110 + dW - (health_stat * dW),dY + instance.extraY, health_stat * dW - 10, dH, tocolor(255, 195, 88,200) )

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
    		if (i == 3) then
    			x, y, w, h = x+((w+5)*i)+3, y+3, w-6, h-6
    			dxDrawText(currentExprance(getElementData(localPlayer, "level"),1).."/"..currentExprance(getElementData(localPlayer, "level"),2),x,y,w+x,y+h,tocolor(255,255,255),1,'sans','center','center')
    		end
    	end
        setPlayerMoney((localPlayer:getData('money') or 0))
    	local vehicle = localPlayer.vehicle
    	local x, y = sx*0.770, sy*0.35
    	if vehicle then
    		instance:dxDrawShadowText("Hız: "..math.floor(instance:_speed()).." km/h\nYakıt: "..vehicle:getData("fuel").." lt", x, y, w, h, tocolor(58,115,43), 1, "pricedown", "left", "top")
    	end
    end,
    
    drawmta = function()
    SAMP = instance;
        local x, y, w, h = sx-145, 10, 141, 144
        local clip = localPlayer:getAmmoInClip()
        local ammo = localPlayer:getTotalAmmo()

        dxDrawImage(x, y, w, h, 'components/images/hud_bg.png', 0, 0, 0, tocolor(255, 255, 255, 255))
        
        dxDrawImageSection(x + 22.5, y + 1, 97 * getElementData(localPlayer, "hunger") / 100, 32, 0, 0, 97 * getElementData(localPlayer, "hunger") / 100, 32, 'components/images/hud_stamina.png', 0, 0, 0, tocolor(240,204,90, 255))
        dxDrawImageSection(x + 1, y + 23.7, 32, 97 * getElementHealth(localPlayer) / 100, 0, 0, 32, 97 * getElementHealth(localPlayer) / 100, 'components/images/hud_hp.png', 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawImageSection(x + 23, y + 111, 97 * getElementData(localPlayer, "thirst") / 100, 32, 0, 0, 97 * getElementData(localPlayer, "thirst") / 100, 32, 'components/images/hud_armour.png', 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawText(clip, x + 123, y + 95, _, _, tocolor(255, 255, 255, 255), 1, SAMP.font)
        dxDrawImage(x - 56, y + 50, 170, 79, 'components/images/weapons/weapon'..getPedWeapon(localPlayer)..'.png', 0, 0, 0, tocolor(255, 255, 255, 255))
        dxDrawImage(x + 22, y + 16, 16, 16, 'images/hunger.png')
        dxDrawImage(x + 22, y + 110, 16, 16, 'images/thirst.png')
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
        if localPlayer:getData('loggedin') == 1 then
            triggerEvent('hud:changeInterface', localPlayer, saveJSON['mode'])
        end
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
			--if not mode then mode = 2 end
			if mode and (tonumber(mode) >= 1 and tonumber(mode) <= 2) then
				mode = mode + 1
				saveJSON['mode'] = mode
				outputChatBox(exports.pool:getServerSyntax(false, "s").."Arayüz modu başarıyla seçildi. ("..(mode-1)..")", 255, 255, 255, true)
				triggerEvent('hud:changeInterface', localPlayer, mode)
			else
				outputChatBox(exports.pool:getServerSyntax(false, "s").."Aktif SAMP Arayüz Modları: /samp 1, /samp 2", 255, 255, 255, true)
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

local components = { "weapon", "ammo", "health", "clock", "money", "breath", "armour", "radar"}
addEvent('hud:changeInterface', true)
addEventHandler('hud:changeInterface', root, function(data)
	if (tonumber(data) == 1) then
        for i, v in ipairs(components) do
            setPlayerHudComponentVisible(v, false)
        end
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