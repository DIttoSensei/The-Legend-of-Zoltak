extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_texture_button_pressed() -> void:
	LevelManager.load_new_level = "res://Scene/Start Menu.tscn"
	LevelManager.load_level()
			#
	## wait time before killing the node
	await get_tree().create_timer(2).timeout
	queue_free()
	pass # Replace with function body


func _on_play_button_pressed() -> void:
	LevelManager.load_new_level = "res://Scene/Stories/begin_chapter.tscn"
	LevelManager.load_level()
	GlobalGameSystem.fade_out()
