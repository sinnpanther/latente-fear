extends Node2D
class_name WorldDebug2D

@export var cell_size := 8
@export var show_grid := true

var world = null

# --------------------------------------------------
# API
# --------------------------------------------------

func set_world(w):
    world = w
    queue_redraw()

# --------------------------------------------------
# DRAW
# --------------------------------------------------

func _draw():
    if world == null:
        return

    if show_grid:
        _draw_grid()

    _draw_rooms()
    _draw_corridors()
    _draw_exits()

# --------------------------------------------------
# GRID
# --------------------------------------------------

func _draw_grid():
    var w = world.grid[0].size()
    var h = world.grid.size()

    for x in range(w + 1):
        draw_line(
            Vector2(x * cell_size, 0),
            Vector2(x * cell_size, h * cell_size),
            Color(0.15, 0.15, 0.15)
        )

    for y in range(h + 1):
        draw_line(
            Vector2(0, y * cell_size),
            Vector2(w * cell_size, y * cell_size),
            Color(0.15, 0.15, 0.15)
        )

# --------------------------------------------------
# ROOMS
# --------------------------------------------------

func _draw_rooms():
    for room in world.rooms:
        var r := Rect2(
            room.rect.position * cell_size,
            room.rect.size * cell_size
        )

        # fill
        draw_rect(r, Color(0.2, 0.6, 1.0, 0.35), true)
        # outline
        draw_rect(r, Color(0.2, 0.6, 1.0), false, 2)

        # id
        draw_string(
            ThemeDB.fallback_font,
            r.position + Vector2(4, 14),
            str(room.id),
            HORIZONTAL_ALIGNMENT_LEFT,
            -1,
            12,
            Color.WHITE
        )

# --------------------------------------------------
# CORRIDORS
# --------------------------------------------------

func _draw_corridors():
    var h = world.grid.size()
    var w = world.grid[0].size()

    for y in range(h):
        for x in range(w):
            if world.grid[y][x] == 2: # CellType.CORRIDOR
                draw_rect(
                    Rect2(
                        Vector2(x, y) * cell_size,
                        Vector2(cell_size, cell_size)
                    ),
                    Color(1.0, 0.8, 0.2, 0.8),
                    true
                )

# --------------------------------------------------
# EXIT POINTS
# --------------------------------------------------

func _draw_exits():
    for c in world.connections:
        _draw_exit_point(c.start, Color.RED)
        _draw_exit_point(c.end, Color.GREEN)

func _draw_exit_point(p: Vector2i, color: Color):
    var center := (p * cell_size) + Vector2i(cell_size / 2, cell_size / 2)
    draw_circle(center, cell_size * 0.3, color)
