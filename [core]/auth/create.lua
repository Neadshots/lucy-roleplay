
-- @class Auth
-- @author: foreigner26

Auth = {
    screen = Vector2(guiGetScreenSize()),
    debug = true,
    serial = false,
    user = {},
    characters = {},
    cks = {},
    currslot = 0,

    change = function(self,variable,value)

        if variable == 'firstornot' then

            if self.browser then return false end

            showChat(false)
            showCursor(true)

            WebUIManager:new()

            self.browser = WebWindow:new(Vector2(0,0), Vector2(self.screen.x,self.screen.y), "http://mta/auth/html/interface.html", true);
            localPlayer:setData('auth:browser', self.browser)

            self.browser:addEvent("browser:ready",
            function(webwindow)

                self.browser:getUnderlyingBrowser():executeJavascript('start('..tostring(not value)..')');
                Camera.fade(true)
				
			end)
    
            setDevelopmentMode(self.debug, self.debug);

        end


    end,

    events = function(self,event,value)


        --[[
            @method push:serial
            @desc: kullanıcı serialini veritabanında kontrol ettirip cevabını getir.
        ]]--

        if event == 'push:serial' then
            
            if value == 0 then 
                self:change('firstornot',false)
            else 
                self:change('firstornot',true)     
            end

        return true
        end


        --[[
            @method html5_callback
            @desc: kullanıcı adını geri döndürüp veritabanını tetikler.
        ]]--

        if event == 'auth.javascript.html5.document.return.to.username' then

            triggerServerEvent('receive:username', localPlayer, localPlayer, value)
            return true
        end

        if event == 'auth.javascript.html5.document.return.to.password' then
            local encryptionRule = self.user.salt
            local encryptedPW = string.lower(md5(string.lower(md5(value))..encryptionRule))
            if encryptedPW == self.user.password then
                localPlayer:setData("admin_level", tonumber(self.user['admin']))
                localPlayer:setData("supporter_level", tonumber(self.user['supporter']))
                localPlayer:setData("vct_level", tonumber(self.user['vct']))
                localPlayer:setData("mapper_level", tonumber(self.user['mapper']))
                localPlayer:setData("scripter_level", tonumber(self.user['scripter']))
                triggerServerEvent('receive:loginok',localPlayer,localPlayer,self.user)
                triggerServerEvent('receive:characters',localPlayer,localPlayer,self.user.id)
            else 
                self.browser:executeJavascript2('set(2,`'..self.user.username..'`)');
            end            

            return true
        end

        if event == 'auth.javascript.html5.document.return.to.password.register' then
            local salt = math.random(100000, 999999)
            local encryptedPW = string.lower(md5(string.lower(md5(value))..salt))
            triggerServerEvent("receive:register", localPlayer, localPlayer, self.register.username, encryptedPW, salt)
            
            self.register.username = nil;

            return true
        end

        if event == 'push:registerok' then 
            if self.browser then 
                self.browser:executeJavascript2('_error(`Buraya kullanıcı adınızı yazarak giriş yapabilirsiniz.`,true)');
                self.browser:executeJavascript2('set(14)');
            end
        end

        --[[
            @method push:characters:list
            @desc: Karakterleri çekip F10'a aktarma
        ]]
        if event == 'push:characters:list' then
            if value then
                self.characters = value
            end
            return true
        end

        --[[
            @method push:characters
            @desc: karakterleri çekip ekrana yazdırma.
        ]]--

        if event == 'push:characters' then 
          
            if value then
                self.characters = value
                self.browser:executeJavascript2('loadingcharacter()');
                
                for i,v in pairs(value) do
                    if v.cked == 1 then
                        v.cked = 'Ölü';
                    else  
                        v.cked = 'Yaşıyor';
                    end 
                    
                    self.browser:executeJavascript2('set(4)');

                    if (v.pdjail or 0) > 0 then 
                        sendJail = 'Cezalı';
                    else 
                        sendJail = 'Serbest';
                    end
                    
                    self.browser:executeJavascript2('character(`'..v.charactername..'`,`'..sendJail..'`,`'..v.cked..'`,`'..tostring(getZoneName(v.x,v.y,v.z))..'`,`'..(v.lastlogin or "N/A")..'`,`'..v.id..'`)');
 
               end

            else 
                setTimer(function()
                    self.browser:executeJavascript2('set(3)');
                end,500,1)
            end 

        end

        --[[
            @method auth.javascript.html5.document.return.to.character.select
            @desc: kullanıcı karakterle giriş yaptığında
        ]]--
    
        if event == 'auth.javascript.html5.document.return.to.character.select' then 

            if self.browser then 
                setTimer(function()

                    removeEventHandler("onClientKey", root, function(button,press) if press and button == 'enter' then instance:enter() end end)
                    triggerServerEvent('receive:join_character', localPlayer, localPlayer, value)
                      
                    --self.characters = {}
                    self.user = {}

                    showChat(true)
                    showCursor(false)

                    Camera.fade(true)

                end,500,1)
                
            end

            return true
        end

        --[[
            @method push:username
            @desc: kullanıcı adını veritabanından gönderme
        ]]--

        if event == 'push:username' then 
            if #value == 1 then 
                for i,v in ipairs(value) do 
                    for k,l in pairs(v) do 
                        if type(l) == 'string' then 
                            l = l:gsub('\n','')
                        end
                        self.user[tostring(k)] = l
                    end
                end
                
                setTimer(function()
                    self.browser:executeJavascript2('set(2,`'..self.user.username..'`)');
                end,500,1)
            else 
                setTimer(function()
                    self.browser:executeJavascript2('reload()');
                end,500,1)
            end
            return true
        end

        --[[
            @method: push:info
            @desc: hata mesajları
        ]]--
        if event == "push:info" then 
            if self.browser then 
                self.browser:executeJavascript2('_error(`'..value..'`)');
            end
        end

        --[[
            @method: auth.javascript.html5.document.return.to.username.register
            @desc: Kullanıcı adı.
        ]]--
        if event == "auth.javascript.html5.document.return.to.username.register" then 
            self.register = {}
            self.register.username = value;

            triggerServerEvent("receive:rusername", localPlayer, localPlayer, value)
        end

        --[[
            @method: auth.javascript.html5.document.return.to.username.register
            @desc: Kullanıcı adı.
        ]]--
        if event == "push:rusername" then 
            if tonumber(value) > 0 then 
                if self.browser then 
                    self.browser:executeJavascript2('_error(`Kullanıcı adı kullanılıyor.`)');
                    self.browser:executeJavascript2('reload()');
                end
            else 
                if self.browser then
                    self.browser:executeJavascript2('set(12,`'..self.register.username..'`)');            
                end
            end
        end


        --[[
            @method: push:login_character
            @desc: Karaktere giriş, client işleme
        ]]--
        if event == 'push:login_character' then
            showChat(true)
            showCursor(false)
            clearChatBox()
            local syntax = exports.pool:getServerSyntax(false, "e")
            outputChatBox(syntax.."Sunucuya hoş geldin.", 85, 155, 255, true)
            outputChatBox(syntax.."Herhangi bir sorunun olduğunda /rapor komutunu kullanabilirsin.", 85, 155, 255, true)

            self.browser:destroy();
            removeEventHandler('onClientKey',root,enter)
        end
    end,

    index = function(self)
    
        if localPlayer:getData('loggedin') ~= 1 then
           triggerServerEvent('receive:serial',localPlayer,localPlayer)
        end
    end,

    f10 = function(self, state)
    	if localPlayer:getData('loggedin') == 1 then
            if (state == 'on') then
                localPlayer:setData('f10', true)
                if #self.characters == 0 then
                    triggerServerEvent('receive:characters',localPlayer,localPlayer,localPlayer:getData('account:id'),'f10')
                end
                self.currslot = 0;
                local i = 1
		        for index, value in ipairs(self.characters) do
		            if i <= 4 then
		                if value.id == localPlayer:getData('dbid') then
		                    self.currslot = i
		                end
		                i = i + 1
		            end
		        end
                addEventHandler('onClientRender',root,self.characterlist)
                addEventHandler('onClientKey',root,self.characterkey)
            else
                localPlayer:setData('f10', false)
                removeEventHandler('onClientRender',root,self.characterlist)
                removeEventHandler('onClientKey',root,self.characterkey)
            end
    	end
    end,

    characterkey = function(key, state)
    self = Auth
    	if state then
	    	if (key == 'mouse_wheel_up') or (key == 'pgup') then
	    		self.currslot = self.currslot + 1
	    		if self.currslot > 4 then
	    			self.currslot = 1
	    		end
	    	elseif (key == 'mouse_wheel_down') or (key == 'pgdn') then
    			self.currslot = self.currslot - 1
    			if self.currslot < 1 then
    				self.currslot = 4
    			end
	    	elseif (key == 'enter') then
	    		if (self.currslot > 0) then

	    		end
	    	end
	    end
	end,
    
    characterlist = function()
    instance = Auth
        dxDrawImage(instance.screen.x-215, instance.screen.y-210, 200, 200, "components/images/slots/slot"..instance.currslot..".png")
        -- #4 of list one:
        list_positions = {
            [1] = {instance.screen.x-145, instance.screen.y-190},
            [2] = {instance.screen.x-195, instance.screen.y-140},
            [3] = {instance.screen.x-85, instance.screen.y-140},
            [4] = {instance.screen.x-145, instance.screen.y-140},
        }
        local i = 1
        for index, value in ipairs(instance.characters) do
            if i <= 4 then
                local tmp = value.skin
                
                if value.id == localPlayer:getData('dbid') then
                    selected = i
                end
                dxDrawImage(list_positions[i][1], list_positions[i][2], 48, 48, ":item-system/images/skins/"..tmp..".png")
                i = i + 1
            end
        end
 
    end,
}
instance = new(Auth)

