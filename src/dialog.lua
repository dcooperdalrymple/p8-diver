return {
    active_key=false,
    active_index=false,
    events=split("artifact#you've found_a mysterious_artifact...~what do you do now?#reward~chest~unknown,cord#some extra breathing tube!_this will come in handy...~maybe i should delve deeper?#reward~chest~cord,key#a mysterious key!_there should be a door_around here that fits.#reward~chest~key,bomb#finally!_now i can do_some real damage~or maybe_there's a way_deeper?#reward~chest~bomb"),
    init=function(self)
        self.active_key=false
        self.active_index=false

        if type(self.events[1])=="string" then
            for k,e in pairs(self.events) do
                e=split(e,"#")
                self.events[k]={
                    name=e[1],
                    text=split(e[2],"~"),
                    trigger=e[3]
                }
            end
        end

        for e in all(self.events) do
            e.activated=false
            e.completed=false
            e.line=1
        end
    end,
    check=function(self,trigger) -- trigger is sequence describing event as string, no split "a~b~c"
        if type(trigger)=="table" then
            trigger=merge_table(trigger,"~")
        end
        for k,e in pairs(self.events) do
            if not e.activated and e.trigger==trigger then
                self:start(k)
            end
        end
    end,
    update=function(self)
        if self.active_key!=false then
            State.paused=true
            local e=self.events[self.active_key]
            if btnp(4) then
                if e.line>=#e.text then
                    e.completed=true
                    self.active_key=false
                    State.paused=false
                else
                    e.line+=1
                end
                Screen:play_sfx(9)
            end
        end
    end,
    start=function(self,k)
        self.active_key=k
        self.events[k].line=1
        self.events[k].activated=true
        self.events[k].completed=false

        if Config.dev then
            printh("dialog opened: "..self.events[k].name)
        end
    end,
    draw=function(self)

        -- start controls
        if Screen.current_index==Screen.start_index then
            if not State.started then
                local text="diver"
                local s=4+sin(State.time/4)*2+0.5
                local x=64-#text*2*s+s/2
                local y=64-5*s/2

                prints(text,x,y,s,s,14)

                for j=y,y+5*s+1 do
                    --local k=(j-y)/(5*s+1)

                    local c=0
                    if j>=64 then
                        c=8
                    end

                    local m=flr(9-(j-64)/2)
                    if m<1 then
                        m=1
                    end

                    for i=x,x+#text*4*s do
                        local _c=pget(i,j)
                        if _c==14 then
                            if flr(flr(i)+flr(j)*m/2)%m==0 then
                            pset(i,j,c)
                            else
                                pset(i,j,0)
                            end
                        end
                    end
                end

                text="press \142 to start"
                printo(text,64-#text*2,86)
            else
                printo("swim:\139\148\131\145",2,11)
                printo("use:\142",2,17)
                printo("inv:\151",2,23)
            end
        end

        if not self.active_key then
            return
        end

        local e=self.events[self.active_key]
        local text=e.text[e.line]
        local lines=split(text,"_")
        local len=0
        for l in all(lines) do
            if #l>len then
                len=#l
            end
        end
        local x=60-len*2
        local y=58-#lines*3
        local w=len*4+6
        local h=#lines*6+14
        rectfill(x,y,x+w,y+h,0)
        for l in all(lines) do
            print(l,x+4,y+4,7)
            y+=6
        end
        print("press \142",27+w/2,y+6,5)
    end
}
