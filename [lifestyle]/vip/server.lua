--// Coding with Militan

local mysql = exports.mysql
local vipTimers = {}
local hour = 1000*60*60

-- Vip verme fonksiyonu:
function addVIP(player, level, day)
    if getElementData(player, "loggedin") == 1 then
        dbExec(mysql:getConnection(), "UPDATE characters SET vip_time = '"..tonumber(day).."', vip = '"..level.."'  WHERE id = '"..getElementData(player, "dbid").."'")
        setElementData(player, "vip_day", day)
        setElementData(player, "vip_hour", 23)
        setElementData(player, "vip", level)
        vipTimers[player] = setTimer(vipCheckTimer, hour, 0, player, level, day)
    end
end

function checkPlayerVIP(player)
    startVIPTimer(player)
end

function vipCheckTimer(player)
    setElementData(player, "vip_hour", getElementData(player, "vip_hour")-1)--saat
    if getElementData(player, "vip_hour") <= 0 then
        setElementData(player, "vip_day", getElementData(player, "vip_day")-1)
        if getElementData(player, "vip_day") == 0 then
            savePlayerVIP(player);
            killTimer(vipTimers[player]);
            outputChatBox("[!]#ffffff Aldığınız VIP'in süresi bitti!", player, 0, 255, 0, true)
        else
            setElementData(player, "vip_hour", 23)
        end
    end
end

addEventHandler("onResourceStart", resourceRoot,
    function()
        for index, player in ipairs(getElementsByType("player")) do
            if getElementData(player, "loggedin") == 1 and getElementData(player, "vip") > 0 then
                checkPlayerVIP(player)
            end
        end
    end
)

addCommandHandler("vipkalan", 
    function(player, cmd)
        if getElementData(player, "loggedin") == 1 and getElementData(player, "vip") > 0 then
            outputChatBox("[!]#ffffff VIP "..getElementData(player, "vip").. " - Kalan", player, 0, 255, 0, true)
            outputChatBox("[!]#ffffff "..(getElementData(player, "vip_day")).." gün, "..getElementData(player, "vip_hour").." saat", player, 0, 255, 0, true)
        end
    end
)

function savePlayerVIP(player)
    if getElementData(player, "loggedin") == 1 then
        if isTimer(vipTimers[player]) then
            local exprancehour = math.floor(getElementData(player, "vip_day"))
            local expranceday = math.floor(getElementData(player, "vip_hour"))
            if exprancehour > 0 then
                dbExec(mysql:getConnection(), "UPDATE characters SET vip_day = '"..tonumber(exprancehour).."', vip_hour = '"..tonumber(expranceday).."' WHERE id = '"..getElementData(player, "dbid").."'")
            else
                dbExec(mysql:getConnection(), "UPDATE characters SET vip_day = '"..tonumber(exprancehour).."', vip = '0' WHERE id = '"..getElementData(player, "dbid").."'")
            end

            killTimer(vipTimers[player]);
        end
    end
end

function startVIPTimer(player)
    vipTimers[player] = setTimer(vipCheckTimer, hour, 0, player)
end

function onPlayerExchanceServer()
    savePlayerVIP(source)
end
addEventHandler("onPlayerQuit", root, onPlayerExchanceServer)
addEventHandler("onPlayerChangeCharacter", root, onPlayerExchanceServer)