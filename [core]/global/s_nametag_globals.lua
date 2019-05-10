local badges = {}
function updateNametagColor(thePlayer)
	if source then thePlayer = source end
	if getElementData(thePlayer, "loggedin") ~= 1 then -- Not logged in
		setPlayerNametagColor(thePlayer, 127, 127, 127, 139)
	elseif exports.integration:isPlayerTrialAdmin(thePlayer) and getElementData(thePlayer, "duty_admin") == 1 and getElementData(thePlayer, "hiddenadmin") == 0 then -- Admin on duty
		setPlayerNametagColor(thePlayer,  194, 54, 22)
	elseif exports.integration:isPlayerSupporter(thePlayer) and (getElementData(thePlayer, "duty_supporter") == 1) and getElementData(thePlayer, "hiddenadmin") == 0 then 
		setPlayerNametagColor(thePlayer, 70, 200, 30)
	else
		setPlayerNametagColor(thePlayer, 255, 255, 255)
	end
	for index, value in pairs(exports["item-system"]:getBadges()) do
		if getElementData(thePlayer, value[1]) then
			setPlayerNametagColor(thePlayer, value[4][1], value[4][2], value[4][3])
		end
	end

end
addEvent("updateNametagColor", true)
addEventHandler("updateNametagColor", getRootElement(), updateNametagColor)
for key, value in ipairs( getElementsByType( "player" ) ) do
	updateNametagColor( value )
end	

function toggleGoldenNametag()
	setElementData(client, "lifeTimeNameTag_on", not getElementData(client, "lifeTimeNameTag_on"), true)
	setElementData(client, "nametag_on", not getElementData(client, "nametag_on"), true)
	updateNametagColor(client)
end
addEvent("global:toggleGoldenNametag", true)
addEventHandler("global:toggleGoldenNametag", getRootElement(), toggleGoldenNametag)