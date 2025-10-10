class_name Inventory_Ui extends Control

const INVENTORY_SLOT = preload("res://Scene/inventory/inventory_slot.tscn")

@export var data : Inventory_data
#@onready var page: VBoxContainer = 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var page = get_node_or_null("../../../Page")
	var battle_scene = get_node_or_null("../../../..")
	
	if page:
		page.shown.connect(update_inventory)
		page.hides.connect(clear_inventory)
		clear_inventory()
	elif battle_scene:
		battle_scene.show.connect(update_inventory)
		battle_scene.hide.connect(clear_inventory)
		clear_inventory()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func clear_inventory () -> void:
	for c in get_children():
		c.queue_free()
		

func update_inventory () -> void:
	clear_inventory()
	for s in data.slots:
		var new_slot = INVENTORY_SLOT.instantiate()
		add_child(new_slot)
		new_slot.slot_data = s
