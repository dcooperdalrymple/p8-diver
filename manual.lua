-- diver manual
-- by coopersnout, 2021

tdelta=1/30 --1/60

function _init()
    restart()
    menuitem(1,"restart",restart)
end

function restart()
    reload()
    Time=0
    Page=1
    PrevPage=false
    NextPage=false

    Fade:_in()
end

function _update()
    Time+=tdelta

    -- Page Turning
    Fade:update()
    if not NextPage and not PrevPage and btnp(1) then
        NextPage=true
        Fade:out()
    elseif not NextPage and not PrevPage and Page>1 and btnp(0) then
        PrevPage=true
        Fade:out()
    elseif not Fade.state and (NextPage or PrevPage) then
        if NextPage then
            Page+=1
        else
            Page-=1
        end
        NextPage=false
        PrevPage=false
        Fade:_in()
    end

    -- Reset Map
    for y=0,15 do
        for x=0,15 do
            mset(x,y,0)
        end
    end

    if Page<=2 then -- Wave
        for x=0,15 do
            mset(x,0,2)
            mset(x,1,Time%4+3)
            mset(x,15,51)
        end
    elseif Page>=3 and Page<=4 then -- Cave Border
        mset(0,0,18)
        mset(15,0,20)
        mset(15,15,52)
        mset(0,15,50)
        for x=1,14 do
            mset(x,0,19)
            mset(x,15,51)
        end
        for y=1,14 do
            mset(0,y,34)
            mset(15,y,36)
        end
    elseif Page>=5 and Page<=6 then -- Lava Border
        mset(0,0,18)
        mset(15,0,20)
        mset(0,15,117)
        mset(15,15,118)
        for x=1,14 do
            mset(x,0,19)
            mset(x,15,112)
        end
        for y=1,14 do
            mset(0,y,34)
            mset(15,y,36)
        end
        for x=1,14 do
            mset(x,14,Time%4+113)
        end
    end

end

function reset_pal()
    pal()
    palt(14, true)
    palt(0, false)
end

bubbles={}
bubbles_max=64
function _draw()
    reset_pal()
    camera()

    -- Background
    bgc=7
    fgc=6
    buc=6

    cls(bgc)
    for i=0,16 do
        fillp(Fade.pat[16-i])
        rectfill(0,96+32/16*i,128,96+32/16*(i+1),fgc)
    end
    fillp()

    local first=#bubbles==0
    while #bubbles<bubbles_max do
        local y=128
        if first then y=rnd(128) end
        add(bubbles,{
            x=rnd(128),
            y=y,
            dy=rnd(1)*-0.1-0.1,
            dx=0,
            seed=rnd(1)
        })
    end
    for b in all(bubbles) do
        b.dx=cos(b.seed+Time)/10
        b.x+=b.dx
        b.y+=b.dy
        if b.x<0 or b.x>128 or b.y<0 then
            del(bubbles,b)
        else
            pset(b.x,b.y,buc)
        end
    end

    -- Map
    map(0,0,0,0,16,16)

    -- Page Number
    local y=114
    if (Page>=5 and Page<=6) y-=3
    if Page<=2 then
        if Page%2==1 then
            print("pAGE:"..Page,2,y,0)
            print("nEXT:\145",99,y,2)
        else
            print("pAGE:"..Page,103,y,0)
            print("pREV/nEXT:\139\145",2,y,2)
        end
    else
        if Page%2==1 then
            print("pAGE:"..Page,9,y,0)
            print("pREV/nEXT:\139\145",64,y,2)
        else
            print("pAGE:"..Page,96,y,0)
            print("pREV/nEXT:\139\145",9,y,2)
        end
    end

    Fade:draw()
end

-- Global Functions

Fade = {

    _in=function (self,ticks)
        self:init("in",ticks)
    end,

    out=function (self,ticks)
        self:init("out",ticks)
    end,

    init=function (self,state,ticks)
        ticks = ticks or (1/tdelta)/30/2

        self.state=state
        self.index=17
        self.ticks=ticks
        self.tick=ticks
    end,

    update=function (self)
        if self.state then

            self._index=self.index
            if self.state=="in" then
                self._index=18-self._index
            end

            self.tick-=1
            if self.tick<=0 then
                self.tick=self.ticks

                self.index-=1
                if self.index<=0 then
                    self.state=false
                end
            end

        end
    end,

    draw=function (self)
        if self.state then
            fillp(tonum(self.pat[self._index]))
            rectfill(0,0,127,127,0)
            fillp()
        end
    end,

    pat=split("0x0000.8,0x8000.8,0x8020.8,0xa020.8,0xa0a0.8,0xa4a0.8,0xa4a1.8,0xa5a1.8,0xa5a5.8,0xe5a5.8,0xe5b5.8,0xf5b5.8,0xf5f5.8,0xfdf5.8,0xfdf7.8,0xfff7.8,0xffff.8")

}

-- String

function pad(str,len)
    if (#str>=len) return str
    return "0"..pad(str,len-1)
end

-- Print text with outline
function printo(s,x,y,c,o)
    c=c or 7
    o=o or 0
    print(s,x-1,y,o)
    print(s,x+1,y,o)
    print(s,x,y-1,o)
    print(s,x,y+1,o)
    print(s,x,y,c)
end

-- Print text with scale
function prints(text,tlx,tly,sx,sy,col)
    -- get buffer
    local b={}
    for y=0,5 do
        b[y]={}
        for x=0,#text*4 do
            b[y][x]=pget(x,y)
        end
    end

    print(text,0,0,14)
    for y=0,5 do
        for x=0,#text*4 do
            local _col=pget(x,y)
            if _col==14 then
                local nx=x*sx+tlx
                local ny=y*sy+tly
                rectfill(nx,ny,nx+sx,ny+sy,col)
            end
        end
    end

    -- reload buffer
    for y=0,5 do
        for x=0,#text*4 do
            pset(x,y,b[y][x])
        end
    end
end
