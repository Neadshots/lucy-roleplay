--By Reventon

function AracYukle494()
    local txd = engineLoadTXD ('Dosyalar/1.txd')
    engineImportTXD(txd,494)
    local dff = engineLoadDFF('Dosyalar/2.dff',494)
    engineReplaceModel(dff,494)
end
addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),AracYukle494)

--By Reventon