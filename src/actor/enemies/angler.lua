function ActorEnemyAngler()
    return {
        name="angler",
        w=2,
        h=2,
        f=71,
        seed=rnd(6.283),
        life=3,
        dir=0,
        update=function(self)
            self:update_enemy()

            if (self.life<=0) return

            -- fix oscillation & dy
            self.y-=self.dy
            self._y+=self.dy

            -- bob vertically
            self.y=self._y+sin(Time/2+self.seed)*0.25+0.0625

            -- follow player
            if Screen:same(self,Player) and not Path:cast(self,Player) then
                follow_target(self,Player,0.0625)
                self.flx=self.dx<0
            else
                self.dx=0
                self.dy=0
            end
        end
    }
end
