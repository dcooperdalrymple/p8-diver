-- diver
-- by coopersnout, 2021

tdelta=1/30 --1/60

function StateReset()
    Time=0
    Started=false
    Paused=false
    Dead=false
    DeadStarted=false
    Escaped=false
    Pod=nil
end
function StateUpdate()
    if (not Started and btnp(5)) Started=true
    if (Dead or Escaped) and btnp(5) then
        DeadStarted=true
        Fade:out()
    end
    if DeadStarted and not Fade.state then
        restart()
    end
    if (not Started or not Paused) Time+=tdelta
end

function get_path_length(path) -- get length of list of points
    local l=0
    local _pt
    for pt in all(path) do
        if _pt then
            l+=dist(_pt.x-pt.x,_pt.y-pt.y)
        end
        _pt=pt
    end
    return l
end

function draw_path(path,c)
    local _pt
    for pt in all(path) do
        if _pt then
            line(_pt.x*8,_pt.y*8,pt.x*8,pt.y*8,c)
        end
        _pt=pt
    end
end

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
    end
}

-- Graphics
palbw=split("0,5,5,5,5,6,7,6,6,7,7,6,6,6,7,0")
function reset_pal(force)
    if (Paused and force!=true) return
    pal()
    palt(14, true)
    palt(0, false)
end
function draw_around(x,y,w,h,c) -- fills around around a rect
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
end

Fade = {

    _in=function (self,ticks)
        self:init("in",ticks)
    end,

    out=function (self,ticks)
        self:init("out",ticks)
    end,

    init=function (self,state,ticks)
        ticks = ticks or (1/tdelta)/30

        self.state=state
        self.index=17
        self.ticks=ticks
        self.tick=ticks
    end,

    update=function (self)
        if self.state then

            self._index=self.index
            if self.state=="in" then
                self._index=18-self._index
            end

            self.tick-=1
            if self.tick<=0 then
                self.tick=self.ticks

                self.index-=1
                if self.index<=0 then
                    self.state=false
                end
            end

        end
    end,

    draw=function (self)
        if self.state then
            fillp(tonum(self.pat[self._index]))
            rectfill(0,0,127,127,0)
            fillp()
        end
    end,

    pat=split("0x0000.8,0x8000.8,0x8020.8,0xa020.8,0xa0a0.8,0xa4a0.8,0xa4a1.8,0xa5a1.8,0xa5a5.8,0xe5a5.8,0xe5b5.8,0xf5b5.8,0xf5f5.8,0xfdf5.8,0xfdf7.8,0xfff7.8,0xffff.8")

}

-- Actors!

function Actor()
    local function update(self)
        self.x+=self.dx
        self.y+=self.dy

        if self.a and self.at+self.as<=Time then
            self.at=Time
            self.ai+=1
            if self.ai>count(self.a) then
                self.ai=1
            end
            self.f=self.a[self.ai]
        end
    end

    local function draw(self)
        local _x=self.x*8
        local _y=self.y*8
        if self.center then
            _x-=self.w*self.s*4
            _y-=self.h*self.s*4
        end
        sspr(self.f%16*8,flr(self.f/16)*8,self.w*8,self.h*8,_x,_y,self.w*self.s*8,self.h*self.s*8,self.flx,self.fly)
    end

    return {
        --class="",
        --name="",
        --f=0,
        x=0,
        y=0,
        dx=0,
        dy=0,
        w=1,
        h=1,
        s=1, -- scale
        center=true,
        --flx=false,
        --fly=false,

        init=function(self) end,
        reload=function(self) end,
        update=update,
        update_actor=update,
        draw=draw,
        draw_actor=draw,

        --a=false, -- list of frames
        --as=1, -- animation speed (sec)
        at=Time, -- animation timer
        ai=1 -- animation index
    }
end

function ActorReward()
    local function update(self)
        self:update_actor()

        if self.animating then
            self.t-=tdelta
            if self.t<=0 then
                del(Actors,self)
            end
            return
        end

        if self.activated or Dead or not collide(Player,self) then
            self.collided=false
            return
        end

        self:open()
        self.collided=true
    end

    local function open(self)
        self.activated=true
        Screen:play_sfx(0)
        Dialog:check({self.class,self.name,self.r})
    end

    local function draw(self)
        if self.animating and self.t<self.tmax/2 then
            fillp(0b0101101001011010.11)
            self:draw_actor()
            fillp()
        else
            self:draw_actor()
        end
    end

    local function animate(self,t)
        t = t or 2
        self.activated=true
        self.animating=true
        self.dy=-0.01
        self.t=t
        self.tmax=t
    end

    local function set_reward(self,f)
        self.rf=f or self.f
        if fget(self.rf,2) then
            self.r="coin"
        elseif fget(self.rf,3) then
            self.r="harpoon"
        elseif fget(self.rf,4) then
            self.r="cord"
        elseif fget(self.rf,5) then
            self.r="life"
        elseif fget(self.rf,6) then
            self.r="speed"
        elseif fget(self.rf,7) then
            self.r="bomb"
        elseif self.rf==85 then -- flag for key?
            self.r="key"
        elseif self.rf==77 then
            self.r="dagger"
        elseif self.rf==126 then
            self.r="suit"
        else
            self.r="unknown"
        end
    end

    return {
        class="reward",
        w=1,
        h=1,

        rf=-1,
        r="unknown",

        activated=false,
        animating=false,
        collided=false,

        update=update,
        update_reward=update,
        draw=draw,
        draw_reward=draw,

        open=open,
        open_reward=open,

        animate=animate,
        animate_reward=animate,

        set_reward=set_reward,
        _set_reward=set_reward,
    }
