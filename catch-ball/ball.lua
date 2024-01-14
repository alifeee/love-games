local ball = {}

function ball.isClicked(radius, x, y, mousex, mousey)
    if math.abs(mousex - x) < radius and math.abs(mousey - y) < radius then
        return true
    else
        return false
    end
end

function ball.draw(gfx, radius, x, y)
    local height = gfx:getPixelHeight()
    love.graphics.draw(gfx, x - radius, y - radius, 0, BALL.radius * 2 / height)
end

return ball
