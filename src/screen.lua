return {
    bubbles={},
    bubbles_max=64,
    init=function(self)
        self.start_index=false
        self.start_position=false
        self.current_index=false
        self.current_position=false
        self.current_sfx=-1
        self.current_music=-1
        self.sfx_timer=0
    end,
    update=function(self)
        if not self.current_index or self:get_index(Player)!=self.current_index then
            self:change()
        end
        if self.sfx_timer>0 then
            self.sfx_timer-=Config.tdelta
            if self.sfx_timer<=0 then
                Screen:sfx()
            end
        end
    end,
    change=function(self)
        self.current_index=self:get_index(Player)
        self.current_position=self.get_position(Player)
        if not self.start_index then self.start_index=self.current_index end
        if not self.start_position then self.start_position=self.current_position end

        self:music()
        self:sfx()
    end,
    get_index=function(self,p)
        return flr(p.y/16)*4+flr(p.x/16)
    end,
    get_position=function(p)
        return {
            x=flr(p.x/16)*16,
            y=flr(p.y/16)*16
        }
    end,
    in_screen=function(self,p,index)
        index=index or self.current_index
        return index==self:get_index(p)
    end,
    same=function(self,a,b,index)
        index=index or self.current_index
        return self:in_screen(a,index) and self:in_screen(b,index)
    end,
    sfx=function(self,index)
        index=index or self:get_index(Player)
        local selected=0
        if index<8 and index!=4 then
            selected=7
        else
            selected=8
        end
        if selected!=self.current_sfx then
            sfx(selected,3)
            self.current_sfx=selected
        end
    end,
    music=function(self,index)
        index=index or self:get_index(Player)
        local selected=flr(index/8)
        if index==4 then
            selected=1
        end
        if selected!=self.current_music then
            music(selected)
            self.current_music=selected
        end
    end,
    draw_bg=function(self,index)
        index=index or self:get_index(Player)
        local bgc=8
        local fgc=0
        local buc=0
        if State.paused then
            bgc=0
            fgc=5
            buc=6
        elseif index<8 and index!=4 then
            bgc=1
            fgc=2
            buc=12
        elseif index<16 then
            bgc=2
            fgc=0
            buc=0
        elseif index<24 then
            bgc=0
            fgc=8
            buc=8
        end

        cls(bgc)
        for i=0,16 do
            fillp(Fade.pat[16-i])
            rectfill(0,96+32/16*i,128,96+32/16*(i+1),fgc)
        end
        fillp()

        if State.paused!=true then
            local first=#self.bubbles==0
            while #self.bubbles<self.bubbles_max do
                local y=128
                if first then y=rnd(128) end
                add(self.bubbles,{
                    x=rnd(128),
                    y=y,
                    dy=rnd(1)*-0.1-0.1,
                    dx=0,
                    seed=rnd(1)
                })
            end
            for b in all(self.bubbles) do
                b.dx=cos(b.seed+State.time)/10
                b.x+=b.dx
                b.y+=b.dy
                if b.x<0 or b.x>128 or b.y<0 then
                    del(self.bubbles,b)
                end
            end
        end
        for b in all(self.bubbles) do
            pset(b.x,b.y,buc)
        end
    end,
    play_sfx=function(self,n,l)
        l=l or 0.1
        self.current_sfx=-1
        sfx(n,3)
        self.sfx_timer=l
    end
}
