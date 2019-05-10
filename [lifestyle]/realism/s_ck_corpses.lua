mysql = exports.mysql


function loadAllCorpses(res)
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, result in ipairs(res) do
					local res = result["value"]
					local garages = fromJSON( res )
					
					if garages then
						for i = 0, 49 do
							setGarageOpen( i, garages[tostring(i)] )
						end
					else
						outputDebugString( "Failed to load Garage States" )
					end
				end
			end
		end,	
	mysql:getConnection(), "SELECT value FROM settings WHERE name = 'garagestates'")
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllCorpses)