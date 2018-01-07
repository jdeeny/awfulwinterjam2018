math = require 'math'

baton = require 'lib/baton/baton' -- the baton player_input library https://github.com/tesselode/baton
anim8 = require 'lib/anim8/anim8' -- anim8 animation library https://github.com/kikito/anim8
cpml = require 'lib/cpml'-- Cirno's Perfect Math Library https://github.com/excessive/cpml (Docs: http://excessive.github.io/cpml/)
HC = require 'lib/HC' -- General purpose collision detection library for the use with LÖVE. https://github.com/vrld/HC (Docs: http://hc.readthedocs.org)
lovetoys = require('lib/lovetoys/lovetoys') -- Entity-Componet System https://github.com/Lovetoys/lovetoys

--require 'lib/autobatch/autobatch'                 -- autobatch automatic SpriteBatch https://github.com/rxi/autobatch
-- OOP https://github.com/kikito/middleclass
-- nice scaling for pixel graphics (might be fixed in git version?) https://github.com/SystemLogoff/lovePixel
-- interesting text library that allows control per letter https://github.com/mzrinsky/popo https://github.com/EntranceJew/popo
-- neural net that generates text that looks like source data https://github.com/karpathy/char-rnn
-- https://github.com/tastyminerals/coherent-text-generation-limited
-- sound synth lib https://github.com/vrld/Moan

camera = require "camera"
collision = require "collision"
controls = require "controls"
idcounter = require "idcounter"
image = require "image"
map = require "map"
player = require "player"
reticle = require "reticle"
shot = require "shot"
shot_data = require "shot_data"
