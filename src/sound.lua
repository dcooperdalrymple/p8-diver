-- sound

local function init(self)
    self.timer=0
end

local function update(self)
    if self.timer>0 then
        self.timer-=Config.tdelta
        if self.timer<=0 then
            Screen:sfx()
        end
    end
end

return {
    timer=0,
    init=init,
    update=update
}
