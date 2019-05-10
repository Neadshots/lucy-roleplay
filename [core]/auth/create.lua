
-- @class Auth
-- @author: foreigner26

Auth = {
    screen = Vector2(guiGetScreenSize()),
    debug = true,
    serial = false,
    user = {},
    characters = {},
    cks = {},

    change = function(self,variable,value)

        if variable == 'firstornot' then

            showChat(false)
            showCursor(true)

            WebUIManager:new()
           
            self.browser = WebWindow:new(Vector2(0,0), Vector2(self.screen.x, self.screen.y), "http://mta/auth/html/interface.html", true);
            localPlayer:setData('auth:browser', self.browser)
            addEventHandler('onClientBrowserCreated',self.browser:getUnderlyingBrowser(),function()
                addEventHandler('onClientBrowserDocumentReady',self.browser:getUnderlyingBrowser(),function()
                    self.browser:executeJavascript2('first('..tostring(not value)..')');
                    Camera.fade(true)
                end)
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

            --Encrypt:sql('select',{Tablename='accounts',Type='username',Value=tostring(value)},'push:username')
            triggerServerEvent('recieve:username', localPlayer, localPlayer, value)
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
                triggerServerEvent('recieve:loginok',localPlayer,localPlayer,self.user)
                triggerServerEvent('recieve:characters',localPlayer,localPlayer,self.user.id)
            else 
                self.browser:executeJavascript2('set(2,`'..self.user.username..'`)');
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
                    triggerServerEvent('recieve:join_character', localPlayer, localPlayer, value)
                      
                    self.characters = {}
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
        end
    end,
    
    enter = function(self)
        if self.browser then
            self.browser:executeJavascript2('enter()');
        end
    end,

    index = function(self)
    
        if localPlayer:getData('loggedin') ~= 1 then
           triggerServerEvent('recieve:serial',localPlayer,localPlayer)
        end
    end,

    f10 = function(self)
    	if localPlayer:getData('loggedin') == 1 then
    		localPlayer.frozen = true
    		triggerServerEvent('recieve:serial',localPlayer,localPlayer)
    		triggerServerEvent('savePlayer',localPlayer,localPlayer)
    	end
	end,
}
instance = new(Auth)
--localPlayer:setData('loggedin', 0)
addEvent('push:serial',true)
addEvent('push:username',true)
addEvent('push:characters',true)
addEvent('push:start_login',true)
addEvent('push:login_character',true)
addEvent('auth.javascript.html5.document.return.to.username',true)
addEvent('auth.javascript.html5.document.return.to.password',true)
addEvent('auth.javascript.html5.document.return.to.character.select',true)

addEventHandler('push:serial',root,function(callback) instance:events('push:serial',callback) end)
addEventHandler('push:username',root,function(callback) instance:events('push:username',callback) end)
addEventHandler('push:characters',root,function(callback) instance:events('push:characters',callback) end)
addEventHandler('push:login_character',root,function(callback) instance:events('push:login_character',callback) end)
addEventHandler('auth.javascript.html5.document.return.to.username',root,function(event,callback) instance:events(event,callback) end)
addEventHandler('auth.javascript.html5.document.return.to.password',root,function(event,callback) instance:events(event,callback) end)
addEventHandler('auth.javascript.html5.document.return.to.character.select',root,function(event,callback) instance:events(event,callback) end)

addEventHandler("onClientKey", root, function(button,press) if press and button == 'enter' then instance:enter()  end end)

addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),function() triggerServerEvent('recieve:start',root,root) end)
addEventHandler('push:start_login',root,function() instance:index() end)
bindKey('f10', 'down', function(key, state) instance:f10() end)