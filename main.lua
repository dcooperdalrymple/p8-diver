-- diver
-- by coopersnout

Config = require("config")
State = require("src/state")

require("src/utils/string")
require("src/utils/collision")
Path = require("src/utils/path")

Graphics = require("src/graphics")
require("src/graphics/text")
Fade = require("src/graphics/fade")

Player = false
Boat = false

Sound = require("src/sound")
Actors = require("src/actors")
Camera = require("src/camera")
Map = require("src/map")
Clouds = require("src/graphics/clouds")
Dialog = require("src/dialog")
Screen = require("src/screen")
Inventory = require("src/inventory")

MapHud = require("src/hud/map")

function _init()
    restart()
    menuitem(1,"restart",restart)
    Fade:init()
end

function restart()
    cls()
    reload()

    Graphics.reset_pal()
    State:reset()

    Sound:init()
    Screen:init()
    Actors:init()
    Map:init()
    Dialog:init()
    Inventory:init()

    Map:load()
    Actors:load() -- must be run after Map:load() for actors to be created

    Screen:update()
    Camera:set_screen_position(Player)
end

function _update()
--function _update60()

    Sound:update()
    Actors:update()
    Map:update()
    MapHud:update()
    Clouds:update()
    Dialog:update()
    Inventory:update()
    Fade:update()

    State:update()

end

function _draw()
    if State.paused==true then
        pal(Graphics.palbw)
    end

    Screen:draw_bg()
    Screen:update()

    Camera:update()
    Camera:draw()

    Map:draw()
    Clouds:draw()

    -- draw everything else black
    Graphics.draw_around(Screen.current_position.x*8,Screen.current_position.y*8,16*8,16*8,0)

    local c=5
    if Screen.current_index<8 then
        c=2
    elseif Screen.current_index<16 then
        c=1
    end
    Path:draw(Player.cord,c)

    Actors:draw()

    Map:draw_hidden()

    if State.paused==true then
        Graphics.reset_pal(true)
    end

    -- reset for hud
    if State.started==true then
        camera()
        Inventory:draw()
        MapHud:draw()
    end

    -- draw player over hud
    Camera:draw()
    Player:draw()

    camera()
    Fade:draw()
    Dialog:draw()
end
