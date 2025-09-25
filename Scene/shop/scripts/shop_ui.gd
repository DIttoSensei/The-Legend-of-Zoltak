class_name ShopUi
extends Node2D

@onready var coin: Label = $scroll/Label
@onready var shop_container: Shop_Inventory = $items_shop/HBoxContainer

# exports
@export var data : Shop_Data


var current_coin
var slot_items : Array = []

func _ready() -> void:
	#current_coin = GlobalGameSystem.player_coin
	coin.text = str(current_coin)
	SceneTransition.fade_in()
	
	load_shop()
	#load_item_shop()
	#GlobalGameSystem.player_coin 
	pass
	
func load_shop () -> void:
	var player_class = GlobalGameSystem.player_class
	load_resources_from_folder("res://Scene/shop/item/", slot_items)
	
	if player_class == "Warrior":
		load_resources_from_folder("res://Scene/shop/item/warrior/items/", slot_items)
	elif player_class == "Defender":
		load_resources_from_folder("res://Scene/shop/item/defender/item/", slot_items)
	elif player_class == "Summoner":
		load_resources_from_folder("res://Scene/shop/item/summoner/items/", slot_items)
	elif player_class == "Mage":
		load_resources_from_folder("res://Scene/shop/item/mage/item/", slot_items)
	elif player_class == "Ranger":
		load_resources_from_folder("res://Scene/shop/item/ranger/item/", slot_items)
	elif player_class == "Rogue":
		load_resources_from_folder("res://Scene/shop/item/rogue/items/", slot_items)

func _on_exit_pressed() -> void:
	# send a signal to leave the scene and go back to game play
	SignalManager.shop_exit.emit()
	pass # Replace with function body.
	

func load_item_shop () -> void:
	# first load the basic items
	var i = 0
	var slot = shop_container.shop_items.slots
	
	

	# sort the res in alphabetical order
	slot_items.sort_custom(func (a,b):
		return a.resource_path.get_file() < b.resource_path.get_file())
	
	
	var count := slot_items.size() # store the size of the list in a var
	data.items.resize(count) # resize the primary array
	
	# Place the res in the primary array
	for s in range(slot_items.size()):
		data.items[s] = slot_items[s]
	
	# resize the secondary arrey
	slot.resize(count)
	
	
	# create slotdata with the itemdata and place it in
	for r in range(slot.size()):
		var new_slot = Slot_data.new()
		if i < data.items.size():
			new_slot.item_data = data.items[i]
			slot[i] = new_slot
			i += 1
	
	# Load the items for your class (weapons)
	shop_container.update_item_shop()
		#pass
	#shop_container.shop_items.slots
	pass
	
func load_action_shop () -> void:
	# first load the basic items
	var i = 0
	
	# Check for your class and show the actions for that one specifically
	
	for slot in shop_container.shop_actions.actions:
		if slot.action_data == null:
			if i < data.basic_actions.size():
				slot.action_data = data.basic_actions[i]
				i += 1
	shop_container.update_action_shop()


func _on_action_button_pressed() -> void:
	load_action_shop()
	
	pass # Replace with function body.


func _on_item_button_pressed() -> void:
	load_item_shop()
	
	pass # Replace with function body.
	

func load_resources_from_folder (path : String, slot : Array) -> void:
	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			# skip "." and ".."
			if file_name != "." and file_name != "..":
				if not dir.current_is_dir():
					if file_name.ends_with(".remap"):
						var full_path = path.path_join(file_name.trim_suffix(".remap"))
						var res = load(full_path)
						if res != null:
							slot_items.append(res)
							
					elif file_name.ends_with(".tres"):
						var full_path = path.path_join(file_name)
						var res = load(full_path)
						if res != null:
							slot_items.append(res)
		
			# always move to the next file
			file_name = dir.get_next()
		dir.list_dir_end()
		load_item_shop()
	pass
