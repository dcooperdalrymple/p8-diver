return {
    time=0,
    started=false,
    paused=false,
    reset=function (self)
        self.time=0
        self.started=false
        self.paused=false
    end,
    update=function (self)
        if self.started==false and btnp(4) then
            self.started=true
        end
        self.time+=Config.tdelta
    end
}
