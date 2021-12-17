function ActorPlayer()
    return {
        class="player",
        name="player",
        f=16,
        w=2,
        h=1.25,
        speed=0.125,

        doors=split("106_2_2_0_0,107_2_2_-1_0,123_2_2_-1_-1,122_2_2_0_-1,68_1_2_0_0,84_1_2_0_-1"), -- f_w_h_dx_dy

        init = function(self)
            self.life_timer=0
            self.life_timer_max=2

            self.projectile_timer=0
            self.projectile_timer_max=0.25

            self.cord={}

            if type(self.doors[1])=="string" then
                for k,v in pairs(self.doors) do
                    self.doors[k]=split(v,"_",true)
                end
            end
        end,
        update = function(self)
            self:update_actor()

            if not Started then
                return
            end

            -- timers
            if self.life_timer>0 then
                self.life_timer-=tdelta
            end
            if self.projectile_timer>0 then
                self.projectile_timer-=tdelta
            end

            -- player movement
            self.dx=0
            self.dy=0
            local sp=self.speed
            local item=Inventory:get_item("cord")
            if (item.quantity>=item.max) sp*=0.1
            if btn(0) then
                self.flx=true
            elseif btn(1) then
                self.flx=false
            end
            if btn(0) and not Map:is_solid(self.x-1,self.y) then
                self.dx=-sp
            end
            if btn(1) and not Map:is_solid(self.x+0.875,self.y) then
                self.dx=sp
            end
            if btn(2) and not Map:is_solid(self.x,self.y-0.625) then
                self.dy=-sp
            end
            if btn(3) and not Map:is_solid(self.x,self.y+0.5) then
                self.dy=sp
            end

            if self.dx!=0 or self.dy!=0 then
                self.a={16,103}
                self.as=0.25
            else
                self.f=16
                self.a=false
            end

            if btnp(4) then
                item=Inventory.equipped_item
                if item==nil or item.quantity<=0 then
                    Screen:play_sfx(9)
                elseif item.name=="harpoon" or item.name=="bomb" then
                    if self.projectile_timer<=0 then
                        Inventory:remove_item(item)
                        self.projectile_timer=self.projectile_timer_max

                        local a
                        if item.name=="harpoon" then
                            a=Actors:create_projectile(ActorProjectileHarpoon(),self.x,self.y,-1,-0.375)
                        else
                            a=Actors:create_projectile(ActorProjectileBomb(),self.x,self.y,0.75,-0.625)
                            if self.flx then
                                a.x-=2.375
                            end
                        end
                        a.flx=self.flx
                        a:init()
                    else
                        Screen:play_sfx(9)
                    end
                elseif item.name=="dagger" then

                elseif item.name=="key" then
                    for y=self.y-1,self.y+1 do
                        for x=self.x-1,self.x+1 do
                            for a in all(self.doors) do
                                if Map:mget(x,y)==a[1] then
                                    x+=a[4]
                                    y+=a[5]
                                    Map:mclear(x,y,a[2],a[3])
                                    Inventory:remove_item(item)
                                    Screen:play_sfx(19,1.5)
                                end
                            end
                        end
                    end
                end
            end

            -- cord
            local start={
                x=Boat.x,
                y=Boat.y
            }
            local goal={
                x=self.x,
                y=self.y
            }
            self.cord=Path:calc(self.cord,start,goal)
            Inventory:set_item("cord",Path:get_length(self.cord))

        end,
        draw = function(self)
            if self.life_timer>0 and flr(self.life_timer/tdelta/4)%2==0 then
                pal(Graphics.palbw)
                self:draw_actor()
                Graphics.reset_pal()
            else
                self:draw_actor()
            end
        end,
        damage = function(self)
            if (Player.life_timer>0) return

            self.life_timer=self.life_timer_max -- timer for invincibility
            Screen:play_sfx(10,0.2)

            -- take damage
            if not Inventory:remove_item("life") then
                restart()
            end
        end
    }
end
