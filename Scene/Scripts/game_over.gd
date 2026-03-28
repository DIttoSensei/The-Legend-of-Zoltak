extends Control

@onready var video_stream: VideoStreamPlayer = $VideoStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneTransition.fade_in()
	$AnimationPlayer.play("display")
	GlobalGameSystem.global_audio.stream = preload("res://Asset/ost/Crown and Steel - Medieval Free Song(2).mp3")
	
	await get_tree().create_timer(1.5).timeout
	GlobalGameSystem.play_bg_audio()
	pass # Replace with function body.


func _on_continue_pressed() -> void:
	video_stream.paused = true
	var audio = load("res://Asset/sound_effects/click_1.wav")
	GlobalGameSystem.play_sfx_audio(audio)
	
	GlobalGameSystem.fade_out()
	LevelManager.load_new_level = GlobalGameSystem.current_main_game
	LevelManager.load_level()
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	video_stream.paused = true
	var audio = load("res://Asset/sound_effects/click_1.wav")
	GlobalGameSystem.play_sfx_audio(audio)
	
	GlobalGameSystem.fade_out()
	LevelManager.load_new_level = "res://Scene/Start Menu.tscn"
	LevelManager.load_level()
	
