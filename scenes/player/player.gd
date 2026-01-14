extends CharacterBody3D

@export var speed: float = 4.0

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
    # Gravité (toujours utile même sans saut)
    if not is_on_floor():
        velocity.y -= gravity * delta
    else:
        velocity.y = 0.0

    # Inputs gameplay (PAS ui_*)
    var input_dir := Vector2(
        Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
        Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
    )

    var direction := Vector3(input_dir.x, 0, input_dir.y)

    if direction.length() > 0.0:
        direction = direction.normalized()
        velocity.x = direction.x * speed
        velocity.z = direction.z * speed

        # Oriente le player dans la direction du mouvement
        look_at(global_position + direction, Vector3.UP)
    else:
        velocity.x = move_toward(velocity.x, 0, speed)
        velocity.z = move_toward(velocity.z, 0, speed)

    move_and_slide()
