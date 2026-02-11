extends RigidBody2D

@onready var anim = $"AnimationPlayer"

func _ready():
	anim.play("burn_startup")
	apply_impulse(Vector2(0, -50))

func burn_loop():
	anim.stop()
	anim.play("burn_loop")
