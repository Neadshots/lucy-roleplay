local animationManagerWindow = nil
local replaceAnimationLabel, playAnimationLabel = nil, nil
local restoreDefaultsButton, stopAnimationButton = nil, nil
local replaceAnimationGridList, playAnimationGridList = nil, nil

local isShowingAnimationBlocksInPlayGridList = true
local currentBlockNameSelected = nil

local isLocalPlayerAnimating = false


addEventHandler("onClientResourceStart", resourceRoot,
    function()
        triggerServerEvent ( "onCustomAnimationSyncRequest", resourceRoot, localPlayer )

        -- load IFP files and add them to the play animation gridlist
        for customAnimationBlockIndex, customAnimationBlock in ipairs ( globalLoadedIfps ) do 
            local ifp = engineLoadIFP ( customAnimationBlock.path, customAnimationBlock.blockName )
            if not ifp then
               -- outputChatBox ("Failed to load '"..customAnimationBlock.path.."'")
            end
        end

    end
) 

local function ReplacePedBlockAnimations ( player, ifpIndex )
    local customIfpBlockName = globalLoadedIfps [ ifpIndex ].blockName
    for _, animationName in pairs ( globalPedAnimationBlock.animations ) do 
        -- make sure that we don't replace a partial animation
        if not globalPedAnimationBlock.partialAnimations [ animationName ] then 
            engineReplaceAnimation ( player, "ped", animationName, customIfpBlockName, animationName )
        end
    end
end 


addEvent("Animasyon:OzelAnim",true)
addEventHandler("Animasyon:OzelAnim",root, function(sira,blok,anim,deger)
	if deger == "Paket" then
		ReplacePedBlockAnimations ( source, sira )
		triggerServerEvent ( "onCustomAnimationReplace", resourceRoot, source, sira )
	elseif deger == "Anim" then	
		setPedAnimation ( source, blok, anim, nil, nil, false, false )
		triggerServerEvent ( "onCustomAnimationSet", resourceRoot, source, blok, anim )
		isLocalPlayerAnimating = true
	end	
end)

addEvent("Animasyon:OzelAnimSifira",true)
addEventHandler("Animasyon:OzelAnimSifira",root, function()
	engineRestoreAnimation ( source, "ped" )
	triggerServerEvent ( "onCustomAnimationRestore", resourceRoot,  source, "ped" )
end)


addEvent ("onClientCustomAnimationSyncRequest", true )
addEventHandler ("onClientCustomAnimationSyncRequest", root,
    function ( playerAnimations )
        for player, anims in pairs ( playerAnimations ) do 
            if isElement ( player ) then 
                if anims.current then 
                    setPedAnimation ( player, anims.current[1], anims.current[2] ) 
                end
                if anims.replacedPedBlock then 
                    ReplacePedBlockAnimations ( player, anims.replacedPedBlock )
                end
            end
        end 
    end 
)

addEvent ("onClientCustomAnimationSet", true )
addEventHandler ("onClientCustomAnimationSet", root,
    function ( blockName, animationName )
        if source == localPlayer then return end
        if blockName == false then 
            setPedAnimation ( source, false )
            return
        end 
        setPedAnimation ( source, blockName, animationName )
    end 
)

addEvent ("onClientCustomAnimationReplace", true )
addEventHandler ("onClientCustomAnimationReplace", root,
    function ( ifpIndex )
        if source == localPlayer then return end
        ReplacePedBlockAnimations ( source, ifpIndex )
    end 
)

addEvent ("onClientCustomAnimationRestore", true )
addEventHandler ("onClientCustomAnimationRestore", root,
    function ( blockName )
        if source == localPlayer then return end
        engineRestoreAnimation ( source, blockName )
    end 
)


setTimer ( 
    function ()
        if isLocalPlayerAnimating then 
            if not getPedAnimation (localPlayer) then
                isLocalPlayerAnimating = false
                triggerServerEvent ( "onCustomAnimationStop", resourceRoot, localPlayer )
            end
        end
    end, 100, 0
)