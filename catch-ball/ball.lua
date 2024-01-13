local ball = {}

function ball.isClicked(radius, x, y, mousex, mousey)
    if math.abs(mousex - x) < radius and math.abs(mousey - y) < radius then
        return true
    else
        return false
    end
end

function ball.draw(colour, radius, x, y)
    love.graphics.setColor(colour)
    love.graphics.circle("fill", x, y, radius)
end

return ball
