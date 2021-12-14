local function init(self)
    self:init_projectile()
    Screen:play_sfx(10,0.2)
end

local function update(self)
    self:update_actor() -- no update_projectile

    -- check wall collision
    if Map:is_solid(self.x+0.4375,self.y) or Map:is_solid(self.x-0.4375,self.y) or Map:is_solid(self.x,self.y+0.4375) then
        self.dy=0
    end

    self.timer-=Config.tdelta

    if self.timer>0 then
        for a in all(Actors.actors) do
            if a.class=="enemy" and a.life>0 and collide(self,a) then
                self.timer=0
                self.dy=0
            end
        end
    end

    if self.timer>0 and flr(self.timer)!=self._timer and self._timer!=0 then
        self._timer=flr(self.timer)
        Screen:play_sfx(10,0.2)
    elseif self.timer<=0 and self.exploded==false then
        self.exploded=true
        self.dy=0
        for a in all(Actors.actors) do
            if a.class=="enemy" and a.life>0 and in_radius(self,a,2.5) then -- 3=blast_radius
                a:damage_enemy(self.dmg)
            elseif a.class=="player" and in_radius(self,a,2.5) then
                a:damage()
            end
        end
        for y=self.y-2,self.y+2 do
            for x=self.x-2,self.x+2 do
                local m=Map:mget(x,y)
                if fget(m,0) and fget(m,6) then
                    Map:mclear(x,y)
                end
            end
        end
        Screen:play_sfx(18,0.5)
    elseif self.timer<=-1 then
        Actors:remove_actor(self)
    end
end

local function draw(self)
    if self.timer<0 then
        local a=self.timer*-2
        if a>1 then
            a=2-a
        end
        fillp(0b0101101001011010.11)
        circfill(self.x*8,self.y*8,a*24,8)--10)
        --circfill(self.x*8,self.y*8,a*18,9)
        --circfill(self.x*8,self.y*8,a*12,8)
        --circfill(self.x*8,self.y*8,a*6,7)
        fillp()
    else
        if flr(self.timer*2%2)==1 then
            pal(3,8)
        end
        self:draw_actor()
        Graphics:reset_pal()
    end
end

return {
    get=function ()
        return {
            name="bomb",
            w=0.875,
            h=0.875,
            f=40,
            dx=0,
            dy=0.125,
            dmg=2,
            timer=3,
            _timer=2,
            exploded=false,

            init = init,
            init_bomb = init,
            update = update,
            update_bomb = update,
            draw = draw,
            draw_bomb = draw
        }
    end
}
