-- flags:
--  0=solid
--  1=treasure
--   2=coin
--   3=harpoon
--   4=cord
--   5=heart
--   6=speed
--   7=bomb
--  2=enemy
--   3=fish
--   4=urchin
--   5=squid
--   6=angler
--  3=boat
--  4=sky
--  5=player
--  6=bombable
--  7=lava

local function init(self)
    reload()
end

local function load(self)
    for y=0,self.height,1 do
        for x=0,self.width,1 do
            m=self:mget(x,y)
            if fget(m,0) then -- solid
            elseif fget(m,1) then -- reward
                if m==25 then -- chest
                    Actors:create_treasure(m,x,y)
                else -- individual item
                    Actors:create_item(m,x,y)
                end
            elseif fget(m,2) then -- enemy
                if fget(m,3) then
                    Actors:create_fish(m,x,y)
                elseif fget(m,4) then
                    Actors:create_urchin(m,x,y)
                elseif fget(m,5) then
                    Actors:create_squid(m,x,y)
                elseif fget(m,6) then
                    Actors:create_angler(m,x,y)
                end
            elseif fget(m,3) then -- boat
                Actors:create_boat(m,x,y)
            elseif fget(m,5) then -- player
                Actors:create_player(m,x,y)
            end
        end
    end
end

local function update(self)
    self:animate_wave()
end

local function draw(self)
    -- draw map in actual location
    local mapp=self.get_pos()
    map(mapp.x,mapp.y,Screen.current_position.x*8,Screen.current_position.y*8,16,16)
end

local function draw_hidden(self)
    for area in all(self.hidden) do
        if Screen:in_screen(area) then
            local col=collide(Player,area)
            local f=area.f or 1
            for y=area.y,area.y+area.h-1,1 do
                for x=area.x,area.x+area.w-1,1 do
                    if not collide(Player,{x=x,y=y,w=1,h=1}) then
                        if col==true then
                            local dx=Player.x-(x+0.5)
                            local dy=Player.y-(y+0.5)
                            local d2=dx*dx+dy*dy
                            if d2<=3*3 then
                                fillp(0b0101101001011010.11)
                            else
                                fillp()
                            end
                        end
                        spr(f,x*8,y*8, 1, 1, false, false)
                    end
                end
            end
            fillp()
        end
    end
end

local function get_pos(self,p)
    p=p or Screen.current_position
    local _p=Screen.get_position(p)

    i=Screen:get_index(_p)
    if i>=16 then
        _p.x+=16*4
        _p.y-=16*4
    end

    return _p
end

local function get_tile_pos(self,p)
    i=Screen:get_index(p)
    if i>=16 then
        p.x+=16*4
        p.y-=16*4
    end
    return p
end

local function _mget(self,x,y)
    local p=self:get_tile_pos({
        x=x,
        y=y
    })
    return mget(p.x,p.y)
end

local function _mset(self,x,y,f)
    local p=self:get_tile_pos({
        x=x,
        y=y
    })
    return mset(p.x,p.y,f)
end

local function mclear(self,x,y,w,h,m)
    w=w or 1
    h=h or 1
    m=m or 0
    for _y=y,y+h-1,1 do
        for _x=x,x+w-1,1 do
            self:mset(_x,_y,m)
        end
    end
end

local function is_solid(self,x,y)
    return fget(self:mget(x,y),0) and not (Config.dev==true and fget(self:mget(x,y),6))
end

local function animate_wave(self)
    local f=3+flr(State.time*2)%4

    -- water
    local y=3
    for x=0,self.width,1 do
        local m=self:mget(x,y)
        if m>=3 and m<=6 then
            self:mset(x,y,f)
        end
    end

    -- lava
    f+=110
    y=62
    for x=0,self.width,1 do
        local m=self:mget(x,y)
        if m>=113 and m<=116 then
            self:mset(x,y,f)
        end
    end
end

return {
    hidden={
        {
            x=1,
            y=10,
            w=6,
            h=4,
        },
        {
            x=53,
            y=27,
            w=4,
            h=5,
        },
        {
            x=55,
            y=39,
            w=7,
            h=4,
        },
        {
            x=37,
            y=58,
            w=11,
            h=5,
        },
    },

    screen_width=4,
    screen_height=8,
    width=4*16,
    height=8*16,

    init=init,
    load=load,
    update=update,
    draw=draw,
    draw_hidden=draw_hidden,
    get_pos=get_pos,
    get_tile_pos=get_tile_pos,
    mget=_mget,
    mset=_mset,
    mclear=mclear,
    is_solid=is_solid,
    animate_wave=animate_wave,
}
