local function init(self)
    self:init_projectile()
    Screen:play_sfx(1,0.2)
end

return {
    get=function ()
        return {
            name="harpoon",
            w=2,
            h=5/8,
            f=48,
            dx=2/8,
            dy=0.01,
            dmg=1,

            init = init,
            init_harpoon = init,
        }
    end
}
