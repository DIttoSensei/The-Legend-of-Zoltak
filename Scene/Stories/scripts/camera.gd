extends Camera2D

var shake_strength = 0.0
var shake_decay = 1.0

func _process(delta):
	if shake_strength > 0:
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		shake_strength = max(shake_strength - shake_decay * delta, 0)
	else:
		offset = Vector2.ZERO

func shake(amount = 5.0, decay = 5.0):
	shake_strength = amount
	shake_decay = decay
