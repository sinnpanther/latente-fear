extends Node
class_name LevelManager

var current_theme: GameTheme
var current_rng: RandomNumberGenerator

func start_level(level_index: int) -> void:
    # 1️⃣ Choisir le thème (plus tard ce sera aléatoire)
    current_theme = preload("res://data/themes/LabTheme.tres")


    # 2️⃣ Créer le RNG du niveau
    current_rng = SeedManager.create_level_rng(level_index)

    # 3️⃣ Créer le layout
    var layout = LayoutFactory.create(current_theme, current_rng)

    if layout == null:
        push_error("Layout creation failed")
        return

    layout.build()
