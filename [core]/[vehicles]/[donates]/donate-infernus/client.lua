--By Reventon

function AracYukle411()
    local txd = engineLoadTXD ('Dosyalar/1.txd')
    engineImportTXD(txd,411)
    local dff = engineLoadDFF('Dosyalar/2.dff',411)
    engineReplaceModel(dff,411)
end
addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),AracYukle411)

--By Reventon