Actor=require("actor/actor")

ActorReward=require("actor/reward")
ActorRewardItem=require("actor/rewards/item")
ActorRewardTreasure=require("actor/rewards/treasure")

ActorEnemy=require("actor/enemy")
ActorEnemyFish=require("actor/enemies/fish")
ActorEnemyUrchin=require("actor/enemies/urchin")
ActorEnemySquid=require("actor/enemies/squid")
ActorEnemyAngler=require("actor/enemies/angler")

ActorBoat=require("actor/boat")
ActorPlayer=require("actor/player")

ActorProjectile=require("actor/projectile")
ActorProjectileHarpoon=require("actor/projectiles/harpoon")
ActorProjectileBomb=require("actor/projectiles/bomb")

return {
    init = function(self)
        self.actors={}
    end,
    load = function(self) -- actually init actors
        foreach(self.actors, function(obj) obj:init() end)
    end,
    update = function(self)
        if State.paused==true then
            return
        end

        foreach(self.actors, function(obj) obj:update() end)
    end,
    draw = function(self)
        foreach(self.actors, function(obj) if obj.name!="player" then obj:draw() end end)
    end,
    make_actor = function(self,a)
        if type(a) != "table" then
            a={}
        end

        local b=Actor.get()

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
        local b = ActorReward.get()

        for k,v in pairs(a) do
            b[k]=v
        end

        return self:create_actor(f,x,y,b,dx,dy)
    end,
    create_item = function(self,f,x,y)
        local a = self:create_reward(f,x,y,ActorRewardItem.get())
        a:set_reward(f)
        return a
    end,
    create_treasure = function(self,f,x,y)
        local rf = Map:mget(x+1,y)
        local a = self:create_reward(f,x,y,ActorRewardTreasure.get(),0,0.375)
        a:set_reward(rf)
        return a
    end,

    create_enemy = function(self,f,x,y,a,dx,dy)
        local a = a or {}
        local b = ActorEnemy.get()

        for k,v in pairs(a) do
            b[k]=v
        end

        return self:create_actor(f,x,y,b,dx,dy)
    end,
    create_fish = function(self,f,x,y)
        return self:create_enemy(f,x,y,ActorEnemyFish.get())
    end,
    create_urchin = function(self,f,x,y)
        return self:create_enemy(f,x,y,ActorEnemyUrchin.get())
    end,
    create_squid = function(self,f,x,y)
        return self:create_enemy(f,x,y,ActorEnemySquid.get())
    end,
    create_angler = function(self,f,x,y)
        return self:create_enemy(f,x,y,ActorEnemyAngler.get())
    end,

    create_boat = function(self,f,x,y)
        if Boat!=false then
            return
        end
        Boat = self:create_actor(f,x,y,ActorBoat.get(),0,1.25,2)
    end,

    create_player = function(self,f,x,y)
        if Player!=false then
            return
        end
        Player = self:create_actor(f,x,y,ActorPlayer.get())
    end,

    create_projectile = function(self,a,x,y)
        local a = a or {}
        local b = ActorProjectile.get()

        for k,v in pairs(a) do
            b[k]=v
        end

        return self:create_actor(b.f,x,y,b)
    end,
    create_harpoon = function(self,x,y)
        return self:create_projectile(ActorProjectileHarpoon.get(),x,y)
    end,
    create_bomb = function(self,x,y)
        return self:create_projectile(ActorProjectileBomb.get(),x,y)
    end
}
