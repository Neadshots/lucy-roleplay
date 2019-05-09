function getPositionInfront(element)
	local x, y, z = getElementPosition ( element )
	local a,b,r = getElementRotation ( element )
	local x = x - math.sin ( math.rad(r) ) * 0.9
	local y = y + math.cos ( math.rad(r) ) * 0.9
	return x,y,z
end

function isPlayerNearObject(thePlayer, object)
	local pX, pY, pZ = getElementPosition(object)
	local oX, oY, oZ = getElementPosition(thePlayer)
	local distance = getDistanceBetweenPoints3D(pX, pY, pZ, oX, oY, oZ)
	if ( distance < 3 ) then
		return true
	end
	return false
end