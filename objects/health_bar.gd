extends RigidBody2D

@export var evil = false

@onready var health_bar = $"TextureProgressBar"
@onready var kevin = $"Kevin"
@onready var evil_kevin = $"Evil Kevin"

var is_scared = false

func _ready() -> void:
	if evil:
		health_bar.value = 0
		evil_kevin.show()
	else:
		health_bar.value = randi_range(10, 90)
		kevin.show()

func _physics_process(delta: float) -> void:
	if is_scared:
		apply_force(Vector2(-1000, -100))
