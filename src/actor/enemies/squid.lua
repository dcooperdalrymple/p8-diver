local function update(self)
    self:update_enemy()

    if self.life<=0 then
        return
    end

    -- bob vertically
    self.y=self._y+sin(State.time/4+self.seed)*2+0.5/8
end

local function draw(self)
    if not self.__y then
        self.__y=self.y
    end

    if self.life<=0 or self.y-self.__y>0 then -- moving down
        self:draw_enemy()
    else -- moving up
        self.draw_actor({
            f=self.f,
            center=self.center,
            s=self.s,
            x=self.x,
            y=self.y-self.h/4,
            w=self.w,
            h=self.h/2,
            flx=self.flx,
            fly=self.fly,
            life=self.life
        })
        self.draw_actor({
            f=0x7c,
            center=self.center,
            s=self.s,
            x=self.x,
            y=self.y+self.h/4,
            w=self.w,
            h=self.h/2,
            flx=self.flx,
            fly=self.fly,
            life=self.life
        })
    end

    self.__y=self.y
end

return {
    get=function ()
        return {
            class="enemy",
            name="squid",
            w=2,
            h=2,
            f=59,
            seed=rnd(3.1415*2),
            update=update,
            update_squid=update,
            draw=draw,
            draw_squid=draw,
            life=2,
        }
    end
}