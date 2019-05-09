local state = false
local nowSpeed = false

local allowedTypes = {
    ["Automobile"] = true, 
    ["Bike"] = true, 
    ["Monster Truck"] = true,
    ["Quad"] = true,
    ["Boat"] = true, 
    ["Train"] = true,
}

local function setElementSpeed(element, unit, speed)
	--if (unit == nil) then unit = 1 end
	--if (speed == nil) then speed = 0 end
	speed = tonumber(speed)
	--outputChatBox(speed)
	local acSpeed = math.floor(getElementSpeed(element, "km/h")*1)
	if (acSpeed~=false) then 
		local diff = speed/acSpeed
		local x,y,z = getElementVelocity(element)
		setElementVelocity(element,x*diff,y*diff,z*diff)
		return true
	else
		return false
	end
end

function toggleTempomat()
    --if isTimer(spamTimer) then return end
    --spamTimer = setTimer(function() end, 500, 1)
    if isChatBoxInputActive() then return end
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh then
        if not allowedTypes[getVehicleType(veh)] then return end
        if getPedOccupiedVehicleSeat(localPlayer) == 0 then
            local speed = getElementSpeed(veh)
            if not state and speed > 10 then
                if not isVehicleOnGround(veh) then return end
                sourceVeh = veh
                nowSpeed = math.floor(getElementSpeed(veh))
                setElementData(veh, "tempomat", true)
                setElementData(veh, "tempomat.speed", nowSpeed)
                --local syntax = exports['cr_core']:getServerSyntax(false, "success")
                outputChatBox("Hız Sabitleme: " ..nowSpeed.. " km/h", 255,255,255,true)
                addEventHandler("onClientPreRender", root, doingTempo, true, "high")
           
                state = true
            elseif state then
               -- local syntax = exports['cr_core']:getServerSyntax(false, "error")
                outputChatBox("Hız Sabitleme kapatıldı", 255,255,255,true)
                setElementData(veh, "tempomat", false)
                setPedControlState(localPlayer, "accelerate", false)
                setPedControlState(localPlayer, "brake_reverse", false)
                removeEventHandler("onClientPreRender", root, doingTempo)
                state = false
            end
        end
    end
end

addEventHandler("onClientPlayerVehicleExit", root,
    function(veh, seat)
        if source == localPlayer then
            if state then
               --local syntax = exports['cr_core']:getServerSyntax(false, "error")
                outputChatBox("Hız Sabitleme kapatıldı", 255,255,255,true)
                setElementData(veh, "tempomat", false)
                setPedControlState(localPlayer, "accelerate", false)
                setPedControlState(localPlayer, "brake_reverse", false)
                removeEventHandler("onClientPreRender", root, doingTempo)
                state = false
            end
        end
    end
)

addEventHandler("onClientElementDataChange", localPlayer, 
    function(dName)
        local value = getElementData(source, dName)
        if dName == "inDeath" then
            if value then
                if state then
                  --  local syntax = exports['cr_core']:getServerSyntax(false, "error")
                    outputChatBox("Hız Sabitleme kapatıldı", 255,255,255,true)
                    setElementData(sourceVeh, "tempomat", false)
                    setPedControlState(localPlayer, "accelerate", false)
                    setPedControlState(localPlayer, "brake_reverse", false)
                    removeEventHandler("onClientPreRender", root, doingTempo)
                    state = false
                end
            end
        end
    end
)

addEventHandler("onClientElementDestroy", root,
    function()
        if getElementType(source) == "vehicle" then
            local veh = getPedOccupiedVehicle(localPlayer)
            if veh == source then
                if state then
                  --  local syntax = exports['cr_core']:getServerSyntax(false, "error")
                    outputChatBox("Hız Sabitleme kapatıldı", 255,255,255,true)
                    setElementData(sourceVeh, "tempomat", false)
                    setPedControlState(localPlayer, "accelerate", false)
                    setPedControlState(localPlayer, "brake_reverse", false)
                    removeEventHandler("onClientPreRender", root, doingTempo)
                    state = false
                end
            end
        end
    end
)

bindKey("c", "down", toggleTempomat)
bindKey("accelerate", "down", 
    function()
        if state then
          --  local syntax = exports['cr_core']:getServerSyntax(false, "error")
            outputChatBox("Hız Sabitleme kapatıldı", 255,255,255,true)
            setElementData(sourceVeh, "tempomat", false)
            setPedControlState(localPlayer, "accelerate", false)
            setPedControlState(localPlayer, "brake_reverse", false)
            removeEventHandler("onClientPreRender", root, doingTempo)
            state = false
        end
    end
)

