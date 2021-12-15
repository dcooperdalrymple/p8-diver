-- Collision

function get_bounds(a)
    local s=a.s or 1
    local bounds={
        x1=a.x,
        y1=a.y,
        x2=a.x+a.w*s,
        y2=a.y+a.h*s,
    }
    if a.center then
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

function in_radius(a,b,r)
    local dx=a.x-b.x
    local dy=a.y-b.y
    return dist2(dx,dy)<=r*r
end

-- String

function pad(str,len)
    if (#str>=len) return str
    return "0"..pad(str,len-1)
end

-- Table

function in_table(a,t)
    for b in all(t) do
        if a==b then
            return true
        end
    end
    return false
end

function merge_table(t,sep)
    sep=sep or ","
    local s=""
    for i in all(t) do
        if s!="" then
            s..=sep
        end
        s..=tostr(i)
    end
    return s
end

-- Distance

function dist2(x,y)
    return x*x+y*y
end
function dist(x,y)
    return sqrt(dist2(x,y))
end
function idist(x,y)
    return 1/dist(x,y)
end

-- Debug

--[[
function var_dump(t)
    for k,v in pairs(t) do
        if type(v)=="function" or type(v)=="table" then
            printh(k..":"..type(v))
        else
            printh(k..":"..type(v)..":"..tostr(v))
        end
    end
end
]]--
