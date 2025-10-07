extends CanvasLayer

func _ready() -> void:
	$Control.mouse_filter = Control.MOUSE_FILTER_STOP
	
	show_notification()
	pass
	

func show_notification () -> void:
	#$Control/AnimationPlayer.play("show")
	
## Note make sure you check in main to always save before quiting or going home
	if get_tree().current_scene.scene_file_path == "res://Scene/Start Menu.tscn":
		$Control/AnimationPlayer.play("show_exit")
	else:
		$Control/AnimationPlayer.play("show")
		

func _on_exit_pressed() -> void:
	ConfirmQuit.show = false
	#$Control/AnimationPlayer.play("hide")
	#get_tree().create_timer(0.15).timeout
	$".".visible = false
	queue_free()


func _on_home_pressed() -> void:
	$Control/AnimationPlayer.play("hide")
	LevelManager.load_new_level = "res://Scene/Start Menu.tscn"
	LevelManager.load_level()
	GlobalGameSystem.fade_out()
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
