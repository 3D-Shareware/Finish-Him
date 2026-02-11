extends RigidBody2D

@onready var anim = $"AnimationPlayer"

func _ready() -> void:
	anim.play("bomb")
	apply_impulse(Vector2(0, -100))
