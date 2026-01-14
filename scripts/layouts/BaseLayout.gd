extends Node
class_name BaseLayout

var theme: GameTheme
var rng: RandomNumberGenerator

func _init(t: GameTheme, r: RandomNumberGenerator):
    theme = t
    rng = r

func build() -> void:
    push_error("build() must be implemented in child layout")
