local function init(self)
    self:init_actor()
    if self.flx then
        a.dx*=-1
    end
end

local function update(self)
    self:update_actor()

    -- check wall collision
    if (not self.flx and Map:is_solid(self.x+self.w/2,self.y)) or (self.flx and Map:is_solid(self.x-self.w/2,self.y)) then
        Actors:remove_actor(self)
        Screen:play_sfx(11)
        return
    end

    -- check enemy collision
    for a in all(Actors.actors) do
        if a.class=="enemy" then
            if a.life>0 and collide(self,a) then
                a:damage_enemy(self.dmg)
                Actors:remove_actor(self)
                Screen:play_sfx(2)
                break
            end
        end
    end
end

return {
    get=function ()
        return {
            class="projectile",
            dmg=1,
            init=init,
            init_projectile=init,
            update=update,
            update_projectile=update,
        }
    end
}
