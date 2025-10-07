extends Node

var show : bool = false
var loading : bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().current_scene.scene_file_path == "res://Scene/scene_transition.tscn" or get_tree().current_scene.scene_file_path == "res://Scene/Stories/transition_to_main.tscn" or get_tree().current_scene.scene_file_path == "res://Scene/Stories/begin_chapter.tscn":
			return
		if loading == true:
			return
		if show == false:
			show_quit_confirm()
			show = true
		else:
			return
			
func _notification(what: int) -> void:
	match what:
		Node.NOTIFICATION_WM_GO_BACK_REQUEST:
			if get_tree().current_scene.scene_file_path == "res://Scene/scene_transition.tscn" \
			or get_tree().current_scene.scene_file_path == "res://Scene/Stories/transition_to_main.tscn" \
			or get_tree().current_scene.scene_file_path == "res://Scene/Stories/begin_chapter.tscn":
				return
			if loading == true:
				return
			if show == false:
				show_quit_confirm()
				show = true
			else:
				return


func show_quit_confirm () -> void:
	if get_node_or_null('confirm_quit') == null:
		var confirm_scene = preload("res://Scene/confirm_quit.tscn").instantiate()
		confirm_scene.name = "confirm_quit"
		get_tree().current_scene.add_child(confirm_scene)
	pass
