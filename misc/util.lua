local util = {}

function util.steer(pos, target, velocity, speed)
  local desired_velocity = (target - pos):normalized() * speed
  local steering = desired_velocity - velocity
  return velocity + steering
end

function util.smooth_rotate()

end

return util
