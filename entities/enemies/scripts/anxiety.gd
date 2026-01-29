extends Enemy
class_name Anxiety

var anxiety_data: AnxietyData

func _ready():
    super._ready()

    if data is AnxietyData:
        anxiety_data = data
    else:
        push_warning("Anxiety needs AnxietyData")

func update_state(delta):
    match state:
        "idle":
            velocity = Vector3.ZERO

        "chase":
            if last_seen_player_pos:
                chase_player(delta)

func chase_player(delta):
    if not player:  # Utilise une référence au player au lieu d'une position fixe
        return

    var to_target = last_seen_player_pos - global_position
    to_target.y = 0

    var distance = to_target.length()

    if distance <= anxiety_data.stop_distance:
        velocity = Vector3.ZERO
        move_and_slide()
        return

    var direction = to_target.normalized()

    rotate_towards(direction, delta)

    var desired_velocity = direction * anxiety_data.move_speed
    velocity = velocity.lerp(desired_velocity, delta * anxiety_data.acceleration)

    move_and_slide()

func rotate_towards(direction: Vector3, delta):
    var target_rotation = atan2(-direction.x, -direction.z)
    rotation.y = lerp_angle(rotation.y, target_rotation, delta * anxiety_data.rotation_speed)
