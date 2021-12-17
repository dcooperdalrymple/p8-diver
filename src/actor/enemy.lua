local function update(self)
    self:update_actor()

    if self.life>0 then
        if collide(Player,self) then
            Player:damage()
        end
    elseif self.dy!=0 and Map:is_solid(self.x,self.y+self.dy) then
        self.dy=0
    end
end

local function draw(self)
    if self.life>0 then
        self:draw_actor()
    else
        pal(Graphics.palbw)
        self:draw_actor()
        Graphics.reset_pal()
    end
end

function ActorEnemy()
    return {
        class="enemy",
        life=1,
        update = update,
        update_enemy = update,
        damage = function(self,dmg)
            dmg=dmg or 1
            self.life-=dmg
            if self.life<=0 then
                self.dy=0.02
                self.dx=0
                self.fly=true
            end
        end,
        draw = draw,
        draw_enemy = draw,
    }
end
