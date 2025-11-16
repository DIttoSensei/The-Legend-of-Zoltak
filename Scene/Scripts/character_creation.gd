extends Node2D

# Labels for the "Empty" 3 profile 
@onready var label_1: Label = $Control/PanelContainer/Label
@onready var label_2: Label = $Control/PanelContainer2/Label
@onready var label_3: Label = $Control/PanelContainer3/Label

# second profile
@onready var create_2: TextureButton = $Control/PanelContainer2/create_2
@onready var load_2: TextureButton = $Control/PanelContainer2/load
@onready var delete_2: TextureButton = $Control/PanelContainer2/delete_1
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

# third profile
@onready var create_3: TextureButton = $Control/PanelContainer3/create_3
@onready var load_3: TextureButton = $Control/PanelContainer3/load
@onready var delete_3: TextureButton = $Control/PanelContainer3/delete_2
@onready var data_3: Label = $Control/PanelContainer3/data
@onready var info_data_3: Label = $Control/PanelContainer3/data/info_data
@onready var info_3: Label = $Control/PanelContainer3/data/stats/info
@onready var info_2_3: Label = $Control/PanelContainer3/data/stats2/info2

## Buttons load
@onready var load1: TextureButton = $Control/PanelContainer/load
@onready var load2: TextureButton = $Control/PanelContainer2/load
@onready var load3: TextureButton = $Control/PanelContainer3/load



var current_save : String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#SceneTransition.fade_in()
	load1.disabled = false
	load2.disabled = false
	load3.disabled = false
	create.disabled = false
	create_2.disabled = false
	create_3.disabled = false
	
	check_for_save_profile()
	if GlobalGameSystem.global_audio.stream == preload("res://Asset/ost/Medieval song-Dance of the nymphs.mp3"):
		pass
	else:
		GlobalGameSystem.global_audio.stream = preload("res://Asset/ost/Medieval song-Dance of the nymphs.mp3")
		GlobalGameSystem.delay(2)
		GlobalGameSystem.play_bg_audio()
		
		## if the confirm quit notice is shown hide this one
	#if ConfirmQuit.show == true:
		#$Control/CanvasLayer/Control/notice_board/AnimationPlayer.play("hide")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


## Function to check for profiles and update status
func check_for_save_profile () -> void:
	var save_1 = FileAccess.open("user://SAVE_1.txt", FileAccess.READ)
	var save_2 = FileAccess.open("user://SAVE_2.txt", FileAccess.READ)
	var save_3 = FileAccess.open("user://SAVE_3.txt", FileAccess.READ)
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
	
	if save_2:
		label_2.visible = false
		data_2.visible = true
		create_2.visible = false
		load_2.visible = true
		delete_2.visible = true
		
		# values from the save file
		var player_data = JSON.parse_string(save_2.get_as_text())["Player"]
		save_2.close()
		
		# create the value to the labels
		var text = player_data["Name"] + "\n" + player_data["Age"] + "\n" + player_data["Race"] + "\n" + player_data["Class"]
		var text_1 = str(player_data["Atk"]) + "\n" + str(player_data["Def"]) + "\n" + str(player_data["Dex"]) + "\n" + str(player_data["Con"])
		var text_2 = str(player_data["Int"]) + "\n" + str(player_data["Cha"]) + "\n" + str(player_data["Wis"])
		
		# Assign the value to the labels
		info_data_2.text = text
		info_2.text = text_1
		info_2_2.text = text_2
	else:
		label_2.visible = true
		data_2.visible = false
		create_2.visible = true
		load_2.visible = false
		delete_2.visible = false
		
	if save_3:
		label_3.visible = false
		data_3.visible = true
		create_3.visible = false
		load_3.visible = true
		delete_3.visible = true
		
		# values from the save file
		var player_data = JSON.parse_string(save_3.get_as_text())["Player"]
		save_3.close()
		
		# create the value to the labels
		var text = player_data["Name"] + "\n" + player_data["Age"] + "\n" + player_data["Race"] + "\n" + player_data["Class"]
		var text_1 = str(player_data["Atk"]) + "\n" + str(player_data["Def"]) + "\n" + str(player_data["Dex"]) + "\n" + str(player_data["Con"])
		var text_2 = str(player_data["Int"]) + "\n" + str(player_data["Cha"]) + "\n" + str(player_data["Wis"])
		
		# Assign the value to the labels
		info_data_3.text = text
		info_3.text = text_1
		info_2_3.text = text_2
	else:
		label_3.visible = true
		data_3.visible = false
		create_3.visible = true
		load_3.visible = false
		delete_3.visible = false

