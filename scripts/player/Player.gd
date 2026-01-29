extends CharacterBody3D

signal set_movement_state(_movement_state: MovementState)
signal set_movement_direction(_movement_direction: Vector3)

@onready var attack_ray: RayCast3D = $MeshRoot/AttackRaycast

@export var movement_states : Dictionary
@export var gravity : Variant = ProjectSettings.get_setting("physics/3d/default_gravity") * 10

var movement_direction : Vector3

func _input(event) -> void:
    if event.is_action_pressed("attack"):
        attack()

    if event.is_action("movement"):
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
    PhysicsHelper.apply_gravity(self, delta)

    if is_movement_ongoing():
        set_movement_direction.emit(movement_direction)

func is_movement_ongoing() -> bool:
    return abs(movement_direction.x) > 0 or abs(movement_direction.z) > 0

func attack() -> void:
    if attack_ray.is_colliding():
        var target = attack_ray.get_collider()
        if target.has_method("take_damage"):
            target.take_damage(15)