bindKey("handbrake", "down",
    function()
        if state then
           -- local syntax = exports['cr_core']:getServerSyntax(false, "error")
            outputChatBox("Hız Sabitleme kapatıldı", 255,255,255,true)
            setElementData(sourceVeh, "tempomat", false)
            setPedControlState(localPlayer, "accelerate", false)
            setPedControlState(localPlayer, "brake_reverse", false)
            removeEventHandler("onClientPreRender", root, doingTempo)
            state = false
        end
    end
)

bindKey("brake_reverse", "down", 
    function()
        if state then
          --  local syntax = exports['cr_core']:getServerSyntax(false, "error")
            outputChatBox("Hız Sabitleme kapatıldı", 255,255,255,true)
            setElementData(sourceVeh, "tempomat", false)
            setPedControlState(localPlayer, "accelerate", false)
            setPedControlState(localPlayer, "brake_reverse", false)
            removeEventHandler("onClientPreRender", root, doingTempo)
            state = false
        end
    end
)

addEventHandler("onClientVehicleDamage", root,
    function(attacker, weapon, loss)
        local veh = getPedOccupiedVehicle(localPlayer)
        if veh then
            if veh == source then
                local seat = getPedOccupiedVehicleSeat(localPlayer)
                if seat == 0 then
                    if state then
                        --local syntax = exports['cr_core']:getServerSyntax(false, "error")
                        outputChatBox("Hız Sabitleme kapatıldı", 255,255,255,true)
                        setElementData(sourceVeh, "tempomat", false)
                        setPedControlState(localPlayer, "accelerate", false)
                        setPedControlState(localPlayer, "brake_reverse", false)
                        removeEventHandler("onClientPreRender", root, doingTempo)
                        state = false
                    end
                end
            end
        end
    end
)

bindKey("num_sub", "down",
    function()
        if state then
            if nowSpeed - 2 >= 10 then
                nowSpeed = nowSpeed - 2
              --  local syntax = exports['cr_core']:getServerSyntax(false, "success")
               
                setElementData(sourceVeh, "tempomat.speed", nowSpeed)
            end
        end
    end
)

bindKey("num_add", "down",
    function()
        if state then
            local t = getVehicleHandling(sourceVeh)
            local maxVelocity = t["maxVelocity"]
            if nowSpeed + 2 <= maxVelocity then
                nowSpeed = nowSpeed + 2
             --   local syntax = exports['cr_core']:getServerSyntax(false, "success")
               
                setElementData(sourceVeh, "tempomat.speed", nowSpeed)
            end
        end
    end
)

function getElementSpeed( element, unit )
    if isElement( element ) then
        local x,y,z = getElementVelocity( element )
        if unit == "mph" or unit == 1 or unit == "1" then
            return ( x ^ 2 + y ^ 2 + z ^ 2 ) ^ 0.5 * 100
        else
            return ( x ^ 2 + y ^ 2 + z ^ 2 ) ^ 0.5 * 1.8 * 100
        end
    else
        outputDebugString( "Not an element. Can't get speed" )
        return false
    end
end

local sx, sy = guiGetScreenSize()

function doingTempo()
    --setPedControlState("")
    if getElementData(sourceVeh, "veh >> engineBroken") or not getElementData(sourceVeh, "veh >> engine") or getElementData(sourceVeh, "veh >> fuel") <= 0 then
        --local syntax = exports['cr_core']:getServerSyntax(false, "error")
        outputChatBox("Hız Sabitleme kapatıldı", 255,255,255,true)
        setElementData(sourceVeh, "tempomat", false)
        setPedControlState(localPlayer, "accelerate", false)
        removeEventHandler("onClientPreRender", root, doingTempo)
        state = false
        return
    end
    if isVehicleOnGround(sourceVeh) then
        local speed = math.floor(getElementSpeed(sourceVeh))
        --setElementSpeed(sourceVeh, 1, nowSpeed)
        if speed == nowSpeed or (speed - nowSpeed) == 1 or (nowSpeed - speed) == 1 then
            setPedControlState(localPlayer, "accelerate", false)
            setPedControlState(localPlayer, "brake_reverse", false)
            setElementSpeed(sourceVeh, 1, nowSpeed)
        elseif speed < nowSpeed then
            setPedControlState(localPlayer, "accelerate", true)
            setPedControlState(localPlayer, "brake_reverse", false)
        elseif speed > nowSpeed then
            setPedControlState(localPlayer, "accelerate", false)
            setPedControlState(localPlayer, "brake_reverse", true)
        end
    end
end