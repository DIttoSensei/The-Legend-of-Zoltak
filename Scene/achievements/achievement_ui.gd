extends Control
class_name AchievementUi

var data : Achievements : set = set_slot_data

@onready var label: Label = $Label



func _ready() -> void:
	label.text = ""
	

func set_slot_data (value : Achievements) -> void:
	data = value
	if data == null :
		visible = false
		return
	label.text = data.text
	if data.achieved == true:
		modulate = "ffffff"
	else:
		modulate = "7c7c7c"
