function ActorRewardTreasure()
    return {
        name="chest",
        f=25,
        w=2,
        h=2,
        open=function(self)
            self:open_reward()

            self.f=57 -- open sprite

            if self.r=="coin" then
                Inventory:add_item("coin",6)
            elseif self.r=="harpoon" or self.r=="bomb" then
                Inventory:add_item(self.r,5,true)
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
    }
end
