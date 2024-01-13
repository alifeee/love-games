local function drawCenteredText(rectX, rectY, rectWidth, rectHeight, text)
    local font       = love.graphics.getFont()
    local textWidth  = font:getWidth(text)
    local textHeight = font:getHeight()
    love.graphics.print(text, rectX + rectWidth / 2, rectY + rectHeight / 2, 0, 1, 1, textWidth / 2, textHeight / 2)
end

local mainmenu = {}

function mainmenu.load()
    BOGFACE = love.graphics.newFont("BogFace.ttf", 64)
end

function mainmenu.mousepressed(x, y, button, istouch)
    print("presd!")
    SwitchGameState(GAME_STATES.GAME)
end

function mainmenu.draw()
    local window_width, window_height = love.graphics.getDimensions()

    love.graphics.setFont(BOGFACE)

    local w = window_width / 2
    local h = 200
    local x = window_width / 2 - w / 2
    local y = window_height / 2 - h / 2
    -- love.graphics.rectangle("line", x, y, w, h)
    drawCenteredText(x, y, w, h, "Catch the ball!")
end

return mainmenu
