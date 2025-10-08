extends Button
class_name ActionSlotUi

var action_data : Actions : set = set_slot_data

@onready var texture_rect: TextureRect = $TextureRect
@onready var action_name: Label = $TextureRect/name


func _ready() -> void:
	action_name.text = ""
	

func set_slot_data (value : Actions) -> void:
	action_data = value
	if action_data == null :
		return
	action_name.text = action_data.action_data.action_name





func _on_pressed() -> void:
	GlobalGameSystem.action_data_inv = action_data
	$"../../../img".visible = false
	SignalManager.show_action_info.emit()
	SignalManager.player_attack.emit(action_data)
	pass # Replace with function body.
