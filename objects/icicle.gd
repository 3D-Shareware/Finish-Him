extends RigidBody2D

var spawned_object = false

func _ready():
	apply_impulse(Vector2(0, 1000))


func _on_area_2d_area_entered(area: Area2D) -> void:
	if !spawned_object:
		get_parent().spawn_baby_ice(position)
		spawned_object = true
