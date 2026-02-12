extends RigidBody2D

@onready var anim = $"AnimationPlayer"
@onready var audio = $"AudioStreamPlayer2D"

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
	audio.stream = load("res://audio/minor_injury.wav")
	audio.volume_db = -1
	audio.play()

func freeze():
	anim.stop(true)
	anim.play("hurt_freeze")
	audio.stream = load("res://audio/sub_zero.wav")
	audio.volume_db = -5
	audio.play()

func get_scared():
	anim.stop(true)
	anim.play("hurt_scared")
	is_scared = true
	audio.stream = load("res://audio/ahhhhh.wav")
	audio.volume_db = -5
	audio.play()

func you_lose():
	anim.stop(true)
	anim.play("laugh")
