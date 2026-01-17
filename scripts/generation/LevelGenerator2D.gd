extends RefCounted
class_name LevelGenerator2D

# --------------------------------------------------
# CONFIG
# --------------------------------------------------

const ROOM_COUNT := 12
const ROOM_MIN_SIZE := Vector2i(6, 6)
const ROOM_MAX_SIZE := Vector2i(16, 16)

# --------------------------------------------------
# DATA STRUCTURES
# --------------------------------------------------


# --------------------------------------------------
# PUBLIC ENTRY POINT
# --------------------------------------------------

func generate(seed_int: int) -> WorldData:
    var rng := RandomNumberGenerator.new()
    rng.seed = seed_int

    var world := WorldData.new()

    _generate_rooms(world, rng)
    _connect_rooms_mst(world)
    _carve_corridors(world, rng)

    return world

# --------------------------------------------------
# ROOM GENERATION (NO OVERLAP)
# --------------------------------------------------

func _generate_rooms(world: WorldData, rng: RandomNumberGenerator) -> void:
    var attempts := 0
    var id := 0

    while world.rooms.size() < ROOM_COUNT and attempts < ROOM_COUNT * 50:
        attempts += 1

        var size := Vector2i(
            rng.randi_range(ROOM_MIN_SIZE.x, ROOM_MAX_SIZE.x),
            rng.randi_range(ROOM_MIN_SIZE.y, ROOM_MAX_SIZE.y)
        )

        var pos := Vector2i(
            rng.randi_range(1, WorldData.WORLD_WIDTH - size.x - 2),
            rng.randi_range(1, WorldData.WORLD_HEIGHT - size.y - 2)
        )

        var rect := Rect2i(pos, size)

        if _intersects_any_room(rect, world.rooms):
            continue

        var room := RoomData.new(id, rect)
        id += 1

        world.rooms.append(room)
        _fill_rect(world, rect, WorldData.CellType.ROOM)

func _intersects_any_room(rect: Rect2i, rooms: Array[RoomData]) -> bool:
    for r in rooms:
        if rect.grow(1).intersects(r.rect):
            return true
    return false

# --------------------------------------------------
# MST CONNECTION
# --------------------------------------------------

func _connect_rooms_mst(world: WorldData) -> void:
    var edges := []

    for i in range(world.rooms.size()):
        for j in range(i + 1, world.rooms.size()):
            var a := world.rooms[i]
            var b := world.rooms[j]
            var dist := a.center().distance_to(b.center())

            edges.append({
                "a": a,
                "b": b,
                "d": dist
            })

    edges.sort_custom(func(x, y): return x.d < y.d)

    var connected := {}
    connected[world.rooms[0]] = true

    while connected.size() < world.rooms.size():
        for e in edges:
            var a: RoomData = e.a
            var b: RoomData = e.b

            var a_in := connected.has(a)
            var b_in := connected.has(b)

            if a_in != b_in:
                var link := _choose_best_connection(a, b)

                world.connections.append(
                    ConnectionData.new(a, b, link.from, link.to)
                )

                connected[a] = true
                connected[b] = true
                break

# --------------------------------------------------
# EXIT POINT ON ROOM WALL (CENTERED)
# --------------------------------------------------

func _get_exit_candidates(room: RoomData) -> Array[Vector2i]:
    var exits: Array[Vector2i] = []

    var rect := room.rect
    var cx := rect.position.x + rect.size.x / 2
    var cy := rect.position.y + rect.size.y / 2

    # Haut
    exits.append(Vector2i(cx, rect.position.y - 1))
    # Bas
    exits.append(Vector2i(cx, rect.position.y + rect.size.y))
    # Gauche
    exits.append(Vector2i(rect.position.x - 1, cy))
    # Droite
    exits.append(Vector2i(rect.position.x + rect.size.x, cy))

    return exits

func _choose_best_connection(a: RoomData, b: RoomData) -> Dictionary:
    var exits_a := _get_exit_candidates(a)
    var exits_b := _get_exit_candidates(b)

    var best := {
        "from": exits_a[0],
        "to": exits_b[0],
        "cost": INF
    }

    for ea in exits_a:
        for eb in exits_b:
            var cost = abs(ea.x - eb.x) + abs(ea.y - eb.y)
            if cost < best.cost:
                best.from = ea
                best.to = eb
                best.cost = cost

    return best
# --------------------------------------------------
# CARVE L-SHAPED CORRIDORS
# --------------------------------------------------

func _carve_corridors(world: WorldData, rng: RandomNumberGenerator) -> void:
    for c in world.connections:
        var a := c.start
        var b := c.end

        # Cas 1 : couloir vertical direct
        if a.x == b.x:
            _carve_v(world, a.y, b.y, a.x)
            continue

        # Cas 2 : couloir horizontal direct
        if a.y == b.y:
            _carve_h(world, a.x, b.x, a.y)
            continue

        # Cas 3 : couloir en L
        if rng.randf() < 0.5:
            # Horizontal puis vertical
            _carve_h(world, a.x, b.x, a.y)
            _carve_v(world, a.y, b.y, b.x)
        else:
            # Vertical puis horizontal
            _carve_v(world, a.y, b.y, a.x)
            _carve_h(world, a.x, b.x, b.y)

func _carve_h(world: WorldData, x1: int, x2: int, y: int) -> void:
    var from = min(x1, x2)
    var to = max(x1, x2)

    for x in range(from, to + 1):
        world.grid[y][x] = WorldData.CellType.CORRIDOR

func _carve_v(world: WorldData, y1: int, y2: int, x: int) -> void:
    var from = min(y1, y2)
    var to = max(y1, y2)

    for y in range(from, to + 1):
        world.grid[y][x] = WorldData.CellType.CORRIDOR

# --------------------------------------------------
# UTILS
# --------------------------------------------------

func _fill_rect(world: WorldData, rect: Rect2i, value: int) -> void:
    for y in range(rect.position.y, rect.position.y + rect.size.y):
        for x in range(rect.position.x, rect.position.x + rect.size.x):
            world.grid[y][x] = value
