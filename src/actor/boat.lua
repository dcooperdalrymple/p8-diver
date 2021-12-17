function ActorBoat()
    return {
        class="boat",
        name="boat",
        w=4,
        h=2,
        f=11,
        update=function(self)
            self:update_actor()

            -- bob
            self.y=self._y+sin(Time/2)*0.125+0.0625
            self.x=self._x+cos(Time/8)*0.25+0.0625
        end
    }
end
