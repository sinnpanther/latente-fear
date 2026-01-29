@tool
extends Node3D


@export var grid_map_path : NodePath
@onready var grid_map : GridMap = get_node(grid_map_path)
var map_cell_scene : PackedScene = preload("res://imports/DunCell.tscn")

@export var start := false :
    set(value):
        if Engine.is_editor_hint():
            create_map()

var dirs := ["up", "down", "left", "right"]
var vectors := {
    "up": Vector3i.FORWARD,
    "down": Vector3i.BACK,
    "left": Vector3i.LEFT,
    "right": Vector3i.RIGHT,
}

func handle_none(cell: Node3D, dir: String):
    cell.call("remove_door_" + dir)
func handle_00(cell: Node3D, dir: String):
    cell.call("remove_wall_" + dir)
    cell.call("remove_door_" + dir)
func handle_01(cell: Node3D, dir: String):
    cell.call("remove_door_" + dir)
func handle_02(cell: Node3D, dir: String):
    cell.call("remove_wall_" + dir)
    cell.call("remove_door_" + dir)
func handle_10(cell: Node3D, dir: String):
    cell.call("remove_door_" + dir)
func handle_11(cell: Node3D, dir: String):
    cell.call("remove_wall_" + dir)
    cell.call("remove_door_" + dir)
func handle_12(cell: Node3D, dir: String):
    cell.call("remove_wall_" + dir)
    cell.call("remove_door_" + dir)
func handle_20(cell: Node3D, dir: String):
    cell.call("remove_wall_" + dir)
    cell.call("remove_door_" + dir)
func handle_21(cell: Node3D, dir: String):
    cell.call("remove_wall_" + dir)
func handle_22(cell: Node3D, dir: String):
    cell.call("remove_wall_" + dir)
    cell.call("remove_door_" + dir)

func create_map() -> void:
    for c in get_children():
        remove_child(c)
        c.queue_free()

    var t := 0
    for cell in grid_map.get_used_cells():
        var cell_index := grid_map.get_cell_item(cell)
        if cell_index <= 2 && cell_index >= 0:
            var map_cell : Node3D = map_cell_scene.instantiate()
            map_cell.position = Vector3(cell) + Vector3(0.5, 0, 0.5)
            add_child(map_cell)

            t += 1

            for dir in dirs:
                var cell_n = cell + vectors[dir]
                var cell_n_index := grid_map.get_cell_item(cell_n)
                if cell_n_index == -1 || cell_n_index == 3:
                    handle_none(map_cell, dir)
                else:
                    var key := str(cell_index) + str(cell_n_index)
                    call("handle_" + key, map_cell, dir)
        if t % 20 == 19: await get_tree().create_timer(0.01).timeout
