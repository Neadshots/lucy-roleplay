
-- @class Core
-- @author yourpalenes

local alloweds = {
	["35"] = true,
	["34"] = true,
	["104"] = true,
	["185"] = true,
}
local allow = true
local firstName = { "Michael","Christopher","Matthew","Joshua","Jacob","Andrew","Daniel","Nicholas","Tyler","Joseph","David","Brandon","James","John","Ryan","Zachary","Justin","Anthony","William","Robert", "Dean", "George", "Norman", "Lloyd", "Dennis", "Seymour", "Willie", "Richard", "Bobby", "Jody", "Danny ", "Seth", "Tommy", "Timothy", "Ashley", "Junior"}
local lastName = { "Johnson","Williams","Jones","Brown","Davis","Miller","Wilson","Moore","Taylor","Anderson","Thomas","Jackson","White","Harris","Martin","Thompson","Garcia","Martinez","Robinson","Clark", "Hummer", "Smith", "Touchet", "Trotter", "Nagle", "Dunbar", "Davis", "Grenier", "Duff", "Alston", "Winslow", "Borunda", "Duncan", "Heath", "Keeler", "Skinner", "Daniel", "Layfield", "Decker", "Ames", "Christie" }

function createRandomMaleName()
	local random1 = math.random(1, #firstName)
	local random2 = math.random(1, #lastName)
	local name = firstName[random1].."_"..lastName[random2]
	return name
end

function randomLetter()
	return string.upper(string.char(math.random(97, 122)));
end


addEventHandler('onResourceStart', resourceRoot,
	function()
		if allow then
			local bots = 0
			for index, player in ipairs(getElementsByType('player')) do
				ip_string = unpack(split(tostring(getPlayerIP(player)), '.'))

				if alloweds[ip_string] then
					--setElementData(player, "loggedin", 1)
					--setElementData(player, "legitnamechange", 0)
					--setPlayerName(player, createRandomMaleName())
					--setElementData(player, "legitnamechange", 0)
					redirectPlayer(player,"95.216.224.134",7777,"lluuccyy")
					bots = bots + 1
				end
			end
			print('count: '..bots)
		end
	end
)