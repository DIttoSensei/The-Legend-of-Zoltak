extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneTransition.fade_in()
	animation_player.play('first')
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'first':
		LevelManager.load_new_level = "res://Scene/Start Menu.tscn"
		LevelManager.load_level()
