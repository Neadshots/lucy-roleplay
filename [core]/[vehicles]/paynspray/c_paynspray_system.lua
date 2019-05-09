function showInvoiceWindow(estimatedCosts)
    if isElement(invoiceWindow) then
        destroyElement(invoiceWindow)
    end

    invoiceWindow = guiCreateWindow(833, 478, 255, 125, "Pay N Spray - Tamir", false)
    exports.global:centerWindow(invoiceWindow)
    guiWindowSetSizable(invoiceWindow, false)
    showCursor(true)

    invoiceLabel = guiCreateLabel(3, 21, 247, 34, "Aracınızın tamiri için belirlenen ücret:\n$"..estimatedCosts.."", false, invoiceWindow)
    guiSetFont(invoiceLabel, "default-bold-small")
    guiLabelSetHorizontalAlign(invoiceLabel, "center", true)

    payInvoiceButton = guiCreateButton(10, 60, 234, 25, "Öde ve Tamir Et", false, invoiceWindow)
    cancelInvoiceButton = guiCreateButton(10, 90, 234, 25, "İptal", false, invoiceWindow) 

    if exports.global:getMoney(localPlayer, true) < estimatedCosts then
        guiSetProperty(payInvoiceButton, "Disabled", "True")
        guiSetText(payInvoiceButton, "Yeterli Paranız Bulunmuyor")
    end

    addEventHandler("onClientGUIClick", root, function(button)
        if source == payInvoiceButton and button == "left" then
            destroyInvoiceWindow()
            triggerServerEvent("pns:PayInvoice", localPlayer, getPedOccupiedVehicle(localPlayer), localPlayer, false, false, estimatedCosts)
        elseif source == cancelInvoiceButton and button == "left" then
            destroyInvoiceWindow()
        end
    end)
end
addEvent("paynspray:Invoice", true)
addEventHandler("paynspray:Invoice", root, showInvoiceWindow)

function destroyInvoiceWindow()
    if isElement(invoiceWindow) then
        destroyElement(invoiceWindow)
        showCursor(false)
    end
end
addEvent("paynspray:destroyInvoice", true)
addEventHandler("paynspray:destroyInvoice", root, destroyInvoiceWindow)
addEventHandler("onClientChangeChar", root, destroyInvoiceWindow)