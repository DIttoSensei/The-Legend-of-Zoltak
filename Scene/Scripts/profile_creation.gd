extends Node2D

@export_multiline var Name_age_error : String
@export_multiline var Stats_error : String
@export_multiline var Save_display : String

var stats := []
var last_total  := 0

var state_cumulation : int

@onready var animation_player: AnimationPlayer = $Control/CanvasLayer/Control/notice_board/AnimationPlayer
@onready var name_edit: LineEdit = $Control/Profile_data1/Name/LineEdit
@onready var age_edit: LineEdit = $Control/Profile_data1/Age/LineEdit
@onready var notice: Label = $Control/CanvasLayer/Control/notice_board/notice

@onready var race_button: OptionButton = $Control/Profile_data1/Race/OptionButton
@onready var class_button: OptionButton = $Control/Profile_data1/Class/OptionButton
@onready var pic: TextureRect = $Control/ImagePanel/Pic

@onready var atk: Label = $Control/Profile_data2/Atk/Atk_slider/counter
@onready var def: Label = $Control/Profile_data2/Def/Def_slider/counter
@onready var dex: Label = $Control/Profile_data2/Dex/Dex_slider/counter
@onready var con: Label = $Control/Profile_data2/Con/Con_slider/counter
@onready var Int: Label = $Control/Profile_data2/Int/Int_slider/counter
@onready var cha: Label = $Control/Profile_data2/Cha/Cha_slider/counter
@onready var wis: Label = $Control/Profile_data2/Wis/Wis_slider/counter




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#SceneTransition.fade_in()
	#display_notice()
	#notice.text = Stats_error
	
	
	stats = [$Control/Profile_data2/Atk/Atk_slider,
	 $Control/Profile_data2/Def/Def_slider, 
	$Control/Profile_data2/Dex/Dex_slider,
	 $Control/Profile_data2/Con/Con_slider,
	 $Control/Profile_data2/Int/Int_slider,
	 $Control/Profile_data2/Cha/Cha_slider,
	 $Control/Profile_data2/Wis/Wis_slider]
	
	# initilize
	last_total = get_stats_total()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	# perform states calculation each frame to update
	var current_total = get_stats_total()
	if current_total != last_total:
		last_total = current_total
		$Control/Profile_data2/Stats_total.text = str(current_total)
		state_cumulation = int($Control/Profile_data2/Stats_total.text)
	pass


func get_stats_total () -> int:
	var sum = 0
	for stat in stats:
		sum += stat.value
	return sum


func display_notice () -> void :
	$Control/CanvasLayer/Control.mouse_filter = Control.MOUSE_FILTER_STOP
	animation_player.play("show")

func saving_notice () -> void :
	$Control/CanvasLayer/Control.mouse_filter = Control.MOUSE_FILTER_STOP
	animation_player.play("show_saving")
	
func remove_notice () -> void:
	animation_player.play("hide")
	pass
	

func _on_exit_pressed() -> void:
	$Control/CanvasLayer/Control.mouse_filter = Control.MOUSE_FILTER_IGNORE
	remove_notice()
	pass # Replace with function body.


func _on_confirm_pressed() -> void:
	if name_edit.text.length() < 4 or age_edit.text.length() < 2:
		notice.text = Name_age_error
		display_notice()
	elif state_cumulation > 300 or state_cumulation < 300:
		notice.text = Stats_error
		display_notice()
	else:
		save_game()
		notice.text = Save_display
		saving_notice()
		
		await get_tree().create_timer(3).timeout
		remove_notice()
		
		LevelManager.load_new_level = "res://Scene/profile_selection.tscn"
		LevelManager.load_level()


func save_game () -> void :
	var player_data = {
		"Player" : {
			"Hp" : 100,
			"Name" : name_edit.text,
			"Age" : age_edit.text,
			"Race" : race_button.get_item_text(race_button.selected),
			"Class" : class_button.get_item_text(class_button.selected),
			"Apperance" : pic.texture.resource_path,
			"Atk" : int(atk.text),
			"Def" : int(def.text),
			"Dex" : int(def.text),
			"Con" : int(con.text),
			"Int" : int(Int.text),
			"Cha" : int(cha.text),
			"Wis" : int(wis.text),
			"Dialogue_Page" : "",
			"currency" : 900,
		},
		"Main_Inventory" : [],
		"Storage_Inventory" : [],
		"Action" : [],
		"Journal" : [],
		"Achievements" : [],
		
	}
	var json_string = JSON.stringify(player_data, "\t")
	var save = FileAccess.open("user://" + GlobalGameSystem.save_name, FileAccess.WRITE)
	save.store_string(json_string)
	save.close()


#func load_game () -> void:
	#var load = FileAccess.open("user://SAVE_1.txt", FileAccess.READ)
	#if load:
		## if the load data file exist
		#pass
	

## Back button pressed
func _on_texture_button_pressed() -> void:
	LevelManager.load_new_level = "res://Scene/profile_selection.tscn"
	LevelManager.load_level()
