extends RigidBody2D

@onready var anim = $"AnimationPlayer"

@onready var sprite = $"Sprite2D"

func _ready():
	apply_impulse(Vector2(0, 500))

func get_got():
	anim.stop(true)
	pass # play different animation depending on fatality

func you_lose():
	anim.stop(true)
	anim.play("trip")
	apply_impulse(Vector2(250, 0))

func set_frame(key: int):
	sprite.frame = key + 1
