-- LOVE game!

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

function love.load()
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

    BALL = {
        x = 100,
        y = 100,
        vx = 10,
        vy = 10,
        radius = INITIAL_BALL_RADIUS,
        color = { 255, 255, 255 },
        clicked = false,
        clicked_color = { 255, 0, 0 },
    }
end

function love.update(dt)
    local width, height = love.graphics.getDimensions()
    local mousex, mousey = love.mouse.getPosition()

    -- ball position vector
    local x_ball = {
        x = BALL.x,
        y = BALL.y
    }
    -- mouse position vector
    local x_mouse = {
        x = mousex,
        y = mousey
    }
    local mouseInWindow = x_mouse.x > 0 and x_mouse.x < width and x_mouse.y > 0 and x_mouse.y < height
    -- ball velocity vector
    local v_ball = {
        x = BALL.vx,
        y = BALL.vy
    }

    -- difference vector between ball and mouse
    local x_d = {
        x = x_mouse.x - x_ball.x,
        y = x_mouse.y - x_ball.y
    }
    local distance = math.sqrt(x_d.x * x_d.x + x_d.y * x_d.y)
    -- unit difference vector
    local x_d_u = {
        x = x_d.x / distance,
        y = x_d.y / distance
    }
    local distance_multiplier = MOUSE_ESCAPE_DISTANCE_SCALER / distance
    if distance_multiplier > MAXIMUM_VELOCITY_IMPULSE then
        distance_multiplier = MAXIMUM_VELOCITY_IMPULSE
    end

    -- update location
    local x_ball_2 = {
        x = x_ball.x + v_ball.x * dt * VELOCITY_SCALE,
        y = x_ball.y + v_ball.y * dt * VELOCITY_SCALE
    }
    if x_ball_2.x < (0 - OFFSCREEN_BUFFER) then
        x_ball_2.x = width + OFFSCREEN_BUFFER
    elseif x_ball_2.x > (width + OFFSCREEN_BUFFER) then
        x_ball_2.x = 0 - OFFSCREEN_BUFFER
    end
    if x_ball_2.y < (0 - OFFSCREEN_BUFFER) then
        x_ball_2.y = height + OFFSCREEN_BUFFER
    elseif x_ball_2.y > (height + OFFSCREEN_BUFFER) then
        x_ball_2.y = 0 - OFFSCREEN_BUFFER
    end

    -- update velocities
    -- add mouse escape velocity
    local v_ball_1 = v_ball
    if mouseInWindow and distance < MOUSE_MAXIMUM_DISTANCE then
        v_ball_1 = {
            x = v_ball.x + distance_multiplier * MOUSE_ESCAPE_SCALE * x_d_u.x,
            y = v_ball.y + distance_multiplier * MOUSE_ESCAPE_SCALE * x_d_u.y
        }
    end
    -- slowdown velocity
    local v_ball_2 = {
        x = v_ball_1.x * VELOCITY_SLOWDOWN_SCALE,
        y = v_ball_1.y * VELOCITY_SLOWDOWN_SCALE
    }

    -- pulse animation
    local time = love.timer.getTime()
    local new_radius = INITIAL_BALL_RADIUS + math.sin(time * PULSE_ANIMATION_TIMESCALE)

    -- update ball facts
    BALL.x = x_ball_2.x
    BALL.y = x_ball_2.y
    BALL.vx = v_ball_2.x
    BALL.vy = v_ball_2.y
    BALL.radius = new_radius
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        if math.abs(x - BALL.x) < BALL.radius and math.abs(y - BALL.y) < BALL.radius then
            BALL.clicked = true
        end
    end
end

function love.draw()
    if not BALL.clicked then
        love.graphics.setColor(BALL.color)
    else
        love.graphics.setColor(BALL.clicked_color)
    end
    love.graphics.circle("fill", BALL.x, BALL.y, BALL.radius)
end
