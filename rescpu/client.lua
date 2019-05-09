local sx,sy = guiGetScreenSize()
local resStat = false
local clientRows = {}, {}
local serverRows = {}, {}


local MED_CLIENT_CPU = 5 -- 3%
local MAX_CLIENT_CPU = 10 -- 10%

local MED_SERVER_CPU = 5 -- 1%
local MAX_SERVER_CPU = 10 -- 10%


addCommandHandler("cpu", 
    function()
       -- if exports['integration']:isPlayerHeadAdmin(localPlayer) then
            resStat = not resStat
            if resStat then

                _, clientRows = getPerformanceStats("Lua timing")
            
                addEventHandler("onClientRender", root, resStatRender, true, "low")
                triggerServerEvent("getServerStat", localPlayer)
            else
           
                removeEventHandler("onClientRender", root, resStatRender)
                serverRows = {}, {}
                clientRows = {}, {}
                triggerServerEvent("destroyServerStat", localPlayer)
            end
       -- end
    end
)

function toFloor(num)
	return tonumber(string.sub(tostring(num), 0, -2)) or 0
end

addEvent("receiveServerStat", true)
addEventHandler("receiveServerStat", root, 
    function(stat1,stat2)
        _, clientRows = getPerformanceStats("Lua timing")
        _, serverRows = stat1,stat2

        table.sort(clientRows, function(a, b)
            return toFloor(a[2]) > toFloor(b[2])
        end)

        table.sort(serverRows, function(a, b)
            return toFloor(a[2]) > toFloor(b[2])
        end)
    end
)

local disabledResources = {}
function resStatRender()
	local x = sx-300
	if #serverRows == 0 then
		x = sx-140
	end

	if #clientRows ~= 0 then
		local height = (15*#clientRows)+15
		local y = sy/2-height/2
		_y = y
		y = y + 5
		for i, row in ipairs(clientRows) do
			if not disabledResources[row[1]] then
				local usedCPU = toFloor(row[2])
				local r,g,b,a = 255,255,255,255
				if usedCPU > MAX_CLIENT_CPU then
					r,g,b,a = 255,0,0,255
				elseif usedCPU > MED_CLIENT_CPU then
					r,g,b,a = 255,255,0,255
				end
				local text = row[1]:sub(0,15)..": "..usedCPU.."%"
				dxDrawText(text,x+1,y+1,150,15,tocolor(0,0,0,255),1,"default")
				dxDrawText(text,x,y,150,15,tocolor(r,g,b,a),1,"default")
				y = y + 15
				newY = y
			end
		end
		
	end
	
	if #serverRows ~= 0 then
		local x = sx-140
		local height = (15*#serverRows)
		local y = sy/2-height/2
		_y = y
		
		y = y + 5
		for i, row in ipairs(serverRows) do
			if not disabledResources[row[1]] then
				local usedCPU = toFloor(row[2])
				local r,g,b,a = 255,255,255,255
				if usedCPU > MAX_SERVER_CPU then
					r,g,b,a = 255,0,0,255
				elseif usedCPU > MED_SERVER_CPU then
					r,g,b,a = 255,255,0,255
				end
				local text = row[1]:sub(0,15)..": "..usedCPU.."%"
				dxDrawText(text,x+1,y+1,150,15,tocolor(0,0,0,255),1,"default")
				dxDrawText(text,x,y,150,15,tocolor(r,g,b,a),1,"default")
				y = y + 15
				
			end
		end
		
	end
end