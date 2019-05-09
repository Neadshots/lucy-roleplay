--[[
* ***********************************************************************************************************************
* Copyright (c) 2019 SA:RP Project - Enes Akıllıok
* All rights reserved. This program and the accompanying materials are private property belongs to SA:RP Project
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* https://www.github.com/yourpalenes
* ***********************************************************************************************************************
]]

ScreenSize = Vector2(guiGetScreenSize());
self = {};
self.draw = dxDrawRectangle;
self.text = dxDrawText;
self.image = dxDrawImage;
self.color = tocolor;
self.lastClick = 0;
drawArray = {};
attachedBrowsers = {}; -- attachedBrowsers[drawArray[id]] = browserElement; -- pairs

convertFont = {
	['default'] = 'fonts/FontAwesome.ttf',
	['default-bold'] = 'fonts/Yantramanav-Regular.ttf',
	['sans-bold'] = 'fonts/Yantramanav-Black.ttf',
};

function drawRectangle(x, y, w, h, color, postGUI)
	self.id = #drawArray + 1
	drawArray[self.id] = {
		['id'] = self.id,
		['position'] = {x, y},
		['size'] = {w, h},
		['type'] = {'rectangle'},
		['settings'] = {color, postGUI},
		['parents'] = {},
		['visible'] = true,
 	};
	return self.id
end

function drawText(text, x, y, w, h, color, size, font, alignX, alignY, clip, wordBreak, postGUI, colorCoded, linkText)
	self.id = #drawArray + 1
	self.font = DxFont(convertFont[font], size*10) or 'default';
	drawArray[self.id] = {
		['id'] = self.id,
		['position'] = {x, y},
		['size'] = {w, h},
		['type'] = {'text'},
		['settings'] = {color, text, size, self.font, alignX, alignY, clip or false, wordBreak or false, postGUI or false, colorCoded or false, linkText or false},
		['parents'] = {},
		['visible'] = true,
 	};
	return self.id, self.font:getTextWidth(text, size)
end

function drawImage(x, y, w, h, image, rX, rY, rZ, color, postGUI)
	self.id = #drawArray + 1
	drawArray[self.id] = {
		['id'] = self.id,
		['position'] = {x, y},
		['size'] = {w, h},
		['type'] = {'image'},
		['settings'] = {color, image, postGUI},
		['rotation'] = {rX, rY, rZ},
		['parents'] = {},
		['visible'] = true,
 	};
	return self.id
end

function drawButton(text, x, y, w, h, color)
	self.id = #drawArray + 1
	self.size = 1
	drawArray[self.id] = {
		['id'] = self.id,
		['position'] = {x, y},
		['size'] = {w, h},
		['type'] = {'button'},
		['settings'] = {color, text, self.size, DxFont('default', 10)},
		['parents'] = {},
		['visible'] = true,
	};

	return self.id
end

function drawPanel(text, x, y, w, h, color, size, font, closeProperty)
	self.id = #drawArray + 1
	self.font = DxFont(convertFont[font], size*10);
	drawArray[self.id] = {
		['id'] = self.id,
		['position'] = {x, y},
		['size'] = {w, h},
		['type'] = {'panel'},
		['settings'] = {color, text, 1, self.font, closeProperty},	
		['parents'] = {},
		['visible'] = true,
 	};
	return self.id
end

function drawTable(arrayTable, x, y, w, h)
	self.id = #drawArray + 1
	drawArray[self.id] = {
		['id'] = self.id,
		['position'] = {x, y},
		['size'] = {w, h},
		['settings'] = {arrayTable.head, arrayTable.body},
		['type'] = {'grid'},
		['parents'] = {},
		['visible'] = true,
 	};
	return self.id, drawArray[self.id]['selected']
end

function drawBrowser(x, y, w, h, url, isLocal)
	self.id = #drawArray + 1
	self.browser = Browser(ScreenSize.x, ScreenSize.y, isLocal, true)
	attachedBrowsers[self.id] = self.browser;
	self.browser:setData('url', url)
	drawArray[self.id] = {
		['id'] = self.id,
		['position'] = {x, y},
		['size'] = {w, h},
		['settings'] = {url, self.browser},
		['type'] = {'browser'},
		['parents'] = {},
		['visible'] = true,
	};
	return self.id, self.browser
end

