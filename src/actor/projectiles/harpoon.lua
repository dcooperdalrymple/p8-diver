function ActorProjectileHarpoon()
    return {
        name="harpoon",
        w=2,
        h=0.625,
        f=48,
        dx=0.25,
        dy=0.01,
        dmg=1,

        init = function(self)
            self:init_projectile()
            Screen:play_sfx(1,0.2)
        end
    }
end
