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
      
      pause = {'key:escape'},
    },
    pairs = {
      move = {'moveleft', 'moveright', 'moveup', 'movedown'},
      aim = {'aimleft', 'aimright', 'aimup', 'aimdown'},
    },
    joystick = love.joystick.getJoysticks()[1],
  }

  local menu = baton.new {
    controls = {
      left = {'key:a', 'axis:leftx-'},
      right = {'key:d', 'axis:leftx+'},
      up = {'key:w', 'axis:lefty-'},
      down = {'key:s', 'axis:lefty+'},

      pause = {'key:escape'},
      sel = {'key:space', 'button:a', 'axis:triggerright+', 'mouse:1'},
      quit = {'key:q'}
    }  
  }

  return player, menu
end



return controls
