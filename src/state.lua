return {
    reset=function (self)
        self.time=0
        self.started=false
        self.paused=false
    end,
    update=function (self)
        if not self.started and btnp(4) then
            self.started=true
        end
        self.time+=Config.tdelta
    end
}