end
function ActorRewardItem()
    return {
        name="item",
        w=1,
        h=1,

        open=function(self)
            local item=Inventory:get_item(self.r)
            if self.r=="coin" then
                Inventory:add_item("coin")
            elseif self.r=="harpoon" or self.r=="life" or self.r=="bomb" then
                if not Inventory:add_item(self.r) then
                    if not self.collided then
                        Screen:play_sfx(9)
                    end
                    return
                end
            elseif self.r=="cord" then
                Inventory:add_item("cord",8,true)
            elseif self.r=="speed" then
                Player.speed+=0.03125
            elseif self.r=="key" then
                Inventory:add_item("key",1,true)
            elseif self.r=="suit" then
                Player.suit=true
            end

            self:open_reward()
            self:animate()
        end,

        set_reward=function(self,f)
            self:_set_reward(f)
        end
    }
end
function ActorRewardTreasure()
    return {
        name="chest",
        f=25,
        w=2,
        h=2,
        open=function(self)
            self:open_reward()

            self.f=57 -- open sprite

            if self.r=="coin" then
                Inventory:add_item("coin",6)
            elseif self.r=="harpoon" or self.r=="bomb" then
                Inventory:add_item(self.r,5,true)
            elseif self.r=="cord" then
                Inventory:add_item("cord",16,true)
            elseif in_table(self.r,"life,unknown,dagger,key") then
                Inventory:add_item(self.r,1,true)
            elseif self.r=="speed" then
                Player.speed+=0.0625
            end

            -- Show reward and animate up
            local a = CreateReward(self.rf,self.x,self.y,nil,-0.25,-1)
            a:animate()
        end
    }
end

function ActorEnemy()
    local function update(self)
        self:update_actor()

        if self.life>0 then
            Player:damage(self)
        elseif self.dy!=0 and Map:is_solid(self.x,self.y+self.dy) then
            self.dy=0
        end
    end

    local function draw(self)
        if self.life>0 then
            self:draw_actor()
        else
            pal(palbw)
            self:draw_actor()
            reset_pal()
        end
    end

    return {
        class="enemy",
        life=1,
        reload = function(self,index)
            if self.screen==index and self.life>0 then
                self._x=self.__x
                self._y=self.__y
                self.x=self.__x
                self.y=self.__y
            end
        end,
        update = update,
        update_enemy = update,
        damage = function(self,dmg)
            dmg=dmg or 1
            self.life-=dmg
            if self.life<=0 then
                self.dy=0.02
                self.dx=0
                self.fly=true
            end
        end,
        draw = draw,
        draw_enemy = draw,
    }
end
function ActorEnemyFish()
    return {
        name="fish",
        w=2,
        h=1,
        f=23,
        speed=0.125,
        dir=1, -- random?
        life=1,
        update=function(self)
            self:update_enemy()

            if self.life>0 then
                -- move left to right
                self.dx=self.speed*self.dir

                local adjx=self.x+self.dir
                if Map:is_solid(adjx,self.y) or adjx<flr(self.x/16)*16+1 or adjx>flr(self.x/16+1)*16-1 then
                    self.dir*=-1
                    self.flx=self.dir<0
                end
            end
        end
    }
end
function ActorEnemyUrchin()
    return {
        name="urchin",
        w=1,
        h=1,
        f=39,
        seed=rnd(6.283),
        update=function(self)
            self:update_enemy()

            if self.life>0 then
                -- Still use movement
                self._y+=self.dy
                self._x+=self.dx
                if self.dy!=0 and Map:is_solid(self._x,self._y) then
                    self.dx=0
                    self.dy=0
                end

                -- bob around
                self.y=self._y+sin(Time/4+self.seed)*0.125+0.0625
                self.x=self._x+cos(Time/4+self.seed)*0.125+0.0625
            end
        end,
        life=1
    }
end
function ActorEnemySquid()
    return {
        name="squid",
        w=2,
        h=2,
        f=59,
        seed=rnd(6.283),
        update=function(self)
            self:update_enemy()

            if self.life<=0 then
                if self.s>1 and not self.rewarded then
                    self.rewarded=true
                    CreateReward(85,self.x,self.y,ActorRewardItem()):set_reward() -- key
                end
            else
                -- bob vertically
                self.y=self._y+sin(Time/4+self.seed)*2+0.0625

                -- shoot (boss only)
                if self.s>1 and Screen:same(self,Player) and not Path:cast(self,Player) then
                    self.timer-=tdelta
                    if self.timer<=0 then
                        self.timer=3+rnd(2)
                        local a=CreateEnemy(39,self.x,self.y,ActorEnemyUrchin())
                        follow_target(a,Player,0.1)
                    end
                end
            end
        end,
        draw=function(self)
            if not self.___y then
                self.___y=self.y
            end

            if self.life<=0 or self.y-self.___y>0 then -- moving down
                self:draw_enemy()
            else -- moving up
                self.draw_actor({
                    f=self.f,
                    center=self.center,
                    s=self.s,
                    x=self.x,
                    y=self.y-0.5*self.s,
                    w=self.w,
                    h=1,
                    flx=self.flx,
                    fly=self.fly,
                    life=self.life
                })
                self.draw_actor({
                    f=0x7c,
                    center=self.center,
                    s=self.s,
                    x=self.x,
                    y=self.y+0.5*self.s,
                    w=self.w,
                    h=1,
                    flx=self.flx,
                    fly=self.fly,
                    life=self.life
                })
            end

            self.___y=self.y
        end,
        life=2,
        timer=4
    }
