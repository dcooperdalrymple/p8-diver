local function update(self)
    self:update_actor()

    -- bob
    self.y=self._y+sin(State.time/2)*0.125+0.0625
    self.x=self._x+cos(State.time/8)*0.25+0.0625
end

return {
    get=function ()
        return {
            class="boat",
            name="boat",
            w=4,
            h=2,
            f=11,
            update=update,
            update_boat=update,
        }
    end
}
