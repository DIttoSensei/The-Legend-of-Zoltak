class_name Selected_Inventory_Ui extends Control

const INVENTORY_SLOT = preload("res://Scene/inventory/selected_inventory_slot.tscn")

@export var data : Inventory_data
@onready var page: VBoxContainer = $"../../../Page"
@onready var storage_inventory: Inventory_Ui = $"../GridContainer"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	page.shown.connect(update_inventory)
	page.hides.connect(clear_inventory)
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

func set_slot_at_index(slot_data: Slot_data, index: int) -> void:
	# var flag for see if your storage inventory has space or not
	var storage_access := false
	if data.slots[index] != null:
		for i in range(storage_inventory.data.slots.size()):
			if storage_inventory.data.slots[i] == null:
				storage_inventory.data.slots[i] = data.slots[index]
				data.slots[index] = slot_data
				# since there is space make the flag true
				storage_access = true
				break
		# if there is no storage, reture from the function asap
		if not storage_access:
			return
	else:
		data.slots[index] = slot_data
	# Refresh the UI
	update_inventory()



## Notice index
## 0 = Headgear, 1 = Chestplate, 2 = Relics, 3 = leggings, 4 = Weapon
