local function update(self)
    self.x+=self.dx
    self.y+=self.dy

    if self.a!=false and self.at+self.as<=State.time then
        self.at=State.time
        self.ai+=1
        if self.ai>count(self.a) then
            self.ai=1
        end
        self.f=self.a[self.ai]
    end
end

local function draw(self)
    local _x=self.x*8
    local _y=self.y*8
    if self.s==1 then
        if self.center then
            _x-=self.w*4
            _y-=self.h*4
        end
        spr(self.f,_x,_y,self.w,self.h,self.flx,self.fly)
    else
        if self.center then
            _x-=self.w*self.s*4
            _y-=self.h*self.s*4
        end
        sspr(self.f%16*8,flr(self.f/16)*8,self.w*8,self.h*8,_x,_y,self.w*self.s*8,self.h*self.s*8,self.flx,self.fly)
    end
end

return {
    get=function ()
        return {
            class="",
            name="",
            f=0,
            x=0,
            y=0,
            dx=0,
            dy=0,
            w=1,
            h=1,
            s=1, -- scale
            center=true,
            flx=false,
            fly=false,

            init=function(self) end,
            update=update,
            update_actor=update,
            draw=draw,
            draw_actor=draw,

            a=false, -- list of frames
            as=1, -- animation speed (sec)
            at=State.time, -- animation timer
            ai=1 -- animation index
        }
    end
}
