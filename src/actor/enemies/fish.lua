local function update(self)
    self:update_enemy()

    if (self.life<=0) return

    -- move left to right
    self.dx=self.speed*self.dir

    local adjx=self.x+self.dir
    if Map:is_solid(adjx,self.y) or adjx<flr(self.x/16)*16+1 or adjx>flr(self.x/16+1)*16-1 then
        self.dir*=-1
        self.flx=self.dir<0
    end
end

return {
    get=function ()
        return {
            name="fish",
            w=2,
            h=1,
            f=23,
            speed=0.125,
            dir=1, -- random?
            life=1,
            update=update,
            update_fish=update
        }
    end
}
