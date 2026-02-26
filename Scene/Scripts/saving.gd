class_name SavingIcon extends CanvasLayer


@onready var animation_player: AnimationPlayer = $TextureRect/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func play_saving_logic () -> void:
	animation_player.play('start')
