extends RigidBody2D

var colors = [
	Color(0, 255, 255),
	Color.from_hsv(0.1, 0.5, 0.5),
	Color.from_hsv(0.1, 1.0, 1.0),
	Color.from_hsv(0.33, 1.0, 1.0)
]

var is_scared = false

func ready_by_parent(type: int):
	modulate = colors[type]
	if type == 0:
		# ice particle!
		apply_impulse(Vector2(randf_range(-50, 50), -100))
	elif type == 1:
		# ground!
		apply_impulse(Vector2(randf_range(-200, 200), randf_range(-600, -1000)))
	elif type == 2:
		# fire!
		apply_impulse(Vector2(randf_range(-200, 200), randf_range(-200, 200)))
		modulate = Color.from_hsv(randf_range(0.0, 0.15), 1.0, 1.0)
	else:
		# spectral!
		is_scared = true

func _physics_process(_delta: float) -> void:
	if is_scared:
		apply_force(Vector2(-1000, -1000))
