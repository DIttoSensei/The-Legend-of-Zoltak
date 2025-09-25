class_name Shop_Inventory extends GridContainer

@export var shop_items : Inventory_data
@export var shop_actions : Player_Action

const ITEM_SLOT = preload("res://Scene/shop/shop_items.tscn")
const ACTION_SLOT = preload("res://Scene/shop/shop_actions.tscn")

func _ready() -> void:
	#update_item_shop()
	pass
	
func clear_all_slots () -> void:
	var padding = $Control
	for c in get_children():
		if c != padding:
			c.queue_free()
			
	pass

func update_item_shop () -> void:
	var padding = $Control
	clear_all_slots()
	for s in shop_items.slots:
		var new_slot = ITEM_SLOT.instantiate()
		add_child(new_slot)
		move_child(padding, get_child_count() - 1)
		new_slot.slot_data = s
		
		
func update_action_shop () -> void:
	var padding = $Control
	clear_all_slots()
	for s in shop_actions.actions:
		var new_slot = ACTION_SLOT.instantiate()
		add_child(new_slot)
		move_child(padding, get_child_count() - 1)
		new_slot.slot_data = s
