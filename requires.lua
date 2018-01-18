math = require 'math'
duration = require "duration"
delay = require "delay"

baton = require 'lib/baton/baton' -- the baton player_input library https://github.com/tesselode/baton
anim8 = require 'lib/anim8/anim8' -- anim8 animation library https://github.com/kikito/anim8
cpml = require 'lib/cpml'-- Cirno's Perfect Math Library https://github.com/excessive/cpml (Docs: http://excessive.github.io/cpml/)
HC = require 'lib/HC' -- General purpose collision detection library for the use with LÖVE. https://github.com/vrld/HC (Docs: http://hc.readthedocs.org)
lovetoys = require('lib/lovetoys/lovetoys') -- Entity-Componet System https://github.com/Lovetoys/lovetoys
class = require 'lib/middleclass/middleclass' -- OOP https://github.com/kikito/middleclass
moonshine = require 'lib/moonshine/'
gui_flux = require 'lib/flux/flux'  -- Simple tweening system https://github.com/rxi/flux
game_flux = require 'lib/flux/flux'  -- Flux as above, but using game time units
require 'lib/autobatch/autobatch'                 -- autobatch automatic SpriteBatch https://github.com/rxi/autobatch
bitser = require 'lib/bitser/bitser' -- Serialization with LOVE-specific load & save function

-- nice scaling for pixel graphics (might be fixed in git version?) https://github.com/SystemLogoff/lovePixel
-- interesting text library that allows control per letter https://github.com/mzrinsky/popo https://github.com/EntranceJew/popo
-- neural net that generates text that looks like source data https://github.com/karpathy/char-rnn
-- https://github.com/tastyminerals/coherent-text-generation-limited
-- sound synth lib https://github.com/vrld/Moan

require 'window'
require 'map'

OptionItem = require "ui_elements/optionitem"
allowed_options = require "ui_elements/allowed_options"

continue = require "states/continue"
death = require "states/death"
film = require "states/film"
mainmenu = require "states/mainmenu"
pause = require "states/pause"
play = require "states/play"
splash = require "states/splash"
win = require "states/win"
options = require "states/options"


camera = require "camera"
collision = require "collision"
controls = require "controls"
grid = require "grid"
pathfinder = require "pathfinder"
dungeon = require "dungeon"
doodad = require "doodad"
fade = require "fade"
file_io = require "file_io"
hud = require "ui_elements/hud"
idcounter = require "idcounter"
image = require "image"
image.init()
animation = require "animation"
animation.init()
settings = require "settings"
timer = require "timer"

mob = require "enemies/mob"
Ai = require "enemies/ai/ai"
personalities = require "enemies/ai/personalities"
enemy = require "enemies/enemy"
player = require "player"
spawner = require "enemies/spawner"
spark = require "spark"

weapon = require "weapons/weapon"
shot = require "weapons/shot"

PooledSource = require "audio/pooledsource"
AudioManager = require "audio/audiomanager"
LoopedAudio = require "audio/loopedaudio"

doodad_data = require "doodad_data"
enemy_data = require "enemies/enemy_data"
shot_data = require "weapons/shot_data"
spark_data = require "spark_data"

water_effect = require 'effects/water'
ray_effect = require 'effects/ray'

require "lib/a-star-lua/a-star"

ElectricSim = require "electricity/elecsim"
ElecNode = require "electricity/elecnode"
TileElecNode = require "electricity/tileelecnode"
MobElecNode = require "electricity/mobelecnode"
BoltManager = require "electricity/boltmanager"
