local function init(self)
    if Config.dev==true then
        self.speed=2/8
    end

    self.start_pos = {
        x=self.x,
        y=self.y,
    }

    -- initialize camera to start screen
    Camera:set_screen_position(self.start_pos)

    self.coins=0

    self.life_max=3
    self.life=self.life_max
    self.life_timer=0
    self.life_timer_max=2

    self.harpoon_max=3
    self.harpoon_count=self.harpoon_max
    self.harpoon_timer=0
    self.harpoon_timer_max=0.5

    self.cord_length_max=32
    self.cord_length=0

    self.return_timer_max=2
    self.return_timer=0

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
    if self.harpoon_timer>0 then
        self.harpoon_timer-=Config.tdelta
    end

    -- player movement
    self.dx=0
    self.dy=0
    local sp=self.speed
    if self.cord_length>=self.cord_length_max and not Config.dev then
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

    -- return
    if Screen.current_index==Screen.start_index then
        self.return_timer=0
    elseif self.return_timer>=self.return_timer_max and Fade.state=="out" and Fade.index==0 then
        self.return_timer=0
        self.x=self.start_pos.x
        self.y=self.start_pos.y
        self.cord={}
        Fade:_in()
        Camera:set_screen_position(self.start_pos)
    else
        if btn(5) and self.return_timer<self.return_timer_max then
            self.return_timer+=Config.tdelta
        elseif btn(5) and self.return_timer>=self.return_timer_max and Fade.state!="out" then
            -- do return
            Fade:out()
        elseif Fade.state!="out" and not btn(5) and self.return_timer>0 then
            self.return_timer=0
        end
    end

    -- refill harpoons and hearts
    if (self.harpoon_count<self.harpoon_max or self.life<=0) and Screen.current_index==Screen.start_index and collide(Player,Boat) then
        self.harpoon_count=self.harpoon_max
        self.life=self.life_max
        Screen:play_sfx(0)
    end

    -- harpoon
    if btnp(4) and self.harpoon_count>0 and self.harpoon_timer<=0 then
        if not Config.dev then
            self.harpoon_count-=1
        end
        self.harpoon_timer=self.harpoon_timer_max

        a=Actors:create_harpoon(self.x,self.y)
        a.flx=self.flx
        if a.flx then
            a.x-=self.w/2
        else
            a.x+=self.w/2
        end
        a:init()
    elseif btnp(4) and (self.harpoon_count<=0 or self.harpoon_timer>0) then
        Screen:play_sfx(9)
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
    self.cord_length=Path:get_length(self.cord)

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
    -- take damage
    if not Config.dev then
        self.life_max-=1
    end
    self.life_timer=self.life_timer_max -- timer for invincibility

    Screen:play_sfx(10,0.2)

    if self.life<=0 then
        restart()
    end
end

return {
    get=function ()
        return {
            class="player",
            name="player",
            f=16,
            w=16/8,
            h=10/8,
            speed=1/8,

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
