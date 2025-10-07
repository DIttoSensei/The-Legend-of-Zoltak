extends Node

var load_new_level : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func load_level () -> void :
	ConfirmQuit.loading = true #make sure the confirm quit notification dose not interuot any thing
	SceneTransition.fade_out()
	await  get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file(load_new_level)
	SceneTransition.fade_in()
	ConfirmQuit.loading = false
	ConfirmQuit.show = false
	pass

func load_level_single_transition () -> void :
	SceneTransition.fade_in()
	get_tree().change_scene_to_file(load_new_level)
	
