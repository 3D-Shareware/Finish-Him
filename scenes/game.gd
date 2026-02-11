extends Node2D

## Generally ranges between 1.0 and something higher.
@export var ultra_hardcore_difficulty = 1.0

# The fastest the player can reasonably consistently do this game (even with bad rng) is like 3.5 seconds.
# So 4 seconds will be the fastest this game can go.
# Max of 10 seconds?

@onready var key = load("res://objects/key.tscn")
@onready var ember = load("res://objects/ember.tscn")
@onready var bomb = load("res://objects/bomb.tscn")
@onready var icicle = load("res://objects/icicle.tscn")
@onready var tiny_particle = load("res://objects/tiny_particle.tscn")

@onready var camera_anim: AnimationPlayer = $"Camera2D/AnimationPlayer"

@onready var move_on_timer = $"Move On Timer"
@onready var digital_timer_update_timer = $"Digital Timer Update Timer"
@onready var fatality_timer = $"Fatality Timer"

@onready var timer_digit_1 = $"Digit 1"
@onready var timer_digit_2 = $"Digit 2"

@onready var health_bar_1 = $"Health Bar"
@onready var health_bar_2 = $"Health Bar 2"

@onready var good_kevin = $"Good Kevin"
@onready var evil_kevin = $"Evil Kevin"

@onready var bg_darken = $"Background Darkener/AnimationPlayer"

enum INPUTS {up, left, down, right}

## If this project CRASHES AND DOESN'T FUNCTION, rename the up, left, down, and right inputs to match
# the inputs they're named as in the actual project
var target_input_names = ["up", "left", "down", "right"]

var key_input_order = []
var key_nodes = []

# every rigid body ends up here for the earthquake
var all_shakeable_rigid_bodies = []

var time_left: int = 20 # weird digital display, in half seconds, of time left

var remaining_spawning_things = 100

var shake_amount = 800

var won = false

var take_inputs = true
var DEBUG_CAN_RESET = false

var all_embers = []
var is_scared = false

func _ready() -> void:
	bg_darken.stop(true)
	bg_darken.play("start")
	start_game(Global.global_difficulty)
	# start_game(ultra_hardcore_difficulty)

func start_game(new_difficulty: float):
	ultra_hardcore_difficulty = new_difficulty
	var number_of_keys = clampi(int((ultra_hardcore_difficulty * 2.5 + 2.6)), 5, 10)
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
	time_left = 1 + clamp(12 - 2 * ultra_hardcore_difficulty, 4, 10) * 2
	digital_timer_update_timer.start()
	_on_digital_timer_update_timer_timeout()
	all_shakeable_rigid_bodies.append(evil_kevin)
	all_shakeable_rigid_bodies.append(timer_digit_1)
	all_shakeable_rigid_bodies.append(timer_digit_2)
	all_shakeable_rigid_bodies.append(health_bar_1)
	all_shakeable_rigid_bodies.append(health_bar_2)
	for n in key_nodes:
		all_shakeable_rigid_bodies.append(n)

func _physics_process(_delta: float) -> void:
	if take_inputs:
		if Input.is_action_just_pressed(target_input_names[key_input_order[0]]):
			# succesful input!
			camera_anim.stop()
			camera_anim.play("tiny_shake")
			key_nodes[0].get_got()
			key_nodes.pop_front()
			good_kevin.set_frame(key_input_order.pop_front())
			if key_input_order.is_empty():
				# you win!
				you_win()
			else:
				key_nodes[0].raring_to_go()
		elif Input.is_action_just_pressed("kevins_keyboard"):
			# fail!
			you_lose()
	if is_scared:
		spawn_spectral_particle()
	## REMOVE ALL THIS FOR UMDware
	if true and Input.is_action_just_pressed("DEBUG_RESET"):
		if won:
			Global.global_difficulty += 0.5
		else:
			Global.global_difficulty = 1.0
		get_tree().reload_current_scene()


func _on_move_on_timer_timeout() -> void:
	DEBUG_CAN_RESET = true
	# emit_signal(move_on) or something

func you_win():
	take_inputs = false
	won = true
	good_kevin.get_got()
	# evil_kevin.get_got()
	bg_darken.get_parent().show()
	bg_darken.play("darken")
	# should only play once fatality finishes
	digital_timer_update_timer.stop()
	move_on_timer.start()

func you_lose():
	for k in key_nodes:
		k.you_lose()
	take_inputs = false
	good_kevin.you_lose()
	evil_kevin.you_lose()
	move_on_timer.start()
	digital_timer_update_timer.stop()


func _on_digital_timer_update_timer_timeout() -> void:
	if time_left > 0:
		time_left -= 1
	if time_left:
		if time_left >= 10:
			@warning_ignore("integer_division")
			timer_digit_1.new_frame(int(time_left/10))
		else:
			timer_digit_1.new_frame(0)
		timer_digit_2.new_frame(time_left%10)
	else:
		timer_digit_1.new_frame(10)
		timer_digit_2.new_frame(10)
		you_lose()

func spawn_ember(spawn_pos: Vector2):
	var new_ember = ember.instantiate()
	add_child(new_ember)
	new_ember.position = spawn_pos
	all_embers.append(new_ember)

func spawn_icicle():
	if remaining_spawning_things:
		var new_icicle = icicle.instantiate()
		add_child(new_icicle)
		new_icicle.position = Vector2(evil_kevin.position.x, evil_kevin.position.y - 300)
		remaining_spawning_things -= 1

func launch_embers():
	for emb in all_embers:
		emb.apply_impulse(Vector2(200, -50))

func spawn_bomb():
	var new_bomb = bomb.instantiate()
	add_child(new_bomb)
	new_bomb.position = Vector2(good_kevin.position.x + 100, good_kevin.position.y)
	for i in 30:
		var new_particle = tiny_particle.instantiate()
		add_child(new_particle)
		new_particle.ready_by_parent(2)
		new_particle.position = Vector2(good_kevin.position.x + 75, good_kevin.position.y - 40)

func spawn_spectral_particle():
	remaining_spawning_things -= 1
	if remaining_spawning_things > 0:
		var new_particle = tiny_particle.instantiate()
		add_child(new_particle)
		new_particle.ready_by_parent(3)
		new_particle.position = Vector2(good_kevin.position.x + 360, good_kevin.position.y - randi_range(50, 150))

func hurt_evil_kevin():
	evil_kevin.get_got()

func freeze_evil_kevin():
	evil_kevin.freeze()

func scare_evil_kevin():
	evil_kevin.get_scared()
	for b in all_shakeable_rigid_bodies:
		b.is_scared = true
	is_scared = true

func start_freeze_timer():
	spawn_icicle()
	fatality_timer.wait_time = 0.1
	fatality_timer.start()

func _on_fatality_timer_timeout() -> void:
	spawn_icicle()

func spawn_baby_ice(pos: Vector2):
	for i in 2:
		var new_particle = tiny_particle.instantiate()
		call_deferred("add_child", new_particle)
		new_particle.ready_by_parent(0)
		new_particle.position = Vector2(pos.x, pos.y + 18)

func shake_ground():
	for b in all_shakeable_rigid_bodies:
		b.apply_impulse(Vector2(randf_range(-200, 200), randf_range(-600, -1000)))
		b.collision_layer = 1
		b.collision_mask = 1
	for i in 30:
		var new_particle = tiny_particle.instantiate()
		add_child(new_particle)
		new_particle.ready_by_parent(1)
		new_particle.position = Vector2(randi_range(-200, 200), 141)
	hurt_evil_kevin()
	# shake_amount += shake_increment
