extends Node

@export var story_scene: PackedScene
@export var roguelike_scene: PackedScene

var current_mode: Node

func _ready():
    # temporaire : on lance direct le roguelike
    start_roguelike()

func start_story():
    _switch_mode(story_scene)

func start_roguelike():
    _switch_mode(roguelike_scene)

func _switch_mode(scene: PackedScene):
    if current_mode:
        current_mode.queue_free()

    current_mode = scene.instantiate()
    add_child(current_mode)
