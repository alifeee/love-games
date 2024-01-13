local ball = {}

function ball.draw(colour, radius, x, y)
    love.graphics.setColor(colour)
    love.graphics.circle("fill", x, y, radius)
end

return ball
