return {
    clouds={},
    clouds_max=16,
    update=function(self)
        if (Screen:get_index(Player)>=4) return

        for c in all(self.clouds) do
            c.x+=c.dx
            c.y=c._y+sin(Time*c.dt+c.seed)*c.ds
            if c.x-c.r1>128*Map.screen_width then
                del(self.clouds,c)
            end
        end

        if #self.clouds<self.clouds_max then
            for i=#self.clouds,self.clouds_max do
                c=self.make()
                add(self.clouds,c)
            end
        end
    end,
    make=function(self)
        c={
            x=rnd(128*Map.screen_width),
            y=rnd(32)-8,
            dx=0.05+rnd(0.15),
            r1=flr(rnd(4)+4),
            r2=flr(rnd(4)+4),
            r3=flr(rnd(4)+4),
            l1=flr(rnd(6)+4),
            l2=flr(rnd(6)+4),
            seed=rnd(1),
            dt=rnd(0.2)+0.05,
            ds=rnd(3),
        }
        c._y=c.y
        return c
    end,
    draw=function(self)
        if Screen.current_index>=4 then
            return
        end

        for c in all(self.clouds) do
            circfill(c.x,c.y,c.r1,7)
            circfill(c.x+c.l1,c.y,c.r2,7)
            circfill(c.x+c.l1+c.l2,c.y,c.r3,7)
        end
    end
}
