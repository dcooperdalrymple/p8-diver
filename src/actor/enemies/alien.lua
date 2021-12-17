function ActorEnemyAlien()
    return {
        name="alien",
        w=1,
        h=2,
        f=67,
        life=2,
        fire_timer=rnd(2)+1,
        flx_timer=0,
        shots={},
        update=function(self)
            self:update_enemy()

            for a in all(self.shots) do
                if Map:is_solid(a.x,a.y) or not Screen:same(a,self) then
                    del(self.shots,a)
                elseif collide(a,Player) then
                    Player:damage()
                    del(self.shots,a)
                else
                    a.x+=a.dx
                    a.y+=a.dy
                end
            end

            if (self.life<=0) return

            if Screen:same(self,Player) and not Path:cast(self,Player) then
                follow_target(self,Player,0.015625)
                self.dy=0

                if self.dx!=0 then
                    self.flx_timer-=tdelta
                    if self.flx_timer<0 then
                        self.flx=not self.flx
                        self.flx_timer=0.25
                    end
                end

                self.fire_timer-=tdelta
                if self.fire_timer<0 then
                    if self.s>1 then
                        self.fire_timer=rnd(1)+0.5
                    else
                        self.fire_timer=rnd(2)+1
                    end
                    local a={
                        w=0.25,
                        h=0.25,
                        x=self.x,
                        y=self.y
                    }
                    follow_target(a,Player,0.25)
                    add(self.shots,a)
                end
            else
                self.dx=0
            end
        end,
        draw=function(self)
            self:draw_enemy()
            for a in all(self.shots) do
                circfill(a.x*8,a.y*8,1,9)
            end
        end
    }
end
