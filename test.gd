extends Node

@export var lab_theme: GameTheme

func _ready():
    # Init seed
    var human_seed := SeedManager.generate_human_seed()
    SeedManager.init_run(human_seed)

    print("RUN SEED:", human_seed)

    # Level manager
    var level_manager := LevelManager.new()
    add_child(level_manager)

    level_manager.start_level(1)
