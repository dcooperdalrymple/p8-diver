local function update(self)
    self:update_enemy()

    if self.life<=0 then
        return
    end

    -- fix oscillation & dy
    self.y-=self.dy
    self._y+=self.dy

    -- bob vertically
    self.y=self._y+sin(State.time/2+self.seed)*0.25+0.0625

    -- follow player
    if Screen:same(self,Player) and not Path:cast(self,Player) then
        self.dx=Player.x-self.x
        self.dy=Player.y-self.y
        local d=1/sqrt(self.dx*self.dx+self.dy*self.dy)
        self.dx=self.dx*d*self.sp
        self.dy=self.dy*d*self.sp

        self.flx=self.dx<0
    else
        self.dx=0
        self.dy=0
    end
end

return {
    get=function ()
        return {
            name="angler",
            w=2,
            h=2,
            f=71,
            seed=rnd(6.283),
            life=3,
            dir=0,
            sp=0.0625,
            update=update,
            update_angler=update,
        }
    end
}
