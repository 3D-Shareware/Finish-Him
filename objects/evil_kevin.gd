extends RigidBody2D

@onready var anim = $"AnimationPlayer"

func _ready():
	apply_impulse(Vector2(0, 500))
	anim.play("dizzy")

func get_got():
	anim.stop(true)
	anim.play("hurt")

func you_lose():
	anim.stop(true)
	anim.play("laugh")
