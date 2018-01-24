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

      swap = {'key:q', 'button:a', 'button:rightshoulder'},
      swap_rev = {'key:e', 'button:x', 'button:leftshoulder'},
      weap1 = {'key:1'},
      weap2 = {'key:2'},
      weap3 = {'key:3'},

      fire = {'mouse:1'},

      pause = {'key:escape', 'button:start'},
      back = {'key:backspace', 'button:b'},
      sel = {'key:space', 'button:a', 'key:return'},
      quit = {'key:q', 'button:back'},

      killall = {'key:k'}
    },
    pairs = {
      move = {'moveleft', 'moveright', 'moveup', 'movedown'},
      aim = {'aimleft', 'aimright', 'aimup', 'aimdown'},
    },
  }
  player_input.deadzone = 0.25
  return player_input
end

function love.joystickadded(j)
  player_input.joystick = j
end

function love.joystickpressed(j, _)
  if player_input.joystick ~= j then
    player_input.joystick = j
  end
end

return controls
