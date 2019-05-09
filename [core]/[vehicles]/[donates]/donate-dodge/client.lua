--By Reventon

function AracYukle604()
    local txd = engineLoadTXD ('Dosyalar/1.txd')
    engineImportTXD(txd,604)
    local dff = engineLoadDFF('Dosyalar/2.dff',604)
    engineReplaceModel(dff,604)
end
addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),AracYukle604)

--By Reventon