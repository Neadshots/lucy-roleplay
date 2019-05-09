--fakevideo
--Script allows replacing textures in the game with a range of remote pictures to make animated textures
--Created by Exciter, 21.06.2014 (DD.MM.YYYY).
--Based upon iG texture-system (based on Exciter's uG/RPP texture-system), shader_cinema_fl by Ren712, and OwlGaming/Cat's fixes to texture-system based on mabako-clothingstore. 

--exports
mysql = exports.mysql
global = exports.global
integration = exports.integration
clubtec = exports.clubtec
itemworld = exports['item-world']

--settings
theItemID = 165

--cache
fakevideos = {}

--set vars
resourceRoot = getResourceRootElement(getThisResource())
root = getRootElement()

--cat's cache solution
addEventHandler("onResourceStart", resourceRoot,
	function()
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, row in ipairs(res) do
						fakevideos[tonumber(row.id)] = { name = row.name, frames = fromJSON(row.frames), speed = tonumber(row.speed), creator = tonumber(row.createdBy), date = row.createdAt }
					end
				end
			end,
		mysql:getConnection(), "SELECT * FROM textures_animated")
	end)

function getPath(id, frame)
	return "cache/"..tostring(id).."_"..tostring(frame)..".tex"
end

function loadFromURL(id, texName, object, loadimg)
	local data = fakevideos[id]
	local frames = data.frames
	if frames and #frames > 0 then
		local framesPixels = {}
		for frame,url in ipairs(frames) do
			fetchRemote(url, function(str, errno)
				if str == "ERROR" then
					outputDebugString("fakevideo/s_fakevideo: "..tostring(errno).." url "..tostring(url))
				else
					local file = fileCreate(getPath(id, frame))
					fileWrite(file, str)
					fileClose(file)
					table.insert(framesPixels, {frame = frame, pixels = str, size = #str})
					if(frame == #frames) then --if this is the last frame
						if data.pending then
							triggerLatentClientEvent(data.pending, "fakevideo:file", resourceRoot, id, framesPixels, texName, object, loadimg)
							data.pending = nil
						end
					end
				end
			end)			
		end
	else
		outputDebugString("fakevideo/s_fakevideo: loadFromURL - no such video")
	end
end

-- send frames to the client
addEvent("fakevideo:stream", true)
addEventHandler("fakevideo:stream", resourceRoot,
	function(id, texName, object, loadimg)
		local id = tonumber(id)
		-- if its not a number, this'll fail
		if type(id) == "number" then
			local data = fakevideos[id]
			if data then
				local allExist = true
				for k,v in ipairs(data.frames) do
					local path = getPath(id, k)
					if not fileExists(path) then
						allExist = false
						break
					end
				end
				if allExist then
					local framesPixels = {}
					for frame,url in ipairs(data.frames) do
						local path = getPath(id, frame)
						local file = fileOpen(path, true)				
						if file then
							local size = fileGetSize(file)
							local pixels = fileRead(file, size)
							if #pixels == size then
								table.insert(framesPixels, {frame = frame, pixels = pixels, size = size})
							else
								outputDebugString('fakevideo/s_fakevideo:stream - file ' .. path .. ' read ' .. #pixels .. ' bytes, but is ' .. size .. ' bytes long')
							end
							fileClose(file)	
						else
							outputDebugString('fakevideo/s_fakevideo:stream - file ' .. path .. ' existed but could not be opened?')
						end
					end
					triggerLatentClientEvent(client, 'fakevideo:file', resourceRoot, id, framesPixels, texName, object, loadimg)
				else
					-- try to load the files from urls
					if data.pending then
						table.insert(data.pending, client)
					else
						data.pending = { client }
						loadFromURL(id, texName, object, loadimg)
					end
				end
			else
				outputDebugString("fakevideo/s_fakevideo:stream - fakevideo #"..id.." do not exist.")
			end
		end
	end, false)

function getElementsInDimension(theType,dimension)
    local elementsInDimension = { }
      for key, value in ipairs(getElementsByType(theType)) do
        if getElementDimension(value)==dimension then
        table.insert(elementsInDimension,value)
        end
      end
      return elementsInDimension
end

function loadDimensionAnimatedTextures(dimension)
	if not dimension then dimension = getElementDimension(client or source) end
	local dimensionAnimatedTextures = {} --format {id = id, texname = texture, object = object, loadimg = pathToLoadingImg, shaderData = shaderData}

	--check for video players
	local dimensionObjects = getElementsInDimension("object", dimension)
	for k,v in ipairs(dimensionObjects) do
		if getElementParent(getElementParent(v)) == getResourceRootElement(getResourceFromName("item-world")) then
			if clubtec:isVideoPlayer(v) then
				local texName = tostring(getElementData(v, "itemValue"))
				local disc = clubtec:getVideoPlayerCurrentVideoDisc(v) or 0
				if disc < 2 then
					disc = noDisc_id_clubtec
				end
				local shaderData = itemworld:getData(v, "shaderData", "table") or {}
				table.insert(dimensionAnimatedTextures, { id = disc, texname = texName, object = nil, loadimg = "clubtec_load.png", shaderData = shaderData })
			end
		end
	end

	triggerClientEvent(client or source, 'fakevideo:updateDimension', resourceRoot, dimension, dimensionAnimatedTextures)
end
--addEvent("frames:loadInteriorTextures", true)
addEventHandler("frames:loadInteriorTextures", root, loadDimensionAnimatedTextures)
addEvent("fakevideo:loadDimension", true)
addEventHandler("fakevideo:loadDimension", root, loadDimensionAnimatedTextures)

addEvent("fakevideo:syncNewClient", true)
addEventHandler("fakevideo:syncNewClient", root, function()
		--outputDebugString("Sending "..tostring(#fakevideos).." fakevideos to client.")
		triggerClientEvent(client, 'fakevideo:initialSync', resourceRoot, fakevideos)
end)