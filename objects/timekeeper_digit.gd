extends RigidBody2D

@onready var sprite = $"Sprite2D"
@onready var anim = $"AnimationPlayer"

var is_scared = false

func new_frame(frame: int):
	sprite.frame = frame
	if frame == 10:
		anim.play("blink")

func _physics_process(_delta: float) -> void:
	if is_scared:
		apply_force(Vector2(-1000, 100))
