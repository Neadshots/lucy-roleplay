emekleyenler = {}

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
     if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
          local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
          if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
               for i, v in ipairs( aAttachedFunctions ) do
                    if v == func then
        	         return true
        	    end
	       end
	  end
     end
     return false
end

function change()--animasyonu sıfırlama
	setPedAnimationProgress(localPlayer, "car_crawloutrhs", 0)
end

function degistir()
if getElementData(localPlayer, "Emekleme") == true then
	local x, y, z, x1, y1, z1 = getCameraMatrix ( localPlayer ) 
                    local rx, ry, rz = findRotation(x, y, x1, y1) 
	                setElementRotation(localPlayer,0,0,rx+90)
end
end
function render()--rotasyon
	setPedAnimationProgress(localPlayer, "car_crawloutrhs", 0)
end

	
function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end	
	
function render2()
	-- local cam = getCamera()
	-- local x,y,z = getElementRotation(cam)
	-- setElementRotation(localPlayer,0,0,z+90)
	local x, y, z, x1, y1, z1 = getCameraMatrix ( localPlayer ) 
    local rx, ry, rz = findRotation(x, y, x1, y1) 
	setElementRotation(localPlayer,0,0,rx+90) 
end


keys = {
["w"] = "forwards",
}

addEventHandler("onClientKey", root, function(key,press)
	if keys[key] then
		if emekleyenler[localPlayer] then
			if getKeyState(key) then
				setElementFrozen(localPlayer, false)
				setPedControlState(localPlayer, keys[key], true)
				
				if not isTimer(timer) and not isTimer(timertwo) then 
					setPedAnimation(localPlayer, "ped", "car_crawloutrhs") 
					timer = setTimer(change,600,0) 
					--timertwo = setTimer(degistir,150,0) 
				end
				if not isTimer(timertwo) then 
				timertwo = setTimer(degistir,150,0) 
				end
				removeEventHandler("onClientRender",root,render,true,"low")
				--removeEventHandler("onClientRender",root,render2,true,"low")
			else
				for i,v in pairs(keys) do if getKeyState(i) then return end end
				setPedControlState(localPlayer, keys[key], false)
				setElementFrozen(localPlayer, true)
				if isTimer(timer) then killTimer(timer) end
				if isTimer(timertwo) then killTimer(timertwo) end
				setPedAnimation(localPlayer, "ped", "car_crawloutrhs")
				--if isEventHandlerAdded( 'onClientRender', root, render) then return end
				addEventHandler("onClientRender",root,render,true,"low")
				--if isEventHandlerAdded( 'onClientRender', root, render2) then return end
				--addEventHandler("onClientRender",root,render2,true,"low")
			end	
		end	
	end
end)


function changeCheck(oyuncu)
	if isElement(oyuncu) and getPedControlState(oyuncu, "forwards") then
		--outputChatBox(getPlayerName(oyuncu))
		setPedAnimationProgress(oyuncu, "car_crawloutrhs", 0)
	end	
end

local timer2 = {}
function emekletRender()
	local x,y,z = getElementPosition(localPlayer)
	for i,oyuncu in pairs(emekleyenler) do
		if isElement(oyuncu) then
			--local px,py,pz = getElementPosition(oyuncu)
			--if getDistanceBetweenPoints3D(x,y,z,px,py,pz) <= 30 then
				local blok, anim = getPedAnimation(oyuncu)
				
				if blok ~= "ped" and anim ~= "car_crawloutrhs" then
					setPedAnimation(oyuncu, "ped", "car_crawloutrhs")
				end
				
				if getPedControlState(oyuncu, "forwards") then
					if not isTimer(timer2[oyuncu]) then 
						if oyuncu ~= localPlayer then
							timer2[oyuncu] = setTimer(changeCheck,600,0,oyuncu) 
						end	
					end
				else
					if isTimer(timer2[oyuncu]) then killTimer(timer2[oyuncu]) end
					setPedAnimationProgress(oyuncu, "car_crawloutrhs", 0)
				end	
			--end	
		end
	end
end
addEventHandler("onClientRender",root,emekletRender)

addEvent("Emekleme:Emeklet", true)
addEventHandler("Emekleme:Emeklet", root, function(deger)
	if deger == "Ekle" then
		emekleyenler[source] = source
		setElementData(source, "Emekleme",true)
		setPedAnimation(source, "ped", "car_crawloutrhs")
		setElementFrozen(source, true)
		--addEventHandler("onClientRender",root,render,true,"low")
	elseif deger == "Kaldır" then	
		if emekleyenler[source] then emekleyenler[source] = nil end
		removeEventHandler("onClientRender",root,render,true,"low")
		removeEventHandler("onClientRender",root,render2,true,"low")
		setElementFrozen(source, false)
		setElementData(source, "Emekleme",nil)
		setPedAnimation(source, "", "")
	end	
end)


addEventHandler( "onClientElementStreamIn", root, function()
	if getElementType(source) == "player" and emekleyenler[source] then
		setPedAnimation(source, "ped", "car_crawloutrhs")
	end
end)


triggerServerEvent("Emekleme:OyuncuGirdi", localPlayer)
