local secretHandle = 'some_shit_that_is_really_secured'

function changeProtectedElementData(thePlayer, index, newvalue)
	setElementData(thePlayer, index, newvalue)
end

function changeProtectedElementDataEx(thePlayer, index, newvalue, sync, nosyncatall)
	if (thePlayer) and (index) then
		setElementData(thePlayer, index, newvalue)
		return true
	end
	return false
end

function changeEld(thePlayer, index, newvalue)
	if source then thePlayer = thePlayer end
	return setElementData(thePlayer, index, newvalue)
end
addEvent("anticheat:changeEld", true)
addEventHandler("anticheat:changeEld", root, changeEld)

function setEld(thePlayer, index, newvalue, sync)
	if source then thePlayer = thePlayer end
	local sync2 = false
	local nosyncatall = true
	if sync == "one" then
		sync2 = false
		nosyncatall = false
	elseif sync == "all" then
		sync2 = true
		nosyncatall = false
	else
		sync2 = false
		nosyncatall = true
	end
	return changeProtectedElementDataEx(thePlayer, index, newvalue, sync2, nosyncatall)
end
addEvent("anticheat:setEld", true)
addEventHandler("anticheat:setEld", root, setEld)


function genHandle()
	local hash = ''
	for Loop = 1, math.random(5,16) do
		hash = hash .. string.char(math.random(65, 122))
	end
	return hash
end

function fetchH()
	return secretHandle
end

secretHandle = genHandle()