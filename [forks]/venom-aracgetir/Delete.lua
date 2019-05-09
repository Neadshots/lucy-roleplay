deletefiles =
{ "server.lua",
"Delete.lua", }

function onStartResourceDeleteFiles()
for i=1, #deletefiles do
fileDelete(deletefiles[i])
end
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), onStartResourceDeleteFiles)