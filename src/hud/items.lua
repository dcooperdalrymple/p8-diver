local function draw()

    -- coins
    local x=0
    spr(43,x,1,1,1,false,false)
    x+=8+1
    printo(pad(tostr(Player.coins),3),x,3,7)
    x+=4*4

    -- harpoons
    spr(44,x,1,1,1,false,false)
    x+=8+2
    printo(pad(tostr(Player.harpoon_count),2),x,3,7)
    x+=2*4+2

    -- cord left
    spr(45,x,1,1,1,false,false)
    x+=8+2
    local rectw=24
    local recth=2
    rectfill(x-1,4-1,x+1+rectw,3+1+recth,0)
    rectfill(x,4,x+rectw,3+recth,7)
    rectfill(x,4,x+rectw*max(min(Player.cord_length/Player.cord_length_max,1),0),3+recth,2)
    x+=rectw+1

    -- life hearts
    local i=1
    for x=16-Player.life_max,15,1 do
    if Player.life<i then
        pal(Graphics.palbw)
    end
        spr(46,x*8-(16-x),1,1,1)
        Graphics.reset_pal()
        i+=1
    end

end

return {
    draw=draw
}
