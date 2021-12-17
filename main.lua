-- diver
-- by coopersnout

tdelta=1/30 --1/60

State = {
    reset=function (self)
        Time=0
        Started=false
        Paused=false
    end,
    update=function (self)
        if not Started and btnp(4) then
            Started=true
        end
        Time+=tdelta
    end
}

Path = {
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
    end
}

Graphics = {
    palbw=split("0,5,5,5,5,6,7,6,6,7,7,6,6,6,7,0"),
    reset_pal=function(force)
        if (Paused and force!=true) return
        pal()
        palt(14, true)
        palt(0, false)
    end,
    draw_around=function(x,y,w,h,c) -- fills around around a rect
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
    end,
    reset=function(self)
        self.reset_pal()
    end
}
Fade = {
    state="",

    _in=function (self,color,ticks)
        self:_init("in",color,ticks)
    end,

    out=function (self,color,ticks)
        self:_init("out",color,ticks)
    end,

    init=function (self)
        self:_init("")
    end,
    _init=function (self,state,color,ticks)
        color = color or 0
        ticks = ticks or (1/tdelta)/30

        self.state=state
        self.color=color
        self.index=17
        self.ticks=ticks
        self.tick=ticks
    end,

    update=function (self)
        if (self.state=="") return

        if self.state=="in" then
            self._index=17-self.index
        else
            self._index=self.index
        end

        self.tick-=1
        if self.tick<=0 then
            self.tick=self.ticks

            self.index-=1
            if self.index<0 then
                self.state=""
            end
        end
    end,

    draw=function (self)
        if (self.state=="") return
        fillp(self.pat[self._index])
        rectfill(0,0,127,127,self.color)
        fillp()
    end,

    pat={
        0x0000.8,
        0x8000.8,
        0x8020.8,
        0xa020.8,
        0xa0a0.8,
        0xa4a0.8,
        0xa4a1.8,
        0xa5a1.8,
        0xa5a5.8,
        0xe5a5.8,
        0xe5b5.8,
        0xf5b5.8,
        0xf5f5.8,
        0xfdf5.8,
        0xfdf7.8,
        0xfff7.8,
        0xffff.8
    },
}

Player = false
Boat = false

