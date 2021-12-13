return {
    x=0,
    y=0,
    init=init,
    update=function(self)
        -- camera movement (tile by tile)
        if self.x!=Screen.current_position.x*8 then
            local dx=1
            if Screen.current_position.x*8<self.x then dx=-1 end
            self.x+=dx*8
        end
        if self.y!=Screen.current_position.y*8 then
            local dy=1
            if Screen.current_position.y*8<self.y then dy=-1 end
            self.y+=dy*8
        end
    end,
    draw=function(self)
        camera(self.x,self.y)
    end,
    set_position=function(self,p)
        self.x=p.x
        self.y=p.y
    end,
    set_screen_position=function(self,p)
        p=Screen.get_position(p)
        p.x*=8
        p.y*=8
        self:set_position(p)
    end
}
