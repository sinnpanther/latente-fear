extends Node
class_name LayoutFactory

static func create(theme: GameTheme, rng: RandomNumberGenerator) -> BaseLayout:
    match theme.id:
        "laboratory":
            return preload("res://scripts/layouts/LabLayout.gd").new(theme, rng)
        _:
            push_error("Unknown theme: " + theme.id)

            return null
