local function init(self)
    self:init_actor()
    if Config.dev==true then
        printh("chest reward frame: "..self.rf,Config.log)
        printh("chest reward type: "..self.r,Config.log)
    end
end

local function open(self)
    self:open_reward()

    self.f=57 -- open sprite

    if Config.dev==true then
        printh("chest opened: "..self.r,Config.log)
    end

    if self.r=="coin" then
        Player.coins+=5
    elseif self.r=="harpoon" then
        Player.harpoon_max+=2
        Player.harpoon_count+=2
    elseif self.r=="cord" then
        Player.cord_length_max+=16
    elseif self.r=="life" then
        Player.life_max+=1
        Player.life+=1
    elseif self.r=="speed" then
        Player.speed+=0.5/8
    end

    -- Show reward and animate up
    local a = Actors:create_reward(self.rf,self.x,self.y,2/8,4/8)
    --a:init()
    a:animate()
end

return {
    get=function ()
        return {
            name="chest",
            f=25,
            w=2,
            h=2,

            init=init,
            init_treasure=init,

            open=open,
            open_treasure=open,
        }
    end
}
