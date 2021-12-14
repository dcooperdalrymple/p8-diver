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

return {
    hidden=split("1_10_6_4,53_27_4_5,55_39_7_4,37_58_11_5"), -- x_y_w_h, used to reduce tokens

    screen_width=4,
    screen_height=8,
    width=4*16,
    height=8*16,

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
        for y=0,self.height do
            for x=0,self.width do
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
    end,
    update=function(self)
        if State.paused==true then
            return
        end

        -- animate wave
        local f=3+flr(State.time*2)%4

        -- water
        local y=3
        for x=0,self.width do
            local m=self:mget(x,y)
            if m>=3 and m<=6 then
                self:mset(x,y,f)
            end
        end

        -- lava
        f+=110
        y=62
        for x=0,self.width do
            local m=self:mget(x,y)
            if m>=113 and m<=116 then
                self:mset(x,y,f)
            end
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
                            if col==true then
                                local dx=Player.x-(x+0.5)
                                local dy=Player.y-(y+0.5)
                                if dx*dx+dy*dy<=3*3 then
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
        return fget(self:mget(x,y),0) and not (Config.dev==true and fget(self:mget(x,y),6))
    end
}
