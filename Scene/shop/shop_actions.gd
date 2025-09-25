extends Control
class_name Shop_Action

var slot_data : Actions : set = set_slot_data

@onready var item_icon: TextureRect = $Info_board/item_icon
@onready var action_name: Label = $Info_board/name
@onready var damage: Label = $Info_board/damage
@onready var critical_attribute: Label = $"Info_board/critical attribute"
@onready var cooldown: Label = $Info_board/cooldown
@onready var discription: Label = $Info_board/discription
@onready var cost: Label = $Info_board/action/cost
@onready var action_type: Label = $Info_board/action_type




func _ready() -> void:
	#texture_rect.texture = null
	pass

func set_slot_data (value : Actions) -> void:
	slot_data = value
	if slot_data ==null or slot_data.action_data == null :
		visible = false
		return
	action_name.text = slot_data.action_data.action_name
	item_icon.texture = slot_data.action_data.action_img
	damage.text = "DMG " + str(slot_data.action_data.action_damage)
	action_type.text = slot_data.action_data.action_type
	critical_attribute.text = "Critical Rate " + slot_data.action_data.critical_rate
	cooldown.text = "Cooldown " + str(slot_data.action_data.cooldown)
	discription.text = slot_data.action_data.action_info
	cost.text = str(slot_data.action_data.cost) + " Coins"





func _on_action_pressed() -> void:
	GlobalGameSystem.shop_item = slot_data
	pass # Replace with function body.
