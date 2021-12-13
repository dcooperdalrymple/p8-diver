local function init(self)
    self:init_projectile()
    Screen:play_sfx(1,0.2)
end

return {
    get=function ()
        return {
            name="bomb",
            w=0.875,
            h=0.875,
            f=40,
            dx=0,
            dy=0.125,
            dmg=2,

            init = init,
            init_bomb = init
        }
    end
}
