extends CharacterBody3D
class_name Enemy

@onready var mesh: MeshInstance3D = $MeshInstance3D

@export var data: EnemyData
@export var player: Node3D

var state: String = "idle"
var last_seen_player_pos: Vector3
var current_hp: float

func _ready():
    add_to_group("enemies")

    if not player:
        push_warning("Enemy: player not assigned in inspector")

    current_hp = data.max_hp

func _physics_process(delta):
    PhysicsHelper.apply_gravity(self, delta)

    update_perception()
    update_state(delta)
    update_movement(delta)

# -----------------------
# PERCEPTION
# -----------------------
func update_perception():
    if not player:
        return

    if can_see_player():
        last_seen_player_pos = player.global_position
        on_player_seen()

func can_see_player() -> bool:
    var to_player = player.global_position - global_position
    var distance = to_player.length()

    if distance > data.vision_distance:
        return false

    var forward = -global_transform.basis.z
    var direction = to_player.normalized()

    var dot = forward.dot(direction)
    var angle_limit = cos(deg_to_rad(data.vision_angle * 0.5))

    return dot > angle_limit

func on_player_seen():
    state = "chase"

func take_damage(amount: int) -> void:
    current_hp -= amount
    print("%s: -%d HP (%d restants)" % [name, amount, current_hp])

    # Flash rouge sur le mesh
    var mat = mesh.mesh.surface_get_material(0)
    if mat:
        var color_bck = mat.albedo_color
        mat.albedo_color = Color.RED
        await get_tree().create_timer(0.1).timeout
        mat.albedo_color = color_bck

    if current_hp <= 0:
        die()

func die() -> void:
    queue_free()
# -----------------------
# STATE
# -----------------------
func update_state(delta):
    pass

# -----------------------
# MOVEMENT
# -----------------------
func update_movement(delta):
    pass
