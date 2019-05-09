local scoreboardDummy

addEventHandler ( "onResourceStart", getResourceRootElement(getThisResource()), function ()
	scoreboardDummy = createElement ( "scoreboard" )
	setElementData ( scoreboardDummy, "serverName", " LUCY RPG - www.lucyrpg.com - Wilden Your World" )
	setElementData ( scoreboardDummy, "maxPlayers", getMaxPlayers () )
	setElementData ( scoreboardDummy, "allow", true )
end, false )

addEventHandler ( "onResourceStop", getResourceRootElement(getThisResource()), function ()
	if scoreboardDummy then
		destroyElement ( scoreboardDummy )
	end
end, false )
