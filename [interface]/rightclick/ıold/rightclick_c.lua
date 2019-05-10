rcmenu = false
local rcWidth = 0
local rcHeight = 0

local arrayCache = {}
local sx, sy = guiGetScreenSize()
local font = dxCreateFont(":item-system/Roboto.ttf", 10)

function destroy()
	destroyTimer = nil
	exports.gatekeepers:cursorFix()
	if rcmenu then
		destroyElement(rcmenu)
		arrayCache[rcmenu] = nil
	end
	rcWidth = 0
	rcHeight = 0
	rcmenu = nil
	if isCursorShowing() then
		showCursor(false)
		--triggerEvent("cursorHide", getLocalPlayer())
	end
	return true
end

function isrcOpen()
	return rcmenu
end


function leftClickAnywhere(button, state, absX, absY, wx, wy, wz, element)
	if(button == "left" and state == "down") then
		if isElement(rcmenu) then
			destroyTimer = setTimer(destroy, 250, 1) --100
			--guiSetVisible(rcmenu, false)
		end
	end
end
addEventHandler("onClientClick", getRootElement(), leftClickAnywhere, true)
addEvent("serverTriggerLeftClick", true)
addEventHandler("serverTriggerLeftClick", localPlayer, leftClickAnywhere)

function create(title)
	if(destroyTimer) then
		killTimer(destroyTimer)
		destroyTimer = nil
	end
	if(rcmenu) then
		destroy()
	end
	if not title then title = "" end
	local x,y,wx,wy,wz = getCursorPosition()
	if type(x) == 'boolean' then
		x = 0.5
		y = 0.5
	end
	rcmenu = guiCreateStaticImage(x,y,0,0,"0_a90.png",true)


	guiSetAlpha(rcmenu, 0)


	rcWidth = dxGetTextWidth(title, 1, font) + 20
	rcHeight = 22
	guiSetSize(rcmenu,rcWidth,rcHeight,false)
	arrayCache[rcmenu] = {
		['pos'] = {x*sx, y*sy},
		['size'] = {rcWidth, rcHeight},
		['text'] = title,
		['childs'] = {},
	};
	
	return rcmenu
end

function addRow(title,header,nohover)
	local row
	local image
	if not title then title = "" end
	if header then
		local rowbg = guiCreateStaticImage(0,rcHeight,500,25,"0.png",false,rcmenu)
		local textX = 10+19+10 --margin+img+margin
		local addWidth = textX + 10
		row = guiCreateLabel(textX,0,0,0,tostring(title),false,rowbg)
		guiSetFont(row,"default-bold-small")
		guiLabelSetColor(row,255,255,255)
		guiLabelSetVerticalAlign(row, "center")
		local extent = guiLabelGetTextExtent(row)
		guiSetSize(row,extent,25,false)
		guiSetAlpha(rowbg, 0)
		rcHeight = rcHeight + 25
		if(extent + addWidth > rcWidth) then
			rcWidth = extent + addWidth + 10
		end
		guiSetSize(rcmenu,rcWidth,rcHeight+5,false)
	else
		local textX = 10+19+10 --margin+img+margin
		local addWidth = textX + 5
		row = guiCreateLabel(textX,rcHeight,0,0,tostring(title),false,rcmenu)
		guiLabelSetVerticalAlign(row, "center")

		local extent = guiLabelGetTextExtent(row)
		guiSetSize(row,extent,25,false)
		rcHeight = rcHeight + 25
		if(extent + addWidth > rcWidth) then
			rcWidth = extent + addWidth + 10
		end
		guiSetSize(rcmenu,rcWidth,rcHeight+5,false)
		guiSetAlpha(row, 0)
	end

	-- make sure the menu fits on the screen still.
	local posX, posY = guiGetPosition(rcmenu, false)
	local menuWidth, menuHeight = guiGetSize(rcmenu, false)
	local screenWidth, screenHeight = guiGetScreenSize()
	posX = math.max(0, math.min(posX, screenWidth - menuWidth))
	posY = math.max(0, math.min(posY, screenHeight - menuHeight))
	guiSetPosition(rcmenu, posX, posY, false)

	arrayCache[rcmenu]["childs"][#arrayCache[rcmenu]["childs"] + 1] = {
		['text'] = title,
	}

	return row
end

function addrow(title,header,nohover)
	return addRow(title,header,nohover)
end


addEventHandler("onClientRender", root,
	function()
		for index, value in pairs(arrayCache) do
			if not isElement(index) then
				arrayCache[index] = nil
				exports.gatekeepers:cursorFix()
				break
			end
			x, y = unpack(value['pos'])
			w, h = guiGetSize(index, false)
			
			dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 80))
			w, h = w-4, h-4
			x, y = x+2, y+2
			dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 80))
			dxDrawRectangle(x, y, w, 20, tocolor(0, 0, 0, 80))
			dxDrawText(value['text'], x, y, w+x, 20+y, tocolor(225, 225, 225), 1, font, "center", "center")
			y_offset = 0
			for count, data in ipairs(value['childs']) do
				if count % 2 ~= 0 then
					dxDrawRectangle(x, y+20+y_offset, w, 25, tocolor(0, 0, 0, 160))
				else
					dxDrawRectangle(x, y+20+y_offset, w, 25, tocolor(0, 0, 0, 120))
				end
				if isInSlot(x, y+20+y_offset, w, 25) then
					dxDrawRectangle(x, y+20+y_offset, w, 25, tocolor(0, 0, 0, 120))
				end
		

				dxDrawText(data['text'], x, y+20+y_offset, w+x, 25+(y+20+y_offset), tocolor(200, 200, 200), 1, font, "center", "center")
				y_offset = y_offset + 25
			end
		end
	end
)

function isInSlot(xS, yS, wS, hS)
	if(isCursorShowing()) then
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*sx, cursorY*sy
		if(cursorX >= xS and cursorX <= xS+wS and cursorY >= yS and cursorY <= yS+hS) then
			return true
		else
			return false
		end
	end	
end