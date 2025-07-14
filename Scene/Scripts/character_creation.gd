extends Node2D

# Labels for the "Empty" 3 profile 
@onready var label_1: Label = $Control/PanelContainer/Label
@onready var label_2: Label = $Control/PanelContainer2/Label
@onready var label_3: Label = $Control/PanelContainer3/Label

# second profile
@onready var create_2: TextureButton = $Control/PanelContainer2/create
@onready var load_2: TextureButton = $Control/PanelContainer2/load
@onready var delete_2: TextureButton = $Control/PanelContainer2/delete
@onready var data_2: Label = $Control/PanelContainer2/data
@onready var info_data_2: Label = $Control/PanelContainer2/data/info_data
@onready var info_2: Label = $Control/PanelContainer2/data/stats/info
@onready var info_2_2: Label = $Control/PanelContainer2/data/stats2/info2


# first profile
@onready var create: TextureButton = $Control/PanelContainer/create
@onready var load: TextureButton = $Control/PanelContainer/load
@onready var delete: TextureButton = $Control/PanelContainer/delete
@onready var data: Label = $Control/PanelContainer/data
@onready var info_data: Label = $Control/PanelContainer/data/info_data
@onready var info: Label = $Control/PanelContainer/data/stats/info
@onready var info_2_1: Label = $Control/PanelContainer/data/stats2/info2



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#SceneTransition.fade_in()
	check_for_save_profile()
	if GlobalGameSystem.global_audio.stream == preload("res://Asset/ost/Medieval song-Dance of the nymphs.mp3"):
		pass
	else:
		GlobalGameSystem.global_audio.stream = preload("res://Asset/ost/Medieval song-Dance of the nymphs.mp3")
		GlobalGameSystem.delay(2)
		GlobalGameSystem.play_bg_audio()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


## Function to check for profiles and update status
func check_for_save_profile () -> void:
	var save_1 = FileAccess.open("user://SAVE_1.txt", FileAccess.READ)
	if save_1:
		label_1.visible = false
		data.visible = true
		create.visible = false
		load.visible = true
		delete.visible = true
		
		# values from the save file
		var player_data = JSON.parse_string(save_1.get_as_text())["Player"]
		save_1.close()
		
		# create the value to the labels
		var text = player_data["Name"] + "\n" + player_data["Age"] + "\n" + player_data["Race"] + "\n" + player_data["Class"]
		var text_1 = str(player_data["Atk"]) + "\n" + str(player_data["Def"]) + "\n" + str(player_data["Dex"]) + "\n" + str(player_data["Con"])
		var text_2 = str(player_data["Int"]) + "\n" + str(player_data["Cha"]) + "\n" + str(player_data["Wis"])
		
		# Assign the value to the labels
		info_data.text = text
		info.text = text_1
		info_2_1.text = text_2
	else:
		label_1.visible = true
		data.visible = false
		create.visible = true
		load.visible = false
		delete.visible = false
		

# Function to display notice
func delete_file_notice () -> void:
	# show notice to delete
	$Control/CanvasLayer/Control.mouse_filter = Control.MOUSE_FILTER_STOP
	$Control/CanvasLayer/Control/notice_board/AnimationPlayer.play("show")
	

## Back button
func _on_texture_button_pressed() -> void:
	LevelManager.load_new_level = "res://Scene/Start Menu.tscn"
	LevelManager.load_level()
	
	# fade out the current audio
	GlobalGameSystem.fade_out()


## Create Button to create save files for each profile
func _on_create_pressed() -> void:
	GlobalGameSystem.save_name = "SAVE_1.txt"
	LevelManager.load_new_level = "res://Scene/Profile_creation.tscn"
	LevelManager.load_level()

	
	


## For delete profile
func _on_delete_pressed() -> void:
	delete_file_notice()
	
func _on_yes_pressed() -> void:
	$Control/CanvasLayer/Control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Control/CanvasLayer/Control/notice_board/AnimationPlayer.play("hide")
	DirAccess.remove_absolute("user://SAVE_1.txt")
	LevelManager.load_new_level = "res://Scene/profile_selection.tscn"
	LevelManager.load_level()

## For canceling delete profile
func _on_exit_pressed() -> void:
	$Control/CanvasLayer/Control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Control/CanvasLayer/Control/notice_board/AnimationPlayer.play("hide")
	pass # Replace with function body.