end
function ActorEnemyAngler()
    return {
        name="angler",
        w=2,
        h=2,
        f=71,
        seed=rnd(6.283),
        life=3,
        dir=0,
        update=function(self)
            self:update_enemy()

            if self.life>0 then
                -- fix oscillation & dy
                --self.y-=self.dy
                self._y+=self.dy

                -- bob vertically
                self.y=self._y+sin(Time/2+self.seed)*0.25+0.0625

                -- follow player
                self.dx=0
                self.dy=0
                if Screen:same(self,Player) and not Path:cast(self,Player) then
                    follow_target(self,Player,0.0625)
                    self.flx=self.dx<0
                end
            end
        end
    }
end
function ActorEnemyAlien()
    return {
        name="alien",
        w=1,
        h=2,
        f=67,
        life=2,
        fire_timer=rnd(2)+1,
        flx_timer=0,
        shots={},
        update=function(self)
            self:update_enemy()

            for a in all(self.shots) do
                if Map:is_solid(a.x,a.y) or not Screen:same(a,self) or Player:collide(a) then
                    Player:damage(a)
                    del(self.shots,a)
                else
                    a.x+=a.dx
                    a.y+=a.dy
                end
            end

            if self.life>0 then
                self.dx=0
                if Screen:same(self,Player) and not Path:cast(self,Player) then
                    follow_target(self,Player,0.015625)
                    self.dy=0

                    if self.dx!=0 then
                        self.flx_timer-=tdelta
                        if self.flx_timer<0 then
                            self.flx=not self.flx
                            self.flx_timer=0.25
                        end
                    end

                    self.fire_timer-=tdelta
                    if self.fire_timer<0 then
                        if self.s>1 then
                            self.fire_timer=rnd(1)+0.5
                        else
                            self.fire_timer=rnd(2)+1
                        end
                        local a={
                            w=0.25,
                            h=0.25,
                            x=self.x,
                            y=self.y
                        }
                        follow_target(a,Player,0.25)
                        add(self.shots,a)
                    end
                end
            end
        end,
        draw=function(self)
            self:draw_enemy()
            for a in all(self.shots) do
                circfill(a.x*8,a.y*8,1,9)
            end
        end
    }
end

function ActorBoat()
    return {
        class="boat",
        name="boat",
        w=4,
        h=2,
        f=11,
        update=function(self)
            self:update_actor()

            -- bob
            self.y=self._y+sin(Time/2)*0.125+0.0625
            self.x=self._x+cos(Time/8)*0.25+0.0625
        end
    }
