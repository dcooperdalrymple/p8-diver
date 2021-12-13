return {
    timer=0,
    init=function(self)
        self.timer=0
    end,
    update=function(self)
        if self.timer>0 then
            self.timer-=Config.tdelta
            if self.timer<=0 then
                Screen:sfx()
            end
        end
    end
}
