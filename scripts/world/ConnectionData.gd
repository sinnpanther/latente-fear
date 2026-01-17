class_name ConnectionData
extends RefCounted

var room_a: RoomData
var room_b: RoomData
var start: Vector2i
var end: Vector2i

func _init(a: RoomData, b: RoomData, s: Vector2i, e: Vector2i):
    room_a = a
    room_b = b
    start = s
    end = e