function sendJS(html, functionName, ...)
	if (not html) then
		outputDebugString("Browser is not loaded yet, can't send JS.")
		return false
	end

	local js = functionName.."("

	local argCount = #arg
	for i, v in ipairs(arg) do
		local argType = type(v)
		if (argType == "string") then
			js = js.."'"..addslashes(v).."'"
		elseif (argType == "boolean") then
			if (v) then js = js.."true" else js = js.."false" end
		elseif (argType == "nil") then
			js = js.."undefined"
		elseif (argType == "table") then
			--
		elseif (argType == "number") then
			js = js..v
		elseif (argType == "function") then
			js = js.."'"..addslashes(tostring(v)).."'"
		elseif (argType == "userdata") then
			js = js.."'"..addslashes(tostring(v)).."'"
		else
			outputDebugString("Unknown type: "..type(v))
		end

		argCount = argCount - 1
		if (argCount ~= 0) then
			js = js..","
		end
	end
	js = js .. ");"

	executeBrowserJavascript(html, js)
end

function addslashes(s)
	local s = string.gsub(s, "(['\"\\])", "\\%1")
	s = string.gsub(s, "\n", "")
	return (string.gsub(s, "%z", "\\0"))
end

function getSize(elementID)
	if drawArray[elementID] then
		return drawArray[elementID]['size'][1], drawArray[elementID]['size'][2]
	end
	return false
end

function setSize(elementID, w, h)
	if drawArray[elementID] then
		drawArray[elementID]['size'] = {w, h}
		return true
	end
	return false
end

function setPosition(elementID, x, y)
	if drawArray[elementID] then
		drawArray[elementID]['position'] = {x, y}
		return true
	end
	return false
end

function setColor(elementID, r, g, b, a)
	if drawArray[elementID] then
		drawArray[elementID]['settings'][1] = tocolor(r, g, b, a)
		return true
	end
	return false
end

function setText(elementID, text)
	if drawArray[elementID] then
		drawArray[elementID]['settings'][2] = text;
		return true
	end
	return false
end

function setCursor(bool)
	showCursor(bool);
	return true
end

function getPosition(elementID)
	if drawArray[elementID] then
		return drawArray[elementID]['position'][1], drawArray[elementID]['position'][2]
	end
	return false
end

function centerElement(elementID)
	if drawArray[elementID] then
		w, h = getSize(elementID)
		drawArray[elementID]['position'] = {ScreenSize.x/2-w/2, ScreenSize.y/2-h/2}
		return true
	end
	return false
end

function attachArray(elementID, from)
	if drawArray[elementID] and drawArray[from] then
		drawArray[from]['parent'] = elementID;
		table.insert(drawArray[elementID]['parents'], from)
		return true
	end
	return false
end

function updateTable(elementID, table, head)
	if drawArray[elementID] then
		drawArray[elementID]['settings'][2] = table;
		if head then
			drawArray[elementID]['settings'][1] = head;
		end
		return true
	end
	return false
end

function sort(elementID, index)
	if drawArray[elementID] then
		table.sort(drawArray[elementID]['settings'][2], 
			function(a, b)
				idA, idB = a[index], b[index]
				return tonumber(idA) < tonumber(idB)
			end
		)
	end
end

function destroy(elementID)
	if tonumber(elementID) then
		if drawArray[elementID] then
			for index, value in ipairs(drawArray[elementID]['parents']) do
				destroy(value)
				drawArray[value] = nil;
			end
			table.remove(drawArray, elementID)
			return true
		end
	else--CEF
		if attachedBrowsers[elementID] then
			destroyElement(attachedBrowsers[elementID])
			table.remove(drawArray, elementID)
			table.remove(attachedBrowsers, elementID)
			return true
		else
			return false
		end
	end
	return false
end

function isElement(elementID)
	if tonumber(elementID) then
		if drawArray[elementID] then
			return true
		else
			return false
		end
	else
		if isElement(elementID) then
			return true
		else
			return false
		end
	end
end

function getParent(elementID)
	if drawArray[elementID] and drawArray[elementID]['parent'] then
		return drawArray[elementID]['parent']
	end
	return false
end

function getVisible(elementID)
	if drawArray[elementID] then
		return drawArray[elementID]['visible']
	end
	return false
end

function setVisible(elementID, bool)
	if drawArray[elementID] and bool then
		drawArray[elementID]['visible'] = bool
		return true
	end
	return false
end

addEvent('onElementClick', true);
addEventHandler("onClientBrowserCreated", resourceRoot,
	function()
		source:loadURL(source:getData('url'))
	end
)