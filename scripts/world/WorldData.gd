class_name WorldData
extends RefCounted

const WORLD_WIDTH := 100
const WORLD_HEIGHT := 100

enum CellType {
    EMPTY,
    ROOM,
    CORRIDOR
}

var grid: Array
var rooms: Array[RoomData] = []
var connections: Array[ConnectionData] = []

func _init():
    grid = []
    for y in WORLD_HEIGHT:
        var row := []
        for x in WORLD_WIDTH:
            row.append(CellType.EMPTY)
        grid.append(row)
