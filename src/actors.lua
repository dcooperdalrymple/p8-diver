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

local function init(self)
    self.actors={}
end

local function make_actor(self,a)
    if type(a) != "table" then
        a={}
    end

    local b=Actor.get()

    for k,v in pairs(a) do
        b[k]=v
    end

    return b
end

local function add_actor(self,a)
    local a = self:make_actor(a)
    printh("added "..a.class..":"..a.name)
    add(self.actors,a)
    return a
end

local function remove_actor(self,a)
    del(self.actors,a)
end

local function load(self) -- actually init actors
    foreach(self.actors, function(obj) obj:init() end)
end

local function update(self)
    if State.paused==true then
        return
    end

    foreach(self.actors, function(obj) obj:update() end)
end

local function draw(self)
    foreach(self.actors, function(obj) obj:draw() end)
end

-- actor create functions

local function create_actor(self,f,x,y,dx,dy,a)
    local a = a or {}
    local dx = dx or 0
    local dy = dy or 0
    Map:mclear(x,y,a.w,a.h)
    a.x=x+dx
    a.y=y+dy
    if a.center then
        a.x+=a.w/2
        a.y+=a.h/2
    end
    a._x=a.x
    a._y=a.y
    a.f=f
    return self:add_actor(a)
end

local function create_reward(self,f,x,y,dx,dy,a)
    local a = a or {}
    local b = ActorReward.get()

    for k,v in pairs(a) do
        b[k]=v
    end

    return self:create_actor(f,x,y,dx,dy,b)
end

local function create_item(self,f,x,y)
    local a = self:create_reward(f,x,y,0,0,ActorRewardItem.get())
    a:set_reward(f)
    return a
end

local function create_treasure(self,f,x,y)
    local rf = Map:mget(x+1,y)
    local a = self:create_reward(f,x,y,0,3/8,ActorRewardTreasure.get())
    a:set_reward(rf)
    return a
end

local function create_enemy(self,f,x,y,dx,dy,a)
    local a = a or {}
    local b = ActorEnemy.get()

    for k,v in pairs(a) do
        b[k]=v
    end

    return self:create_actor(f,x,y,dx,dy,b)
end

local function create_fish(self,f,x,y)
    return self:create_enemy(f,x,y,0,0,ActorEnemyFish.get())
end

local function create_urchin(self,f,x,y)
    return self:create_enemy(f,x,y,0,0,ActorEnemyUrchin.get())
end

local function create_squid(self,f,x,y)
    return self:create_enemy(f,x,y,0,0,ActorEnemySquid.get())
end

local function create_angler(self,f,x,y)
    return self:create_enemy(f,x,y,0,0,ActorEnemyAngler.get())
end

local function create_boat(self,f,x,y)
    if Boat!=false then
        return
    end
    Boat = self:create_actor(f,x,y,0,1.25,ActorBoat.get())
end

local function create_player(self,f,x,y)
    if Player!=false then
        return
    end
    Player = self:create_actor(f,x,y,0,0,ActorPlayer.get())
end

local function create_projectile(self,a,x,y)
    local a = a or {}
    local b = ActorProjectile.get()

    for k,v in pairs(a) do
        b[k]=v
    end

    return self:create_actor(b.f,x,y,0,0,b)
end

local function create_harpoon(self,x,y)
    return self:create_projectile(ActorProjectileHarpoon.get(),x,y)
end

return {
    init = init,
    load = load,
    update = update,
    draw = draw,
    make_actor = make_actor,
    add_actor = add_actor,
    remove_actor = remove_actor,

    create_actor = create_actor,

    create_reward = create_reward,
    create_item = create_item,
    create_treasure = create_treasure,

    create_enemy = create_enemy,
    create_fish = create_fish,
    create_urchin = create_urchin,
    create_squid = create_squid,
    create_angler = create_angler,

    create_boat = create_boat,

    create_player = create_player,

    create_projectile = create_projectile,
    create_harpoon = create_harpoon,
}
