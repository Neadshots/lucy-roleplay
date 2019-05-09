--By Reventon

function AracYukle502()
    local txd = engineLoadTXD ('Dosyalar/1.txd')
    engineImportTXD(txd,502)
    local dff = engineLoadDFF('Dosyalar/2.dff',502)
    engineReplaceModel(dff,502)
end
addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),AracYukle502)

--By Reventon