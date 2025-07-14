extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("text_fade")
	
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "text_fade":
		LevelManager.load_new_level = "res://Scene/profile_selection.tscn"
		LevelManager.load_level_single_transition()
