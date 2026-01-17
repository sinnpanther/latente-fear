extends Node2D

@onready var debug := $WorldDebug2D
@onready var camera := $Camera2D
@export var camera_speed := 600

func _ready():
    var human_seed := SeedManager.generate_human_seed()
    SeedManager.init_run(human_seed)

    var generator := LevelGenerator2D.new()
    var world := generator.generate(SeedManager.seed_string_to_int(human_seed))

    debug.set_world(world)

    _center_camera(world)

func _center_camera(world):
    camera.make_current()

    var w = world.grid[0].size()
    var h = world.grid.size()

    camera.position = Vector2(
        w * debug.cell_size / 2,
        h * debug.cell_size / 2
    )

    camera.zoom = Vector2(1.5, 1.5)

func _process(delta):
    var dir := Vector2.ZERO

    if Input.is_action_pressed("ui_left"):
        dir.x -= 1
    if Input.is_action_pressed("ui_right"):
        dir.x += 1
    if Input.is_action_pressed("ui_up"):
        dir.y -= 1
    if Input.is_action_pressed("ui_down"):
        dir.y += 1

    if dir != Vector2.ZERO:
        camera.position += dir.normalized() * camera_speed * delta
