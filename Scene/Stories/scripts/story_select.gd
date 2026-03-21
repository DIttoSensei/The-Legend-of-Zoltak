extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Control/story_1/play button".disabled = false
	$option_scene.disabled = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	var audio = load("res://Asset/sound_effects/click_1.wav")
	GlobalGameSystem.play_sfx_audio(audio)
	LevelManager.load_new_level = "res://Scene/Start Menu.tscn"
	LevelManager.load_level()
			#
	## wait time before killing the node
	await get_tree().create_timer(2).timeout
	queue_free()
	pass # Replace with function body


func _on_play_button_pressed() -> void:
	var audio = load("res://Asset/sound_effects/click_1.wav")
	GlobalGameSystem.play_sfx_audio(audio)
	$"Control/story_1/play button".disabled = true
	LevelManager.load_new_level = "res://Scene/Stories/begin_chapter.tscn"
	LevelManager.load_level()
	GlobalGameSystem.fade_out()
	GlobalGameSystem.game_map = $"Control/story_1/play button".get_meta("Map")
	


func _on_gear_icon_no_bg_pressed() -> void:
	var audio = load("res://Asset/sound_effects/click_1.wav")
	GlobalGameSystem.play_sfx_audio(audio)
	$option_scene.disabled = true
	LevelManager.load_new_level = "res://Scene/options_scene.tscn"
	LevelManager.load_level()
	
	
