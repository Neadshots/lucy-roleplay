texShader = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/2222.png")
dxSetShaderValue(texShader,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader,"concretemanky")

removeWorldModel(4215,1000,1776.42163,-1775.17102, 3.54053)

texShader1 = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/tabela.png")
dxSetShaderValue(texShader1,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader1,"randysign1_256")

texShader2 = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/tabela2.png")
dxSetShaderValue(texShader2,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader2,"randysign2_256")


texShader3 = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/banka.png")
dxSetShaderValue(texShader3,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader3,"sfe_arch8")

texShader4 = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/2222.png")
dxSetShaderValue(texShader4,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader4,"greyground256128")

texShader5 = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/lsbankgiris.png")
dxSetShaderValue(texShader5,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader5,"zombotech1")

texShader6 = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/lsbankafis.png")
dxSetShaderValue(texShader6,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader6,"zombotech2")

texShader7 = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/lsbankkampanya.png")
dxSetShaderValue(texShader7,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader7,"zombotech3")


texShader8 = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/hangar.png")
dxSetShaderValue(texShader8,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader8,"garage_docks")

texShader9 = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/zemin.jpg")
dxSetShaderValue(texShader9,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader9,"sam_camo")


texShader10 = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/zemin.jpg")
dxSetShaderValue(texShader10,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader10,"bonyrd_skin2")



texShader11 = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/2222.png")
dxSetShaderValue(texShader11,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader11,"Grass_lawn_128HV")


texShader12 = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/2222.png")
dxSetShaderValue(texShader12,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader12,"tenniscourt1_256")

texShader13 = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/2222.png")
dxSetShaderValue(texShader13,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader13,"grassdeep256")


texShader14 = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/pavyonzemin.png")
dxSetShaderValue(texShader14,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader14,"LoadingDoorClean")

texShader15 = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/pavyonduvar.png")
dxSetShaderValue(texShader15,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader15,"ws_garagedoor2_blue")

texShader16 = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/marijuanaparkgang.png")
dxSetShaderValue(texShader16,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader16,"temple")

texShader17 = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/cityhallfloor.jpg")
dxSetShaderValue(texShader17,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader17,"Was_scrpyd_wall_in_hngr")

texShader18 = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/cityhallwall.jpg")
dxSetShaderValue(texShader18,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader18,"Was_swr_wall_blue")

texShader19 = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/cityhallwall.jpg")
dxSetShaderValue(texShader19,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader19,"ballydoor01_128")

texShader20 = dxCreateShader ( "shader/texreplace.fx" )

Shader = dxCreateTexture("generic/cityhalllogo.png")
dxSetShaderValue(texShader20,"gTexture",Shader)
engineApplyShaderToWorldTexture(texShader20,"CJ_DS_light")


--------------------------------------------------------
---------------------MODELLER BURDAN SONRA--------------
--------------------------------------------------------

function models()
    local txd = engineLoadTXD ('models/bassguitar01.txd')
    engineImportTXD(txd,3112)
    local dff = engineLoadDFF('models/bassguitar01.dff',3112)
    engineReplaceModel(dff,3112)
    local col = engineLoadCOL('models/bassguitar01.col')
    engineReplaceCOL(col,3112)
---------------------------------------------------------- 
    local txd1 = engineLoadTXD ('models/dr_gsstudio.txd')
    engineImportTXD(txd1,1246)
    local dff1 = engineLoadDFF('models/DrumKit1.dff',1246)
    engineReplaceModel(dff1,1246)
    local col1 = engineLoadCOL('models/DrumKit1.col')
    engineReplaceCOL(col1,1246)  
----------------------------------------------------------  
    local txd2 = engineLoadTXD ('models/dr_gsstudio.txd')
    engineImportTXD(txd2,3785)
    local dff2 = engineLoadDFF('models/GuitarAmp5.dff',3785)
    engineReplaceModel(dff2,3785)
    local col2 = engineLoadCOL('models/GuitarAmp5.col')
    engineReplaceCOL(col2,3785)      
---------------------------------------------------------- 
    local txd3 = engineLoadTXD ('models/Microphone1.txd')
    engineImportTXD(txd3,3082)
    local dff3 = engineLoadDFF('models/Microphone1.dff',3082)
    engineReplaceModel(dff3,3082)
    local col3 = engineLoadCOL('models/Microphone1.col')
    engineReplaceCOL(col3,3082)  
----------------------------------------------------------  
    local txd4 = engineLoadTXD ('models/Microphone1.txd')
    engineImportTXD(txd4,3078)
    local dff4 = engineLoadDFF('models/MicrophoneStand1.dff',3078)
    engineReplaceModel(dff4,3078)
    local col4 = engineLoadCOL('models/MicrophoneStand1.col')
    engineReplaceCOL(col4,3078)          
----------------------------------------------------------  
    local txd5 = engineLoadTXD ('models/ciggyx.txd')
    engineImportTXD(txd5,3063)
    local dff5 = engineLoadDFF('models/ciggy.dff',3063)
    engineReplaceModel(dff5,3063)                                           
end
addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),models)

