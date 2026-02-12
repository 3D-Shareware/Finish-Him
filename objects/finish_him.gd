extends Sprite2D

func _ready():
	scale = Vector2(0.01, 0.01)

func play():
	show()
	$"AnimationPlayer".play("come_in")
	$"Start".play()

func you_lose():
	$"Lose".play()
