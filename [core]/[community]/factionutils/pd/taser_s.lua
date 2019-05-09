local shockedTimer = {}

function shockPlayer(player)
    if isTimer(shockedTimer[player]) then return end
    setElementData(player,"teaser:inTeaser",true)
     outputChatBox("[!]#ffffff Tazer kartuşu yediğin için hareket edemezsin.",player,0,255,0,true)
    shockedTimer[player] = setTimer(function(player)
        applyAnimation( player, nil,nil)
        setElementData(player,"teaser:inTeaser",false)
        toggleAllControls(player,true)
       
    end,1000*60,1,player)
    toggleAllControls(player,false)
    applyAnimation( player, "ped", "FLOOR_hit", -1, false, false, false)
end
addEvent("taser->Target",true)
addEventHandler("taser->Target",root,shockPlayer)

function applyAnimation(player, block, anim, time, canLoop, fixPos, interupt)
    setPedAnimation(player, block, anim, time, canLoop, fixPos, interupt)
end

function removeTaser(player,cmd,target)
    if getElementData(player,"loggedin") == 1 and exports.integration:isPlayerTrialAdmin(player) or (getElementData(player,"faction") == 1) then
        if target then
            found = exports.global:findPlayerByPartialNick(player, target)
            if found then
                outputChatBox("[!]#ffffff Kullanıcının tazer kartuşu çıkartıldı! Hemen müdahale et.",player,0,255,0,true)
                applyAnimation( found, nil,nil)
                setElementData(found,"teaser:inTeaser",false)
                toggleAllControls(found,true)
                if isTimer(shockedTimer[found]) then
                    killTimer(shockedTimer[found])
                end
            end
        else
            outputChatBox("[!]#ffffff /"..cmd.." id",player,0,255,0,true)
        end
    end
end
addCommandHandler("tazerkaldır",removeTaser)
addCommandHandler("taserkaldır",removeTaser)
addCommandHandler("taserkaldir",removeTaser)
addCommandHandler("tazerkaldir",removeTaser)

addCommandHandler("tazer",
	function(player, cmd)
		if getElementData(player, "loggedin") == 1 and getElementData(player, "faction") == 1 then
			teaserUsing = getElementData(player, "teaser:usingTeaser")
			setElementData(player, "teaser:usingTeaser", not teaserUsing)
			if getElementData(player, "teaser:usingTeaser") then--kullanıyorsa,
				local mySerial = exports.global:createWeaponSerial( 1, getElementData(player, "dbid"), getElementData(player, "dbid"))
				local serial = "23:"..mySerial..":"..getWeaponNameFromID(23).."::"
				setElementData(player, "teaser:usingSerial", serial)
				local ammoCap = "23:15:Ammo for "..getWeaponNameFromID(23)
				setElementData(player, "teaser:usingAmmo", ammoCap)
				give, error = exports.global:giveItem(player, 115, serial)

				exports.global:giveItem(player, 116, ammoCap)
				outputChatBox(exports.pool:getServerSyntax(false, "s").."Tazer başarıyla envantere verildi.", player, 255, 255, 255, true)
			else
				--exports.global:takeItem(player, 116, getElementData(player, "teaser:usingAmmo"))
				exports.global:takeItem(player, 115, getElementData(player, "teaser:usingSerial"))
				outputChatBox(exports.pool:getServerSyntax(false, "s").."Tazer başarıyla alındı.", player, 255, 255, 255, true)
			end
		end
	end
)