-- dialogue system

local function init(self)
    self.active_key=false
    self.active_index=false
    for e in all(self.events) do
        e.activated=false
        e.completed=false
        e.line=1
    end
end

local function update(self)
    if self.active_key!=false then
        State.paused=true
        local e=self.events[self.active_key]
        if btnp(4) then
            if e.line>=#e.text then
                e.completed=true
                self.active_key=false
            else
                e.line+=1
            end
            play_sfx(9)
        end
    else
        State.paused=false
        for k,e in pairs(self.events) do
            if e.activated==false and e:activate() then
                self.start(k)
            end
        end
    end
end

local function start(self,k)
    self.active_key=k
    self.events[k].line=1
    self.events[k].activated=true
    self.events[k].completed=false

    if Config.dev==true then
        printh("dialog opened: "..self.events[k].name,Config.log)
    end
end

local function draw(self)

    -- start controls
    if Screen.current_index==Screen.start_index then

        if State.started==false then
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
    local lines=split(text,"_",false)
    local len=0
    for l in all(lines) do
        if #l>len then
            len=#l
        end
    end
    local x=64-len*2-6+2
    local y=64-#lines*3-6
    local w=len*4+6
    local h=#lines*6+8+4+2
    rectfill(x,y,x+w,y+h,0)
    x+=4
    y+=4
    for l in all(lines) do
        print(l,x,y,7)
        y+=6
    end
    x=64+w/2-6-7-6*4
    y+=2
    print("press 🅾️",x,y,5)
end

return {
    active_key=false,
    active_index=false,
    events={
        {
            name="artifact",
            text={
                "you've found_a mysterious_artifact...",
                "what do you do now?",
            },
            activate=function (self)
                for a in all(actors) do
                    if a.class=="treasure" and a.name=="chest" and a.r=="unknown" and a.activated==true then
                        return true
                    end
                end
                return false
            end,
        },
        {
            name="cord",
            text={
                "some extra breathing tube!_this will come in handy...",
                "maybe i should delve deeper?",
            },
            activate=function (self)
                for a in all(actors) do
                    if a.class=="treasure" and a.name=="chest" and a.r=="cord" and a.activated==true then
                        return true
                    end
                end
                return false
            end,
        },
        {
            name="key",
            text={
                "a mysterious key!_there should be a door_around here that fits.",
            },
            activate=function (self)
                for a in all(actors) do
                    if a.class=="treasure" and a.name=="chest" and a.r=="key" and a.activated==true then
                        return true
                    end
                end
                return false
            end
        }
    },
    init=init,
    update=update,
    start=start,
    draw=draw
}
