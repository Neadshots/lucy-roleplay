Events = {
    mysql = exports.mysql:getConnection(),
    vehlist = {},
    debug = false,
    npclist = {
        ['BMW'] = {
        	['npc'] = {549.369140625, -1293.125, 17.248237609863, 350},
        	['veh'] = {543.5732421875, -1271.4130859375, 17.248237609863, 0, 0, 301},
        },
        ['Ford'] = {
        	['npc'] = {2131.6240234375, -1151.248046875, 24.066234588623, 354},
        	['veh'] = {2120.384765625, -1132.9013671875, 25.347015380859, 0, 0, 350},
        },
        ['Honda'] = {
        	['npc'] = {2111.71484375, -2144.5205078125, 13.6328125, 350},
        	['veh'] = {2125.08984375, -2136.75390625, 13.6328125, 0, 0, 0},
        },
        ['Audi'] = {
        	['npc'] = {2126.3798828125, -2091.8525390625, 13.546875, 130},
        	['veh'] = {2113.23828125, -2091.0068359375, 13.554370880127, 0, 0, 173},
        }
    },

    __smallestID = function(self)
        local query = self.mysql:query("SELECT MIN(e1.id+1) AS nextID FROM vehicles AS e1 LEFT JOIN vehicles AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
        local result = query:poll(-1)
        if result then
            local id = tonumber(result[1]["nextID"]) or 1
            return id
        end
        return false
    end,

    __load = function(self)
        self.vehlist = {};
        self.mysql:query(
            function(qh)
                local res, rows, err = qh:poll(0);
                if rows > 0 then
                    Async:foreach(res, function(row)
                        if not self.vehlist[row.vehbrand] then
                            self.vehlist[row.vehbrand] = {}
                        end
                        table.insert(self.vehlist[row.vehbrand], row)
                    end)
                    if self.debug then
                        print('All vehicle settings loaded succesfuly.')
                    end
                    self:__npc()
                end
            end,
        "SELECT * FROM `vehicles_shop` WHERE `enabled` = '1'");
    end,

    __npc = function(self)
        for index, data in pairs(self.npclist) do
            local ped = createPed(189, unpack(data.npc));
            ped:setFrozen(true)
            ped:setData('carshop', true)
            ped:setData('brand', index)
        end
    end,

    __events = function(self, ename, args)
        if ename == 'push:carshop:load' then
            triggerClientEvent(args[1], 'push:carshop:send', args[1], args, self.vehlist[args[2]])
        elseif ename == 'push:carshop:buy' then
            insertID = self.__smallestID(self)
            player = args[1]
            if exports.global:hasMoney(player, args[2].vehprice) then
				--// Find Vehicle Position:
				local x, y, z, rx, ry, rz = unpack(self.npclist[args[2].vehbrand]['veh'])

				--// Args:
				local dbid = player:getData('dbid')
				local color1,color2,color3,color4 = toJSON({255,255,255}),toJSON({255,255,255}),toJSON({255,255,255}),toJSON({255,255,255})
				local letter1 = string.char(math.random(65,90))
				local letter2 = string.char(math.random(65,90))
				local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)

				--// Insert Vehicle From Database:
				self.mysql:exec("INSERT INTO vehicles SET id='"..(insertID).."', model='" .. (args[2].vehmtamodel) .. "', x='" .. (x) .. "', y='" .. (y) .. "', z='" .. (z) .. "', rotx='" .. (rx) .. "', roty='" .. (ry) .. "', rotz='" .. (rz) .. "', color1='" .. (color1) .. "', color2='" .. (color2) .. "', color3='" .. (color3) .. "', color4='" .. (color4) .. "', faction='-1', owner='" .. (dbid) .. "', plate='" .. (plate) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='0', currry='0', currrz='" .. (rz) .. "', locked='1',description1='', description2='', description3='',description4='',description5='', creationDate=NOW(), createdBy='-1', vehicle_shop_id='"..(args[2].id).."',odometer='0'")

				--// Load Vehicle:
				exports.global:giveItem(player, 3, insertID)
				exports.vehicle:reloadVehicle(insertID)

				--// Take Money:
				exports.global:takeMoney(player, args[2].vehprice)

				--// Info:
				outputChatBox(exports.pool:getServerSyntax(false, "s").."Başarıyla aracı satın aldınız, araç galerinin önünde. ( Araç ID: "..insertID.." / Plaka: "..plate, player, 255, 255, 255, true)
            end
        end
    end,
}
instance = new(Events);
addEventHandler('onResourceStart',resourceRoot,function() instance:__load() end)
addEvent('push:carshop:load', true)
addEvent('push:carshop:buy', true)
addEventHandler('push:carshop:load',root,function(player,brand) instance:__events('push:carshop:load', {player, brand}) end)
addEventHandler('push:carshop:buy',root,function(player,cardata) instance:__events('push:carshop:buy', {player,cardata}) end)