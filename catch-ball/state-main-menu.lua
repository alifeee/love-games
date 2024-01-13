local ball = require "ball"

local function drawCenteredText(rectX, rectY, rectWidth, rectHeight, text)
    local font       = love.graphics.getFont()
    local textWidth  = font:getWidth(text)
    local textHeight = font:getHeight()
    love.graphics.print(text, rectX + rectWidth / 2, rectY + rectHeight / 2, 0, 1, 1, textWidth / 2, textHeight / 2)
end

local mainmenu = {}

function mainmenu.load()
    local window_width, window_height = love.graphics.getDimensions()
    CENTER_X = window_width / 2
    CENTER_Y = window_height / 2

    BOGFACE = love.graphics.newFont("BogFace.ttf", 64)

    -- animation time scaler
    PULSE_ANIMATION_TIMESCALE = 10
    -- initial ball radius
    INITIAL_BALL_RADIUS = 10
    BALL = {
        radius = INITIAL_BALL_RADIUS,
        x = CENTER_X,
        y = CENTER_Y + 100
    }
end

function mainmenu.resize(w, h)
    mainmenu.load()
end

function mainmenu.update(dt)
    -- pulse animation
    local time = love.timer.getTime()
    local new_radius = INITIAL_BALL_RADIUS + math.sin(time * PULSE_ANIMATION_TIMESCALE)
    BALL.radius = new_radius
end

function mainmenu.mousepressed(x, y, button, istouch)
    if button == 1 then
        if ball.isClicked(BALL.radius, BALL.x, BALL.y, x, y) then
            SwitchGameState(GAME_STATES.GAME)
        end
    end
end

function mainmenu.draw()
    local window_width, window_height = love.graphics.getDimensions()

    love.graphics.setFont(BOGFACE)

    -- title
    local w = window_width / 2
    local h = 200
    local x = CENTER_X - w / 2
    local y = CENTER_Y - h / 2
    drawCenteredText(x, y, w, h, "Catch the ball!")

    -- ball
    ball.draw({ 255, 255, 255 }, BALL.radius, BALL.x, BALL.y)
end

return mainmenu
