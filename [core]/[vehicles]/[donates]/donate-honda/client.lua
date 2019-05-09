--By Reventon

function AracYukle542()
    local txd = engineLoadTXD ('Dosyalar/1.txd')
    engineImportTXD(txd,542)
    local dff = engineLoadDFF('Dosyalar/2.dff',542)
    engineReplaceModel(dff,542)
end
addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),AracYukle542)

--By Reventon