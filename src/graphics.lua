-- game specific

local function reset_pal()
    pal()
    palt(14, true)
    palt(0, false)
end

-- fills around around a rect
local function draw_around(x,y,w,h,c)
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
end

-- general routines

local function arc(x,y,r,angle,c,offset)
    offset=offset or 0
    if angle<0 then return end
    for i=0,.75,.25 do
        local a=angle
        if a<i then break end
        if a>i+.25 then a=i+.25 end
        local x1=x+r*cos(i+offset)
        local y1=y+r*sin(i+offset)
        local x2=x+r*cos(a+offset)
        local y2=y+r*sin(a+offset)
        local cx1=min(x1,x2)
        local cx2=max(x1,x2)
        local cy1=min(y1,y2)
        local cy2=max(y1,y2)
        clip(cx1,cy1,cx2-cx1+2,cy2-cy1+2)
        circ(x,y,r,c)
        clip()
    end
end

return {
    palbw={1,1,5,5,5,6,7,6,6,7,7,6,6,6,7,0},
    reset_pal=reset_pal,
    draw_around=draw_around,
    arc=arc,
    reset=function (self)
        self.reset_pal()
    end,
}
