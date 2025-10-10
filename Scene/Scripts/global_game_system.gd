extends Node2D

@onready var global_audio: AudioStreamPlayer = $"global Audio"

@export var transition_duration : float = 2.00

# Var decleration
var audio : Resource 
var save_name : String

# global var
var button_data_inv
var action_data_inv
var player_coin
var shop_item
var player_class


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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_story_data()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func play_bg_audio () -> void:
	global_audio.play()
	pass


# fade out the audio playing
func fade_out():
	var tween_out = create_tween()
	tween_out.tween_property(global_audio, "volume_db", -80, transition_duration)
	tween_out.tween_callback(Callable(self, "_on_fade_out_complete"))
	
func _on_fade_out_complete ():
	global_audio.stop()
	global_audio.volume_db = 0


# global delay function
func delay (seconds : float) -> void:
	await  get_tree().create_timer(seconds).timeout


# loads the game story file in main scene
func load_story_data():
	var file = FileAccess.open("res://Scene/Stories/Ashes of Brinkwood/story.json", FileAccess.READ)
	if file:
		var chapters = file.get_as_text()
		ashes_of_brinkwood = JSON.parse_string(chapters)
		file.close()
		if ashes_of_brinkwood == null:
			print("Failed to parse JSON data.")
	else:
		print("Could not open the journey data file.")