Actors = require("src/actors")
Camera = {
    x=0,
    y=0,
    update=function(self)
        -- camera movement (tile by tile)
        if self.x!=Screen.current_position.x*8 then
            local dx=1
            if Screen.current_position.x*8<self.x then dx=-1 end
            self.x+=dx*8
        end
        if self.y!=Screen.current_position.y*8 then
            local dy=1
            if Screen.current_position.y*8<self.y then dy=-1 end
            self.y+=dy*8
        end
    end,
    draw=function(self)
        camera(self.x,self.y)
    end,
    set_position=function(self,p)
        self.x=p.x
        self.y=p.y
    end,
    set_screen_position=function(self,p)
        p=Screen.get_position(p)
        p.x*=8
        p.y*=8
        self:set_position(p)
    end
}
Map = {
    --[[
    flags:
        0=solid
        1=treasure
            2=coin
            3=harpoon
            4=cord
            5=heart
            6=speed
            7=bomb
        2=enemy
            3=fish
            4=urchin
            5=squid
            6=angler
            7=alien
        3=boat
        4=sky
        5=player
        6=bombable
        7=lava
    ]]--

    hidden=split("1_10_7_4,53_27_4_5,55_39_7_4,37_58_11_5,43_33_5_5,42_38_4_3,48_59_4_2,48_61_7_3,16_86_4_4,27_86_5_4,26_75_6_5,53_70_11_6,58_75_6_5,58_80_6_16,58_96_6_2,59_96_5_4,60_100_4_5,48_96_11_4,48_88_6_3,51_124_4_4,56_124_4_4"), -- x_y_w_h, used to reduce tokens

    screen_width=4,
    screen_height=8,

    visited=false,
    visited_current_x=false,
    visited_current_y=false,

    init=function(self)
        reload()
        if type(self.hidden[1])=="string" then
            for k,i in pairs(self.hidden) do
                i=split(i,"_",true)
                self.hidden[k]={
                    x=i[1],
                    y=i[2],
                    w=i[3],
                    h=i[4]
                }
            end
        end
    end,
    load=function(self)
        for y=0,128 do
            for x=0,64 do
                m=self:mget(x,y)
                local a
                if fget(m,0) then -- solid
                elseif fget(m,1) then -- reward
                    if m==25 then -- chest
                        local rf=Map:mget(x+1,y)
                        a = Actors:create_reward(m,x,y,ActorRewardTreasure(),0,0.375)
                        a:set_reward(rf)
                    else -- individual item
                        a = Actors:create_reward(m,x,y,ActorRewardItem())
                        a:set_reward(m)
                    end
                elseif fget(m,2) then -- enemy
                    if fget(m,3) then
                        Actors:create_enemy(m,x,y,ActorEnemyFish())
                    elseif fget(m,4) then
                        Actors:create_enemy(m,x,y,ActorEnemyUrchin())
                    elseif fget(m,5) then
                        a=Actors:create_enemy(m,x,y,ActorEnemySquid())
                        if Screen:in_screen(a,9) then -- boss
                            a.s=2
                            a.life=8
                        end
                    elseif fget(m,6) then
                        a=Actors:create_enemy(m,x,y,ActorEnemyAngler())
                        if Screen:in_screen(a,18) then -- boss
                            a.s=2
                            a.life=8
                        end
                    elseif fget(m,7) then
                        a=Actors:create_enemy(m,x,y,ActorEnemyAlien())
                        if Screen:in_screen(a,28) then -- control room
                            a.s=2
                            a.life=4
                        end
                    end
                elseif fget(m,3) then -- boat
                    if not Boat then
                        Boat = Actors:create_actor(m,x,y,ActorBoat(),0,1.25,2)
                    end
                elseif fget(m,5) then -- player
                    Player = Actors:create_actor(m,x,y,ActorPlayer())
                end
            end
        end
    end,
    update=function(self)
        -- animate wave
        local f=3+flr(Time*2)%4

        -- water
        local y=3
        for x=0,64 do
            local m=self:mget(x,y)
            if m>=3 and m<=6 then
                self:mset(x,y,f)
            end
        end

        -- lava
        f+=110
        y=62
        for x=0,64 do
            local m=self:mget(x,y)
            if m>=113 and m<=116 then
                self:mset(x,y,f)
            end
        end

        -- hud
        if not self.visited then
            self.visited={}
            for j=0,8 do
                self.visited[j]={}
                for i=0,4 do
                    self.visited[j][i]=false
                end
            end
        end

        if Screen.current_index!=false then
            local x=Screen.current_index%4
            local y=flr(Screen.current_index/4)
            if not self.visited[y][x] then
                self.visited[y][x]=true
            end
            self.visited_current_x=x
            self.visited_current_y=y
        end
    end,
    draw=function(self)
        -- draw map in actual location
        local mapp=self.get_pos()
        map(mapp.x,mapp.y,Screen.current_position.x*8,Screen.current_position.y*8,16,16)
    end,
    draw_hidden=function(self)
        for area in all(self.hidden) do
            if Screen:in_screen(area) then
                local col=collide(Player,area)
                local f=area.f or 1
                for y=area.y,area.y+area.h-1 do
                    for x=area.x,area.x+area.w-1 do
                        if not collide(Player,{x=x,y=y,w=1,h=1}) then
                            if col then
                                if dist2(Player.x-(x+0.5),Player.y-(y+0.5))<=9 then
                                    fillp(0b0101101001011010.11)
                                else
                                    fillp()
                                end
                            end
                            spr(f,x*8,y*8)
                        end
                    end
                end
                fillp()
            end
        end
    end,
    draw_hud=function(self)
        if self.visited!=false and self.visited_current_x!=false then
            rectfill(121,117,126,126,0)
            for j=0,7 do
                for i=0,3 do
                    if self.visited_current_x==i and self.visited_current_y==j then
                        pset(122+i,118+j,11)
                    elseif self.visited[j][i] then
                        pset(122+i,118+j,7)
                    else
                        pset(122+i,118+j,3)
                    end
                end
            end
        end
    end,
    get_pos=function(self,p)
        p=p or Screen.current_position
        local _p=Screen.get_position(p)

        i=Screen:get_index(_p)
        if i>=16 then
            _p.x+=16*4
            _p.y-=16*4
        end

        return _p
    end,
    get_tile_pos=function(self,p)
        i=Screen:get_index(p)
        if i>=16 then
            p.x+=16*4
            p.y-=16*4
        end
        return p
    end,
    mget=function(self,x,y)
        local p=self:get_tile_pos({
            x=x,
            y=y
        })
        return mget(p.x,p.y)
    end,
    mset=function(self,x,y,f)
        local p=self:get_tile_pos({
            x=x,
            y=y
        })
        return mset(p.x,p.y,f)
    end,
    mclear=function(self,x,y,w,h,m)
        w=w or 1
        h=h or 1
        m=m or 0
        for _y=y,y+h-1 do
            for _x=x,x+w-1 do
                self:mset(_x,_y,m)
            end
        end
    end,
    is_solid=function(self,x,y)
        return fget(self:mget(x,y),0)
    end
}
--Clouds = require("src/graphics/clouds")
Screen = {
    bubbles={},
    bubbles_max=64,
    init=function(self)
        self.current_index=false
        self.current_position=false
        self.current_sfx=-1
        self.current_music=-1
        self.sfx_timer=0
    end,
    update=function(self)
        if not self.current_index or self:get_index(Player)!=self.current_index then
            self:change()
        end
        if self.sfx_timer>0 then
            self.sfx_timer-=tdelta
            if self.sfx_timer<=0 then
                Screen:sfx()
            end
        end
    end,
    change=function(self)
        local d={"screenchange",self.current_index}

        self.current_index=self:get_index(Player)
        self.current_position=self.get_position(Player)

        add(d,self.current_index)
        Dialog:check(d)
        Dialog:check({"screen",self.current_index})

        self:music()
        self:sfx()
    end,
    get_index=function(self,p)
        return flr(p.y/16)*4+flr(p.x/16)
    end,
    get_position=function(p)
        return {
            x=flr(p.x/16)*16,
            y=flr(p.y/16)*16
        }
    end,
    in_screen=function(self,p,index)
        index=index or self.current_index
        return index==self:get_index(p)
    end,
    same=function(self,a,b,index)
        index=index or self.current_index
        return self:in_screen(a,index) and self:in_screen(b,index)
    end,
    sfx=function(self,index)
        index=index or self:get_index(Player)
        local selected=0
        if index<8 and index!=4 then
            selected=7
        else
            selected=8
        end
        if selected!=self.current_sfx then
            sfx(selected,3)
            self.current_sfx=selected
        end
    end,
    music=function(self,index)
        index=index or self:get_index(Player)
        local selected=flr(index/8)
        if index==4 then
            selected=1
        end
        if selected!=self.current_music then
            music(selected)
            self.current_music=selected
        end
    end,
    draw_bg=function(self,index)
        index=index or self:get_index(Player)
        local bgc=8
        local fgc=0
        local buc=0
        if Paused then
            bgc=0
            fgc=5
            buc=6
        elseif index<8 and index!=4 then
            bgc=1
            fgc=2
            buc=12
        elseif index<16 then
            bgc=2
            fgc=0
            buc=0
        elseif index<24 then
            bgc=0
            fgc=8
            buc=8
        end

        cls(bgc)
        for i=0,16 do
            fillp(Fade.pat[16-i])
            rectfill(0,96+32/16*i,128,96+32/16*(i+1),fgc)
        end
        fillp()

        if Paused!=true then
            local first=#self.bubbles==0
            while #self.bubbles<self.bubbles_max do
                local y=128
                if first then y=rnd(128) end
                add(self.bubbles,{
                    x=rnd(128),
                    y=y,
                    dy=rnd(1)*-0.1-0.1,
                    dx=0,
                    seed=rnd(1)
                })
            end
            for b in all(self.bubbles) do
                b.dx=cos(b.seed+Time)/10
                b.x+=b.dx
                b.y+=b.dy
                if b.x<0 or b.x>128 or b.y<0 then
                    del(self.bubbles,b)
                end
            end
        end
        for b in all(self.bubbles) do
            pset(b.x,b.y,buc)
        end
    end,
    play_sfx=function(self,n,l)
        l=l or 0.1
        self.current_sfx=-1
        sfx(n,3)
        self.sfx_timer=l
    end
}

