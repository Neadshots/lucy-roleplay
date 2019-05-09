addEvent("load.commands", true)
addEventHandler("load.commands", root,
	function(data)
		outputChatBox(" Kapatmak için /commandsclose", 255, 0, 0)
		window = guiCreateWindow(0, 0, 276, 439, "Sunucudaki Komutlar", false)
        guiWindowSetSizable(window, false)
        exports.global:centerWindow(window)

        grid = guiCreateGridList(9, 30, 257, 378, false, window)
        g1 = guiGridListAddColumn(grid, "Sistem Adı", 0.5)
        g2 = guiGridListAddColumn(grid, "Komut", 0.5) 
		for index, value in pairs(data) do
			local row = guiGridListAddRow(grid)
			guiGridListSetItemText ( grid, row, g1, value[1], false, false)

			guiGridListSetItemText ( grid, row, g2, value[2], false, false)
		end
		addCommandHandler("commandsclose",
			function()
				destroyElement(window)
			end
		)
	end
)