--By Reventon

function AracYukle503()
    local txd = engineLoadTXD ('Dosyalar/1.txd')
    engineImportTXD(txd,503)
    local dff = engineLoadDFF('Dosyalar/2.dff',503)
    engineReplaceModel(dff,503)
end
addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),AracYukle503)

--By Reventon