Dialog = require("src/dialog")
Shop = require("src/shop")
Inventory = require("src/inventory")

function _init()
    restart()
    menuitem(1,"restart",restart)
    Fade:init()
end

function restart()
    cls()
    reload()

    Graphics.reset_pal()
    State:reset()

    Screen:init()
    Actors:init()
    Map:init()
    Dialog:init()
    Shop:init()
    Inventory:init()

    Map:load()
    Actors:load() -- must be run after Map:load() for actors to be created

    --[[ Dev Mode
    Player.speed=0.33
    Player.x=8
    Player.y=115
    Inventory:add_item("life",7,true)
    Inventory:add_item("cord",512,true)
    Inventory:add_item("harpoon",99,true)
    Inventory:add_item("bomb",99,true)
    Inventory:add_item("dagger",1,true)
    Inventory:add_item("key",99,true)
    --]]--

    Screen:update()
    Camera:set_screen_position(Player)
end

function _update()
--function _update60()

    if not Paused then
        Actors:update()
        Map:update()
        --Clouds:update()
    end

    Dialog:update()
    if Started then
        Shop:update()
        Inventory:update()
    end

    Fade:update()
    State:update()

end

function _draw()
    if Paused then
        pal(Graphics.palbw)
    end

    Screen:draw_bg()
    Screen:update()

    Camera:update()
    Camera:draw()

    Map:draw()
    --Clouds:draw()

    -- draw everything else black
    Graphics.draw_around(Screen.current_position.x*8,Screen.current_position.y*8,16*8,16*8,0)

    local c=5
    if Screen.current_index<8 then
        c=2
    elseif Screen.current_index<16 then
        c=1
    end
    Path:draw(Player.cord,c)

    Actors:draw()

    Map:draw_hidden()

    if Paused then
        Graphics.reset_pal(true)
    end

    -- reset for hud
    if Started then
        camera()
        Inventory:draw()
        Map:draw_hud()
    end

    -- draw player over hud
    Camera:draw()
    Player:draw()

    camera()
    Shop:draw()
    Fade:draw()
    Dialog:draw()
end

-- Global Functions

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
function follow_target(self,b,speed)
    speed=speed or 1
    flx=flx or true
    self.dx=b.x-self.x
    self.dy=b.y-self.y
    local d=idist(self.dx,self.dy)
    self.dx*=d*speed
    self.dy*=d*speed
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
