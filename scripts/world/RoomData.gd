class_name RoomData
extends RefCounted

var id: int
var rect: Rect2i

func _init(_id: int, _rect: Rect2i):
    id = _id
    rect = _rect

func center() -> Vector2i:
    return Vector2i(
        rect.position.x + rect.size.x / 2,
        rect.position.y + rect.size.y / 2
    )
