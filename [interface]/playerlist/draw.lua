Playerlist = {
	screen = Vector2(guiGetScreenSize()),
	font = dxCreateFont(':hud/fonts/Roboto.ttf', 10),
	players = {},

	_sync = function(self)
	self = Playerlist;
		self.players = {};
		for index, value in ipairs(getElementsByType('player')) do
			self.players[value] = {value:getData('playerid'), value.name, value:getData('level') or 0, value:getData('loggedin')};
		end
		table.sort(self.players,
			function(a, b)
				return a[1] < b[1]
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
	self = Playerlist;
		w, h = 360, 30
		x, y = self.screen.x/2-w/2, self.screen.y/2-h/2

		self._sync()

		self._rectangle(x, y, w, h, tocolor(0, 0, 0, 180), 7)
		dxDrawText(' Lucy RPG - Wilden Your World - www.lucyrpg.com', x, y, w+x, h+y-1, tocolor(255, 255, 255), 1, self.font, 'center', 'center')
		--dxDrawImage(x+w/2-128/2+2, y-108, 128, 128, 'components/logo.png', 0, 0, 0, tocolor(255, 153, 0))
		dxDrawImage(x+w/2-(552/2)/2, y-110, 552/2, 222/2, 'components/logo.png')

		y,ny = y + (h+7),0
		w = w-20
		x = x+10
		for index, data in pairs(self.players) do
			self._rectangle(x, y+ny, w, h, tocolor(0, 0, 0, 180), 7)
			r, g, b = 255, 255, 255
			if data[4] == 0 then
				r, g, b = 100, 100, 100, 100
			end

			dxDrawText(data[1], x+8, y+ny, w, h+y+ny, tocolor(r, g, b), 1, self.font, 'left', 'center')
			dxDrawText(data[2], x+38, y+ny, w, h+y+ny, tocolor(r, g, b), 1, self.font, 'left', 'center')
			dxDrawText(data[3].."lvl", x+w-150, y+ny, w, h+y+ny, tocolor(r, g, b), 1, self.font, 'left', 'center')
			dxDrawText(getPlayerPing(index).."ms", x+w-50, y+ny, w, h+y+ny, tocolor(r, g, b), 1, self.font, 'left', 'center')
			ny = ny + (h+4)
		end
	end,
}
instance = new(Playerlist)

instance:_sync()

bindKey('tab', 'down', function() instance:_new('on') end)
bindKey('tab', 'up', function() instance:_new('off') end)