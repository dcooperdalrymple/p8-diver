return {
    visited=false,
    visited_current_x=false,
    visited_current_y=false,
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
        self.visited_current_x=x
        self.visited_current_y=y
    end,
    draw=function (self)
        if self.visited==false or self.visited_current_x==false then
            return
        end

        local x=122
        local y=11
        local c_1=3
        local c_2=7
        local c_3=11
        rectfill(x-1,y-1,x+Map.screen_width,y+Map.screen_height,0)
        for j=0,Map.screen_height-1 do
            for i=0,Map.screen_width-1 do
                if self.visited_current_x==i and self.visited_current_y==j then
                    pset(x+i,y+j,c_3)
                elseif self.visited[j][i] then
                    pset(x+i,y+j,c_2)
                else
                    pset(x+i,y+j,c_1)
                end
            end
        end
    end
}