end
function ActorPlayer()
    return {
        class="player",
        name="player",
        f=16,
        w=2,
        h=1.5,

        init = function(self)
            self.life_timer=0
            self.attack_timer=0

            self.speed=0.125

            self.cord={}

            self.doors=split("106_2_2_0_0,107_2_2_-1_0,123_2_2_-1_-1,122_2_2_0_-1,68_1_2_0_0,84_1_2_0_-1") -- f_w_h_dx_dy
            for k,v in pairs(self.doors) do
                self.doors[k]=split(v,"_",true)
            end

            self.escape={x=20,y=121,w=7,h=4}
        end,
        update = function(self)
            self:update_actor()

            if Dead then
                if self.dy!=0 and Map:is_solid(self.x,self.y+self.dy) then
                    self.dy=0
                end
            elseif Started then
                -- timers
                if (self.life_timer>0) self.life_timer-=tdelta
                if (self.attack_timer>0) self.attack_timer-=tdelta
                if (self.attack_timer<0.125) self.dagger=false

                -- player movement
                self.dx=0
                self.dy=0
                local sp=self.speed
                local item=Inventory:get_item("cord")
                if (item.quantity>=item.max) sp*=0.1
                if btn(0) then
                    self.flx=true
                elseif btn(1) then
                    self.flx=false
                end
                if btn(0) and not Map:is_solid(self.x-1,self.y) then
                    self.dx=-sp
                end
                if btn(1) and not Map:is_solid(self.x+0.875,self.y) then
                    self.dx=sp
                end
                if btn(2) and not Map:is_solid(self.x,self.y-0.625) then
                    self.dy=-sp
                end
                if btn(3) and not Map:is_solid(self.x,self.y+0.5) then
                    self.dy=sp
                end

                if self.dx!=0 or self.dy!=0 then
                    self.a={16,103}
                    self.as=0.25
                else
                    self.f=16
                    self.a=false
                end

                -- enviro suit
                if not self.suit and Map:is_lava(self.x,self.y) then
                    self:damage()
                end

                if btnp(4) then
                    item=Inventory.equipped_item
                    if item==nil or item.quantity<=0 then
                        Screen:play_sfx(9)
                    elseif in_table(item.name,"harpoon,bomb") then
                        if self.attack_timer<=0 then
                            self.attack_timer=0.25
                            Inventory:remove_item(item)

                            local a
                            if item.name=="harpoon" then
                                a=CreateProjectile(ActorProjectileHarpoon(),self.x,self.y,-1,-0.375)
                            else
                                a=CreateProjectile(ActorProjectileBomb(),self.x,self.y,0.75,-0.625)
                                if self.flx then
                                    a.x-=2.375
                                end
                            end
                            a.flx=self.flx
                            a:init()
                        else
                            Screen:play_sfx(9)
                        end
                    elseif item.name=="dagger" then
                        if self.attack_timer<=0 then
                            self.attack_timer=0.25

                            for a in all(Actors) do
                                local p={
                                    x=self.x+1.5,
                                    y=self.y,
                                    w=1,
                                    h=1,
                                    center=true
                                }
                                if (self.flx) p.x-=3
                                if in_table(a.name,"urchin,alien") and a.life>0 and collide(p,a) then
                                    a:damage(self.dmg)
                                    Screen:play_sfx(2)
                                    self.dagger=true
                                    break
                                end
                            end
                            if (not self.dagger) Screen:play_sfx(11)
                            self.dagger=true
                        else
                            Screen:play_sfx(9)
                        end
                    elseif item.name=="key" then
                        for y=self.y-1,self.y+1 do
                            for x=self.x-1,self.x+1 do
                                for a in all(self.doors) do
                                    if Map:mget(x,y)==a[1] then
                                        x+=a[4]
                                        y+=a[5]
                                        Map:mclear(x,y,a[2],a[3])
                                        Inventory:remove_item(item)
                                        Screen:play_sfx(19,1.5)
                                    end
                                end
                            end
                        end
                    elseif item.name=="unknown" and collide(self,self.escape) then
                        Pod={}
                        for y=self.escape.y,self.escape.y+self.escape.h do
                            for x=self.escape.x,self.escape.x+self.escape.w do
                                local f=Map:mget(x,y,1,1)
                                if f>0 then
                                    local a=CreateActor(f,x,y)
                                    add(Pod,a)
                                    Map:mclear(x,y)
                                end
                            end
                        end
                        del(Actors,self)
                        music(-1,1000)
                        Screen:play_sfx(23,-1)
                    end
                end
            end

            -- cord
            self.cord=Path:calc(self.cord,{x=Boat.x,y=Boat.y},{x=self.x,y=self.y})
            Inventory:set_item("cord",get_path_length(self.cord))

        end,
        draw = function(self)
            if self.dagger then
                local x=self.x*8+8
                if (self.flx) x-=24
                spr(77,x,self.y*8-4,1,1,self.flx)
            end
            if Dead or (self.life_timer>0 and flr(self.life_timer/tdelta/4)%2==0) then
                pal(palbw)
            elseif self.suit then
                pal(4,3)
            end
            self:draw_actor()
            reset_pal()
        end,
        collide = function(self,obj)
            return collide({
                center=true,
                x=self.x,
                y=self.y-0.25,
                w=1.5,
                h=0.75
            },obj)
        end,
        damage = function(self,obj)
            if (self.life_timer>0 or (type(obj)=="table" and not self:collide(obj)) or Dead) return

            self.life_timer=2 -- timer for invincibility
            Screen:play_sfx(10,0.2)

            -- take damage
            local item=Inventory:get_item("life")
            item.quantity-=1
            if item.quantity==0 then
                Dead=true
                self.dy=0.02
                self.dx=0
                self.fly=true
                self.a=false
                self.f=16
                Screen:_music(5)
            end
        end
    }
end

function ActorProjectile()
    local function init(self)
        if self.flx then
            self.dx*=-1
        end
    end

    local function update(self)
        self:update_actor()

        -- check wall collision
        if (not self.flx and Map:is_solid(self.x+self.w/2,self.y)) or (self.flx and Map:is_solid(self.x-self.w/2,self.y)) then
            del(Actors,self)
            Screen:play_sfx(11)
            return
        end

        -- check enemy collision
        for a in all(Actors) do
            if a.class=="enemy" and a.life>0 and collide(self,a) then
                a:damage(self.dmg)
                del(Actors,self)
                Screen:play_sfx(2)
                break
            end
        end
    end

    return {
        class="projectile",
        dmg=1,
        init=init,
        init_projectile=init,
        update=update,
        update_projectile=update,
    }
end
function ActorProjectileHarpoon()
    return {
        name="harpoon",
        w=2,
        h=0.625,
        f=48,
        dx=0.25,
        dy=0.01,
        dmg=1,

        init = function(self)
            self:init_projectile()
            Screen:play_sfx(1,0.2)
        end
    }
