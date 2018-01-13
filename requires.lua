math = require 'math'

baton = require 'lib/baton/baton' -- the baton player_input library https://github.com/tesselode/baton
anim8 = require 'lib/anim8/anim8' -- anim8 animation library https://github.com/kikito/anim8
cpml = require 'lib/cpml'-- Cirno's Perfect Math Library https://github.com/excessive/cpml (Docs: http://excessive.github.io/cpml/)
HC = require 'lib/HC' -- General purpose collision detection library for the use with LÖVE. https://github.com/vrld/HC (Docs: http://hc.readthedocs.org)
lovetoys = require('lib/lovetoys/lovetoys') -- Entity-Componet System https://github.com/Lovetoys/lovetoys
class = require 'lib/middleclass/middleclass' -- OOP https://github.com/kikito/middleclass
moonshine = require 'lib/moonshine/'

--require 'lib/autobatch/autobatch'                 -- autobatch automatic SpriteBatch https://github.com/rxi/autobatch
-- nice scaling for pixel graphics (might be fixed in git version?) https://github.com/SystemLogoff/lovePixel
-- interesting text library that allows control per letter https://github.com/mzrinsky/popo https://github.com/EntranceJew/popo
-- neural net that generates text that looks like source data https://github.com/karpathy/char-rnn
-- https://github.com/tastyminerals/coherent-text-generation-limited
-- sound synth lib https://github.com/vrld/Moan

continue = require "states/continue"
death = require "states/death"
film = require "states/film"
main_menu = require "states/main_menu"
pause = require "states/pause"
play = require "states/play"

camera = require "camera"
collision = require "collision"
controls = require "controls"grid = require "grid"
dungeon = require "dungeon"
doodad = require "doodad"
fade = require "fade"
idcounter = require "idcounter"
image = require "image"
image.init()
animation = require "animation"
animation.init()
mob = require "enemies/mob"
enemy = require "enemies/enemy"
player = require "player"
room = require "room"
shot = require "shot"
timer = require "timer"
sound = require "sound"
state = require "state"
weapon = require "weapon"

doodad_data = require "doodad_data"
enemy_data = require "enemies/enemy_data"
shot_data = require "shot_data"

require "lib/a-star-lua/a-star"
