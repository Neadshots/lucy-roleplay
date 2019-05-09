local damagedWeapons = {
  [4] = true,
  [22] = true,
  [8] = true,
  [9] = true,
  [23] = true,
  [24] = true,
  [25] = true,
  [26] = true,
  [27] = true,
  [28] = true,
  [29] = true,
  [32] = true,
  [30] = true,
  [31] = true,
  [33] = true,
  [34] = true,
  [35] = true,
  [36] = true,
  [37] = true,
  [38] = true,
  [16] = true,
  [39] = true,
}

addEventHandler("onPlayerDamage", root,
  	function(attacker, weapon, body, part)
    -- source: yaralanan kişi
    -- attacker: yaralayan kişi
    	if damagedWeapons[weapon] then
      	-- yaralanma fonksiyonunu tetikle:
      	damageStartPlayer(source);
      end
    end
)

function damageStartPlayer(thePlayer)
  	setElementData(thePlayer, "injury", true)
  	triggerClientEvent (thePlayer, "playerbleeding", thePlayer)
    setTimer ( function()
    setElementData(thePlayer, "bugfix", true)
    end, 50, 1 )
end


function stopthisshit ( thePlayer, commandName )
    setElementData(thePlayer, "injury", false)
    triggerClientEvent (thePlayer, "stopbleeding", thePlayer)
end
addCommandHandler ( "stopthisshit", stopthisshit )

function startthisshit (thePlayer)
    damageStartPlayer(thePlayer);
end
addCommandHandler ( "startthisshit", startthisshit )