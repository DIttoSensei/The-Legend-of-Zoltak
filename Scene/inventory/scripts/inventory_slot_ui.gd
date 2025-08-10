extends Button
class_name InventorySlotUi

var slot_data : Slot_data : set = set_slot_data

@onready var texture_rect: TextureRect = $TextureRect


func _ready() -> void:
	texture_rect.texture = null
	

func set_slot_data (value : Slot_data) -> void:
	slot_data = value
	if slot_data ==null or slot_data.item_data == null :
		texture_rect.texture = null
		return
	texture_rect.texture = slot_data.item_data.texture



# when button is pressed
func _on_pressed() -> void:
	GlobalGameSystem.button_data_inv = slot_data
	SignalManager.show_item_info_board.emit()
	pass # Replace with function body.
