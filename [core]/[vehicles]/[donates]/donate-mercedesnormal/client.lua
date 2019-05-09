--By Reventon

function AracYukle451()
    local txd = engineLoadTXD ('Dosyalar/1.txd')
    engineImportTXD(txd,451)
    local dff = engineLoadDFF('Dosyalar/2.dff',451)
    engineReplaceModel(dff,451)
end
addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),AracYukle451)

--By Reventon