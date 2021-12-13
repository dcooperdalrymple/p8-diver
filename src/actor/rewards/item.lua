local function open(self)
    local item=Inventory:get_item(self.name)
    if self.name=="coin" then
        Inventory:add_item("coin")
    elseif self.name=="harpoon" or self.name=="life" or self.name=="bomb" then
        if not Inventory:add_item(self.name) then
            if self.collided==false then
                Screen:play_sfx(9)
            end
            return
        end
    elseif self.name=="cord" then
        Inventory:add_item("cord",8,true)
    elseif self.name=="speed" then
        Player.speed+=0.03125
    end

    self:open_reward()
    self:animate()
end

return {
    get=function ()
        return {
            name="coin",
            w=1,
            h=1,

            open=open,
            open_item=open,

            set_reward=function(self,f)
                self:_set_reward(f)
                self.name=self.r
            end,
        }
    end
}
