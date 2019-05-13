Playerlist = {
	screen = Vector2(guiGetScreenSize()),
	font = dxCreateFont(':fonts/components/Roboto.ttf', 10),
	players = {},
	max_players = 13,
	current = 1,
	latest = 1,

	_sync = function(self)
	self = Playerlist;
		self.players = {};
		for index, value in ipairs(getElementsByType('player')) do
			self.players[index] = value;
		end
		table.sort(self.players,
			function(a, b)
				if a ~= localPlayer and b ~= localPlayer and getElementData(a, "playerid") and getElementData(b, "playerid") then
					return tonumber(getElementData(a, "playerid")) < tonumber(getElementData(b, "playerid"))
				end
			end
		)
	end,

	_rectangle = function(x, y, rx, ry, color, radius)
	    rx = rx - radius * 2
	    ry = ry - radius * 2
	    x = x + radius
	    y = y + radius

	    if (rx >= 0) and (ry >= 0) then
	        dxDrawRectangle(x, y, rx, ry, color)
	        dxDrawRectangle(x, y - radius, rx, radius, color)
	        dxDrawRectangle(x, y + ry, rx, radius, color)
	        dxDrawRectangle(x - radius, y, radius, ry, color)
	        dxDrawRectangle(x + rx, y, radius, ry, color)

	        dxDrawCircle(x, y, radius, 180, 270, color, color, 7)
	        dxDrawCircle(x + rx, y, radius, 270, 360, color, color, 7)
	        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 7)
	        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 7)
	    end
	end,

	_new = function(self, mode)
		if (tonumber(localPlayer:getData('loggedin')) == 1) then
			if (mode == 'on') then
				addEventHandler('onClientRender',root,self._draw)
			else
				removeEventHandler('onClientRender',root,self._draw)
			end
		end
	end,

	_draw = function()
	self = instance
		w, h = 360, 30
		x, y = self.screen.x/2-w/2, self.screen.y/2-h/2

		--if #self.players >= self.max_players then
			y = self.screen.y/2-(h+320)/2
		--end

		self._sync()

		self._rectangle(x, y, w, h, tocolor(0, 0, 0, 180), 7)
		dxDrawText(' Lucy RPG - Widen Your World - www.lucyrpg.com', x, y, w+x, h+y-1, tocolor(255, 255, 255), 1, self.font, 'center', 'center')
		dxDrawImage(x+w/2-(552/2)/2, y-110, 552/2, 222/2, 'components/logo.png')

		y,ny = y + (h+7),0
		w = w-20
		x = x+10

		self.latest = self.current + self.max_players - 1
		for index, player in pairs(self.players) do
			if index >= self.current and index <= self.latest then
				index = index - self.current + 1
				self._rectangle(x, y+ny, w, h, tocolor(0, 0, 0, 180), 7)
				r, g, b = 255, 255, 255
				if player:getData('loggedin') ~= 1 then
					r, g, b = 100, 100, 100, 100
				end

				ping = player:getPing()
                    if ping > 80 then 
                        ping = ping - 20
                    end

				dxDrawText(player:getData('playerid'), x+8, y+ny, w, h+y+ny, tocolor(r, g, b), 1, self.font, 'left', 'center')
				dxDrawText(player.name:gsub("_", " "), x+38, y+ny, w, h+y+ny, tocolor(r, g, b), 1, self.font, 'left', 'center')
				dxDrawText((player:getData('level') or 0).."lvl", x+w-150, y+ny, w, h+y+ny, tocolor(r, g, b), 1, self.font, 'left', 'center')
				dxDrawText(ping.."ms", x+w-50, y+ny, w, h+y+ny, tocolor(r, g, b), 1, self.font, 'left', 'center')
				ny = ny + (h+4)
			end
		end
		w, x = w+20, x-10
		self._rectangle(x, y+ny, w, h, tocolor(0, 0, 0, 180), 7)
		dxDrawText('Toplam Oyuncu: '..(#self.players)..'/100', x, y+ny, w+x, h+(y+ny), tocolor(255, 255, 255), 1, self.font, 'center', 'center')
	end,

	down = function()
	self = instance
		if getKeyState('tab') then
			if self.current < (#self.players) - (self.max_players - 1) then
				self.current = self.current + 1
			end
		end
	end,

	up = function()
	self = instance
		if getKeyState('tab') then
			if self.current > 1 then
				self.current = self.current - 1
			end
		end
	end,
}
instance = new(Playerlist)

instance:_sync()

bindKey('tab', 'down', function() instance:_new('on') end)
bindKey('tab', 'up', function() instance:_new('off') end)

bindKey('mouse_wheel_up', 'down', function() instance:up() end)
bindKey('mouse_wheel_down', 'down', function() instance:down() end)
bindKey('pgup', 'down', function() instance:up() end)
bindKey('pgdn', 'down', function() instance:down() end)