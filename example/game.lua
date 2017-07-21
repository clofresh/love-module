-- We use the regular lua require to require the Module module
local Module = require('module')

-- We use the Module.req() function to require any other dependent
-- modules so that we can hotload them later.
local SomeDep = Module.req('some_dep')

local M = {}

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- This will only get called once
function M.load()
  love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT)
end

-- This function will get called after every hotload.
-- prevState is the value returned from the hotunload callback.
function M.hotload(prevState)
  M.rect = {'fill', WINDOW_WIDTH / 2, WINDOW_HEIGHT / 2, 100, 100}
  M.color = {0, 255, 0}
  if prevState then
    SomeDep.time = prevState.time
  end
end

-- This function will get called before this module gets unloaded
-- and passed the output to the new hotload function. We can use
-- that state to present and values you want to survival hotloads.
function M.hotunload()
  local prevState = {}
  prevState.time = SomeDep.time
  return prevState
end

-- This function becomes the love.update callback.
-- You can see your changes immediately if you hotload.
-- Since SomeDep was required using Module.req(), changes
-- to that module will also get hotloaded.
function M.update(dt)
  SomeDep.update(dt, M.rect, M.color)
end

-- This function becomes the love.draw callback
function M.draw()
  love.graphics.setColor(M.color)
  love.graphics.rectangle(unpack(M.rect))
end

-- This function becomes the love.keyreleased callback.
-- In this case, we're mapping "r" to trigger a hotload
function M.keyreleased(key)
  if key == 'r' then
    Module.hotload()
  end
end

return M
