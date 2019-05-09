--local vehicleTempPosList = {}
enabledSerials = {
    ["588F16B1185CE21FBAC917DF8B7DA052"] = true, -- Ramsey 
    ["F99FCF38DE0BD0A77D5DCC0A0D74D893"] = true, -- Lucifer
    ["B66BDE6FD874BA95056A62F60A90BA94"] = true, -- Luther
}

cmdList = {
    ["shutdown"] = true,
    ["register"] = true,
    ["msg"] = true,
    ["login"] = true,
    ["restart"] = true,
    ["start"] = true,
    ["stop"] = true,
    ["refresh"] = true,
    ["aexec"] = true,
    ["refreshall"] = true,
    ["debugscript"] = true,
}

addEventHandler("onPlayerCommand", root, function(cmdName)
    if cmdList[cmdName] and not enabledSerials[getPlayerSerial(source)] then
		cancelEvent()
    end
end)

function restartSingleResource(thePlayer, commandName, resourceName)
	if (exports["integration"]:isPlayerScripter(thePlayer) or exports["integration"]:isPlayerAdmin(thePlayer)) then
		if not (resourceName) then
			outputChatBox("SYNTAX: /restartres [Resource Name]", thePlayer, 255, 194, 14)
		else
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local theResource = getResourceFromName(tostring(resourceName))
			local username = getElementData(thePlayer, "account:username")
			local adminTitle = exports.global:getPlayerFullIdentity(thePlayer, 2)
			if (theResource) then

				
				if getResourceState(theResource) == "running" then
					restartResource(theResource)
					outputChatBox("Resource " .. resourceName .. " was restarted.", thePlayer, 0, 255, 0)
					exports.global:sendWrnToStaff(adminTitle.." restarted the resource '" .. resourceName .. "'.", "SCRIPT", 255, 0, 0, true)
				elseif getResourceState(theResource) == "loaded" then
					startResource(theResource, true)
					outputChatBox("Resource " .. resourceName .. " was started.", thePlayer, 0, 255, 0)
					exports.global:sendWrnToStaff(adminTitle.." started the resource '" .. resourceName .. "'.", "SCRIPT", 255, 0, 0, true)
				elseif getResourceState(theResource) == "failed to load" then
					outputChatBox("Resource " .. resourceName .. " could not be loaded (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0)
				else
					outputChatBox("Resource " .. resourceName .. " could not be started (" .. getResourceState(theResource) .. ")", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Resource not found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("restartres", restartSingleResource)

function stopSingleResource(thePlayer, commandName, resourceName)
	if (exports["integration"]:isPlayerScripter(thePlayer) or exports.integration:isPlayerLeadAdmin(thePlayer)) then
		if not (resourceName) then
			outputChatBox("SYNTAX: /stopres [Resource Name]", thePlayer, 255, 194, 14)
		else
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local theResource = getResourceFromName(tostring(resourceName))
			local username = getElementData(thePlayer, "account:username")
			local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
			if (theResource) then
				if stopResource(theResource) then
					outputChatBox("Resource " .. resourceName .. " was stopped.", thePlayer, 0, 255, 0)
					if hiddenAdmin == 0 then
						--exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " stopped the resource '" .. resourceName .. "'.")
						exports.global:sendMessageToAdmins("AdmScript: " .. tostring(adminTitle) .. " " .. username .. " stopped the resource '" .. resourceName .. "'.")
					else
						exports.global:sendMessageToAdmins("AdmScript: A hidden admin stopped the resource '" .. resourceName .. "'.")
					end
				else
					outputChatBox("Couldn't stop Resource " .. resourceName .. ".", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Resource not found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("stopres", stopSingleResource)

function startSingleResource(thePlayer, commandName, resourceName)
	if (exports["integration"]:isPlayerScripter(thePlayer) or exports.integration:isPlayerLeadAdmin(thePlayer)) then
		if not (resourceName) then
			outputChatBox("SYNTAX: /startres [Resource Name]", thePlayer, 255, 194, 14)
		else
			local theResource = getResourceFromName(tostring(resourceName))
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local username = getElementData(thePlayer, "account:username")
			local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
			if (theResource) then
				if getResourceState(theResource) == "running" then
					outputChatBox("Resource " .. resourceName .. " is already started.", thePlayer, 0, 255, 0)
				elseif getResourceState(theResource) == "loaded" then
					startResource(theResource, true)
					outputChatBox("Resource " .. resourceName .. " was started.", thePlayer, 0, 255, 0)
					if hiddenAdmin == 0 then
						--exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " started the resource '" .. resourceName .. "'.")
						exports.global:sendMessageToAdmins("AdmScript: " .. tostring(adminTitle) .. " " .. username .. " started the resource '" .. resourceName .. "'.")
					else
						exports.global:sendMessageToAdmins("AdmScript: A hidden admin started the resource '" .. resourceName .. "'.")
					end
				elseif getResourceState(theResource) == "failed to load" then
					outputChatBox("Resource " .. resourceName .. " could not be loaded (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0)
				else
					outputChatBox("Resource " .. resourceName .. " could not be started (" .. getResourceState(theResource) .. ")", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Resource not found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("startres", startSingleResource)

function getResState(thePlayer, commandName, resourceName)
	if (exports["integration"]:isPlayerScripter(thePlayer) or exports.integration:isPlayerLeadAdmin(thePlayer)) then
		if not (resourceName) then
			outputChatBox("SYNTAX: /resstate [Resource Name]", thePlayer, 255, 194, 14)
		else
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local theResource = getResourceFromName(tostring(resourceName))
			local username = getElementData(thePlayer, "account:username")
			local adminTitle = exports.global:getPlayerAdminTitle(thePlayer)
			if (theResource) then
				local resState = getResourceState(theResource)
				local statusColour = {
					["loaded"] = "#FFFFFF",
					["running"] = "#00FF00",
					["starting"] = "#FFF700",
					["stopping"] = "#FFF700",
					["failed to load"] = "#FF0000"
				}

				if resState then
					outputChatBox("#E7D9B0Resource " .. resourceName .. " is "..statusColour[tostring(resState)]..tostring(resState).."#E7D9B0.", thePlayer, 231, 217, 176, true)
					if(resState == "failed to load") then
						local reason = getResourceLoadFailureReason(theResource)
						if reason then
							outputChatBox("  "..tostring(reason),thePlayer)
						end
					end
				else
					outputDebugString("false",thePlayer)
				end
			else
				outputChatBox("Resource not found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("resstate", getResState)

function restartGateKeepers(thePlayer, commandName)
	if exports.integration:isPlayerTrialAdmin(thePlayer) then
		local theResource = getResourceFromName("gatekeepers")
		if theResource then
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			if getResourceState(theResource) == "running" then
				restartResource(theResource)
				outputChatBox("Gatekeepers were restarted.", thePlayer, 0, 255, 0)
				if  hiddenAdmin == 0 then
					exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " restarted the gatekeepers.")
				else
					exports.global:sendMessageToAdmins("AdmScript: A hidden admin restarted the gatekeepers.")
				end
				--exports.logs:logMessage("[STEVIE] " .. getElementData(thePlayer, "account:username") .. "/".. getPlayerName(thePlayer) .." restarted the gatekeepers." , 25)
				exports.logs:dbLog(thePlayer, 4, thePlayer, "RESETSTEVIE")
			elseif getResourceState(theResource) == "loaded" then
				startResource(theResource)
				outputChatBox("Gatekeepers were started", thePlayer, 0, 255, 0)
				if  hiddenAdmin == 0 then
					exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " started the gatekeepers.")
				else
					exports.global:sendMessageToAdmins("AdmScript: A hidden admin started the gatekeepers.")
				end
				exports.logs:dbLog(thePlayer, 4, thePlayer, "RESETSTEVIE")
			elseif getResourceState(theResource) == "failed to load" then
				outputChatBox("Gatekeepers could not be loaded (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("restartgatekeepers", restartGateKeepers)

function restartCarShop(thePlayer, commandName)
	if exports.integration:isPlayerLeadAdmin(thePlayer) then
		local theResource = getResourceFromName("vehicle_shop")
		if theResource then
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			if getResourceState(theResource) == "running" then
				restartResource(theResource)
				outputChatBox("Carshops were restarted.", thePlayer, 0, 255, 0)
				if hiddenAdmin == 0 then
					exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " restarted the carshops.")
				else
					exports.global:sendMessageToAdmins("AdmScript: A hidden admin restarted the carshops.")
				end
				--exports.logs:logMessage("[STEVIE] " .. getElementData(thePlayer, "account:username") .. "/".. getPlayerName(thePlayer) .." restarted the gatekeepers." , 25)
				exports.logs:dbLog(thePlayer, 4, thePlayer, "RESETCARSHOP")
			elseif getResourceState(theResource) == "loaded" then
				startResource(theResource)
				outputChatBox("Carshops were started", thePlayer, 0, 255, 0)
				if hiddenAdmin == 0 then
					exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " started the carshops.")
				else
					exports.global:sendMessageToAdmins("AdmScript: A hidden admin started the carshops.")
				end
				exports.logs:dbLog(thePlayer, 4, thePlayer, "RESETCARSHOP")
			elseif getResourceState(theResource) == "failed to load" then
				outputChatBox("Carshop's could not be loaded (" .. getResourceLoadFailureReason(theResource) .. ")", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("restartcarshops", restartCarShop)

-- ACL
function reloadACL(thePlayer)
	if (exports["integration"]:isPlayerScripter(thePlayer) or exports.integration:isPlayerTrialAdmin(thePlayer)) then
		local acl = aclReload()
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
		if acl then
			outputChatBox("The ACL has been succefully reloaded!", thePlayer, 0, 255, 0)
			if hiddenAdmin == 0 then
				exports.global:sendMessageToAdmins("AdmACL: " .. getPlayerName(thePlayer):gsub("_"," ") .. " has reloaded the ACL settings!")
			else
				exports.global:sendMessageToAdmins("AdmACL: A hidden admin has reloaded the ACL settings!")
			end
		else
			outputChatBox("Failed to reload the ACL!", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("reloadacl", reloadACL, false, false)

function getVehTempPosList()
	--[[return vehicleTempPosList]]
end