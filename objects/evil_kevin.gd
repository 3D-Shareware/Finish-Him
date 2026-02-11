extends RigidBody2D

@onready var anim = $"AnimationPlayer"

var is_scared = false

func _ready():
	apply_impulse(Vector2(0, 500))
	anim.play("dizzy")

func _physics_process(_delta: float) -> void:
	if is_scared:
		apply_force(Vector2(-1000, -100))

func get_got():
	anim.stop(true)
	anim.play("hurt")

func freeze():
	anim.stop(true)
	anim.play("hurt_freeze")

func get_scared():
	anim.stop(true)
	anim.play("hurt_scared")
	is_scared = true

func you_lose():
	anim.stop(true)
	anim.play("laugh")
