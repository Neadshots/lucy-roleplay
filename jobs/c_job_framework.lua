job = 0
localPlayer = getLocalPlayer()

function playerSpawn()
	local logged = getElementData(localPlayer, "loggedin")

	if (logged==1) then
		job = tonumber(getElementData(localPlayer, "job"))
		
		if (job==8) then -- Kamyon
			displayTruck1Job()
		else
			resetTruck1Job()
		end
	end
end
addEventHandler("onClientPlayerSpawn", localPlayer, 
	function()
		setTimer(playerSpawn, 1000, 1)
	end
)

