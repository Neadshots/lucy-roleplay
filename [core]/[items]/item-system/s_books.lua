function startBook(id, slot)
	if not tonumber(id) then 
		outputChatBox("Error, BK#01. Report on bugs.owlgaming.net", client, 255, 0, 0)
		return
	end
	dbQuery(
		function(qh, client)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					if row then
						triggerClientEvent(client, "PlayerBook", client, row.title, row.author, row.book, row.readOnly, slot, id)
					else
						triggerClientEvent(client, "PlayerBook", client, false, false, "Error, BK#02: Issue fetching book data! Report @ bugs.owlgaming.net")
					end
				end
			end
		end,
	{client}, mysql:getConnection(), "SELECT title, author, book, readOnly FROM books WHERE id=".. (id))
end
addEvent("books:beginBook", true)
addEventHandler("books:beginBook", getRootElement(), startBook)
function setData(id, title, author, book, readOnly)
	if not tonumber(id) then 
		return
	end

	if readOnly then
		readOnly = 1
	else
		readOnly = 0
	end
	if readOnly == 1 then
		triggerEvent("sendAme", client, "closes ".. title .. " and clicks his pen.")
	end
	local query = dbExec(mysql:getConnection(), "UPDATE books SET title='".. (title) .."', author='".. (author) .."', book='".. (book) .."', readOnly=".. readOnly .. " WHERE id=".. id)
end
addEvent("books:setData", true)
addEventHandler("books:setData", getRootElement(), setData)