end
function ActorProjectileBomb()
    return {
        name="bomb",
        w=0.875,
        h=0.875,
        f=40,
        dx=0,
        dy=0.125,
        dmg=2,
        timer=3,
        _timer=2,
        damaged={},

        init = function(self)
            self:init_projectile()
            Screen:play_sfx(10,0.2)
        end,
        get_radius = function(self)
            local a=self.timer*-4
            if (a>1) a=2-a
            return a*4
        end,
        update = function(self)
            self:update_actor() -- no update_projectile

            -- check wall collision
            if Map:is_solid(self.x+0.4375,self.y) or Map:is_solid(self.x-0.4375,self.y) or Map:is_solid(self.x,self.y+0.4375) then
                self.dy=0
            end

            self.timer-=tdelta

            if self.timer>0 then
                for a in all(Actors) do
                    if a.class=="enemy" and a.life>0 and collide(self,a) then
                        self.timer=0
                        self.dy=0
                    end
                end
            end

            if self.timer>0 and flr(self.timer)!=self._timer and self._timer!=0 then
                self._timer=flr(self.timer)
                Screen:play_sfx(10,0.2)
            elseif self.timer<=0 and self.timer>-0.5 then
                self.dy=0

                local r=self:get_radius()
                for a in all(Actors) do
                    if not in_table(a,self.damaged) and in_radius(self,a,r) and in_table(a.class,"enemy,player") then
                        add(self.damaged,a)
                        a:damage(self.dmg)
                    end
                end

                for i=0,16 do
                    local x=self.x+cos(i/16)*r
                    local y=self.y+sin(i/16)*r
                    local m=Map:mget(x,y)
                    if fget(m,0) and fget(m,6) then
                        Map:mclear(x,y)
                    end
                end

                if not self.exploded then
                    self.exploded=true
                    Screen:play_sfx(18,0.5)
                end
            elseif self.timer<=-0.5 then
                del(Actors,self)
            end
        end,
        draw = function(self)
            if self.timer<0 then
                fillp(0b0101101001011010.11)
                circfill(self.x*8,self.y*8,self:get_radius()*8,8)--*24,10)
                --circfill(self.x*8,self.y*8,a*18,9)
                --circfill(self.x*8,self.y*8,a*12,8)
                --circfill(self.x*8,self.y*8,a*6,7)
                fillp()
            else
                if (flr(self.timer*2%2)==1) pal(3,8)
                self:draw_actor()
                reset_pal()
            end
        end
    }
end

-- Main Actors functions ("Actors" is global table)

function CreateActor(f,x,y,a,dx,dy,m)
    a=a or {}
    local b=Actor()
    for k,v in pairs(a) do
        b[k]=v
    end
    add(Actors,b)

    dx = dx or 0
    dy = dy or 0
    m = m or 0
    if Map:mget(x,y)==f then
        Map:mclear(x,y,ceil(b.w),ceil(b.h),m)
    end
    b.x=x+dx
    b.y=y+dy
    if b.center then
        b.x+=b.w/2
        b.y+=b.h/2
    end
    b._x=b.x
    b._y=b.y
    b.f=f
    b.screen=get_screen_index(b)
    b.__x=b.x
    b.__y=b.y
    return b
end

function CreateReward(f,x,y,a,dx,dy)
    local a = a or {}
    local b = ActorReward()

    for k,v in pairs(a) do
        b[k]=v
    end

    if f==126 then
        b.w=2
    end

    return CreateActor(f,x,y,b,dx,dy)
end

function CreateEnemy(f,x,y,a,dx,dy)
    local a = a or {}
    local b = ActorEnemy()

    for k,v in pairs(a) do
        b[k]=v
    end

    return CreateActor(f,x,y,b,dx,dy)
end

function CreateProjectile(a,x,y,dx,dy)
    local a = a or {}
    local b = ActorProjectile()

    for k,v in pairs(a) do
        b[k]=v
    end

    return CreateActor(b.f,x,y,b,dx,dy)
end

--CameraX=0
--CameraY=0
function CameraUpdate()
    -- camera movement (tile by tile)
    if CameraX!=Screen.current_position.x*8 then
        local dx=1
        if (Screen.current_position.x*8<CameraX) dx=-1
        CameraX+=dx*8
    end
    if CameraY!=Screen.current_position.y*8 then
        local dy=1
        if (Screen.current_position.y*8<CameraY) dy=-1
        CameraY+=dy*8
    end
end
function CameraSetScreenPosition(p)
    p=get_screen_position(p)
    p.x*=8
    p.y*=8
    CameraX=p.x
    CameraY=p.y
