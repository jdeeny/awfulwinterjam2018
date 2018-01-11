local controls = {}

function controls.init()
  local player = baton.new {
    controls = {
      moveleft = {'key:a', 'axis:leftx-'},
      moveright = {'key:d', 'axis:leftx+'},
      moveup = {'key:w', 'axis:lefty-'},
      movedown = {'key:s', 'axis:lefty+'},

      aimleft = {'key:left', 'axis:rightx-'},
      aimright = {'key:right', 'axis:rightx+'},
      aimup = {'key:up', 'axis:righty-'},
      aimdown = {'key:down', 'axis:righty+'},

      fire = {'key:space', 'button:a', 'axis:triggerright+', 'mouse:1'},
      
      pause = {'key:escape', 'button:start'},
    },
    pairs = {
      move = {'moveleft', 'moveright', 'moveup', 'movedown'},
      aim = {'aimleft', 'aimright', 'aimup', 'aimdown'},
    },
    joystick = love.joystick.getJoysticks()[1],
  }

  local menu = baton.new {
    controls = {
      left = {'key:a', 'axis:leftx-', 'button:dpleft'},
      right = {'key:d', 'axis:leftx+', 'button:dpright'},
      up = {'key:w', 'axis:lefty-', 'button:dpup'},
      down = {'key:s', 'axis:lefty+', 'button:dpdown'},

      unpause = {'button:start'},
      back = {'key:escape', 'button:b'},
      sel = {'key:space', 'button:a', 'axis:triggerright+', 'key:enter'},
      quit = {'key:q', 'button:back'},
    },
    pairs = {
      dir = {'left', 'right', 'up', 'down'},
    },
    joystick = love.joystick.getJoysticks()[1],
  }

  return player, menu
end



return controls
