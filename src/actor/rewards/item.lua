local function open(self)
    if self.name=="coin" then
        Player.coins+=1
    elseif self.name=="harpoon" then
        if Player.harpoon_count>=Player.harpoon_max then
            if self.collided==false then
                Screen:play_sfx(9)
            end
            return
        end
        Player.harpoon_count+=1
    elseif self.name=="cord" then
        Player.cord_length_max+=8
    elseif self.name=="life" then
        if Player.life>=Player.life_max then
            if self.collided==false then
                Screen:play_sfx(9)
            end
            return
        end
        Player.life+=1
    elseif self.name=="speed" then
        Player.speed+=0.25/8
    end

    self:open_reward()
    self:animate()
end

local function set_reward(self,f)
    self:_set_reward(f)
    self.name=self.r
end

return {
    get=function ()
        return {
            name="coin",
            w=1,
            h=1,

            open=open,
            open_item=open,

            set_reward=set_reward,
        }
    end
}
