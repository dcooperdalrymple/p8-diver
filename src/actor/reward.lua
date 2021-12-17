local function update(self)
    self:update_actor()

    if self.animating then
        self.t-=tdelta
        if self.t<=0 then
            Actors:remove_actor(self)
        end
        return
    end

    if self.activated or not collide(Player,self) then
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
    self.rf=f
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
    else
        self.r="unknown"
    end
end

function ActorReward()
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