addEvent('push:serial',true)
addEvent('push:username',true)
addEvent('push:rusername',true)
addEvent('push:characters',true)
addEvent('push:characters:list',true)
addEvent('push:start_login',true)
addEvent('push:login_character',true)
addEvent('push:info',true)
addEvent('push:registerok',true)
addEvent('auth.javascript.html5.document.return.to.username',true)
addEvent('auth.javascript.html5.document.return.to.password',true)
addEvent('auth.javascript.html5.document.return.to.character.select',true)
addEvent('auth.javascript.html5.document.return.to.character.create',true)
addEvent('auth.javascript.html5.document.return.to.username.register',true)
addEvent('auth.javascript.html5.document.return.to.password.register',true)

addEventHandler('push:serial',root,function(callback) instance:events('push:serial',callback) end)
addEventHandler('push:username',root,function(callback) instance:events('push:username',callback) end)
addEventHandler('push:rusername',root,function(callback) instance:events('push:rusername',callback) end)
addEventHandler('push:registerok',root,function(callback) instance:events('push:registerok',callback) end)
addEventHandler('push:characters',root,function(callback) instance:events('push:characters',callback) end)
addEventHandler('push:characters:list',root,function(callback) instance:events('push:characters:list',callback) end)
addEventHandler('push:login_character',root,function(callback) instance:events('push:login_character',callback) end)
addEventHandler('push:info',root,function(message) instance:events('push:info',tostring(message)) end)
addEventHandler('auth.javascript.html5.document.return.to.username',root,function(event,callback) instance:events(event,callback) end)
addEventHandler('auth.javascript.html5.document.return.to.password',root,function(event,callback) instance:events(event,callback) end)
addEventHandler('auth.javascript.html5.document.return.to.character.select',root,function(event,callback) instance:events(event,callback) end)
addEventHandler('auth.javascript.html5.document.return.to.username.register',root,function(event,callback) instance:events(event,callback) end)
addEventHandler('auth.javascript.html5.document.return.to.password.register',root,function(event,callback) instance:events(event,callback) end)

addEventHandler('auth.javascript.html5.document.return.to.character.create',root,function(chname,chage,chlength,chweight,chgender)
    if chgender == 'Erkek' then 
        chgender = 0;
    else 
        chgender = 1;
    end
    triggerServerEvent('receive:create_character', localPlayer, localPlayer, chname, chage, chlength, chweight, chgender)
end)

function enter(button,press)
    if press and button == 'enter' then
        if instance.browser then
            instance.browser:executeJavascript2('enter()');
        end
    end
end

addEventHandler("onClientKey", root, enter)

addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),function() triggerServerEvent('receive:start',root,root) end)
addEventHandler('push:start_login',root,function() instance:index() end)
bindKey('f10', 'down', function(key, state) instance:f10('on') end)
bindKey('f10', 'up', function(key, state) instance:f10('off') end)