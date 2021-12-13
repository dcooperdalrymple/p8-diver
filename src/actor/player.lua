local function init(self)
    if Config.dev==true then
        self.speed=0.25
    end

    self.life_timer=0
    self.life_timer_max=2

    self.projectile_timer=0
    self.projectile_timer_max=0.5

    self.cord={}
end

local function update(self)
    self:update_actor()

    if State.paused==true or State.started==false then
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
    if item.quantity>=item.max and not Config.dev then
        sp*=0.1
    end
    if btn(0) then
        self.flx=true
    elseif btn(1) then
        self.flx=false
    end
    if btn(0) and not Map:is_solid(self.x-self.w/2,self.y) then
        self.dx=-sp
    end
    if btn(1) and not Map:is_solid(self.x+self.w/2,self.y) then
        self.dx=sp
    end
    if btn(2) and not Map:is_solid(self.x,self.y-self.h/2) then
        self.dy=-sp
    end
    if btn(3) and not Map:is_solid(self.x,self.y+self.h/2) then
        self.dy=sp
    end

    if self.dx!=0 or self.dy!=0 then
        self.a={16,103}
        self.as=0.25
    else
        self.f=16
        self.a=false
    end

    -- refill harpoons and hearts
    --[[
    if (self.harpoon_count<self.harpoon_max or self.life<=0) and Screen.current_index==Screen.start_index and collide(Player,Boat) then
        self.harpoon_count=self.harpoon_max
        self.life=self.life_max
        Screen:play_sfx(0)
    end
    ]]--

    if btnp(4) then
        item=Inventory.equipped_item
        if item==nil or item.quantity<=0 then
            Screen:play_sfx(9)
        elseif item.name=="harpoon" or item.name=="bomb" then
            if self.projectile_timer<=0 then
                if not Config.dev then
                    item.quantity-=1
                end
                self.projectile_timer=self.projectile_timer_max

                if item.name=="harpoon" then
                    a=Actors:create_harpoon(self.x,self.y)
                    a.x-=self.w/2
                else
                    a=Actors:create_bomb(self.x,self.y)
                    a.y-=self.h/2
                    if self.flx then
                        a.x-=self.w*0.8125
                    else
                        a.x+=self.w*0.375
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
                    local _y=flr(y)
                    local _x=flr(x)
                    if m==107 or m==123 then
                        x-=1
                    elseif m==122 or m==123 then
                        y-=1
                    end
                    if Map:mget(x,y)==106 then
                        Map:mclear(x,y,2,2)
                        Map:mset(x-1,y,34)
                        Map:mset(x-1,y+1,34)
                        Map:mset(x+2,y,36)
                        Map:mset(x+2,y+1,36)
                        item.quantity-=1
                        break
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

end

local function draw(self)
    if self.life_timer>0 and flr(self.life_timer/Config.tdelta/4)%2==0 then
        pal(Graphics.palbw)
        self:draw_actor()
        Graphics.reset_pal()
    else
        self:draw_actor()
    end
end

local function damage(self)
    local life=Inventory:get_item("life")

    -- take damage
    if not Config.dev then
        life.quantity-=1
    end
    self.life_timer=self.life_timer_max -- timer for invincibility

    Screen:play_sfx(10,0.2)

    if life.quantity<=0 then
        restart()
    end
end

return {
    get=function ()
        return {
            class="player",
            name="player",
            f=16,
            w=2,
            h=1.25,
            speed=0.125,

            init = init,
            init_player = init,
            update = update,
            update_player = update,
            draw = draw,
            draw_player = draw,
            damage = damage,
            damage_player = damage,
        }
    end
}
