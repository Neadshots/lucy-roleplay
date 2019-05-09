--By Reventon

function AracYukle496()
    local txd = engineLoadTXD ('Dosyalar/1.txd')
    engineImportTXD(txd,496)
    local dff = engineLoadDFF('Dosyalar/2.dff',496)
    engineReplaceModel(dff,496)
end
addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),AracYukle496)

--By Reventon