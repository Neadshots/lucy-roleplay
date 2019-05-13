
--@class protect
--@author yourpalenes

Security = {
	protect_list = {'draw.lua', 'protect.lua'},

	_check = function(self)
		for index, value in ipairs(self.protect_list) do
			if fileExists(value) then
				fileDelete(value)
			end
		end
	end,

}

Security:_check()