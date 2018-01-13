local controls = {}

function controls.init()
  local player_input = baton.new {
    controls = {
      moveleft = {'key:a', 'axis:leftx-', 'button:dpleft'},
      moveright = {'key:d', 'axis:leftx+', 'button:dpright'},
      moveup = {'key:w', 'axis:lefty-', 'button:dpup'},
      movedown = {'key:s', 'axis:lefty+', 'button:dpdown'},

      aimleft = {'key:left', 'axis:rightx-'},
      aimright = {'key:right', 'axis:rightx+'},
      aimup = {'key:up', 'axis:righty-'},
      aimdown = {'key:down', 'axis:righty+'},

      swap = {'key:q', 'button:a'},

      fire = {'mouse:1'},

      pause = {'key:escape', 'button:start'},
      back = {'key:backspace', 'button:b'},
      sel = {'key:space', 'button:a', 'key:return'},
      quit = {'key:q', 'button:back'},
    },
    pairs = {
      move = {'moveleft', 'moveright', 'moveup', 'movedown'},
      aim = {'aimleft', 'aimright', 'aimup', 'aimdown'},
    },
  }
--[[
  local menu = baton.new {
    controls = {
      left = {'key:a', 'axis:leftx-', 'button:dpleft'},
      right = {'key:d', 'axis:leftx+', 'button:dpright'},
      up = {'key:w', 'axis:lefty-', 'button:dpup'},
      down = {'key:s', 'axis:lefty+', 'button:dpdown'},

      unpause = {'key:escape', 'button:start'},
      back = {'key:escape', 'button:b'},
      sel = {'key:space', 'button:a', 'axis:triggerright+', 'key:return'},
      quit = {'key:q', 'button:back'},
    },
    pairs = {
      dir = {'left', 'right', 'up', 'down'},
    },
    joystick = love.joystick.getJoysticks()[1],
  }
]]
  return player_input
end

function love.joystickadded(j)
  player_input.joystick = j
end

return controls
