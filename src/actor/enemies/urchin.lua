local function update(self)
    self:update_enemy()

    if self.life<=0 then
        return
    end

    -- bob around
    self.y=self._y+sin(State.time/4+self.seed)*0.125+0.0625
    self.x=self._x+cos(State.time/4+self.seed)*0.125+0.0625
end

return {
    get=function ()
        return {
            name="urchin",
            w=1,
            h=1,
            f=39,
            seed=rnd(6.283),
            update=update,
            update_urchin=update,
            life=1,
        }
    end
}
