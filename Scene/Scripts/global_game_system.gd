extends Node2D

@onready var global_audio: AudioStreamPlayer = $"global Audio"
@onready var global_sfx: AudioStreamPlayer = $global_sfx

@export var transition_duration : float = 2.00

@onready var global_sfx_2: AudioStreamPlayer = $global_sfx2
@onready var global_sfx_3: AudioStreamPlayer = $global_sfx3

var transition_duration_in : float = 0.80

# Var decleration
var audio : Resource 
var save_name : String

# global var
var button_data_inv : Slot_data
var action_data_inv
var player_coin
var shop_item
var player_class
var battle_started : bool = false
var player_purchased_actions = []
var player_load_purchased = []
var game_map
var main_battle : bool = false
var map_battle_quest_won : bool = false
var make_current_audio_empty : bool = false
var reduce_bg_music_by_half : bool = false
var manual_data : ManualData
var current_main_game : String
var current_crpt_data : CryptBtnRes
var active_slot_index
var play_intro : bool = true

# for battle quest
var current_icon_data : IconData # For battle quest
var can_accept_victory : bool = false


# for shop
var item
var action
var is_player_inv_full : bool = false

# var for the story
var ashes_of_brinkwood : Dictionary = {}

# for battle
var current_player_actions : Array = []
var selected_inv : Array = []
var storage_inv : Array = []

var player_atk
var player_def
var player_dex
var player_con
var player_int
var player_wis
var player_hp
var results

var can_play_audio = true
var audio_setting_on : bool = true
var config = ConfigFile.new()
const SAVE_PATH = 'user://settings.cfg'

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var err = config.load(SAVE_PATH)
	load_story_data()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func play_bg_audio () -> void:
	if reduce_bg_music_by_half == true:
		global_audio.volume_db = -18
	else:
		global_audio.volume_db = 0
		
	check_bg_audio_volume()
	global_audio.play()
	pass
	
func check_bg_audio_volume () -> void:
	config.load(SAVE_PATH)
	
	var music = config.get_value("Settings", "music_enabled")
	if music == false:
		print(typeof(music))
		global_audio.volume_db = -90
		print('false')
		#can_play_audio = false
	elif music == true:
		print ('true')
		global_audio.volume_db = 0
		#can_play_audio = true


func play_sfx_audio (audio) -> void:
	global_sfx.stream = audio
	global_sfx.play()

func play_sfx2_audio (audio, volume : float = 0) -> void:
	global_sfx_2.stream = audio
	global_sfx.volume_db = volume
	global_sfx_2.play()
	
func play_sfx3_audio (audio, volume : float = 0) -> void:
	global_sfx_3.stream = audio
	global_sfx.volume_db = volume
	global_sfx_3.play()

# fade out the audio playing
func fade_out():
	if can_play_audio == false:
		return
	
	var tween_out = create_tween()
	tween_out.tween_property(global_audio, "volume_db", -80, transition_duration)
	tween_out.tween_callback(Callable(self, "_on_fade_out_complete"))
	return tween_out
	
func fade_in():
	if can_play_audio == false:
		return
	var tween_in = create_tween()
	global_audio.volume_db = -80
	global_audio.play()
	tween_in.tween_property(global_audio, "volume_db", 0, transition_duration_in)
	#tween_in.tween_callback(Callable(self, "_on_fade_in_complete"))
	
func _on_fade_out_complete ():
	global_audio.stop()
	global_audio.volume_db = 0
	
func _on_fade_in_complete ():
	global_audio.volume_db = 0

## FOR MAIN GAME (TEXT BASED AREA)
func fade_out_audio_main_game():
	if can_play_audio == false:
		return
	var tween_out = create_tween()
	tween_out.tween_property(global_audio, "volume_db", -80, transition_duration)
	tween_out.tween_callback(Callable(self, "_on_fade_out_main_game_audio_complete"))
	
func _on_fade_out_main_game_audio_complete ():
	global_audio.volume_db = 0


# global delay function
func delay (seconds : float) -> void:
	await  get_tree().create_timer(seconds).timeout


# loads the game story file in main scene
func load_story_data():
	var file = FileAccess.open("res://Scene/Stories/Ashes of Brinkwood/story_1.json", FileAccess.READ)
	if file:
		var chapters = file.get_as_text()
		ashes_of_brinkwood = JSON.parse_string(chapters)
		file.close()
		if ashes_of_brinkwood == null:
			print("Failed to parse JSON data.")
	else:
		print("Could not open the journey data file.")
		

func hit_stop (duration : float = 0.1, slowdown : float = 0.0) -> void:
	var original_scale = Engine.time_scale
	Engine.time_scale = slowdown
	await get_tree().create_timer(duration, true).timeout
	Engine.time_scale = original_scale
