extends CharacterBody3D

signal set_movement_state(_movement_state: MovementState)
signal set_movement_direction(_movement_direction: Vector3)

@export var movement_states : Dictionary
@export var gravity : Variant = ProjectSettings.get_setting("physics/3d/default_gravity")

var movement_direction : Vector3

func _input(event) -> void:
    if event.is_action("movement"):
        #var input_dir := Vector2(
            #Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
            #Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
        #)

        movement_direction.x = Input.get_action_strength("move_left") - Input.get_action_strength("move_right")
        movement_direction.z = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")

        if is_movement_ongoing():
            if Input.is_action_pressed("run"):
                set_movement_state.emit(movement_states["run"])
            else:
                set_movement_state.emit(movement_states["walk"])
        else:
            set_movement_state.emit(movement_states["stand"])

func _ready() -> void:
    set_movement_state.emit(movement_states['stand'])

func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= gravity * delta
    else:
        velocity.y = 0.0

    if is_movement_ongoing():
        set_movement_direction.emit(movement_direction)

func is_movement_ongoing() -> bool:
    return abs(movement_direction.x) > 0 or abs(movement_direction.z) > 0
