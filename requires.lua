math = require 'math'

-- Framework Requirements
require("core/Stackhelper")
require("core/Resources")

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

camera = require "camera"
collision = require "collision"
controls = require "controls"
dungeon = require "dungeon"
doodad = require "doodad"
idcounter = require "idcounter"
image = require "image"
image.init()
animation = require "animation"
animation.init()
mob = require "mob"
enemy = require "enemy"
player = require "player"
intro = require 'intro'
room = require "room"
shot = require "shot"
timer = require "timer"
menu = require "menu"
sound = require "sound"
weapon = require "weapon"

doodad_data = require "doodad_data"
enemy_data = require "enemy_data"
shot_data = require "shot_data"

require "lib/a-star-lua/a-star"
