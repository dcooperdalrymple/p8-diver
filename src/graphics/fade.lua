return {
    state="",

    _in=function (self,color,ticks)
        self:_init("in",color,ticks)
    end,

    out=function (self,color,ticks)
        self:_init("out",color,ticks)
    end,

    init=function (self)
        self:_init("")
    end,
    _init=function (self,state,color,ticks)
        color = color or 0
        ticks = ticks or (1/Config.tdelta)/30

        self.state=state
        self.color=color
        self.index=17
        self.ticks=ticks
        self.tick=ticks
    end,

    update=function (self)
        if (self.state=="") return

        if self.state=="in" then
            self._index=17-self.index
        else
            self._index=self.index
        end

        self.tick-=1
        if self.tick<=0 then
            self.tick=self.ticks

            self.index-=1
            if self.index<0 then
                self.state=""
            end
        end
    end,

    draw=function (self)
        if (self.state=="") return
        fillp(self.pat[self._index])
        rectfill(0,0,127,127,self.color)
        fillp()
    end,

    pat={
        0x0000.8,
        0x8000.8,
        0x8020.8,
        0xa020.8,
        0xa0a0.8,
        0xa4a0.8,
        0xa4a1.8,
        0xa5a1.8,
        0xa5a5.8,
        0xe5a5.8,
        0xe5b5.8,
        0xf5b5.8,
        0xf5f5.8,
        0xfdf5.8,
        0xfdf7.8,
        0xfff7.8,
        0xffff.8
    },
}
