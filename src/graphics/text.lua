
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
