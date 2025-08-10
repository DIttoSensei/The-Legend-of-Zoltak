extends CanvasLayer

@onready var label: Label = $TextureRect/Label



func _on_exit_pressed() -> void:
	visible = false
	pass # Replace with function body.
	
func show_notification () -> void:
	visible = true
	
func chnage_notification_message (message : String) -> void:
	label.text = message
	show_notification()
