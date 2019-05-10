function isResourceRunning(resName)
	local res = getResourceFromName(resName)
	if res then
		return getResourceState(res) == "running"
	end
	return false
end