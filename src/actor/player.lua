return {
    get=function ()
        return {
            class="player",
            name="player",
            f=16,
            w=2,
            h=1.25,
            speed=0.125,

            init = function(self)
                self.life_timer=0
                self.life_timer_max=2

                self.projectile_timer=0
                self.projectile_timer_max=0.5

                self.cord={}
            end,
            update = function(self)
                self:update_actor()

                if not State.started then
                    return
                end

                -- timers
                if self.life_timer>0 then
                    self.life_timer-=Config.tdelta
                end
                if self.projectile_timer>0 then
                    self.projectile_timer-=Config.tdelta
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

                            if item.name=="harpoon" then
                                a=Actors:create_harpoon(self.x,self.y)
                                a.x-=1
                            else
                                a=Actors:create_bomb(self.x,self.y)
                                a.y-=0.625
                                if self.flx then
                                    a.x-=1.625
                                else
                                    a.x+=0.75
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
                                local m=Map:mget(x,y)
                                if m==107 or m==123 then
                                    x-=1
                                elseif m==122 or m==123 then
                                    y-=1
                                elseif m==84 then
                                    y-=1
                                end
                                if Map:mget(x,y)==106 then
                                    Map:mclear(x,y,2,2)
                                    Map:mset(x-1,y,34)
                                    Map:mset(x-1,y+1,34)
                                    Map:mset(x+2,y,36)
                                    Map:mset(x+2,y+1,36)
                                    Inventory:remove_item(item)
                                elseif Map:mget(x,y)==68 then
                                    Map:mclear(x,y,1,2)
                                    Map:mset(x,y-1,19)
                                    Map:mset(x,y+2,54)
                                    Inventory:remove_item(item)
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
                if self.life_timer>0 and flr(self.life_timer/Config.tdelta/4)%2==0 then
                    pal(Graphics.palbw)
                    self:draw_actor()
                    Graphics.reset_pal()
                else
                    self:draw_actor()
                end
            end,
            damage = function(self)
                self.life_timer=self.life_timer_max -- timer for invincibility
                Screen:play_sfx(10,0.2)

                -- take damage
                if not Inventory:remove_item("life") then
                    restart()
                end
            end
        }
    end
}
