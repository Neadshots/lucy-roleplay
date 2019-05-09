deletefiles =
{ "donmedolap_data_pos.lua",
  "balon_c.lua",
  "dosyalar/donmedolap.col", 
  "dosyalar/balon.col", 
  "dosyalar/balon.txd", 
  "dosyalar/balon.dff", }

function onStartResourceDeleteFiles()
for i=1, #deletefiles do
fileDelete(deletefiles[i])
end
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), onStartResourceDeleteFiles)
