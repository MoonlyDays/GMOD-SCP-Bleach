--914 fix by Xy for gm_site19.
--Code is made available under the MIT license, see LICENSE file.
--If this isn't working, make an issue.

--IF YOU'RE RUNNING A DIFFERENT VERSION OF SITE19 OTHER THAN JUNE 24th 2017, YOU WILL NEED TO MAKE EDITS
--Basically, The values *216 and *221 may vary between map versions, and will need to be changed accordingly



print("Initializing 914fix for gm_site19_old by 'Xy' and edited by 'Dragon4k'.")


--Hack to fix 914
--You can have a command call this if you'd like, but the default hook works pretty well from my testing.
--You can localize this, but that makes it harder to call manually if needed (and from commands)
function Fix914()
	--Only site19 is supported
  
	if game.GetMap() != "gm_site19_old" then return end
	for k,v in pairs(ents.GetAll()) do
		--Basically, the button is a brush ent and *216 is its model. *216 should be unique to the trigger, and this is the best way we have to indentify it because for some reason Entity:GetName() isn't working on func_button :( 
    
		if v and IsValid(v) and v:GetClass() == "func_button" and v.GetModel and v:GetModel() == "*164" then
			v:Fire("Unlock")
			--If we were to just PressOut again, then 914 would go again, so we disable the logic relay
      
			for x,y in pairs(ents.GetAll()) do
				if y and IsValid(y) and y:GetClass() == "logic_relay" and y.GetName and y:GetName() == "914_relay" then
					y:Fire("Disable")
					--So we can enable it next frame
          
					local e = y
					timer.Simple(0.1, function ()
						if e and IsValid(e) then
							--Enable the logic relay for future presses
              
							e:Fire("Enable")
						end
					end)
				end
			end
			--This part presses the button, resetting it to the old position.
			v:Fire("PressOut")
      --The 0 here just makes the timer trigger next frame, which, now that I think about it, is probably not needed
			timer.Simple(0, function ()
				for a,b in pairs(ents.GetAll()) do
					--This unlocks the selector and the trigger, because the PressOut will also lock these two.
          --*221 is the brush model for the dial, it should also be unique to the dial
					if v.GetModel and (v:GetModel() == "*164" or v:GetModel() == "*221") then
						v:Fire("Unlock")
					end
				end
			end)
		end
	end
end


hook.Add("PlayerUse", "FixSCP914", function (ply, ent)
  --create a timer that fixes SCP914 everytime the trigger is used. This has *seems* to have no effect if 914 doesn't break
  if game.GetMap() == "gm_site19_old" and IsValid(ent) and ent.GetModel and ent:GetModel() == "*164" then
    timer.Simple(15, Fix914)
  end
end)