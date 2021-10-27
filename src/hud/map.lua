return {
    visited=false,
    visited_current=false,
    update=function (self)
        if self.visited==false then
            self.visited={}
            for j=0,Map.screen_height do
                self.visited[j]={}
                for i=0,Map.screen_width do
                    self.visited[j][i]=false
                end
            end
        end

        if not Screen.current_index then
            return
        end

        local x=Screen.current_index%Map.screen_width
        local y=flr(Screen.current_index/Map.screen_width)
        if self.visited[y][x]==false then
            self.visited[y][x]=true
        end
        self.visited_current={
            x=x,
            y=y,
        }
    end,
    draw=function (self)
        if self.visited==false or self.visited_current==false then
            return
        end

        local x=128-2-4
        local y=10
        local c={0,7,11}
        for j=0,Map.screen_height do
            for i=0,Map.screen_width do
                if self.visited_current.x==i and self.visited_current.y==j then
                    pset(x+i,y+j,c[3])
                elseif self.visited[j][i] then
                    pset(x+i,y+j,c[2])
                else
                    pset(x+i,y+j,c[1])
                end
            end
        end
    end
}
