--[[
* ***********************************************************************************************************************
* Copyright (c) 2019 Lucy Project - Enes Akıllıok
* All rights reserved. This program and the accompanying materials are private property belongs to Lucy Project
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* https://www.github.com/yourpalenes
* ***********************************************************************************************************************
]]

function showPlayerWithTaser ( attacker, weapon )
    if ( weapon == 23 or (weapon == 23) ) then
        cancelEvent()
        triggerServerEvent("taser->Target",getLocalPlayer(),source)
    end
end
addEventHandler ( "onClientPlayerDamage", getLocalPlayer(), showPlayerWithTaser )