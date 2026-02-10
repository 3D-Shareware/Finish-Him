extends RigidBody2D

var id = 0

func ready_by_parent(i: int, key_frame: int):
	id = i
	position.x = id * 32 - 160
	position.y = -200
	$"Sprite2D".rotation = key_frame * -PI / 2
	print(i)
	print(position)
	print("hi")

func get_got():
	collision_layer = 1
	collision_mask = 1
	$"AnimationPlayer".stop(true)
	$"AnimationPlayer".play("break")

func raring_to_go():
	$"AnimationPlayer".play("blink")
