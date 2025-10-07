class_name Start_Menu extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_player_2: AnimationPlayer = $AnimationPlayer2


const next_scene = preload("res://Scene/into.tscn")


var input_locked := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_locked = true
	SceneTransition.fade_in()
	animation_player_2.play("text_animation")
	GlobalGameSystem.global_audio.stream = preload("res://Asset/ost/Autumn_Walk.mp3")
	
	await get_tree().create_timer(2).timeout
	GlobalGameSystem.play_bg_audio()
	input_locked = false
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if input_locked:
		return
	if ConfirmQuit.show == true:
		return
	if event is InputEventScreenTouch:
		if event.is_pressed():
			# hamdle touch input
			input_locked = true
			LevelManager.load_new_level = "res://Scene/into.tscn"
			LevelManager.load_level()
			
