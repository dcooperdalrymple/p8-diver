local function init(self)
    self:init_projectile()
    Screen:play_sfx(1,0.2)
end

return {
    get=function ()
        return {
            name="harpoon",
            w=2,
            h=0.625,
            f=48,
            dx=0.25,
            dy=0.01,
            dmg=1,

            init = init,
            init_harpoon = init
        }
    end
}
