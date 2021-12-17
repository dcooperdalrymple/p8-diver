require("actor/actor")

require("actor/reward")
require("actor/rewards/item")
require("actor/rewards/treasure")

require("actor/enemy")
require("actor/enemies/fish")
require("actor/enemies/urchin")
require("actor/enemies/squid")
require("actor/enemies/angler")
require("actor/enemies/alien")

require("actor/boat")
require("actor/player")

require("actor/projectile")
require("actor/projectiles/harpoon")
require("actor/projectiles/bomb")

return {
    init = function(self)
        self.actors={}
    end,
    load = function(self) -- actually init actors
        foreach(self.actors, function(obj) obj:init() end)
    end,
    update = function(self)
        foreach(self.actors, function(obj) obj:update() end)
    end,
    draw = function(self)
        foreach(self.actors, function(obj) if obj.name!="player" then obj:draw() end end)
    end,
    make_actor = function(self,a)
        if type(a) != "table" then
            a={}
        end

        local b=Actor()

        for k,v in pairs(a) do
            b[k]=v
        end

        return b
    end,
    add_actor = function(self,a)
        a = self:make_actor(a)
        add(self.actors,a)
        return a
    end,
    remove_actor = function(self,a)
        del(self.actors,a)
    end,

    create_actor = function(self,f,x,y,a,dx,dy,m)
        a = self:add_actor(a or {})
        dx = dx or 0
        dy = dy or 0
        m = m or 0
        if Map:mget(x,y)==f then
            Map:mclear(x,y,ceil(a.w),ceil(a.h),m)
        end
        a.x=x+dx
        a.y=y+dy
        if a.center then
            a.x+=a.w/2
            a.y+=a.h/2
        end
        a._x=a.x
        a._y=a.y
        a.f=f
        return a
    end,

    create_reward = function(self,f,x,y,a,dx,dy)
        local a = a or {}
        local b = ActorReward()

        for k,v in pairs(a) do
            b[k]=v
        end

        return self:create_actor(f,x,y,b,dx,dy)
    end,

    create_enemy = function(self,f,x,y,a,dx,dy)
        local a = a or {}
        local b = ActorEnemy()

        for k,v in pairs(a) do
            b[k]=v
        end

        return self:create_actor(f,x,y,b,dx,dy)
    end,

    create_projectile = function(self,a,x,y,dx,dy)
        local a = a or {}
        local b = ActorProjectile()

        for k,v in pairs(a) do
            b[k]=v
        end

        return self:create_actor(b.f,x,y,b,dx,dy)
    end,
}
