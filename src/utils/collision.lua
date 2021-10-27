function get_bounds(a)
    local s=a.s or 1
    local bounds={
        x1=a.x,
        y1=a.y,
        x2=a.x+a.w*s,
        y2=a.y+a.h*s,
    }
    if a.center==true then
        bounds.x1-=a.w*s/2
        bounds.y1-=a.h*s/2
        bounds.x2-=a.w*s/2
        bounds.y2-=a.h*s/2
    end
    return bounds
end

function collide(a,b)
    local ab=get_bounds(a)
    local bb=get_bounds(b)
    return ab.x2>bb.x1 and ab.x1<bb.x2 and ab.y2>bb.y1 and ab.y1<bb.y2
end
