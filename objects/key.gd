extends RigidBody2D

var id = 0

var is_active = false

@onready var anim = $"AnimationPlayer"

func ready_by_parent(i: int, key_frame: int):
	id = i
	position.x = id * 32 - 160
	position.y = -200
	$"Sprite2D".rotation = key_frame * -PI / 2

func get_got():
	collision_layer = 1
	collision_mask = 1
	anim.stop(true)
	anim.play("break")
	$"Sprite2D".z_index = 0
	is_active = false

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
