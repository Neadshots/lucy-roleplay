--By Reventon

function AracYukle490()
    local txd = engineLoadTXD ('Dosyalar/1.txd')
    engineImportTXD(txd,490)
    local dff = engineLoadDFF('Dosyalar/2.dff',490)
    engineReplaceModel(dff,490)
end
addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),AracYukle490)

--By Reventon