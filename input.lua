require "requires"

player_input = baton.new {
  controls = {
    moveleft = {'key:a', 'axis:leftx-'},
    moveright = {'key:d', 'axis:leftx+'},
    moveup = {'key:w', 'axis:lefty-'},
    movedown = {'key:s', 'axis:lefty+'},

    aimleft = {'key:left', 'axis:rightx-'},
    aimright = {'key:right', 'axis:rightx+'},
    aimup = {'key:up', 'axis:righty-'},
    aimdown = {'key:down', 'axis:righty+'},

    fire = {'key:space', 'button:a', 'axis:triggerright+'},
  },
  pairs = {
    move = {'moveleft', 'moveright', 'moveup', 'movedown'},
    aim = {'aimleft', 'aimright', 'aimup', 'aimdown'},
  },
  joystick = love.joystick.getJoysticks()[1],
}