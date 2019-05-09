--[[
* ***********************************************************************************************************************
* Copyright (c) 2019 LUCY RPG Project - Enes Akıllıok
* All rights reserved. This program and the accompanying materials are private property belongs to LUCY RPG Project
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* https://www.github.com/yourpalenes
* ***********************************************************************************************************************
]]
--[[
addEventHandler('onClientRender', root,
	function()
		for index, value in ipairs(drawArray) do
			x, y = unpack(value['position'])
			w, h = unpack(value['size'])
			self.type = value['type'][1] or false
			color = value['settings'][1] or self.color(255, 255, 255)
			if self.type ~= 'rectangle' or self.type ~= 'image' then
				text = value['settings'][2]
				size = value['settings'][3] or 1
				font = value['settings'][4] or 'default'
			end
			visible = value['visible'] or true
			alignX, alignY, clip, wordBreak, postGUI, colorCoded = value['settings'][5] and self.type == 'text' or (value['settings'][5] or false), value['settings'][6] or 'top', value['settings'][7] or false, value['settings'][8] or false, value['settings'][9] or false, value['settings'][10] or false
			if visible == true then	
				if self.type == 'rectangle' then
					self.draw(x, y, w, h, color);
					if isInBox(x, y, w, h) then
						if getKeyState('mouse1') and self.lastClick+200 <= getTickCount() then
							self.lastClick = getTickCount();
							triggerEvent('onElementClick', root, value['id'], self.type);
						end
					end
				elseif self.type == 'text' then
					self.text(text, x, y, w, h, color, size, font, value['settings'][5], value['settings'][6], clip, wordBreak, postGUI, colorCoded);
				elseif self.type == 'image' then
					rX, rY, rZ = value['rotation'][1] or 0, value['rotation'][2] or 0, value['rotation'][3] or 0
					self.image(x, y, w, h, text, rX, rY, rZ, color);
					if isInBox(x, y, w, h) then
						if getKeyState('mouse1') and self.lastClick+200 <= getTickCount() then
							self.lastClick = getTickCount();
							triggerEvent('onElementClick', root, index, self.type);
						end
					end
				elseif self.type == 'button' then
					if type(color) == "string" then color = stringToColor(color); end
					r, g, b, a = toRGBA(color);
					local border = 2;
					if h > 120 then
				        border = 5;
				    elseif h > 80 then
				        border = 4;
				    elseif h > 40 then
				        border = 3;
				    end
				    if isInBox(x, y, w, h) then
				        color = colorDarker(color, 1.2);
				        r, g, b, a = toRGBA(color);
				    end
					self.draw(x, y, w, h, self.color(r, g, b, a));
					self.draw(x + border, y + border, w - border * 2, h - border * 2, self.color(r, g, b, a));
					if isInBox(x, y, w, h) then
						if getKeyState('mouse1') and self.lastClick+200 <= getTickCount() then
							self.lastClick = getTickCount();
							triggerEvent('onElementClick', root, index, self.type);
						end
					end

					self.text(text, x-1, y-1, x+w, y+h, self.color(0, 0, 0), size, font, 'center', 'center');
					self.text(text, x, y, x+w, y+h, self.color(255, 255, 255), size, font, 'center', 'center');
				elseif self.type == 'panel' then
					self.draw(x, y, w, h, self.color(0, 0, 0, 120));
					
					self.draw(x, y, 1, h, self.color(0, 0, 0));
					self.draw(x+w-1, y, 1, h, self.color(0, 0, 0));
					self.draw(x, y, w, 1, self.color(0, 0, 0));
					self.draw(x, y+h-1, w, 1, self.color(0, 0, 0));
					
					self.draw(x, y, w, 25, self.color(0, 0, 0, 140))
					self.text(text, x-1, y-1, w+x, y+25, self.color(0, 0, 0), size, font, 'center', 'center');
					self.text(text, x, y, w+x, y+25, color, size, font, 'center', 'center');

					--Close
					if alignX then
						self.draw(x+w-23, y+2, 21, 21, self.color(194, 54, 22, 200))
						if isInBox(x+w-23, y+2, 21, 21) then
							self.draw(x+w-23, y+2, 21, 21, self.color(20, 20, 20, 100))
							if getKeyState('mouse1') and self.lastClick+200 <= getTickCount() then
								self.lastClick = getTickCount()
								destroy(index)
							end
						end
						self.text('', x+w-23, y+1, 21+(x+w-23), 21+(y+1), self.color(255, 255, 255), size, convertFont[1]['default'], 'center', 'center')
					end
				elseif self.type == 'grid' then
					local head, body = color, text
					self.xOffsetArray = 0;
					local count = 0
					for i, text in ipairs(head) do
						self.yOffsetArray = y+20;
						self.text(text, x+self.xOffsetArray, y, w, h, self.color(255, 255, 255), size, convertFont[1]['sans-bold'], 'left', 'top');
						
						if _ == (#head) then
							self.xOffsetArray = self.xOffsetArray+convertFont[1]['sans-bold']:getTextWidth(text, size)+20
							if self.xOffsetArray > w then
								self.xOffsetArray = w-convertFont[1]['sans-bold']:getTextWidth(text, size)
							end
						end
						for _, body_value in ipairs(body) do
							if drawArray[index]['selected'] == _ then
								self.text(body_value[i], x+self.xOffsetArray, self.yOffsetArray, w, h, self.color(255, 255, 255), size, convertFont[1]['default'], 'left', 'top');
							else
								self.text(body_value[i], x+self.xOffsetArray, self.yOffsetArray, w, h, self.color(200, 200, 200), size, convertFont[1]['default'], 'left', 'top');
							end
							if isInBox(x, self.yOffsetArray, w, 20) then
								if getKeyState('mouse1') and self.lastClick+200 <= getTickCount() then
									self.lastClick = getTickCount()
									drawArray[index]['selected'] = _;
								end
							end
							self.yOffsetArray = self.yOffsetArray + 20;
						end
						self.xOffsetArray = self.xOffsetArray+convertFont[1]['sans-bold']:getTextWidth(text, size)+(w/#head)
						if i > 1 then
						
							self.draw(x, y+(20*count), w, 1, self.color(255, 255, 255));
							self.draw(x, y+(20*count)+20, w, 1, self.color(255, 255, 255))	
						end
						count = count + 1
					end
					self.draw(x, self.yOffsetArray, w, 1, self.color(255, 255, 255))
				elseif self.type == 'browser' then
					dxDrawImageSection(x, y, w, h, x, y, w, h, text)
				end
			end
		end
	end,
true, 'low-5');

function toRGBA(color)
    local r = bitExtract(color, 16, 8 ) 
    local g = bitExtract(color, 8, 8 ) 
    local b = bitExtract(color, 0, 8 ) 
    local a = bitExtract(color, 24, 8 ) 
    return r, g, b, a;
end

function stringToRGBA(string)
    local r = tonumber(string:sub(2, 3), 16);
    local g = tonumber(string:sub(4, 5), 16);
    local b = tonumber(string:sub(6, 7), 16);
    local a = 0;
    if string:len() == 7 then
        a = 255;
    else
        a = tonumber(string:sub(8, 9), 16);
    end
    return r, g, b, a;
end

function stringToColor(string)
    local r, g, b, a = stringToRGBA(string);
    return self.color(r, g, b, a);
end

function colorDarker(color, factor)
    local r, g, b, a = toRGBA(color);
    r = r * factor;
    if r > 255 then r = 255; end
    g = g * factor;
    if g > 255 then g = 255; end
    b = b * factor;
    if b > 255 then b = 255; end
    return self.color(r, g, b, a);
end

function isInBox(startX, startY, sizeX, sizeY)
    if isCursorShowing() then
        local cursorPosition = {getCursorPosition()};
        cursorPosition.x, cursorPosition.y = cursorPosition[1] * ScreenSize.x, cursorPosition[2] * ScreenSize.y

        if cursorPosition.x >= startX and cursorPosition.x <= startX + sizeX and cursorPosition.y >= startY and cursorPosition.y <= startY + sizeY then
            return true
        else
            return false
        end
    else
        return false
    end
end
]]--