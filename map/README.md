A `Level` holds `Layer`s representing the graphical depiction of the current
playfield. It is used while running the game.

A `Room` defines a layout, and is filled with `Tile`s. `Tiles`s define the
type of tile in a given location.

When a level is loaded, a `Level` is created from a `Room`.

The file `tilekinds.lua` contains definitions of various types of `Tile`s.
