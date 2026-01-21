extends Node3D

@export var map_gen_scene: PackedScene
@export var player_scene: PackedScene
@export var lab_theme: GameTheme

var mapgen: Node3D

func _ready():
    init_seed()
    spawn_map()
    await mapgen.generation_finished
    spawn_player()

func init_seed():
    var human_seed := SeedManager.generate_human_seed()
    print("SEED: ", human_seed)
    SeedManager.init_run(human_seed)

func spawn_map():
    mapgen = map_gen_scene.instantiate()
    add_child(mapgen)
    mapgen.generate()

func spawn_player():
    var player := player_scene.instantiate()
    add_child(player)
    player.global_position = mapgen.get_spawn_position()
