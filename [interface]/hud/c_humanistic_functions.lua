--[levelUpHour] = level
local levels = {}
local hourOfCache = 0

for i=1, 99 do
	levels[hourOfCache] = i
	hourOfCache = hourOfCache + 10
end
function setElementData(element, data, value)
	triggerServerEvent("anticheat:changeEld", element, element, data, value)
end

addEventHandler("onClientElementDataChange", localPlayer,
    function(dName)
        if dName == "hoursplayed" then
            local value = getElementData(source, dName)
            local levelUp = levels[value] or findPlayerLevel(value)
            if levelUp then
                setElementData(source, "level", levelUp)
                triggerServerEvent("save:level", source, source, levelUp, getPlayerLastXP(source))
              	local syntax = "#ff9600[LUCY RPG]#ffffff "
              -- outputChatBox(syntax .. "Seviye atladınız! Yeni Seviyeniz: "..levelUp, 255,255,255,true)
                executeCommandHandler("mylevel")
            end
        end
    end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		if getElementData(localPlayer, "loggedin") == 1 then
			local value = getElementData(localPlayer, "hoursplayed")
            local levelUp = findPlayerLevel(value)
            if levelUp then
                setElementData(localPlayer, "level", levelUp)
                triggerServerEvent("save:level", localPlayer, localPlayer, levelUp, getPlayerLastXP(localPlayer))
              --	local syntax = "#ff9600[LUCY RPG]#ffffff "
               -- outputChatBox(syntax .. "Seviye atladınız! Yeni Seviyeniz: "..levelUp, 255,255,255,true)
             --   executeCommandHandler("mylevel")
            end
		end
	end
)
function findLevelToMinute(level)
	for i, v in pairs(levels) do
		if v == level then
			return i--hour type
		end
	end
end

function findPlayerLevel()
	hoursPlayed = getElementData(localPlayer, "hoursplayed")
	for index, value in pairs(levels) do
		if (tonumber(hoursPlayed) >= index and tonumber(hoursPlayed) < index+10) then
			return value
		end
	end
	return 1
end

function currentExprance(level, type)
	currentLevel = level
	lastLevel = currentLevel + 1
	backLevel = currentLevel - 1

	backLevelPoint = findLevelToMinute(backLevel)
	lastLevelPoint = findLevelToMinute(lastLevel)

	if type == 1 then-- current
		--return backLevelPoint/60
		return math.floor(getElementData(localPlayer, "hoursplayed"))
	elseif type == 2 then-- finish
		return lastLevelPoint
	end
end

function getPlayerCurrentXP(playerSource)
	return currentExprance(getElementData(playerSource, "level"),1)
end

function getPlayerCurrentLevel(playerSource)
	return tonumber(getElementData(playerSource, "level"))
end

function getPlayerLastXP(playerSource)
	return currentExprance(getElementData(playerSource, "level"),2)
end

addCommandHandler("mylevel",
	function(cmd)
		if getElementData(localPlayer, "loggedin") == 1 then
	        local syntax = "#ff9600[LUCY RPG]#ffffff "
            outputChatBox(syntax .. "Şu anki seviye: "..getElementData(localPlayer, "level"), 255,255,255,true)
            outputChatBox(syntax .. "EXP: "..currentExprance(getElementData(localPlayer, "level"),1).." / "..currentExprance(getElementData(localPlayer, "level"),2), 255,255,255,true)
		end
	end
)


setTimer(
    function()
        if getElementData(localPlayer, "loggedin") ~= 1 then return end
     
        local oldFood = (tonumber(getElementData(localPlayer, "hunger")) or 100)
        local foodNull = false
        if oldFood - 0.05 >= 0 then
            setElementData(localPlayer, "hunger", oldFood - 0.05)

        else
            setElementData(localPlayer, "hunger", 0)
            foodNull = true
        end
        
        local oldDrink = (tonumber(getElementData(localPlayer, "thirst")) or 100)
        local drinkNull = false
        if oldDrink - 0.10 >= 0 then
            setElementData(localPlayer, "thirst", oldDrink - 0.10)  
    
        else
            setElementData(localPlayer, "thirst", 0)
            drinkNull = true
        end
        
        if drinkNull and not foodNull then  -- 20 hp
            local health = getElementHealth(localPlayer)
            setElementHealth(localPlayer, health - 20)
            if health - 20 <= 0 then
            	outputChatBox("Birşeyler yiyip/içmediğin için bayıldın!", 255, 0, 0, true)
            end
        elseif drinkNull and foodNull then
            outputChatBox("Birşeyler yiyip/içmediğin için bayıldın!", 255, 0, 0, true)
        elseif not drinkNull and foodNull then -- 50 hp
            local health = getElementHealth(localPlayer)
            setElementHealth(localPlayer, health - 50)
            if health - 50 <= 0 then
            	outputChatBox("Birşeyler yiyip/içmediğin için bayıldın!", 255, 0, 0, true)
            end
        end
    end, 1000*40, 0
)