end

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

    init=function(self)
        self.hidden=split("1_10_7_4,53_27_4_5,55_39_7_4,37_58_11_5,43_33_5_5,42_38_4_3,48_59_4_2,48_61_7_3,16_86_4_4,27_86_5_4,26_75_6_5,53_70_11_6,58_75_6_5,58_80_6_16,58_96_6_2,59_96_5_4,60_100_4_5,48_96_11_4,48_88_4_3,52_88_2_2,51_124_4_4,56_124_4_4") -- x_y_w_h, used to reduce tokens
        for k,i in pairs(self.hidden) do
            i=split(i,"_",true)
            self.hidden[k]={
                x=i[1],
                y=i[2],
                w=i[3],
                h=i[4]
            }
        end

        self.visited=false
        self.visited_current_x=false
        self.visited_current_y=false

        reload()
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
                        CreateReward(m,x,y,ActorRewardTreasure(),0,0.375):set_reward(rf)
                    else -- individual item
                        CreateReward(m,x,y,ActorRewardItem()):set_reward()
                    end
                elseif fget(m,2) then -- enemy
                    if fget(m,3) then
                        CreateEnemy(m,x,y,ActorEnemyFish())
                    elseif fget(m,4) then
                        CreateEnemy(m,x,y,ActorEnemyUrchin())
                    elseif fget(m,5) then
                        a=CreateEnemy(m,x,y,ActorEnemySquid())
                        if Screen:in_screen(a,9) then -- boss
                            a.s=2
                            a.life=8
                        end
                    elseif fget(m,6) then
                        a=CreateEnemy(m,x,y,ActorEnemyAngler())
                        if Screen:in_screen(a,18) then -- boss
                            a.s=2
                            a.life=8
                        end
                    elseif fget(m,7) then
                        a=CreateEnemy(m,x,y,ActorEnemyAlien())
                        if Screen:in_screen(a,28) then -- control room
                            a.s=2
                            a.life=4
                        end
                    end
                elseif fget(m,3) then -- boat
                    if not Boat then
                        Boat = CreateActor(m,x,y,ActorBoat(),0,1.25,2)
                    end
                elseif fget(m,5) then -- player
                    Player = CreateActor(m,x,y,ActorPlayer())
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
        local _p=get_screen_position(p)

        i=get_screen_index(_p)
        if i>=16 then
            _p.x+=64
            _p.y-=64
        end

        return _p
    end,
    get_tile_pos=function(self,p)
        i=get_screen_index(p)
        if i>=16 then
            p.x+=64
            p.y-=64
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
    end,
    is_lava=function(self,x,y)
        return y>64 or fget(self:mget(x,y),7)
    end
}
--[[
Clouds = {
    clouds={},
    clouds_max=16,
    update=function(self)
        if (get_screen_index(Player)>=4) return

        for c in all(self.clouds) do
            c.x+=c.dx
            c.y=c._y+sin(Time*c.dt+c.seed)*c.ds
            if c.x-c.r1>128*Map.screen_width then
                del(self.clouds,c)
            end
        end

        if #self.clouds<self.clouds_max then
            for i=#self.clouds,self.clouds_max do
                c=self.make()
                add(self.clouds,c)
            end
        end
    end,
    make=function(self)
        c={
            x=rnd(512),
            y=rnd(32)-8,
            dx=0.05+rnd(0.15),
            r1=flr(rnd(4)+4),
            r2=flr(rnd(4)+4),
            r3=flr(rnd(4)+4),
            l1=flr(rnd(6)+4),
            l2=flr(rnd(6)+4),
            seed=rnd(1),
            dt=rnd(0.2)+0.05,
            ds=rnd(3)
        }
        c._y=c.y
        return c
    end,
    draw=function(self)
        if Screen.current_index>=4 then
            return
        end

        for c in all(self.clouds) do
            circfill(c.x,c.y,c.r1,7)
            circfill(c.x+c.l1,c.y,c.r2,7)
            circfill(c.x+c.l1+c.l2,c.y,c.r3,7)
        end
    end
}
]]--

function get_screen_index(p)
    return flr(p.y/16)*4+flr(p.x/16)
end
function get_screen_position(p)
    return {
        x=flr(p.x/16)*16,
        y=flr(p.y/16)*16
    }
end

