x,y,z = 1913.947265625, -1768.1884765625, 13.39999961853
local marker1 = createMarker( x,y,z, "corona", 1, 255, 0, 0 ,170)
local pickup = createPickup( x,y,z, 3, 1210)
data = {}
data.roleplayMSG = outputChatBox
data.rolePlayVeriAl = getElementData
data.rolePlayVeriAyarla = setElementData
data.rolePlayKomutEkle = addCommandHandler
data.rolePlayKomutSil = removeCommandHandler
data.rolePlayYerel = getLocalPlayer

addEventHandler("onClientRender", getRootElement(), data.rolePlayMarkerTextRender)
function jobmarker(thePlayer)
    if thePlayer == getLocalPlayer() then
     data.rolePlayKomutEkle("isbasi", data.roleplayGiveJobPlayer)
   end
 end
addEventHandler("onClientMarkerHit",marker1,jobmarker)

function data.rolePlayMarkerText(TheElement,text,height,distance,R,G,B,alpha,size,font,checkBuildings,checkVehicles,checkPeds,checkDummies,seeThroughStuff,ignoreSomeObjectsForCamera,ignoredElement)
    local x, y, z = getElementPosition(TheElement)
    local x2, y2, z2 = getElementPosition(localPlayer)
    local distance = distance or 20
    local height = height or 1
                                local checkBuildings = checkBuildings or true
                                local checkVehicles = checkVehicles or false
                                local checkPeds = checkPeds or false
                                local checkObjects = checkObjects or true
                                local checkDummies = checkDummies or true
                                local seeThroughStuff = seeThroughStuff or false
                                local ignoreSomeObjectsForCamera = ignoreSomeObjectsForCamera or false
                                local ignoredElement = ignoredElement or nil
    if (isLineOfSightClear(x, y, z, x2, y2, z2, checkBuildings, checkVehicles, checkPeds , checkObjects,checkDummies,seeThroughStuff,ignoreSomeObjectsForCamera,ignoredElement)) then
     local sx, sy = getScreenFromWorldPosition(x, y, z+height)
     if(sx) and (sy) then
      local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
      if(distanceBetweenPoints < distance) then
       dxDrawText(text, sx+2, sy+2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), (size or 1)-(distanceBetweenPoints / distance), font or "arial", "center", "center")
   end
  end
 end
end