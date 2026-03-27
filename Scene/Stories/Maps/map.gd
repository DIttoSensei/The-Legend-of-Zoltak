extends Control
@onready var camera_2d: Camera2D = $Camera2D

var target_zoom : float = 1.0
var zoom_speed : float = 0.05
var min_zoom : float = 1.0
var max_zoom : float = 5.0

var base_size = Vector2(2046,2400)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalGameSystem.global_audio.volume_db = -18
	var sound = load ("res://Asset/ost/sound_effects/cold_wind.mp3")
	GlobalGameSystem.play_sfx2_audio(sound, 10.0)
	#SceneTransition.fade_in()
	$ScrollContainer.set_deferred("scroll_vertical", 205)
	$ScrollContainer.set_deferred("scroll_horizontal", 485)


	
func _on_exit_pressed() -> void:
	GlobalGameSystem.global_audio.volume_db = 0
	GlobalGameSystem.reduce_bg_music_by_half = false
	GlobalGameSystem.global_sfx_2.stop()
	var sound = load ("res://Asset/sound_effects/click_4_p.wav")
	GlobalGameSystem.play_sfx_audio(sound)
	self.visible = false
	SignalManager.enable_camera.emit()
	queue_free()
	pass # Replace with function body.


func _on_slider_value_changed(value: float) -> void:
	var camera_zoom_level = 1.0 * value
	var tween = create_tween()
	tween.tween_property(camera_2d, "zoom", Vector2(camera_zoom_level, camera_zoom_level), 0.1)
	pass # Replace with function body.
