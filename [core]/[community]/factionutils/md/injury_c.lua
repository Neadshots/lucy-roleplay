function bloodEffect()
	if getElementData(localPlayer, "injury") then
      local x, y, z = getElementPosition( localPlayer )
      local randombloodamount = 10000 
      fxAddBlood ( x, y, z-2, 0.00000, 0.00000, 0.00000, randombloodamount, 1 )
    end
end

function bleeding()
	if not getElementData(localPlayer, "bugfix") then
		if getElementData(localPlayer, "injury") then
		  sound = playSound("md/heart.mp3", true)
		  exports.hud:startBlackWhite()
		  setTimer ( bloodEffect, 50, 0)
		end
 	end
end
addEvent( "playerbleeding", true )
addEventHandler( "playerbleeding", localPlayer, bleeding )

setTimer(
    function()
        if getElementData(localPlayer, "injury") then  -- 20 hp
            local health = getElementHealth(localPlayer)
            setElementHealth(localPlayer, health - 20)
            if health - 20 <= 0 then
            	outputChatBox(" Çok fazla kan kaybettiğin için bayıldın!", 255, 0, 0, true)
            end
        end
    end, 1000*40, 0
)

function stopInjury()
	if not getElementData(localPlayer, "injury") then
		stopSound( sound )
		setElementData(localPlayer, "bugfix", false)
		exports.hud:stopBlackWhite()
	end
end
addEvent( "stopbleeding", true )
addEventHandler( "stopbleeding", localPlayer, stopInjury )