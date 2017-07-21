local M = {}
M.time = 0
function M.update(dt, rect, color)
  color[2] = (color[2] + dt*75) % 128  + 128
  M.time = M.time + dt
  rect[2] = WINDOW_WIDTH / 2 + 100 * math.cos(M.time)
  rect[3] = WINDOW_HEIGHT / 2 + 100 * math.sin(M.time)
end

return M
