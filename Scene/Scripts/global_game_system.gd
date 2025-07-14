extends Node2D

@onready var global_audio: AudioStreamPlayer = $"global Audio"

var audio : Resource 
var save_name : String

@export var transition_duration : float = 2.00


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func play_bg_audio () -> void:
	global_audio.play()
	pass

func fade_out():
	var tween_out = create_tween()
	tween_out.tween_property(global_audio, "volume_db", -80, transition_duration)
	tween_out.tween_callback(Callable(self, "_on_fade_out_complete"))
	
func _on_fade_out_complete ():
	global_audio.stop()
	global_audio.volume_db = 0
	
func delay (seconds : float) -> void:
	await  get_tree().create_timer(seconds).timeout
	
	
