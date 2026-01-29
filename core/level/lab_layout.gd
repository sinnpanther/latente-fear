extends BaseLayout

func build() -> void:
    var room_count := rng.randi_range(theme.min_rooms, theme.max_rooms)

    print("")
    print("=== LAB LAYOUT ===")
    print("Theme:", theme.id)
    print("Rooms:", room_count)

    for i in room_count:
        generate_room(i)


func generate_room(room_id: int) -> void:
    var room_rng := RandomNumberGenerator.new()
    room_rng.seed = rng.seed + room_id * 100

    var enemy_count := 0
    if theme.has_enemies:
        enemy_count = room_rng.randi_range(1, 3)

    print("Room", room_id, "| enemies:", enemy_count)
