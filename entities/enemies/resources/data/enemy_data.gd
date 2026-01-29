extends Resource
class_name EnemyData

@export_category("Combat")
@export var hp := 100.0
@export var max_hp := 100.0
@export var defense := 5.0

@export_category("Movement")
@export var move_speed := 3.5
@export var rotation_speed := 6.0
@export var stop_distance := 0.8
@export var acceleration := 12.0

@export_category("Vision")
@export var vision_distance := 15.0
@export var vision_angle := 60.0

@export_category("Behavior")
@export var lose_target_distance := 20.0