# Function to display notice
func delete_file_notice () -> void:
	# show notice to delete
	$Control/CanvasLayer/Control.mouse_filter = Control.MOUSE_FILTER_STOP
	$Control/CanvasLayer/Control/notice_board/AnimationPlayer.play("show")
	

# function to delete save file
func delete_save_file () -> void:
	$Control/CanvasLayer/Control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Control/CanvasLayer/Control/notice_board/AnimationPlayer.play("hide")
	
	if FileAccess.file_exists("user://" + current_save):
		DirAccess.remove_absolute("user://" + current_save)
		LevelManager.load_new_level = "res://Scene/profile_selection.tscn"
		LevelManager.load_level()
	

## Back button
func _on_texture_button_pressed() -> void:
	LevelManager.load_new_level = "res://Scene/Start Menu.tscn"
	LevelManager.load_level()
	
	# fade out the current audio
	GlobalGameSystem.fade_out()


## Create Button to create save files for each profile
func _on_create_pressed() -> void:
	create.disabled = true
	GlobalGameSystem.save_name = "SAVE_1.txt"
	LevelManager.load_new_level = "res://Scene/Profile_creation.tscn"
	LevelManager.load_level()

func _on_create_2_pressed() -> void:
	create_2.disabled = true
	GlobalGameSystem.save_name = "SAVE_2.txt"
	LevelManager.load_new_level = "res://Scene/Profile_creation.tscn"
	LevelManager.load_level()

func _on_create_3_pressed() -> void:
	create_3.disabled = true
	GlobalGameSystem.save_name = "SAVE_3.txt"
	LevelManager.load_new_level = "res://Scene/Profile_creation.tscn"
	LevelManager.load_level()
	

	
	
## For delete profile
func _on_delete_pressed() -> void:
	current_save = "SAVE_1.txt"
	delete_file_notice()

func _on_delete_1_pressed() -> void:
	current_save = "SAVE_2.txt"
	delete_file_notice()

func _on_delete_2_pressed() -> void:
	current_save = "SAVE_3.txt"
	delete_file_notice()
	
func _on_yes_pressed() -> void:
	delete_save_file()
	


## For canceling delete profile
func _on_exit_pressed() -> void:
	$Control/CanvasLayer/Control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Control/CanvasLayer/Control/notice_board/AnimationPlayer.play("hide")


func _on_load_pressed() -> void:
	load1.disabled = true
	GlobalGameSystem.save_name = "SAVE_1.txt"
	LevelManager.load_new_level = "res://Scene/Stories/transition_to_main.tscn"
	LevelManager.load_level()
	GlobalGameSystem.fade_out()
	pass # Replace with function body.


func _on_load2_pressed() -> void:
	load2.disabled = true
	GlobalGameSystem.save_name = "SAVE_2.txt"
	LevelManager.load_new_level = "res://Scene/Stories/transition_to_main.tscn"
	LevelManager.load_level()
	GlobalGameSystem.fade_out()
	pass # Replace with function body.


func _on_load3_pressed() -> void:
	load3.disabled = true
	GlobalGameSystem.save_name = "SAVE_3.txt"
	LevelManager.load_new_level = "res://Scene/Stories/transition_to_main.tscn"
	LevelManager.load_level()
	GlobalGameSystem.fade_out()
	pass # Replace with function body.
