local M = {}

M.required = {}
function M.req(module)
  M.required[module] = true
  return require(module)
end

function M.load(gameModuleName)
  M.hotload = function()
    local firstRun = M.Game == nil
    local prevState = nil

    if M.Game and M.Game.hotunload then
      prevState = M.Game.hotunload()
    end

    -- clear the loaded modules
    for module, _ in pairs(M.required) do
      package.loaded[module] = nil
      M.required[module] = nil
    end

    -- require the game module
    M.Game = M.req(gameModuleName)

    -- register the love callbacks
    if firstRun and M.Game.load then
      M.Game.load()
    end
    -- call the game module's hotload function
    M.Game.hotload(prevState)
    for _, callback in pairs(M.loveCallbacks) do
      love[callback] = M.Game[callback]
    end
    print(string.format('hotloaded %s module', gameModuleName), M.Game)
  end

  M.hotload()
end

M.loveCallbacks = {
  -- core
  'update', 'draw',

  -- keyboard
  'keypressed', 'keyreleased',
  'textedited', 'text-input',

  -- mouse
  'mousepressed', 'mousereleased', 'mousemoved', 'wheelmoved',

  -- mobile
  'lowmemory',
  'touchpressed', 'touchreleased', 'touchmoved',

  -- window
  'visible', 'focus', 'resize',
  'directorydropped', 'filedropped',

  -- process control
  'quit', 'threaderror',
}

return M
