extends Control

func _ready() -> void:
	var sound = load( "res://Asset/sound_effects/gentle-rainfall-16960.mp3" )
	var sound_2 = load ("res://Asset/ost/sound_effects/waterfall.mp3")
	GlobalGameSystem.play_sfx_audio(sound)
	GlobalGameSystem.play_sfx2_audio(sound_2)


func _on_back_pressed() -> void:
	$VideoStreamPlayer.paused = true
	var audio = load("res://Asset/sound_effects/click_1.wav")
	GlobalGameSystem.play_sfx_audio(audio)
	
	GlobalGameSystem.global_sfx.stop()
	GlobalGameSystem.global_sfx_2.stop()
	
	LevelManager.load_new_level = "res://Scene/options_scene.tscn"
	LevelManager.load_level()
