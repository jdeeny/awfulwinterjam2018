A `Level` contains a set of numbered `Layer`s.

Each `Layer` contains a set of entities, which are sorted by type (kind).

When update and draw calls are made, the layers are operated on in ascending order.

The `TileSet` holds `Tile` objects. Each `Tile` is able to create an entity that
can be stored in the map.
