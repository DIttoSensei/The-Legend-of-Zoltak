extends Button
class_name InventorySlotUi

var slot_data : Slot_data : set = set_slot_data
var slot_index : int = -1

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
	var sound = load ("res://Asset/sound_effects/click_001.ogg")
	GlobalGameSystem.play_sfx_audio(sound)
	
	GlobalGameSystem.button_data_inv = slot_data
	
	GlobalGameSystem.active_slot_index = slot_index
	
	SignalManager.show_item_info_board.emit()
	pass # Replace with function body.