Screen = {
    init=function(self)
        self.bubbles={}
        self.bubbles_max=64

        self.current_index=false
        self.current_position=false
        self.current_sfx=-1
        self.current_music=-1
        self.sfx_timer=0
    end,
    update=function(self)
        if not self.current_index or get_screen_index(Player)!=self.current_index then
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

        self.current_index=get_screen_index(Player)
        self.current_position=get_screen_position(Player)

        add(d,self.current_index)
        Dialog:check(d)
        Dialog:check({"screen",self.current_index})

        self:music()
        self:sfx()

        foreach(Actors, function (obj) obj:reload(self.current_index) end)
    end,
    in_screen=function(self,p,index)
        index=index or self.current_index
        return index==get_screen_index(p)
    end,
    same=function(self,a,b,index)
        index=index or self.current_index
        return self:in_screen(a,index) and self:in_screen(b,index)
    end,
    get_level=function(self,index)
        index=index or get_screen_index(Player)
        local l=flr(index/8)
        if index==4 then
            l=1
        elseif index==11 then
            l=0
        end
        return l
    end,
    sfx=function(self,index)
        local l=self:get_level(index)
        local selected=8

        local selected=8
        if l==0 then
            selected=7
        end
        if selected!=self.current_sfx then
            sfx(selected,3)
            self.current_sfx=selected
        end
    end,
    music=function(self,index)
        local selected=self:get_level(index)
        if (selected!=self.current_music) self:_music(selected)
    end,
    _music=function(self,song)
        music(song,0,0b0111)
        self.current_music=song
    end,
    draw_bg=function(self,index)
        local l=self:get_level(index)
        local bgc=8
        local fgc=0
        local buc=0
        if Paused then
            bgc=0
            fgc=5
            buc=6
        elseif Dead or Escaped then
            bgc=5
            --fgc=0
            --buc=0
        elseif l==0 then
            bgc=1
            fgc=2
            buc=12
        elseif l==1 then
            bgc=2
            --fgc=0
            --buc=0
        elseif l==2 then
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

Dialog = {
    init=function(self)
        self.events=split("
            artifact#you've found_a mysterious_artifact...~what do you do now?#reward~chest~unknown,
            cord#some extra breathing tube!_this will come in handy...~maybe i should delve deeper?#reward~chest~cord,
            key#a mysterious key!_there should be a door_around here that fits.#reward~chest~key,
            harpoon#sweet!_now i can_defend myself~there are only_5 harpoons_in this chest~looks like_i have to_be stingy#reward~chest~harpoon,
            bomb#finally!_now i can do_some real damage~or maybe_there's a way_deeper?#reward~chest~bomb,
            dagger#a dagger?!_what is this doing_here?~looks aged_and blunt with_weird markings.~well maybe it_still has some_use left.#reward~chest~dagger,
            envirosuit#oooh a fancy_new diving_suit!~the fibers seem_incredibly durable.~who made this?#reward~item~suit,
            entrance#this cave_looks strange.~almost as if_it were_designed?#screen~16,
            enterbase#what is this?_it must be...~some kind of_facility?#screen~27,
            escape#let's get_out of here!~quick!_get in the ship.#screenchange~28~29")
        for k,e in pairs(self.events) do
            e=split(e,"#")
            self.events[k]={
                name=e[1],
                text=split(e[2],"~"),
                trigger=e[3],
                activated=false,
                completed=false,
                line=1
            }
        end

        self.active_key=false
        self.active_index=false
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
            Paused=true
            local e=self.events[self.active_key]
            if btnp(5) then
                if e.line>=#e.text then
                    e.completed=true
                    self.active_key=false
                    Paused=false
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
    end,
    draw=function(self)

        --local text

        -- start controls
        if not Started or Dead or Escaped then
            text="diver"
            local s=4.5+sin(Time/4)*2
            if Dead or Escaped then
                text="you perished"
                if (Escaped) text="you've escaped!"
                s/=3
            end

            local x=64-#text*1.99*s+s/2
            local y=64-s*2.5

            prints(text,x,y,s,s,14)

            for j=y,y+5*s+1 do
                --local k=(j-y)/(5*s+1)

                local c=0
                if (j>=64) c=8

                local m=flr(41-j/2) --flr(9-(j-64)/2)
                if (m<1) m=1

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

            text="press \151 to start"
            if (Dead) text="press \151 to try again"
            if (Escaped) text="press \151 to play again"
            printo(text,64-#text*2,86)
        elseif Screen.current_index==1 then
            printo("swim:\139\148\131\145",2,11)
            printo("use/select:\142",2,17)
            printo("inv/shop:\151",2,23)
        end

        if self.active_key then
            local e=self.events[self.active_key]
            text=e.text[e.line]
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
            rectfill(x,y,x+w,y+h,1)
            rect(x,y,x+w,y+h,7)
            for l in all(lines) do
                print(l,x+4,y+4,7)
                y+=6
            end
            print("press \151",27+w/2,y+6,6)
        end
    end
}
Shop = {
    init=function(self)
        self.open=false
        self.key=nil

        self.areas=split("21_2_6_4_buy something_will ya?,33_82_4_3_security comp_access granted,38_99_4_3_core facility_access granted") -- x_y_w_h_text1_text2
        for k,i in pairs(self.areas) do
            i=split(i,"_",true)
            self.areas[k]={
                x=i[1],
                y=i[2],
                w=i[3],
                h=i[4],
                text1=i[5],
                text2=i[6]
            }
        end

        self.items=split("life_16,harpoon_5,bomb_5")
        for k,i in pairs(self.items) do
            i=split(i,"_")
            self.items[k]={
                name=i[1],
                amount=tonum(i[2])
            }
        end
    end,
    update=function(self)
        self._open=self.open
        if self.open and btnp(5) then
            if self.key and Inventory:remove_item("coin",5) then
                Inventory:add_item(self.item.name,self.item.amount)
                Screen:play_sfx(0)
            elseif self.key then
                Screen:play_sfx(1)
            end
            self.key=nil
            self.open=not self.open
            Paused=self.open
        elseif self.open and btnp(4) then
            while true do
                self.key,self.item=next(self.items,self.key)
                if (self.key==nil or self.can_buy(self.item.name)) break
            end
        elseif not Paused and not Dead and btnp(5) then
            for area in all(self.areas) do
                if collide(Player,area) then
                    self.area=area
                    self.open=not self.open
                    Paused=self.open
                    break
                end
            end
        end
    end,
    can_buy=function(name)
        local item=Inventory:get_item(name)
        return item.quantity<item.max
    end,
    draw=function(self)
        if self.open then
            rectfill(32,32,96,96,1)
            rect(32,32,96,96,7)
            print(self.area.text1,36,36,7)
            print(self.area.text2,36,44,7)
            for k,i in pairs(self.items) do
                if self.key==k then
                    circfill(37,46+k*12,1,8)
                end
                local c=5
                if self.can_buy(i.name) then
                    c=7
                    Inventory:draw_item(i.name,42,42+k*12)
                end
                print(i.name,53,44+k*12,c)
            end

            Inventory:draw_item("coin",84,84)
            print("5",80,86,7)
        end
    end
}
Inventory = {
    init=function(self)
        self.open=false
        self.timer=0
        self.items=split("coin_43,life_46,cord_45,harpoon_44,bomb_40,key_85,dagger_77,unknown_56") -- name_frame, used to reduce tokens
        for k,i in pairs(self.items) do
            i=split(i,"_")
            self.items[k]={
                name=i[1],
                f=tonum(i[2])
            }
        end
        for i in all(self.items) do
            i.quantity=0
            i.max=0
            if i.name=="life" then
                i.quantity=3
                i.max=3
            elseif i.name=="cord" then
                i.max=32
            end
        end
        self.equipped_items={}
        self.equipped_item=nil
        self.equipped_key=nil
    end,
    update=function(self)
        if (Dialog.active_key or Shop.open or Shop._open or Dead or Escaped) return

        if btnp(5) then
            self.open=not self.open
            Paused=self.open
        end

        if self.open and self.timer<0.25 then
            -- animation timer
            self.timer+=tdelta
        elseif not self.open and self.timer>0 then
            self.timer-=tdelta
        end

        -- item selection logic
        if self.open and btnp(4) then
            self.equipped_key,self.equipped_item=next(self.equipped_items,self.equipped_key)
        end
    end,
    draw=function(self)

        -- coins
        self:draw_item("coin",0,1,3)

        -- equipped item
        self:draw_item(self.equipped_item,25,1,2)

        -- cord left
        local item=self:get_item("cord")
        self:draw_item(item,45,1)
        rectfill(54,3,80,6,0)
        rectfill(55,4,79,5,7)
        rectfill(55,4,55+24*max(min(item.quantity/item.max,1)),5,2)

        -- life hearts
        item=self:get_item("life")
        local i=1
        for y=0,flr((item.max-1)/5) do
            for x=16-min(item.max-y*5,5),15 do
                if item.quantity<i then
                    pal(palbw)
                end
                spr(46,x*9-16,y*9+1,1,1)
                i+=1
            end
        end
        reset_pal(true)

        -- Inventory Selector
        if self.timer>0 then
            local a=min(self.timer/0.25,1)
            circfill(Player.x*8-CameraX,Player.y*8-CameraY,a*14,11)
            circfill(Player.x*8-CameraX,Player.y*8-CameraY,a*10,3)

            -- display items, a is distance
            a*=14 -- 14=radius
            for k,i in pairs(self.equipped_items) do
                local x=Player.x*8+cos(k/#self.equipped_items)*a-CameraX
                local y=Player.y*8+sin(k/#self.equipped_items)*a-CameraY
                if self.equipped_key==k then
                    circfill(x,y,6,7)
                else
                    circ(x,y,6,7)
                end
                self:draw_item(i,x-4,y-4)
            end
        end
    end,
    get_item=function(self, name)
        for item in all(self.items) do
            if item.name==name then
                return item
            end
        end
    end,
    set_item=function(self, name, quantity)
        --quantity=quantity or 0
        local item=self:get_item(name)
        item.quantity=quantity
        -- no max?
    end,
    add_item=function(self, item, amount, max)
        if type(item)=="string" then
            item=self:get_item(item)
        end
        amount=amount or 1
        item.quantity+=amount
        if max then
            if item.max<=0 and not in_table(item.name, "life,cord,coin") then
                add(self.equipped_items, item)
            end
            item.max+=amount
        elseif item.name!="coin" and item.quantity>item.max then
            item.quantity=item.max
            return false
        end
        return true
    end,
    remove_item=function(self,item,amount)
        if type(item)=="string" then
            item=self:get_item(item)
        end
        amount=amount or 1
        if (item.quantity-amount<0) return false
        item.quantity-=amount
        return true
    end,
    draw_item=function(self,item,x,y,digits)
        if in_table(type(item),"string,number") then
            item=self:get_item(item)
        end
        if item then
            spr(item.f,x,y)
            if digits and not in_table(item.name, "dagger,unknown") then
                printo(pad(tostr(item.quantity),digits),x+10,y+2)
            end
        end
    end
}

function _init()
    restart()
    menuitem(1,"restart",restart)
end

function restart()
    Boat=false
    Player=false

    reset_pal()
    StateReset()

    Screen:init()
    Actors={}
    Map:init()
    Dialog:init()
    Shop:init()
    Inventory:init()

    Map:load()
    foreach(Actors, function(obj) obj:init() end) -- must be run after Map:load() for actors to be created

    Screen:update()
    CameraSetScreenPosition(Player)

    Fade:_in()
end

function _update()
--function _update60()

    if not Paused then
        foreach(Actors, function(obj) obj:update() end)
        Map:update()
        --Clouds:update()

        if Pod then
            if #Pod==0 and not Escaped then
                Escaped=true
                sfx(-1,3)
                music(6,1000)
            else
                for a in all(Pod) do
                    a.dy-=0.001
                    if (a.y+a.h)*8<CameraY then
                        del(Pod,a)
                    end
                end
            end
        end
    end

    if Started then
        Shop:update()
        Inventory:update()
    end
    Dialog:update()

    Fade:update()
    StateUpdate()

end

function _draw()
    if Paused or Dead or Escaped then
        pal(palbw)
    end

    Screen:draw_bg()
    Screen:update()

    CameraUpdate()
    camera(CameraX,CameraY)

    Map:draw()
    --Clouds:draw()

    -- draw everything else black
    draw_around(Screen.current_position.x*8,Screen.current_position.y*8,128,128,0)

    if not Pod then
        local l=Screen:get_level()
        local c=5
        if l==0 then
            c=2
        elseif l==1 then
            c=1
        end
        draw_path(Player.cord,c)
    end

    for a in all(Actors) do
        if (a.name!="player") a:draw()
    end

    Map:draw_hidden()

    reset_pal(true)

    -- reset for hud
    if Started then
        camera()
        Inventory:draw()
        Map:draw_hud()
    end

    if not Pod then
        -- draw player over hud
        camera(CameraX,CameraY)
        Player:draw()
        camera()
    end

    Shop:draw()
    Dialog:draw()
    Fade:draw()
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
    if (type(t)=="string") t=split(t)
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
    local d=dist2(x,y)
    if (d<1) d=1
    return sqrt(d)
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
