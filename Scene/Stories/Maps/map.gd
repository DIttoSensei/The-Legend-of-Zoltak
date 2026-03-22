extends Control
@onready var camera_2d: Camera2D = $Camera2D

var target_zoom : float = 1.0
var zoom_speed : float = 0.05
var min_zoom : float = 1.0
var max_zoom : float = 5.0

var base_size = Vector2(2046,2400)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ScrollContainer.set_deferred("scroll_vertical", 205)
	$ScrollContainer.set_deferred("scroll_horizontal", 485)


	
func _on_exit_pressed() -> void:
	self.visible = false
	queue_free()
	SignalManager.enable_camera.emit()
	pass # Replace with function body.


func _on_slider_value_changed(value: float) -> void:
	var camera_zoom_level = 1.0 * value
	var tween = create_tween()
	tween.tween_property(camera_2d, "zoom", Vector2(camera_zoom_level, camera_zoom_level), 0.1)
	pass # Replace with function body.
