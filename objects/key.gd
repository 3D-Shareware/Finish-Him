extends RigidBody2D

var id = 0

var is_active = false

var is_scared = false

@onready var anim = $"AnimationPlayer"

@onready var audio = $"AudioStreamPlayer2D"

func ready_by_parent(i: int, key_frame: int):
	id = i
	position.x = id * 32 - 144
	position.y = -200
	$"Sprite2D".rotation = key_frame * -PI / 2
	apply_impulse(Vector2(0, 250))

func _physics_process(_delta: float) -> void:
	if is_scared:
		apply_force(Vector2(-1000, -100))

func get_got():
	collision_layer = 5
	collision_mask = 5
	anim.stop(true)
	anim.play("break")
	$"Sprite2D".z_index = 1
	is_active = false
	audio.pitch_scale = 0.1 + id * 0.2
	audio.play()
	#apply_impulse(Vector2(0, 500))

func raring_to_go():
	anim.play("blink")
	$"Sprite2D".z_index = 2
	is_active = true

func you_lose():
	anim.stop(true)
	if is_active:
		anim.play("fail_blink")
	else:
		anim.play("fail")
