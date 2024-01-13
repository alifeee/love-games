local mouse = {}
local ball = require "ball"
local vectors = {}

--
-- MOUSE FUNCTIONS
--
function mouse.isInWindow(x, y, width, height)
    -- returns true if mousevector is within window
    -- x, y is mouse position
    -- width, height is window size
    return x > 0 and x < width and y > 0 and y < height
end

--
-- BALL FUNCTIONS
--

function ball.offEdge(width, height, buffer, position, edge)
    -- if item is off an edge, with a buffer (int) of pixels to allow for item width
    if edge == "top" then
        return position.y < 0 - buffer
    elseif edge == "bottom" then
        return position.y > height + buffer
    elseif edge == "left" then
        return position.x < 0 - buffer
    elseif edge == "right" then
        return position.x > width + buffer
    else
        error("edge should be top/bottom/left/right, nothing else", 1)
    end
end

function ball.offEdgeCurried(width, height, buffer)
    return function(position, edge)
        return ball.offEdge(width, height, buffer, position, edge)
    end
end

function ball.movedToEdge(width, height, buffer, position, edge)
    -- returns new position vector, having moved ball to specified edge
    --  with buffer px for item width
    if edge == "top" then
        return {
            x = position.x,
            y = 0 - buffer
        }
    elseif edge == "bottom" then
        return {
            x = position.x,
            y = height + buffer
        }
    elseif edge == "left" then
        return {
            x = 0 - buffer,
            y = position.y
        }
    elseif edge == "right" then
        return {
            x = width + buffer,
            y = position.y
        }
    else
        error("edge should be top/bottom/left/right, nothing else", 1)
    end
end

function ball.movedToEdgeCurried(width, height, buffer)
    return function(position, edge)
        return ball.movedToEdge(width, height, buffer, position, edge)
    end
end

--
-- VECTOR FUNCTIONS
--


function vectors.vector(x, y)
    -- turns x, y into vector
    return {
        x = x,
        y = y
    }
end

function vectors.add(a, b)
    -- vector addition a + b
    return {
        x = a.x + b.x,
        y = a.y + b.y
    }
end

function vectors.multiply(a, const)
    -- vector multiplication const * a
    return {
        x = a.x * const,
        y = a.y * const
    }
end

function vectors.difference(a, b)
    -- vector subtraction a - b
    return {
        x = a.x - b.x,
        y = a.y - b.y
    }
end

function vectors.magnitude(a)
    -- return magnitude of a vector
    return math.sqrt(a.x * a.x + a.y * a.y)
end

function vectors.unitVector(a)
    local magnitude = vectors.magnitude(a)
    return {
        x = a.x / magnitude,
        y = a.y / magnitude
    }
end

--
-- PLAYING GAME STATE
--

local playing = {}

function playing.load()
    -- velocity multiplier for all velocities
    VELOCITY_SCALE = 5
    -- velocity multiplier every frame
    VELOCITY_SLOWDOWN_SCALE = 0.99
    -- velocity multiplier with mouse distance
    MOUSE_ESCAPE_SCALE = -1
    -- maximum velocity impulse
    MAXIMUM_VELOCITY_IMPULSE = 100
    -- distance divider for mouse distance
    MOUSE_ESCAPE_DISTANCE_SCALER = 150
    -- maximum mouse distance for velocity altering
    MOUSE_MAXIMUM_DISTANCE = 300
    -- distance off-screen until reappearance on the other side
    OFFSCREEN_BUFFER = 5
    -- animation time scaler
    PULSE_ANIMATION_TIMESCALE = 10
    -- initial ball radius
    INITIAL_BALL_RADIUS = 10
    -- ball default colour
    BALL_COLOUR = { 255, 255, 255 }
    -- ball pressed colour
    BALL_PRESSED_COLOUR = { 255, 0, 0 }

    BALL = {
        x = 100,
        y = 100,
        vx = 10,
        vy = 10,
        radius = INITIAL_BALL_RADIUS,
        clicked = false,
    }
end

function StepToward(from, to, step)
    local next = from + step
    if step > 0 and next > to then
        return to
    end
    if step < 0 and next < to then
        return to
    end
    return next
end

function playing.update(dt)
    local window_width, window_height = love.graphics.getDimensions()
    local mousex, mousey = love.mouse.getPosition()

    local ball_position = vectors.vector(BALL.x, BALL.y)
    local mouse_position = vectors.vector(mousex, mousey)
    local ball_velocity = vectors.vector(BALL.vx, BALL.vy)

    local ball_to_mouse_vector = vectors.difference(mouse_position, ball_position)
    local mouse_to_ball_distance = vectors.magnitude(ball_to_mouse_vector)
    local velocity_impulse = MOUSE_ESCAPE_DISTANCE_SCALER / mouse_to_ball_distance
    if velocity_impulse > MAXIMUM_VELOCITY_IMPULSE then
        velocity_impulse = MAXIMUM_VELOCITY_IMPULSE
    end
    local ball_to_mouse_unitVector = vectors.unitVector(ball_to_mouse_vector)

    -- update ball position
    local ball_position_delta = vectors.multiply(ball_velocity, dt * VELOCITY_SCALE)
    ball_position = vectors.add(ball_position, ball_position_delta)
    -- bounds check
    local offEdge = ball.offEdgeCurried(window_width, window_height, OFFSCREEN_BUFFER)
    local movedToEdge = ball.movedToEdgeCurried(window_width, window_height, OFFSCREEN_BUFFER)
    if offEdge(ball_position, "left") then
        ball_position = movedToEdge(ball_position, "right")
    elseif offEdge(ball_position, "right") then
        ball_position = movedToEdge(ball_position, "left")
    end
    if offEdge(ball_position, "top") then
        ball_position = movedToEdge(ball_position, "bottom")
    elseif offEdge(ball_position, "bottom") then
        ball_position = movedToEdge(ball_position, "top")
    end

    -- update velocities
    -- add mouse escape velocity
    if mouse.isInWindow(mouse_position.x, mouse_position.y, window_width, window_height) and mouse_to_ball_distance < MOUSE_MAXIMUM_DISTANCE then
        local dv_ball = vectors.multiply(ball_to_mouse_unitVector, velocity_impulse * MOUSE_ESCAPE_SCALE)
        ball_velocity = vectors.add(ball_velocity, dv_ball)
    end
    -- slowdown velocity
    ball_velocity = vectors.multiply(ball_velocity, VELOCITY_SLOWDOWN_SCALE)

    -- pulse animation
    local time = love.timer.getTime()
    local new_radius = INITIAL_BALL_RADIUS + math.sin(time * PULSE_ANIMATION_TIMESCALE)

    -- update ball facts
    BALL.x = ball_position.x
    BALL.y = ball_position.y
    BALL.vx = ball_velocity.x
    BALL.vy = ball_velocity.y
    BALL.radius = new_radius
end

function playing.draw()
    if not BALL.clicked then
        ball.draw(BALL_COLOUR, BALL.radius, BALL.x, BALL.y)
    else
        ball.draw(BALL_PRESSED_COLOUR, BALL.radius, BALL.x, BALL.y)
    end
end

function playing.mousepressed(x, y, button, istouch)
    if button == 1 then
        if ball.isClicked(BALL.radius, BALL.x, BALL.y, x, y) then
            BALL.clicked = true
        end
    end
end

return playing
