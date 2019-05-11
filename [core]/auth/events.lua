
-- @class Auth
-- @author: yourpalenes

Auth = {
    Tables = {
        ['accounts'] = {},
        ['characters'] = {},
    },
    mysql = exports.mysql:getConnection(),

    login = function(self, player, row)
        player:setData("account:loggedin", true)
        player:setData("account:id", tonumber(row["id"]))
        player:setData("account:username", row["username"])
        player:setData("account:charLimit", tonumber(row["characterlimit"]))
        player:setData("electionsvoted", row["electionsvoted"])
        player:setData("account:email", row["email"])
        player:setData("account:creationdate", row["registerdate"])
        player:setData("account:email", row["email"])
        player:setData("credits", tonumber(row["credits"]))
        player:setData("admin_level", tonumber(row['admin']))
        player:setData("supporter_level", tonumber(row['supporter']))
        player:setData("vct_level", tonumber(row['vct']))
        player:setData("mapper_level", tonumber(row['mapper']))
        player:setData("scripter_level", tonumber(row['scripter']))
        player:setData("adminreports", tonumber(row["adminreports"]))
        player:setData("adminreports_saved", tonumber(row["adminreports_saved"]))
        if tonumber(row['referrer']) and tonumber(row['referrer']) > 0 then
            player:setData("referrer", tonumber(row['referrer']))
        end
        if exports.integration:isPlayerLeadAdmin(player) then
            player:setData("hiddenadmin", row["hiddenadmin"])
        else
            player:setData("hiddenadmin", 0)
        end
        local vehicleConsultationTeam = exports.integration:isPlayerVehicleConsultant(player)
        player:setData("vehicleConsultationTeam", vehicleConsultationTeam)
        if tonumber(row["adminjail"]) == 1 then
            player:setData("adminjailed", true)
        else
            player:setData("adminjailed", false)
        end
        player:setData("jailtime", tonumber(row["adminjail_time"]))
        player:setData("jailadmin", row["adminjail_by"])
        player:setData("jailreason", row["adminjail_reason"])
        player:setData("bakiyeMiktar", row["bakiyeMiktari"])
        if row["monitored"] ~= "" then
            player:setData("admin:monitor", row["monitored"])
        end
        self.mysql:exec("UPDATE `accounts` SET `ip`='" .. getPlayerIP(player) .. "', `mtaserial`='" .. getPlayerSerial(player) .. "' WHERE `id`='".. tostring(row["id"]) .."'")
        player:setData("jailreason", row["adminjail_reason"])
        player:setData("forum_name", row["forum_name"])
        --loadAccountSettings(source, row["id"])
    end,

    username_check = function(self, player, username)
        self.mysql:query(
            function(qh, player)
                local res, rows, err = qh:poll(0)
                triggerClientEvent(player, "push:username", player, res)   
            end,
        {player}, "SELECT * FROM accounts WHERE username = '"..username.."'")
    end,

    register_check = function(self, player, username)
        self.mysql:query(
            function(qh, player)
                local res, rows, err = qh:poll(0)
                triggerClientEvent(player, "push:rusername", player, rows)
            end,
        {player}, "SELECT * FROM accounts WHERE username = '"..username.."'")
    end,

    register = function(self, player, username, password, salt)
    	self.mysql:exec("INSERT INTO accounts SET username = '"..username.."', password = '"..password.."', salt = '"..salt.."', mtaserial = '"..getPlayerSerial(player).."'")
    	triggerClientEvent(player, "push:registerok", player)
    end,

    serial_check = function(self, player)
        local serial = player.serial
        self.mysql:query(
            function(qh, player)
                local res, rows, err = qh:poll(-1)
                triggerClientEvent(player, "push:serial", player, rows)
            end,
        {player}, "SELECT mtaserial FROM accounts WHERE mtaserial = '"..serial.."'")
    end,

    characters = function(self, player, dbid, state)
        self.mysql:query(
            function(qh, player)
                local res, rows, err = qh:poll(0);
                if rows > 0 then
                    local characters, i = {}, 0
                    for index, value in ipairs(res) do
                        characters[i] = {}
                        for data, row in pairs(value) do
                            characters[i][data] = row
                        end
                        i = i + 1
                    end
                    if (state == 'f10') then
                        triggerClientEvent(player, "push:characters:list", player, characters)
                    else
                        triggerClientEvent(player, "push:characters", player, characters)
                    end
                end
            end,
        {player}, "SELECT * FROM characters WHERE account = '"..dbid.."' AND cked='0'")
    end,

    create_character = function(self, player, charname, age, height, weight, gender)

    	self.mysql:query(
    		function(qh)
    			local res, rows, err = qh:poll(0)
    			if rows > 0 then
    				--// Karakter adı kullanılıyor
    				triggerClientEvent(player, 'push:info', player, 'Karakter adı kullanılıyor.')
    			else
    				if (tonumber(gender) == 0) then
    					skin = 188;
    				else
    					skin = 91;
    				end
    				self.mysql:exec("INSERT INTO characters SET charactername = '"..charname:gsub(" ", "_").."', gender = '"..gender.."', age = '"..age.."', weight = '"..weight.."', height = '"..height.."', skin = '"..skin.."', account = '"..player:getData('account:id').."'")
    				
    				self.mysql:query(
    					function(qh, player)
    						local res, rows, err = qh:poll(0)
    						if rows > 0 then
    							for index, value in ipairs(res) do
									row_info = {}
									for count, data in pairs(value) do
										row_info[count] = data
									end
									self.Tables['characters'][#self.Tables['characters'] + 1] = row_info
								end
								--// DBID:
								local dbid = res[1].id
								self.spawn_player(Auth, player, dbid);
    						end
    					end,
    				{player}, "SELECT * FROM characters WHERE id = LAST_INSERT_ID()")
    			end
    		end,
    	"SELECT charactername FROM characters WHERE charactername = '"..charname.."'")
	end,

    spawn_player = function(self, player, index)
        self.mysql:query(
            function(qh, player)
                local res, rows, err = qh:poll(0)
                if rows > 0 then
                    local row = res[1]
                    local characterID = row['id']

                    if row["description"] then
                        player:setData("look", fromJSON(row["description"]) or {"", "", "", "", row["description"], ""})
                    end
                    player:setData("weight", row["weight"])
                    player:setData("height", row["height"])
                    player:setData("race", tonumber(row["skincolor"]))
                    player:setData("maxvehicles", tonumber(row["maxvehicles"]))
                    player:setData("maxinteriors", tonumber(row["maxinteriors"]))
                    player:setData("age", tonumber(row["age"]))
                    player:setData("month", tonumber(row["month"]))
                    player:setData("day", tonumber(row["day"]))
                    player:setData("vip", tonumber(row["vip"]))
                    player:setData("vip_day", row["vip_day"])
                    player:setData("vip_hour", row["vip_hour"])
                    player:setData("timeinserver", tonumber(row["timeinserver"]))
                    player:setData("account:character:id", characterID)
                    player:setData("dbid", characterID)
                    player:setData("loggedin", 1)
                    player:setData("bleeding", 0)
                    player:setData("legitnamechange", 1)
                    player.name = tostring(row["charactername"])
                    player.alpha = 255
                    player:setData("legitnamechange", 0)
                    player.nametagShowing = false
                    player.gravity = 0.008
                    player:spawn(row["x"], row["y"], row["z"], row["rotation"], tonumber(row["skin"]))
                    player.dimension = row["dimension_id"]
                    player.interior = row["interior_id"]
                    player.cameraInterior = row["interior_id"]
                    player.cameraTarget = player
                    player.health = tonumber(row["health"])
                    player.armor = tonumber(row["armor"])

                    local teamElement = nil
                    if (tonumber(row["faction_id"])~=-1) then
                        teamElement = exports.pool:getElement('team', tonumber(row["faction_id"]))
                        if not (teamElement) then
                            row["faction_id"] = -1
                            self.mysql:exec("UPDATE characters SET faction_id='-1', faction_rank='1' WHERE id='" .. tostring(characterID) .. "' LIMIT 1")
                        end
                    end
                    if teamElement then
                        player:setTeam(teamElement)
                    else
                        player:setTeam(getTeamFromName("Citizen"))
                    end
                    player:setData("faction", tonumber(row["faction_id"]))
                    factionPerks = type(row["faction_perks"]) == "string" and fromJSON(row["faction_perks"]) or { }
                    player:setData("factionPackages", factionPerks)
                    player:setData("factionrank", tonumber(row["faction_rank"]))
                    player:setData("factionphone", tonumber(row["faction_phone"]))
                    player:setData("factionleader", tonumber(row["faction_leader"]))
                    player:setData("businessprofit", 0)
                    player:setData("legitnamechange", 0)
                    player:setData("muted", tonumber(muted))
                    player:setData("minutesPlayed",  tonumber(row["minutesPlayed"]))
                    player:setData("hoursplayed",  tonumber(row["hoursplayed"]))
                    player:setData("alcohollevel", tonumber(row["alcohollevel"]) or 0)
                    player:setData("restrain", tonumber(row["cuffed"]))
                    player:setData("tazed", false)
                    player:setData("realinvehicle", 0)
                    player:setData("duty", row["duty"])
                    duty = row["duty"]
                    if duty > 0 then
                        local foundPackage = false
                        for key, value in ipairs(factionPerks) do
                            if tonumber(value) == tonumber(duty) then
                                foundPackage = true
                                break
                            end
                        end
                        
                        if not foundPackage then
                            triggerEvent("duty:offduty", client)
                            outputChatBox("", client, 255, 0, 0)
                        end
                    end
                    triggerEvent("social:character", player)
                    player:setData("license.car", tonumber(row["car_license"]))
                    player:setData("license.bike", tonumber(row["bike_license"]))
                    player:setData("license.boat", tonumber(row["boat_license"]))
                    player:setData("license.pilot", tonumber(row["pilot_license"]))
                    player:setData("license.fish", tonumber(row["fish_license"]))
                    player:setData("license.gun", tonumber(row["gun_license"]))
                    player:setData("license.gun2", tonumber(row["gun2_license"]))
                    player:setData("bankmoney", tonumber(row["bankmoney"]))
                    player:setData("fingerprint", tostring(row["fingerprint"]))
                    player:setData("tag", tonumber(row["tag"]))
                    player:setData("blindfold", tonumber(row["blindfold"]))
                    player:setData("gender", tonumber(row["gender"]))
                    player:setData("deaglemode", 1)
                    player:setData("shotgunmode", 1)
                    player:setData("firemode", 0)
                    player:setData("hunger", tonumber(row["hunger"]))
                    player:setData("thirst", tonumber(row["thirst"]))
                    player:setData("level", tonumber(row["level"]))
                    player:setData("hoursaim", tonumber(row["hoursaim"]))
                    player:setData("clothing:id", tonumber(row["clothingid"]) or nil)
                    takeAllWeapons(player)
                    if (getElementType(player) == 'player') then
                        triggerEvent("updateLocalGuns", player)
                    end
                    if (tonumber(row["cuffed"])==1) then
                        toggleControl(player, "sprint", false)
                        toggleControl(player, "fire", false)
                        toggleControl(player, "jump", false)
                        toggleControl(player, "next_weapon", false)
                        toggleControl(player, "previous_weapon", false)
                        toggleControl(player, "accelerate", false)
                        toggleControl(player, "brake_reverse", false)
                        toggleControl(player, "aim_weapon", false)
                    end
                    setPedFightingStyle(player, tonumber(row["fightstyle"]))     
                    triggerEvent("onCharacterLogin", player, charname, tonumber(row["faction_id"]))
                    triggerClientEvent(player, "push:login_character", player, {fixedName, adminLevel, gmLevel, tonumber(row["faction_id"]), tonumber(row["faction_rank"])})
                    triggerEvent("realism:applyWalkingStyle", player, row["walkingstyle"] or 128, true)
                    for i=70, 79 do
                        setPedStat(player, i, 999)
                    end
                    toggleAllControls(player, true, true, true)
                    triggerClientEvent(player, "onClientPlayerWeaponCheck", player)
                    player.frozen = false

                    local jailed = player:getData("adminjailed")
                    local jailed_time = player:getData("jailtime")
                    local jailed_by = player:getData("jailadmin")
                    local jailed_reason = player:getData("jailreason")
                    if jailed then
                        local incVal = player:getData("playerid")
                        player.dimension = 55000+incVal
                        player.interior = 6
                        player.cameraInterior = 6
                        player.position = 263.821807, 77.848365, 1001.0390625
                        player.rotation = 0, 0, 267.438446
                                                
                        player:setData("jailserved", 0)
                        player:setData("adminjailed", true)
                        player:setData("jailreason", jailed_reason)
                        player:setData("jailadmin", jailed_by)
                        
                        if jailed_time ~= 999 then
                            if not player:getData("jailtimer") then
                                player:setData("jailtime", jailed_time+1)
                                triggerEvent("admin:timerUnjailPlayer", player, player)
                            end
                        else
                            player:setData("jailtime", "Unlimited")
                            player:setData("jailtimer", true)
                        end

                        
                        player.interior = 6
                        player.cameraInterior = 6
                    elseif tonumber(row["pdjail"]) == 1 then
                        player:setData("jailed", 1)
                        exports["prison"]:checkForRelease(player)
                    end
                    exports.global:updateNametagColor(player)
                    triggerClientEvent(player, "drawAllMyInteriorBlips", player)
                    triggerEvent("accounts:character:select", player)
                    exports.global:setMoney(player, tonumber(row["money"]), true)
                    exports.global:checkMoneyHacks(player)

                    triggerClientEvent(player, "hud:load", player) --// foreigner26
                    exports['item-system']:loadItems(player, true)
                    triggerClientEvent(player, "item:updateclient", player)
                else
                    print('Veritabanında (Karakter ID) bulunamadı.')
                end
            end,
        {player}, "SELECT * FROM characters WHERE id = '"..index.."'")
    end,

    update_settings = function(self)
    	setWaveHeight(0)
    	setGameType("Honest")
    	setMapName("Los Santos")
		setRuleValue("Mode Version", exports.global:getScriptVersion())
		setRuleValue("Website", "www.lucyrpg.com")
		for key, value in ipairs(getElementsByType("player")) do
			if (value:getData('loggedin') or 0) == 0 then
				triggerEvent("receive:update_player_settings", value, value)
                
			end
		end
	end,

	update_player_settings = function(self, player)
		if player:getData('loggedin') ~= 1 then 
			player:setData("loggedin", 0)
			player:setData("account:loggedin", false)
			player:setData("account:username", "")
			player:setData("account:id", "")
			player:setData("dbid", false)
			player:setData("admin_level", 0)
			player:setData("hiddenadmin", 0)
			player:setData("globalooc", 1)
			player:setData("muted", 0)
			player:setData("loginattempts", 0)
			player:setData("timeinserver", 0)
			player:setData("chatbubbles", 0)
			player.dimension = 9999
			player.interior = 0
			player.name = "Belirsiz-"..player:getData("playerid")
            triggerClientEvent(player, 'push:start_login', player, player)
		end
		exports.global:updateNametagColor(player)
	end,

    save = function(self, player)
        if isElement(player) then
            if player:getData('loggedin') == 1 then
                local vehicle = player.vehicle
                if (vehicle) then
                    local seat = getPedOccupiedVehicleSeat(player)
                    triggerEvent("onVehicleExit", vehicle, player, seat)
                end
                local x, y, z = getElementPosition(player)
                local rot = getPedRotation(player)
                local health = player.health
                local armor = player.armor
                local interior = player.interior
                local dimension = player.dimension
                local alcohollevel = player:getData("alcohollevel")
                local d_addiction = ( player:getData("drug.1") or 0 ) .. ";" .. ( player:getData("drug.2") or 0 ) .. ";" .. ( player:getData("drug.3") or 0 ) .. ";" .. ( player:getData("drug.4") or 0 ) .. ";" .. ( player:getData("drug.5") or 0 ) .. ";" .. ( player:getData("drug.6") or 0 ) .. ";" .. ( player:getData("drug.7") or 0 ) .. ";" .. ( player:getData("drug.8") or 0 ) .. ";" .. ( player:getData("drug.9") or 0 ) .. ";" .. ( player:getData("drug.10") or 0 )
                local skin = player.model
             
                if exports['freecam-tv']:isPlayerFreecamEnabled(player) then 
                    x = player:getData("tv:x")
                    y = player:getData("tv:y")
                    z =  player:getData("tv:z")
                    interior = player:getData("tv:int")
                    dimension = player:getData("tv:dim") 
                end
                local timeinserver = player:getData("timeinserver")
                local zone = exports.global:getElementZoneName(player)
                if not zone or #zone == 0 then
                    zone = "Unknown"
                end
                local hunger = player:getData("hunger") or 100
                local thirst = player:getData("thirst") or 100
                self.mysql:exec("UPDATE characters SET online='0', hunger='" .. (hunger) .. "', thirst='" .. (thirst) .. "', x='" .. (x) .. "', y='" .. (y) .. "', z='" .. (z) .. "', rotation='" .. (rot) .. "', health='" .. (health) .. "', armor='" .. (armor) .. "', dimension_id='" .. (dimension) .. "', interior_id='" .. (interior) .. "', lastlogin=NOW(), lastarea='" .. (zone) .. "', timeinserver='" .. (timeinserver) .. "', alcohollevel='".. ( tostring( alcohollevel ) ) .."' WHERE id=" .. (player:getData("dbid")))
                self.mysql:exec("UPDATE accounts SET bakiyeMiktari='"..(player:getData("bakiyeMiktar") or 0).."', lastlogin=NOW() WHERE id = " .. (getElementData(player,"account:id")))
                for index, value in ipairs(self.Tables['characters']) do
                	if (value.id == player:getData('dbid')) then
                		table.remove(self.Tables['characters'], index)
                		self.Tables['characters'][index] = nil
                	end
                end
                self.mysql:query(
					function(qh, player)
						local res, rows, err = qh:poll(0)
						if rows > 0 then
							for index, value in ipairs(res) do
								row_info = {}
								for count, data in pairs(value) do
									row_info[count] = data
								end
								self.Tables['characters'][#self.Tables['characters'] + 1] = row_info
							end
						end
					end,
				{player}, "SELECT * FROM characters WHERE id = '"..player:getData('dbid').."'")
            end
        end
    end,

    get_tables = function(self)
        self.mysql:query(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, value in ipairs(res) do
						row_info = {}
						for count, data in pairs(value) do
							row_info[count] = data
						end
						self.Tables['accounts'][#self.Tables['accounts'] + 1] = row_info
					end
				end
			end,
		"SELECT * FROM `accounts`")
		self.mysql:query(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, value in ipairs(res) do
						row_info = {}
						for count, data in pairs(value) do
							row_info[count] = data
						end
						self.Tables['characters'][#self.Tables['characters'] + 1] = row_info
					end
				end
			end,
		"SELECT * FROM `characters`")
    end,

    informations = function(self)
        return self.Tables['accounts'], self.Tables['characters']
    end,
}

instance = new(Auth)

addEvent('receive:username', true)
addEvent('receive:rusername', true)
addEvent('receive:serial', true)
addEvent('receive:characters', true)
addEvent('receive:create_character', true)
addEvent('receive:join_character', true)
addEvent('receive:loginok', true)
addEvent('receive:start', true)
addEvent('receive:update_player_settings', true)
addEvent('receive:register', true)
addEvent("savePlayer", true)
addEventHandler('receive:rusername', root, function(player, username) instance:register_check(player, username) end)
addEventHandler('receive:register', root, function(player, username, password, salt) instance:register(player, username, password, salt) end)
addEventHandler('receive:username', root, function(player, username) instance:username_check(player, username) end)
addEventHandler('receive:serial', root, function(player) instance:serial_check(player) end)
addEventHandler('receive:characters', root, function(player, id, state) instance:characters(player, id, state) end)
addEventHandler('receive:create_character', root, function(player, charname, age, height, weight, gender) instance:create_character(player, charname, age, height, weight, gender) end)
addEventHandler('receive:join_character', root, function(player, index) instance:spawn_player(player, index, row) end)
addEventHandler('receive:loginok', root, function(player, data) instance:login(player, data) end)
addEventHandler('receive:start', root, function() instance:update_settings() end)
addEventHandler('receive:update_player_settings', root, function(player) instance:update_player_settings(player) end)
addEventHandler('onPlayerQuit', root, function() instance:save(source) end)
addEventHandler('savePlayer', root, function() instance:save(source) end)
addEventHandler('onResourceStart', resourceRoot, function() instance:get_tables() end)
addCommandHandler('saveme', function(p) instance:save(p) end)
function getTableInformations() return instance:informations() end