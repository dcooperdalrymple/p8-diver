-- diver
-- by coopersnout

-- compilation/code layout reference: https://github.com/tupini07/pico-8-games/tree/main/marksman-p

--local utilities = require("src/utilities")

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

MapHud = require("src/hud/map")
ItemsHud = require("src/hud/items")

function _init()
    restart()

    Fade:init()

    menuitem(1,"restart",restart)
end

function restart()
    cls()
    reload()

    Graphics.reset_pal()
    State:reset()

    Sound:init()
    Actors:init()
    Camera:init()
    Map:init()
    Dialog:init()

    Map:load()
    Actors:load() -- must be run after Map:load() for actors to be created
end

function _update()
--function _update60()

    Sound:update()
    Actors:update()
    Map:update()
    MapHud:update()
    Clouds:update()
    Dialog:update()
    Fade:update()

    State:update()

end

function _draw()
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

    -- draw hidden fill over outside objects
    --fillp(0b0101101001011010.1)
    --Graphics.draw_around(Screen.current_position.x*8,Screen.current_position.y*8,16*8,16*8,0)
    --fillp()

    -- reset for hud
    camera()

    -- return timer arc
    if Player.return_timer>0 then
        local a=Player.return_timer/Player.return_timer_max
        Graphics.arc(Player.x*8-Camera.x,Player.y*8-Camera.y,10,a,3,0.25)
        Graphics.arc(Player.x*8-Camera.x,Player.y*8-Camera.y,14,a,11,0.25)
    end

    Fade:draw()

    Dialog:draw()

    if State.started==false then
        return
    end

    MapHud:draw()
    ItemsHud:draw()
end
