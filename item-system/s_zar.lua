--[[
function zarAt()
local max = tonumber(itemValue) or 6
			if max == 1 then
				max = 6
			end
			exports.global:sendLocalText(source, " ✪ " .. getPlayerName(source):gsub("_", " ") .. " rolls a " .. (max == 6 and "" or (max .. "-sided ")) .. "dice and gets " .. math.random( 1, max ) ..".", 255, 51, 102)
	end
addEvent("zarAt", true)
addEventHandler("zarAt", getRootElement(), zarAt)
addCommandHandler("zarat", zarAt)
]]--

function zarAttir()
			exports.global:sendLocalText(source, " ✪ " .. getPlayerName(source):gsub("_", " ") .. " zar atti ((" .. math.random( 1, 6 ) ..", " .. math.random( 1, 6 ) .. ")) .", 102, 255, 255)
	end
addEvent("zarAttir", true)
addEventHandler("zarAttir", getRootElement(), zarAttir)
addCommandHandler("zarat", zarAttir)