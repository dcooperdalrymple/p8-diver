local function init(self)
    self:init_actor()
end

local function open(self)
    self:open_reward()

    self.f=57 -- open sprite

    if Config.dev==true then
        printh("chest opened: "..self.r)
    end

    if self.r=="coin" then
        Inventory:add_item("coin",5)
    elseif self.r=="harpoon" or self.r=="bomb" then
        Inventory:add_item(self.r,2,true)
    elseif self.r=="cord" then
        Inventory:add_item("cord",16,true)
    elseif in_table(self.r,split("life,unknown,dagger,key")) then
        Inventory:add_item(self.r,1,true)
    elseif self.r=="speed" then
        Player.speed+=0.0625
    end

    -- Show reward and animate up
    local a = Actors:create_reward(self.rf,self.x,self.y,nil,-0.25,-1)
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
