-- pathfinding
-- used for breathing tube

local function calc(self,path,start,goal)
    if path==nil or #path<2 then
        path={start,goal}
    end

    path[1]=start
    path[#path]=goal

    -- check if we need to add another point
    if self:cast(path[#path],path[#path-1]) then
        add(path,path[#path])
        path[#path-1].x=self.ray.x
        path[#path-1].y=self.ray.y
    else
        -- check if the last point is not needed
        if #path>2 and not self:castcast(path[#path],path[#path-1],path[#path-2]) then
            del(path,path[#path-1])
        end
    end

    return path
end

-- get length of list of points
local function get_length(self,path)
    local l=0
    local _pt=false
    for pt in all(path) do
        if _pt!=false then
            local dx=_pt.x-pt.x
            local dy=_pt.y-pt.y
            l+=sqrt(dx*dx+dy*dy)
        end
        _pt=pt
    end
    return l
end

-- simple cast to find if solid is in path
local function cast(self,a,b,r) -- r=resolution
    self.ray={
        x=a.x,
        y=a.y
    }
    r=r or 1

    local d,dx,dy=0
    dx=b.x-a.x
    dy=b.y-a.y
    d=(1/sqrt(dx*dx+dy*dy))/r
    dx*=d
    dy*=d

    while true do
        self.ray.x+=dx
        self.ray.y+=dy
        if abs(self.ray.x-b.x)<1 and abs(self.ray.y-b.y)<1 then
            return false
        end
        if Map:is_solid(self.ray.x,self.ray.y) then
            return true
        end
    end

    return false
end

-- cast between a triangle to find solid
local function castcast(self,a,b,c,r)
    self.rayray={
        x=b.x,
        y=b.y
    }
    r=r or 1

    local d,dx,dy=0
    dx=c.x-b.x
    dy=c.y-b.y
    d=(1/sqrt(dx*dx+dy*dy))/r
    dx*=d
    dy*=d

    while true do
        self.rayray.x+=dx
        self.rayray.y+=dy
        if abs(self.ray.x-c.x)<1 and abs(self.ray.y-c.y)<1 then
            return false
        end
        if self:cast(a,self.rayray,r) then
            return true
        end
    end

    return false
end

local function draw(self,path,c)
    _pt=false
    for pt in all(path) do
        if _pt then
            line(_pt.x*8,_pt.y*8,pt.x*8,pt.y*8,c)
        end
        _pt=pt
    end
    if Config.dev then
        for pt in all(path) do
            pset(pt.x*8,pt.y*8,12)
        end
    end
end

return {
    ray={
        x=0,
        y=0
    },
    rayray={
        x=0,
        y=0
    },
    calc=calc,
    get_length=get_length,
    cast=cast,
    castcast=castcast,
    draw=draw
}
