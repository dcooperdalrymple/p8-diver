return {
    get=function ()
        return {
            name="urchin",
            w=1,
            h=1,
            f=39,
            seed=rnd(6.283),
            update=function(self)
                self:update_enemy()

                if (self.life<=0) return

                -- Still use movement
                self._y+=self.dy
                self._x+=self.dx
                if self.dy!=0 and Map:is_solid(self._x,self._y) then
                    self.dx=0
                    self.dy=0
                end

                -- bob around
                self.y=self._y+sin(State.time/4+self.seed)*0.125+0.0625
                self.x=self._x+cos(State.time/4+self.seed)*0.125+0.0625
            end,
            life=1
        }
    end
}
