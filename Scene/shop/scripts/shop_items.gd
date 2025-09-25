extends Control
class_name Shop_Items

var slot_data : Slot_data : set = set_slot_data

@onready var item_icon: TextureRect = $Info_board/item_icon
@onready var buff_texture: TextureRect = $"Info_board/buff texture"
@onready var buff_texture_2: TextureRect = $"Info_board/buff texture2"
@onready var item_name: Label = $Info_board/name
@onready var attribute: Label = $Info_board/attribute
@onready var item_type: Label = $Info_board/item_type
@onready var discription: Label = $Info_board/discription
@onready var cost: Label = $Info_board/action/cost



func _ready() -> void:
	#texture_rect.texture = null
	pass

func set_slot_data (value : Slot_data) -> void:
	slot_data = value
	if slot_data ==null or slot_data.item_data == null :
		visible = false
		return
	item_name.text = slot_data.item_data.name
	item_icon.texture = slot_data.item_data.texture
	buff_texture.texture = slot_data.item_data.buff_texture
	buff_texture_2.texture = slot_data.item_data.buff_texture2
	item_type.text = slot_data.item_data.item_type
	attribute.text = slot_data.item_data.attribute + " " + str(slot_data.item_data.attribute_value)
	cost.text = str(slot_data.item_data.item_cost) + " coins"
	discription.text = slot_data.item_data.discription




func _on_action_pressed() -> void:
	GlobalGameSystem.shop_item = slot_data
	pass # Replace with function body.
