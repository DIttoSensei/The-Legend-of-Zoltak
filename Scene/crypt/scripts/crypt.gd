extends Control


func _ready() -> void:
	var sound = load ("res://Asset/ost/sound_effects/waterfall.mp3")
	var sound_2 = load("res://Asset/sound_effects/tanweraman-night-ambience-with-cricket-sound-271304.mp3")
	GlobalGameSystem.play_sfx_audio(sound)
	GlobalGameSystem.play_sfx2_audio(sound_2, -1)
	
	SceneTransition.fade_in()


func _on_back_button_pressed() -> void:
	var audio = load("res://Asset/sound_effects/click_1.wav")
	GlobalGameSystem.play_sfx3_audio(audio)
		
	$VideoStreamPlayer.paused = true
		
	GlobalGameSystem.global_sfx.stop()
	GlobalGameSystem.global_sfx_2.stop()
		
	LevelManager.load_new_level = "res://Scene/options_scene.tscn"
	LevelManager.load_level()
	pass # Replace with function body.
