--By Reventon

function AracYukle451()
    local txd = engineLoadTXD ('Dosyalar/1.txd')
    engineImportTXD(txd,588)
    local dff = engineLoadDFF('Dosyalar/2.dff',588)
    engineReplaceModel(dff,588)
end
addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),AracYukle451)

--By Reventon