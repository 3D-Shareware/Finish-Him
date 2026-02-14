extends RigidBody2D

@onready var anim = $"AnimationPlayer"

@onready var audio = $"AudioStreamPlayer"

@onready var sprite = $"Sprite2D"

var game: Node2D

var is_burning = false # when true, constantly spawns ember

var is_scaring = false # when true, constantly runs forward

func _ready():
	sprite.frame = 0
	apply_impulse(Vector2(0, 500))
	if get_parent() != null:
		game = get_parent()

func get_got():
	anim.stop(true)
	if sprite.frame == 1:
		# fatality for up
		anim.play("ice_to_meet_you")
	elif sprite.frame == 2:
		# fatality for left
		anim.play("get_over_here")
	elif sprite.frame == 3:
		# fatality for down
		anim.play("temper_tantrum")
	else:
		# fatality for right
		anim.play("fourth_degree_burn")
	pass # play different animation depending on fatality

func you_lose():
	anim.stop(true)
	anim.play("trip")
	apply_impulse(Vector2(250, 0))

func set_frame(key: int):
	sprite.frame = key + 1

func _physics_process(_delta: float) -> void:
	if is_burning and game != null:
		game.spawn_ember(Vector2(position.x + 75, position.y - 40))
	if is_scaring:
		apply_impulse(Vector2(50, -20))

func set_burning(burning: bool):
	audio.volume_db = -5.0
	audio.stream = load("res://audio/charge.wav")
	audio.pitch_scale = 1.0
	audio.play()
	is_burning = burning
	if !is_burning and game != null:
		game.launch_embers()
		bomb_it()
	else:
		game.shake_it()

func bomb_it():
	audio.volume_db = -10.0
	audio.stream = load("res://audio/KABOOM.wav")
	audio.pitch_scale = 0.5
	audio.play()
	if game != null:
		game.spawn_bomb()

func freeze_it():
	audio.volume_db = -12.0
	audio.stream = load("res://audio/icicle.wav")
	audio.pitch_scale = 1.0
	if game != null:
		game.start_freeze_timer()

func play_icicle_sound():
	audio.pitch_scale = randf_range(0.5, 1.3)
	audio.play()

func hurt_evil_kevin():
	if game != null:
		game.hurt_evil_kevin()

func freeze_evil_kevin():
	if game != null:
		game.freeze_evil_kevin()
	anim.stop()
	anim.play("ice_to_meet_you_loop")

func earthquake():
	audio.volume_db = 1.0
	audio.stream = load("res://audio/tremble.wav")
	audio.pitch_scale = 0.5
	audio.play()
	if game != null:
		game.shake_ground()

func scare_evil_kevin():
	# is_scaring = true
	audio.volume_db = 5.0
	audio.stream = load("res://audio/inhale.wav")
	audio.pitch_scale = 1.0
	audio.play()
	if game != null:
		game.scare_evil_kevin()
	anim.stop()
	anim.play("get_over_here_loop")

func start_shaking():
	audio.volume_db = -10.0
	audio.stream = load("res://audio/rumble.wav")
	audio.pitch_scale = 2.0
	audio.play()
	if game != null:
		game.start_shaking()

func pause_shaking():
	if game != null:
		game.pause_shaking()
