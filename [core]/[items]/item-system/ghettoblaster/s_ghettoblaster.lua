local timer = {}
local tuned = {}
local mysql = exports.mysql
local function updateWorldItemValue(item, station, volume)
	if type(step) == "number" then
		if station < 0 or station > #exports.carradio:getStreams() then return end
	end
	
    local newvalue = tostring(station)
    if type(volume) == "number" then
        newvalue = newvalue .. ';' .. volume
    end

    setElementData(item, "itemValue", newvalue)
  
    --dbExec(mysql:getConnection(), "UPDATE worlditems SET itemvalue='" .. newvalue .. "' WHERE id=" .. getElementData(item, "id"))
    triggerClientEvent("toggleSound", item)
end

function changeTrack(item, step)
	if type(step) == "number" then
		local streams = exports.carradio:getStreams()
		local splitValue = split(tostring(getElementData(item, "itemValue")), ';')
		local current = tonumber(splitValue[1]) or 1
		current = current + step
		if current > #streams then
			current = 0
		elseif current < 0 then
			current = #streams
		end
		updateWorldItemValue(item, current, tonumber(splitValue[2]))
	elseif type(step) == "string" then
		local url = step
		updateWorldItemValue(item, url, 90 --[[volume ayarı yapılacak]] )
	end
	
	if not tuned[item] then
		exports.global:sendLocalMeAction(source, "Ghettoblaster'da şarkı değiştirildi.")
		tuned[item] = true
	else
		if timer[item] and isTimer(timer[item]) then
			killTimer(timer[item])
		end
		timer[item] = setTimer(function()
			tuned[item] = false
		end, 10*1000, 1)
	end
end
addEvent("changeGhettoblasterTrack", true)
addEventHandler("changeGhettoblasterTrack", getRootElement(), changeTrack)

addEvent('changeGhettoblasterVolume', true)
addEventHandler('changeGhettoblasterVolume', root,
    function(newvalue)
        newvalue = math.floor(newvalue)
        if newvalue < 0 or newvalue > 100 then return end

        local splitValue = split(tostring(getElementData(source, "itemValue")), ';')

        updateWorldItemValue(source, tonumber(splitValue[1]) or tostring(splitValue[1]) or 1, newvalue)
    end)