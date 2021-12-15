-- pathfinding, used for breathing tube

return {
    calc=function(self,path,start,goal)
        if path==nil or #path<2 then
            path={start,goal}
        end

        path[1]=start
        path[#path]=goal

        -- check if we need to add another point
        if self:cast(path[#path],path[#path-1]) then
            add(path,path[#path])
            path[#path-1].x=self.ray_x
            path[#path-1].y=self.ray_y
        elseif #path>2 and not self:castcast(path[#path],path[#path-1],path[#path-2]) then -- check if the last point is not needed
            del(path,path[#path-1])
        end

        return path
    end,
    get_length=function(self,path) -- get length of list of points
        local l=0
        local _pt
        for pt in all(path) do
            if _pt then
                l+=dist(_pt.x-pt.x,_pt.y-pt.y)
            end
            _pt=pt
        end
        return l
    end,
    cast=function(self,a,b,r) -- simple cast to find if solid is in path -- r=resolution
        self.ray_x=a.x
        self.ray_y=a.y
        r=r or 1

        local dx=b.x-a.x
        local dy=b.y-a.y
        local d=idist(dx,dy)/r
        dx*=d
        dy*=d

        while true do
            self.ray_x+=dx
            self.ray_y+=dy
            if abs(self.ray_x-b.x)<1 and abs(self.ray_y-b.y)<1 then
                return false
            end
            if Map:is_solid(self.ray_x,self.ray_y) then
                return true
            end
        end

        return false
    end,
    castcast=function(self,a,b,c,r) -- cast between a triangle to find solid
        local rayray_x=b.x
        local rayray_y=b.y
        r=r or 1

        local dx=c.x-b.x
        local dy=c.y-b.y
        local d=idist(dx,dy)/r
        dx*=d
        dy*=d

        while true do
            rayray_x+=dx
            rayray_y+=dy
            if abs(self.ray_x-c.x)<1 and abs(self.ray_y-c.y)<1 then
                return false
            end
            if self:cast(a,{x=rayray_x,y=rayray_y},r) then
                return true
            end
        end

        return false
    end,
    draw=function(self,path,c)
        local _pt
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
}
