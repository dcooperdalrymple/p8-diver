
function init(self)
    self.start_index=false
    self.start_position=false
    self.current_index=false
    self.current_position=false
    self.current_sfx=-1
    self.current_music=-1
end

function update(self)
    if not self.current_index or self:get_index(Player)!=self.current_index then
        self:change()
    end
end

local function change(self)
    self.current_index=self:get_index(Player)
    self.current_position=self.get_position(Player)
    if not self.start_index then self.start_index=self.current_index end
    if not self.start_position then self.start_position=self.current_position end

    self:music()
    self:sfx()
end

local function get_index(self,p)
    return flr(p.y/16)*4+flr(p.x/16)
end

local function get_position(p)
    return {
        x=flr(p.x/16)*16,
        y=flr(p.y/16)*16,
    }
end

local function in_screen(self,p,index)
    index=index or self.current_index
    return index==self:get_index(p)
end

local function same(self,a,b,index)
    index=index or self.current_index
    return self:in_screen(a,index) and self:in_screen(b,index)
end

local function _sfx(self,index)
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
end

local function _music(self,index)
    index=index or self:get_index(Player)
    local selected=flr(index/8)
    if index==4 then
        selected=1
    end
    if selected!=self.current_music then
        music(selected)
        self.current_music=selected
    end
end

local function draw_bg(self,index)
    index=index or self:get_index(Player)
    local bgc=8
    local fgc=0
    local buc=0
    if index<8 and index!=4 then
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
    else
        bgc=8
        fgc=0
        buc=0
    end

    cls(bgc)
    for i=0,16,1 do
        fillp(Fade.pat[16-i])
        rectfill(0,96+32/16*i,128,96+32/16*(i+1),fgc)
    end
    fillp()

    local first=#self.bubbles==0
    while #self.bubbles<self.bubbles_max do
        local y=128
        if first then y=rnd(128) end
        add(self.bubbles,{
            x=rnd(128),
            y=y,
            dy=rnd(1)*-0.1-0.1,
            dx=0,
            seed=rnd(1),
        })
    end

    for b in all(self.bubbles) do
        b.dx=cos(b.seed+State.time)/10
        b.x+=b.dx
        b.y+=b.dy
        if b.x<0 or b.x>128 or b.y<0 then
            del(self.bubbles,b)
        else
            pset(b.x,b.y,buc)
        end
    end
end

local function play_sfx(self,n,l)
    l=l or 0.1
    self.current_sfx=-1
    sfx(n,3)
    Sound.timer=l
end

return {
    bubbles={},
    bubbles_max=64,
    init=init,
    update=update,
    change=change,
    get_index=get_index,
    get_position=get_position,
    in_screen=in_screen,
    same=same,
    sfx=_sfx,
    music=_music,
    draw_bg=draw_bg,
    play_sfx=play_sfx
}
