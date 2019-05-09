
GTA = {
    screen = Vector2(guiGetScreenSize()),
    extraY = -1,
    moneyY = 0,

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

    drawhealth = function()
    GTA = instance

        if not (tonumber(localPlayer:getData('loggedin')) > 0) then return end
        
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
        dxDrawRectangle( dX + 10 - 110 + dW - (health_stat * dW),dY + instance.extraY, health_stat * dW - 10, dH, tocolor(r1,g1,b1,a) )
    end,

    drawmoney = function()
    GTA = instance

        if not (tonumber(localPlayer:getData('loggedin')) > 0) then return end
        
        local cash = localPlayer:getData('money')
        cash = "$"..cash
        
        local r1,g1,b1
        if (getElementData(localPlayer,'money') >= 0) then
            r1,g1,b1 = 54,104,44
        else
            cash = string.gsub(cash, "%D", "")
            cash = "-$"..cash
            r1,g1,b1 = 180,25,29
        end
            
        local dX,dY,dW,dH = instance.screen.x - 6, 35 + instance.moneyY,instance.screen.x - 6, 30
        local dX,dY,dW,dH = dX - instance.zone.x, dY + instance.zone.y, dW - instance.zone.x, dH + instance.zone.y
        
        instance:dxDrawShadowText(cash, dX + 6 - 111,dY,dW + 6 - 111,dH, tocolor(r1,g1,b1,255), 1.35, "pricedown", "right")
    end,

    draweapon = function()
    GTA = instance
       
        if not (tonumber(localPlayer:getData('loggedin')) > 0) then return end
        
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
    end,

    index = function(self)
        self.zone = Vector2(self.screen.x * 0.03, self.screen.y * 0.01)
        
        local components = {"health", "armour", "breath", "money", "weapon","clock", "ammo", "vehicle_name", "area_name", "wanted"} 
        healthTimer = setTimer(function() end,1000,0)

        for i,v in ipairs(components) do 
            setPlayerHudComponentVisible(v,false)
        end

        addEventHandler("onClientRender", root, self.drawhealth,true,"low-10")
        addEventHandler("onClientRender", root, self.drawmoney,true,"low-10")
        addEventHandler("onClientRender", root, self.draweapon,true,"low-10")
    end,

}
instance = new(GTA)
instance:index()

-- Oxygen
---------->>

function renderOxygenLevel()
	if (isPlayerMapVisible() or not hudEnabled) then return end
	
	local oxygen = getPedOxygenLevel(localPlayer)
	if (oxygen >= 1000) then return end
	local oxygenStat = oxygen/1000
	
	local r1,g1,b1, r2,g2,b2
	r1,g1,b1 = 172,203,241
	r2,g2,b2 = 86,101,120
	
	local dX,dY,dW,dH = sX-222,0 + 55,72,15
	local dX,dY,dW,dH = sX-222-SAFEZONE_X, dY+SAFEZONE_Y, dW, dH
	dxDrawRectangle( dX - 100,dY + extraY + 55,dW,dH, tocolor(0,0,0,200) )
	local dX,dY,dW,dH = sX-219,3 + 55,69,9
	local dX,dY,dW,dH = sX-219-SAFEZONE_X, dY+SAFEZONE_Y, dW, dH
	dxDrawRectangle( dX - 100,dY + extraY + 55,dW,dH, tocolor(r2,g2,b2,200) )
	dxDrawRectangle( dX - 100+dW-(oxygenStat*dW),dY + extraY + 55,oxygenStat*dW,dH, tocolor(r1,g1,b1,200) )
end
addEventHandler("onClientRender", root, renderOxygenLevel)