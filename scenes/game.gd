extends Node2D

## Generally ranges between 1.0 and something higher.
@export var ultra_hardcore_difficulty = 1.0

@onready var key = load("res://objects/key.tscn")

@onready var camera_anim: AnimationPlayer = $"Camera2D/AnimationPlayer"

enum INPUTS {up, left, down, right}

## If this project CRASHES AND DOESN'T FUNCTION, rename the up, left, down, and right inputs to match
# the inputs they're named as in the actual project
var target_input_names = ["up", "left", "down", "right"]

var key_input_order = []
var key_nodes = []

var take_inputs = true

func _ready() -> void:
	var number_of_keys = clampi(int((ultra_hardcore_difficulty * 2 + 1)), 3, 10)
	for i in number_of_keys:
		var new_input = randi_range(0, 3)
		# add inputs
		key_input_order.append(new_input)
		# add keys
		var new_key = key.instantiate()
		add_child(new_key)
		new_key.ready_by_parent(i, new_input)
		key_nodes.append(new_key)
	key_nodes[0].raring_to_go()

func _physics_process(delta: float) -> void:
	if take_inputs:
		if Input.is_action_just_pressed(target_input_names[key_input_order[0]]):
			# succesful input!
			camera_anim.stop()
			camera_anim.play("tiny_shake")
			key_input_order.pop_front()
			key_nodes[0].get_got()
			key_nodes.pop_front()
			if key_input_order.is_empty():
				take_inputs = false
			else:
				key_nodes[0].raring_to_go()
		elif Input.is_action_just_pressed("keyboard"):
			# fail!
			for key in key_nodes:
				key.you_lose()
			take_inputs = false
