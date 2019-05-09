--SCRIPT AUTHOR İSMİNİ DEĞİŞTİRMEYİNİZ--
addEvent("cuff.getAnim",true)
local cuffed = {}
local controls = {"fire", "next_weapon", "previous_weapon","jump","action","aim_weapon","vehicle_fire", "vehicle_secondary_fire","vehicle_left", "vehicle_right", "steer_forward", "steer_back", "accelerate", "brake_reverse", "sprint"}
local cuffedFuncs = {}

function isElementInRange(ele, x, y, z, range)
   if isElement(ele) and type(x) == "number" and type(y) == "number" and type(z) == "number" and type(range) == "number" then
      return getDistanceBetweenPoints3D(x, y, z, getElementPosition(ele)) <= range -- returns true if it the range of the element to the main point is smaller than (or as big as) the maximum range.
   end
   return false
end

addCommandHandler("kelepcele",
	function(player,cmd,n)
		if isElement(player) then
			if isElement(player:getTeam()) then
				if player:getTeam():getName() == "Los Santos Police Department" then
					if n then 
						local target = exports.global:findPlayerByPartialNick(player, n) 
						if isElement(target) then
							local x,y,z = getElementPosition(player)
							if isElementInRange(target, x, y, z, 5) then 
							--if player == target then outputChatBox("Kendini kelepçeleyemezsin.",player,255,0,0) return end	
							
								if not cuffed[player] then
									cuffed[player] = {}
								end	
								player:setAnimation("BD_FIRE", "wash_up", 1000, false, true, false, false)
								
								--[[cuffedFuncs[target:getName()] = function ()
									if isElement(target) then
										target:setAnimation("sword", "sword_block", 1000, false, true, false)
									end
								end
								cuffedFuncs[target:getName()]()
								addEventHandler("onPlayerVehicleExit", target, cuffedFuncs[target:getName()])]]--
								target:setAnimation("sword", "sword_block", 1000, false, true, false)
								target:setData("restrain", 1)
								for i, v in ipairs(controls) do
									toggleControl(target, v, false)
								end	
								
								outputChatBox("[!] #FFFFFF"..target:getName().." isimli şahsı kelepçelediniz.", player, 255, 125, 0, true)
								outputChatBox("[!] #FFFFFF"..player:getName().." tarafından kelepçelendiniz.", target, 255, 125, 0, true)
								
								cuffedFuncs[target:getName()] = setTimer (
									function ()
										target:setAnimation("sword", "sword_block", 50, false, true, false)
									end	,
								2000,0)
								cuffed[player][target:getName()] = true
								cuffedFuncs[player] = setTimer(
									function ( )
										target:setAnimationProgress("sword_block",1.0)
										toggleControl(target, v, false)
									end	,
								50,0)
								
								giveWeapon(target,1,1,true)
							else
								outputChatBox("[!] Kelepçeyi takabilmek için karşı kullanıcıya yakın olman gerekiyor.",player,255,0,0)
							end	
						end	
					else	
						outputChatBox("SYNTAX: /kelepcele [isim]", player, 255, 0, 0)
					end
				else
					outputChatBox("[!]#FFFFFF Bu komutu sadece polisler kullanabilir.", player, 255, 0, 0,true)
				end
			else
				outputChatBox("[!]#FFFFFF Bu komutu sadece polisler kullanabilir.", player, 255, 0, 0,true)
			end
		end	
	end
)

addCommandHandler("kelepcecikar",
	function(player,cmd,n)
		if cuffed[player] then
			if n then
				local target = exports.global:findPlayerByPartialNick(player, n)
				
				if cuffed[player][target:getName()] then
					if isElement(target) then
					
						--if player == target then return end
						target:setAnimation("ped","facgum",50,false)
						
						for i,v in ipairs(controls) do
							toggleControl(target,v,true)
						end	
						
						takeWeapon(target, 1)
						setPedWeaponSlot(target,2)
						target:setData("restrain", 0)
						outputChatBox("[!] #FFFFFF"..target:getName().." isimli kişinin kelepçesini çıkarttınız.", player, 255, 125, 0, true)
						outputChatBox("[!] #FFFFFF"..player:getName().." kelepçenizi çıkarttı.", target, 255, 125, 0, true)
						
						if isTimer (cuffedFuncs[target:getName()]) then
							killTimer (cuffedFuncs[target:getName()])
						end	
						if isTimer (cuffedFuncs[player]) then
							killTimer (cuffedFuncs[player])
						end	
						
						cuffedFuncs[target:getName()] = nil;
						cuffedFuncs[player] = nil;
						
						cuffed[player][target:getName()] = nil
						
					end
				end	
			else
				for i in pairs (cuffed[player]) do 
					local target = Player(i)
					
					if isElement(target) then
					
						target:setAnimation("ped","facgum",50,false)
						
						for i,v in ipairs(controls) do
							toggleControl(target,v,true)
						end	
						
						takeWeapon(target,1)
						setPedWeaponSlot(target,2)
						target:setData("restrain", 0)
						outputChatBox("[!]#FFFFFF Tüm oyuncuların kelepçelerini çıkardın.", player, 255, 125, 0,true)
						outputChatBox("[!]#FFFFFF"..player:getName().." kelepçenizi çıkarttı.", target, 255, 125, 0, true)	
						
						if isTimer(cuffedFuncs[player]) then
							killTimer(cuffedFuncs[player])
						end	 
						if isTimer (cuffedFuncs[target:getName()]) then
							killTimer (cuffedFuncs[target:getName()])
						end	
						cuffedFuncs[player] = nil; 
						cuffedFuncs[target:getName()] = nil;						
				
						cuffed[player][target:getName()] = nil
						cuffed[player][i] = nil
						
					end	
				end
			end
		end
	end
)	
		