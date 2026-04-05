extends Button
class_name AchievementUi

var data : Achievements : set = set_slot_data

@onready var info: TextureRect = $info
@onready var label: Label = $Label
@onready var t_info : Label = $info/Label
@onready var timer: Timer = $Timer



func _ready() -> void:
	label.text = ""
	info.visible = false
	

func set_slot_data (value : Achievements) -> void:
	data = value
	if data == null :
		visible = false
		return
	label.text = data.title
	t_info.text = data.text
	if data.achieved == true:
		modulate = "ffffff"
	else:
		modulate = "7c7c7c"


func _on_timer_timeout() -> void:
	info.visible = true
	


func _on_button_down() -> void:
	timer.start()
	


func _on_button_up() -> void:
	timer.stop()
	info.visible = false
