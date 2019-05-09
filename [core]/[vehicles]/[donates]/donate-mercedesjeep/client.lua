--By Reventon

function AracYukle458()
    local txd = engineLoadTXD ('Dosyalar/1.txd')
    engineImportTXD(txd,458)
    local dff = engineLoadDFF('Dosyalar/2.dff',458)
    engineReplaceModel(dff,458)
end
addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),AracYukle458)

--By Reventon