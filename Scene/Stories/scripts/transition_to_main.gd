extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer

func _ready() -> void:
	animation_player.play("loading")
	




func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "loading":
		LevelManager.load_new_level = "res://Scene/Stories/Ashes of Brinkwood/main.tscn"
		LevelManager.load_level_single_transition()
	
	pass # Replace with function body.
