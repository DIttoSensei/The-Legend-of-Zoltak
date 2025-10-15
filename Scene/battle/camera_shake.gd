extends Camera2D

var shake_strength = 0.0
var shake_decay = 1.0

# New variable to track the total requested duration for reference
var shake_duration = 0.0

func _ready() -> void:
	make_current()

func _process(delta):
	if shake_strength > 0:
		# 1. Apply a random offset within the current strength limits
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		
		# 2. Decay the strength over time
		# The 'max' keeps the strength from going negative
		shake_strength = max(shake_strength - shake_decay * delta, 0.0)
	else:
		# 3. Reset the offset when the shake is finished
		offset = Vector2.ZERO


# amount: Max pixels the camera moves (e.g., 8.0)
# duration: Time in seconds the shake should last (e.g., 0.15)
func shake(amount: float = 10.0, duration: float = 0.14):
	shake_strength = amount
	shake_duration = duration
	
	# Calculate the necessary decay rate to drop from 'amount' to 0
	# over the specified 'duration'. This ensures a predictable time limit.
	if duration > 0:
		shake_decay = amount / duration
	else:
		shake_decay = 0.0
