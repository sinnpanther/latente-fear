extends Resource
class_name GameTheme

@export var id: String
@export var allowed_layouts: Array[String]

@export var min_rooms: int = 4
@export var max_rooms: int = 8

@export var has_internal_walls: bool = true
@export var has_props: bool = true
@export var has_enemies: bool = true
