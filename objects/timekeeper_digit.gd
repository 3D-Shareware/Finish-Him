extends RigidBody2D

@onready var sprite = $"Sprite2D"

var is_scared = false

func new_frame(frame: int):
	sprite.frame = frame

func _physics_process(delta: float) -> void:
	if is_scared:
		apply_force(Vector2(-1000, 100))
