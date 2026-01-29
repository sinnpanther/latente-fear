extends Node

const DEFAULT_GRAVITY = 25.0
const MAX_FALL_SPEED = 50.0

func apply_gravity(body: CharacterBody3D, delta: float):
    if not body.is_on_floor():
        body.velocity.y -= DEFAULT_GRAVITY * delta
        body.velocity.y = max(body.velocity.y, -MAX_FALL_SPEED)
    else:
        body.velocity.y = 0.0
