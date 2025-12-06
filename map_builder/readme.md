
# 📘 **Tile Map JSON Format – README**

This document describes the JSON format produced by the Tile Map Builder.
It explains the map structure, layer system, tile data, and how to interpret the exported values.

---

## 🗺️ **Overview**

The Tile Map Builder exports a complete description of your map in JSON.
Each map file contains:

* Metadata about the map
* Tile size
* Multiple layers (Ground, Objects, etc.)
* A 2D array of tiles for each layer

This format is designed to be simple, engine-agnostic, and easy to load in Godot, Unity, custom engines, or web games.

---

# 📂 **Top-Level Structure**

Example:

```json
{
  "name": "MyMap",
  "width": 30,
  "height": 20,
  "tile_size": 16,
  "layers": [ ... ]
}
```

### **Fields**

| Field       | Type   | Description                                |
| ----------- | ------ | ------------------------------------------ |
| `name`      | string | Name of the map.                           |
| `width`     | int    | Number of tiles horizontally.              |
| `height`    | int    | Number of tiles vertically.                |
| `tile_size` | int    | Size of each tile in pixels (e.g., 16×16). |
| `layers`    | array  | List of layers in the map.                 |

---

# 🧱 **Layer Format**

Each layer is stored as an object:

```json
{
  "name": "Ground",
  "visible": true,
  "tiles": [ ... ]
}
```

### **Layer Fields**

| Field     | Type    | Description                                           |
| --------- | ------- | ----------------------------------------------------- |
| `name`    | string  | Name of the layer (e.g., Ground, Walls, Objects).     |
| `visible` | boolean | Whether this layer is visible (useful for toggling).  |
| `tiles`   | array   | A 2D grid (height rows × width cols) of tile entries. |

---

# 🎨 **Tile Format**

Each tile is represented by:

```json
{
  "tx": -1,
  "ty": -1
}
```

### **Tile Fields**

| Field | Type | Description                                                                       |
| ----- | ---- | --------------------------------------------------------------------------------- |
| `tx`  | int  | Tile X coordinate inside the tileset atlas. A value of **-1** means “empty tile.” |
| `ty`  | int  | Tile Y coordinate inside the tileset atlas. A value of **-1** means “empty tile.” |

### 🟦 What Are `tx` and `ty`?

These are the *tileset coordinates*, not world/map coordinates.

* (0,0) = top-left tile in the tileset
* (1,0) = tile right of that
* (0,1) = tile below that
* and so on…

### 🟥 Empty Tiles

A tile with:

```json
{ "tx": -1, "ty": -1 }
```

means **no tile placed** at that position.

---

# 🧭 **Tile Grid Layout**

Tiles are stored as a 2D array:

```
tiles[row][column]
```

Which corresponds to:

* `tiles[y][x]`

So if the map is 30×20:

* There are **20 rows**
* Each row contains **30 tile objects**

---

# 📌 **Example Layer Snippet**

```json
"tiles": [
  [
    {"tx": -1, "ty": -1},
    {"tx": -1, "ty": -1},
    {"tx":  5, "ty":  2},
    ...
  ],
  [
    {"tx": -1, "ty": -1},
    {"tx":  1, "ty":  3},
    {"tx":  1, "ty":  3},
    ...
  ]
]
```

---

# 🔄 **How to Load This Map**

### General approach:

1. Read the JSON file.
2. Iterate through each layer.
3. For each tile:

   * If `tx == -1` ignore (empty tile)
   * Otherwise:

     * Find the tile in your tileset at `(tx, ty)`
     * Render or place it at the map coordinate `(x, y)`

### Tile world position:

```
world_x = x * tile_size
world_y = y * tile_size
```

---

