local playing = require "state-playing"
local mainmenu = require "state-main-menu"

-- LOVE game!



function SwitchGameState(gamestate)
    print("switchin")
    if gamestate.load then
        gamestate.load()
    end
    GAME_STATE = gamestate
end

function love.load()
    GAME_STATES = {
        MAIN_MENU = mainmenu,
        GAME = playing
    }
    SwitchGameState(GAME_STATES.MAIN_MENU)
end

function love.update(dt)
    if GAME_STATE.update then
        GAME_STATE.update(dt)
    end
end

function love.mousepressed(x, y, button, istouch)
    if GAME_STATE.mousepressed then
        GAME_STATE.mousepressed(x, y, button, istouch)
    end
end

function love.draw()
    if GAME_STATE.draw then
        GAME_STATE.draw()
    end
end
