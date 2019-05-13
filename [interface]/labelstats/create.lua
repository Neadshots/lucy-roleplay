-- @class Label Stats Instance
-- @params 
--
-- @desc: usefull tableClass
-- @author: foreigner26
labelClass = {}

function labelClass:startup()
    screen = Vector2(guiGetScreenSize())
        framesPerSecond = 0 
        framesDeltaTime = 0 
        lastRenderTick = false 

            label = GuiLabel(0,0,screen.x,15,'',false) 
                label:setAlpha(0.5)

end
labelClass:startup()
  
addEventHandler("onClientRender", root, 
    function () 
        local currentTick = getTickCount() 
            lastRenderTick = lastRenderTick or currentTick 
            framesDeltaTime = framesDeltaTime + (currentTick - lastRenderTick) 
            lastRenderTick = currentTick 
            framesPerSecond = framesPerSecond + 1 
         
                if framesDeltaTime >= 1000 then 
                    ping = localPlayer:getPing()
                    if ping > 80 then 
                        ping = ping - 20
                    end

                    label:setText(framesPerSecond..'fps |  '..ping..'ms')
                    label:setSize(20 + guiLabelGetTextExtent(label) + 5,14,false)
                    label:setPosition(20 + guiLabelGetTextExtent(label) - 90, screen.y - 15, false)

                        framesDeltaTime = framesDeltaTime - 1000 
                        framesPerSecond = 0 
                end 
    end 
,true,"low-5") 
