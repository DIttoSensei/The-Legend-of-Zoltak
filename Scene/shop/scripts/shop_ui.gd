class_name ShopUi
extends Node2D

@onready var coin: Label = $scroll/Label
@onready var shop_container: Shop_Inventory = $items_shop/HBoxContainer
@onready var sound_effect: AudioStreamPlayer = $sound_effect
@onready var sound_effect_2: AudioStreamPlayer = $sound_effect2


# exports
@export var data : Shop_Data


var current_coin
var slot_items : Array = []
var slot_action : Array = []
var notif_message : String

func _ready() -> void:
	#current_coin = GlobalGameSystem.player_coin
	$CanvasLayer.visible = false
	SignalManager.notification_purchase.connect(purchased_notif)
	SignalManager.notification_cant_purchase.connect(cant_purchase_notif)
	SignalManager.player_inv_full.connect(inventory_full)
	SignalManager.action_purchase.connect(action_purchased)
	SignalManager.action_not_purchased.connect(action_cant_purchase)
	
	coin.text = str(current_coin)
	SceneTransition.fade_in()
	
	load_action()
	load_shop()
	
	GlobalGameSystem.global_audio.stream = preload("res://Asset/ost/White Woodlands - Alexander Nakarada.mp3")
	GlobalGameSystem.play_bg_audio()
	
	#load_item_shop()
	#GlobalGameSystem.player_coin 
	pass
	
func load_shop () -> void:
	slot_items.clear()
	
	var player_class = GlobalGameSystem.player_class
	load_item_resources_from_folder("res://Scene/shop/item/", slot_items)
	
	if player_class == "Warrior":
		load_item_resources_from_folder("res://Scene/shop/item/warrior/items/", slot_items)
	elif player_class == "Defender":
		load_item_resources_from_folder("res://Scene/shop/item/defender/item/", slot_items)
	elif player_class == "Summoner":
		load_item_resources_from_folder("res://Scene/shop/item/summoner/items/", slot_items)
	elif player_class == "Mage":
		load_item_resources_from_folder("res://Scene/shop/item/mage/item/", slot_items)
	elif player_class == "Ranger":
		load_item_resources_from_folder("res://Scene/shop/item/ranger/item/", slot_items)
	elif player_class == "Rogue":
		load_item_resources_from_folder("res://Scene/shop/item/rogue/items/", slot_items)
		
func load_action () -> void:
	slot_action.clear()
	
	var player_class = GlobalGameSystem.player_class
	
	if player_class == "Warrior":
		load_action_resources_from_folder("res://Scene/shop/item/warrior/action/", slot_action)
	if player_class == "Defender":
		load_action_resources_from_folder("res://Scene/shop/item/defender/action/", slot_action)
	if player_class == "Mage":
		load_action_resources_from_folder("res://Scene/shop/item/mage/action/", slot_action)
	if player_class == "Summoner":
		load_action_resources_from_folder("res://Scene/shop/item/summoner/action/", slot_action)
	if player_class == "Ranger":
		load_action_resources_from_folder("res://Scene/shop/item/ranger/action/", slot_action)
	if player_class == "Rogue":
		load_action_resources_from_folder("res://Scene/shop/item/rogue/action/", slot_action)

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
	var slot = shop_container.shop_actions.actions
	
	

	# sort the res in alphabetical order
	slot_action.sort_custom(func (a,b):
		return a.resource_path.get_file() < b.resource_path.get_file())
	
	
	var count := slot_action.size() # store the size of the list in a var
	data.actions.resize(count) # resize the primary array
	
	# Place the res in the primary array
	for s in range(slot_action.size()):
		data.actions[s] = slot_action[s]
	
	# resize the secondary arrey
	slot.resize(count)
	
	
	# create slotdata with the itemdata and place it in
	for r in range(slot.size()):
		var new_slot = Actions.new()
		if i < data.actions.size():
			new_slot.action_data = data.actions[i]
			slot[i] = new_slot
			i += 1
	
	# Load the items for your class (weapons)
	shop_container.update_action_shop()


func _on_action_button_pressed() -> void:
	load_action_shop()
	
	pass # Replace with function body.


func _on_item_button_pressed() -> void:
	load_item_shop()
	
	pass # Replace with function body.
	

func load_item_resources_from_folder (path : String, _slot : Array) -> void:
	
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

func load_action_resources_from_folder (path : String, _slot : Array) -> void:
	
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
							slot_action.append(res)
							
					elif file_name.ends_with(".tres"):
						var full_path = path.path_join(file_name)
						var res = load(full_path)
						if res != null:
							slot_action.append(res)
		
			# always move to the next file
			file_name = dir.get_next()
		dir.list_dir_end()
		load_action_shop()


func purchased_notif () -> void:
	if GlobalGameSystem.item is Slot_data:
		current_coin = GlobalGameSystem.player_coin
		coin.text = str(current_coin)
		notif_message = "New Item added to your inventory."
		SignalManager.add_item_to_inventory.emit()
		$CanvasLayer/Control/TextureRect/Label.text = notif_message
		$CanvasLayer.visible = true
		$CanvasLayer/Control/AnimationPlayer.play("show")
	
	
func cant_purchase_notif () -> void:
	notif_message = "Come back when you can afford the dirt this item is sitting on."
	$CanvasLayer/Control/TextureRect/Label.text = notif_message
	$CanvasLayer.visible = true
	$CanvasLayer/Control/AnimationPlayer.play("show")
	pass

func inventory_full () -> void:
	notif_message = "Oh, splendid… your inventory’s full. Who could’ve seen that coming?"
	$CanvasLayer/Control/TextureRect/Label.text = notif_message
	$CanvasLayer.visible = true
	$CanvasLayer/Control/AnimationPlayer.play("show")
	pass
	
func action_purchased () -> void:
	if GlobalGameSystem.item is Actions:
		current_coin = GlobalGameSystem.player_coin
		coin.text = str(current_coin)
		notif_message = "Purchased! Another skill in your repertoire."
		SignalManager.add_action_to_slot.emit()
		$CanvasLayer/Control/TextureRect/Label.text = notif_message
		$CanvasLayer.visible = true
		$CanvasLayer/Control/AnimationPlayer.play("show")
	pass

func action_cant_purchase () -> void:
	notif_message = "Empty pockets, hmm? That’s… ambitious."
	$CanvasLayer/Control/TextureRect/Label.text = notif_message
	$CanvasLayer.visible = true
	$CanvasLayer/Control/AnimationPlayer.play("show")
	pass


func _on_exit_n_pressed() -> void:
	$CanvasLayer.visible = false
	pass # Replace with function body.
