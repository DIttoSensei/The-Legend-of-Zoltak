extends Node

@onready var music_label: Label = $music/Label
@onready var sfx_label: Label = $sfx/Label


var config = ConfigFile.new()
const SAVE_PATH = 'user://settings.cfg'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneTransition.fade_in()
	if !GlobalGameSystem.global_audio.playing:
		GlobalGameSystem.global_audio.stream = preload("res://Asset/ost/Autumn_Walk.mp3")
		await get_tree().create_timer(2).timeout
		GlobalGameSystem.play_bg_audio()
	
	var err = config.load(SAVE_PATH)
	load_config()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func load_config () -> void:
	var music = config.get_value("Settings", "music_enabled")
	var sfx = config.get_value("Settings", "sfx_enabled")
	
	if music == false:
		music_label.text = "OFF"
	else:
		music_label.text = "ON"
	
	if sfx == false:
		sfx_label.text = "OFF"
	else:
		sfx_label.text = 'ON'


func _on_back_button_pressed() -> void:
	var audio = load("res://Asset/sound_effects/click_1.wav")
	GlobalGameSystem.play_sfx_audio(audio)
	LevelManager.load_new_level = "res://Scene/Stories/story_select.tscn"
	LevelManager.load_level()
	
	
	pass # Replace with function body

func manage_audio_reset () -> void:
	## For global audio
	var music = config.get_value("Settings", "music_enabled")
	
	if music == false:
		music_label.text = 'ON'
		GlobalGameSystem.global_audio.volume_db = 0
		GlobalGameSystem.can_play_audio = true
		config.set_value("Settings", "music_enabled", true)
		config.save("user://settings.cfg")
		
	## For sfx
	var sfx = config.get_value("Settings", 'sfx_enabled')
	
	if sfx == false:
		sfx_label.text = 'ON'
		GlobalGameSystem.global_sfx.volume_db = 0
		GlobalGameSystem.global_sfx_2.volume_db = 0
		GlobalGameSystem.global_sfx_3.volume_db = 0
		config.set_value('Settings', 'sfx_enabled', true)
		config.save("user://settings.cfg")
	

func _on_crypt_pressed() -> void:
	var audio = load("res://Asset/sound_effects/click_1.wav")
	GlobalGameSystem.play_sfx_audio(audio)
	LevelManager.load_new_level = "res://Scene/crypt/crypt.tscn"
	GlobalGameSystem.fade_out()
	LevelManager.load_level()
	


func _on_music_pressed() -> void:
	var audio = load("res://Asset/sound_effects/click_1.wav")
	GlobalGameSystem.play_sfx_audio(audio)
	
	var music = config.get_value("Settings", "music_enabled")
	if music == true:
		music_label.text = 'OFF'
		GlobalGameSystem.global_audio.volume_db = -90
		GlobalGameSystem.can_play_audio = false
		config.set_value("Settings", "music_enabled", false)
		config.save("user://settings.cfg")
	elif music == false:
		music_label.text = 'ON'
		GlobalGameSystem.global_audio.volume_db = 0
		GlobalGameSystem.can_play_audio = true
		config.set_value("Settings", "music_enabled", true)
		config.save("user://settings.cfg")
	


func _on_sfx_pressed() -> void:
	var audio = load("res://Asset/sound_effects/click_1.wav")
	GlobalGameSystem.play_sfx_audio(audio)
	
	var sfx = config.get_value("Settings", 'sfx_enabled')
	if sfx == true:
		sfx_label.text = 'OFF'
		GlobalGameSystem.global_sfx.volume_db = -90
		GlobalGameSystem.global_sfx_2.volume_db = -90
		GlobalGameSystem.global_sfx_3.volume_db = -90
		config.set_value('Settings', 'sfx_enabled', false)
		config.save("user://settings.cfg")
	elif sfx == false:
		sfx_label.text = 'ON'
		GlobalGameSystem.global_sfx.volume_db = 0
		GlobalGameSystem.global_sfx_2.volume_db = 0
		GlobalGameSystem.global_sfx_3.volume_db = 0
		config.set_value('Settings', 'sfx_enabled', true)
		config.save("user://settings.cfg")
	

func _on_reset_pressed() -> void:
	var audio = load("res://Asset/sound_effects/click_1.wav")
	GlobalGameSystem.play_sfx_audio(audio)
	
	## for sfx
	var sfx = config.get_value("Settings", 'sfx_enabled')
	var music = config.get_value("Settings", "music_enabled")
	sfx = false
	music = false
	manage_audio_reset()
	

func _on_credits_pressed() -> void:
	var audio = load("res://Asset/sound_effects/click_1.wav")
	GlobalGameSystem.play_sfx_audio(audio)
	LevelManager.load_new_level = "res://Scene/credits.tscn"
	GlobalGameSystem.fade_out()
	LevelManager.load_level()

	
### SOCIALS ZONE
func _on_twitter_pressed() -> void:
	var audio = load("res://Asset/sound_effects/click_1.wav")
	GlobalGameSystem.play_sfx_audio(audio)
	OS.shell_open("https://x.com/TheLegendsOfZol") #Open desireed link


func _on_discord_pressed() -> void:
	var audio = load("res://Asset/sound_effects/click_1.wav")
	GlobalGameSystem.play_sfx_audio(audio)
	OS.shell_open("https://discord.gg/NFt4nvq4Np") #Open desireed link


func _on_itch_io_pressed() -> void:
	var audio = load("res://Asset/sound_effects/click_1.wav")
	GlobalGameSystem.play_sfx_audio(audio)


func _on_manual_pressed() -> void:
	var audio = load("res://Asset/sound_effects/click_1.wav")
	GlobalGameSystem.play_sfx_audio(audio)
	LevelManager.load_new_level = "res://Scene/game_manual/manual.tscn"
	LevelManager.load_level()
	pass # Replace with function body.
