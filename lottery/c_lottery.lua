local lotteryPeds = {
	{
		x = "1955.4365234375",
		y = "-1745.015625",
		z = "13.546875",
		rotation = "180",
	},
}

local firstName = { "Michael","Christopher","Matthew","Joshua","Jacob","Andrew","Daniel","Nicholas","Tyler","Joseph","David","Brandon","James","John","Ryan","Zachary","Justin","Anthony","William","Robert", "Dean", "George", "Norman", "Lloyd", "Dennis", "Seymour", "Willie", "Richard", "Bobby", "Jody", "Danny ", "Seth", "Tommy", "Timothy", "Ashley", "Junior"}
local lastName = { "Johnson","Williams","Jones","Brown","Davis","Miller","Wilson","Moore","Taylor","Anderson","Thomas","Jackson","White","Harris","Martin","Thompson","Garcia","Martinez","Robinson","Clark", "Hummer", "Smith", "Touchet", "Trotter", "Nagle", "Dunbar", "Davis", "Grenier", "Duff", "Alston", "Winslow", "Borunda", "Duncan", "Heath", "Keeler", "Skinner", "Daniel", "Layfield", "Decker", "Ames", "Christie" }

function createRandomMaleName()
    local random1 = math.random(1, #firstName)
    local random2 = math.random(1, #lastName)
    local name = firstName[random1].." "..lastName[random2]
    return name
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		for index, value in ipairs(lotteryPeds) do
			ped = createPed(exports["global"]:getRandomSkin(), value.x, value.y, value.z)
			setPedRotation(ped, value.rotation)
			setElementData(ped, "name", createRandomMaleName())
			setElementData(ped, "nametag", true)
			setElementData(ped, "lottery-system:ped", true)
		end
	end
)

addEventHandler("onClientClick", root,
	function(button, state, _, _, _, _, _, element)
		if (button == "right") then
			if element and isElement(element) and getElementType(element) == "ped" and getElementData(element, "lottery-system:ped") then
				if not isElement(window) then
					createExclusiveGUI(getElementData(element, "name"))
				end
			end
		end
	end
)

function createExclusiveGUI(pedname)
	window = guiCreateWindow(0, 0, 350, 250, "Piyango Bileti Satış Noktası - "..pedname, false)
	exports["global"]:centerWindow(window)
	guiWindowSetMovable(window, false)
	guiWindowSetSizable(window, false)

	guiCreateStaticImage(0, 120/2, 128, 128, ":item-system/images/211.png", false, window)
	guiCreateLabel(20, 30, 340, 35, "Los Santos hükümetinin sağladığı piyango biletinden\nsatın alabilirsiniz.", false, window)

	--##lottery info##--
	guiCreateLabel(130, 60, 210, 115, "Bilet detayları:\n\nYapılacak çekilişte toplam 1.000.000$\nödül dağıtılacaktır.\n\nDaha fazla bilet alarak şansınızı\narttırabilirsiniz.", false, window)
	--##lottery info##--

	okButton = guiCreateButton(10, 190, 330, 25, "Bileti Satın Al (1000$)", false, window)
	addEventHandler("onClientGUIClick", okButton,
		function(b)
			if b == "left" then
				if exports["global"]:hasMoney(localPlayer, 1000) then
					destroyElement(window)
					generatedValue = "1"..math.random(100,999).."-"..math.random(1,99)
					triggerServerEvent("lottery-system:giveItem", localPlayer, localPlayer, generatedValue)
				else
					outputChatBox("Piyango bileti alabilmek için yeterli paranız yok!", 255, 0, 0)
				end
			end
		end
	)
	cancelButton = guiCreateButton(10, 218, 330, 25, "İptal", false, window)
	addEventHandler("onClientGUIClick", cancelButton,
		function(b)
			if b == "left" then
				destroyElement(window)
			end
		end
	)
end