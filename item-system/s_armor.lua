
--aclGroupAddObject( aclGetGroup( "Admin" ), "user.ahmedo01" )

function updateArmorVal(val)
	local thePlayer = source
	local items = getItems( thePlayer ) -- [] [1] = itemID [2] = itemValue
	local found = false
	for _, itemCheck in ipairs(items) do
		if (itemCheck[1] == 162) then -- Weapon
			found = true
			takeItem(client, 162)
			if not((not tonumber(val)) or (val == 0)) then
				giveItem(client, 162, math.ceil(tonumber(val) or 0))
			end
		end
	end
	if not found then
		setPedArmor(client,0)
	end
end
addEvent("items.updateArmor",true)
addEventHandler("items.updateArmor",root,updateArmorVal)