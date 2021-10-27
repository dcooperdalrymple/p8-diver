-- camera

local function init(self)
    self.x=0
    self.y=0
end

local function update(self)
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
end

local function draw(self)
    camera(self.x,self.y)
end

local function set_position(self,p)
    self.x=p.x
    self.y=p.y
end

local function set_screen_position(self,p)
    self:set_position(Screen.get_position(p))
end

return {
    x=0,
    y=0,
    init=init,
    update=update,
    draw=draw,
    set_position=set_position,
    set_screen_position=set_screen_position,
}
