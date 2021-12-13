return {
    palbw=split("0,5,5,5,5,6,7,6,6,7,7,6,6,6,7,0"),
    reset_pal=function(force)
        if State.paused==true and force!=true then
            return
        end
        pal()
        palt(14, true)
        palt(0, false)
    end,
    draw_around=function(x,y,w,h,c) -- fills around around a rect
        c=c or 0
        if y>0 then -- top
            rectfill(0,0,128*8,y-1,0)
        end
        if y<128*8-h then -- bottom
            rectfill(0,y+w,128*8,128*8,0)
        end
        if x>0 then -- left
            rectfill(0,0,x-1,128*8,0)
        end
        if x<128*8-w then -- right
            rectfill(x+w,128*8,128*8,0)
        end
    end,
    reset=function(self)
        self.reset_pal()
    end
}
