extends VBoxContainer

# Fetch UI elements when the node is ready
@onready var texture_rect: TextureRect = $TextureRect
@onready var text_box: RichTextLabel = $text_box
@onready var choice: Button = $choice
@onready var choice_2: Button = $choice2
@onready var choice_3: Button = $choice3
@onready var choice_4: Button = $choice4
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var continue_butn: Button = $continue

@onready var coin: Label = $"../LittleScroll/coin"
@onready var hp: TextureProgressBar = $"../HP/Hp_bar_solid"
@onready var notification: CanvasLayer = $"../notification"


# info board ui

@onready var info_board: Sprite2D = $"../inventory_border/Control/Info_board"
@onready var item_icon: TextureRect = $"../inventory_border/Control/Info_board/item_icon"
@onready var buff_texture: TextureRect = $"../inventory_border/Control/Info_board/buff texture"
@onready var buff_texture_2: TextureRect = $"../inventory_border/Control/Info_board/buff texture2"
@onready var item_name: Label = $"../inventory_border/Control/Info_board/name"
@onready var item_attribute: Label = $"../inventory_border/Control/Info_board/attribute"
@onready var item_discription: Label = $"../inventory_border/Control/Info_board/discription"
@onready var action_label: Label = $"../inventory_border/Control/Info_board/action/Label"
@onready var item_type: Label = $"../inventory_border/Control/Info_board/item_type"




# Stats
@onready var atk: Label = $"../stat/stat_value/ATK"
@onready var def: Label = $"../stat/stat_value/DEF"
@onready var dex: Label = $"../stat/stat_value/DEX"
@onready var con: Label = $"../stat/stat_value_2/CON"
@onready var Int: Label = $"../stat/stat_value_2/INT"
@onready var wis: Label = $"../stat/stat_value_2/WIS"
@onready var cha: Label = $"../stat/CHA"

# Inventory
@onready var selected_inventory: Selected_Inventory_Ui = $"../inventory_border/Control/selected_inventory"
@onready var storage_inventory: Inventory_Ui = $"../inventory_border/Control/GridContainer"

# Jornal
@onready var jornal_display: CanvasLayer = $"../jornal_display"


# State variables
var current_chapter := "Chapter_1"
var current_page_index = "page_1"
var next_page 
var current_page := {}
var counter = -5
var current_text
var current_roll : int
var clicked_choice
var current_choice
var current_outcome
var current_coin : int = 100
var current_reward_text : String
var current_hp : int = 100
var counter_inventory : int = 0

# signals
signal shown
signal hides

# Called when the scene is loaded
func _ready() -> void:
	# connect to nessarry signals
	SignalManager.show_item_info_board.connect(show_item_info_board)
	SignalManager.show_selected_item_board.connect(show_selected_inventory_board)
	
	# defualt value of clicked choice
	clicked_choice = choice
	load_page()  # Load the first page

# Unused for now, but required if real-time updates are needed
func _process(_delta: float) -> void:
	pass

# Get the current page data from the global system
func get_current_page():
	var chapter_data = GlobalGameSystem.ashes_of_brinkwood.get(current_chapter, {})
	return chapter_data.get(current_page_index, {})




# Load and display a new page's data
func load_page () -> void:
	current_page = get_current_page()
	
	# === PAGE EXISTENCE CHECK ===
	# If the current page is empty (does not exist), hide everything and return early.
	if current_page.is_empty():
		visible = false  # Hide this entire VBoxContainer (self)
		texture_rect.visible = false
		text_box.visible = false
		choice.visible = false
		choice_2.visible = false
		choice_3.visible = false
		choice_4.visible = false
		continue_butn.visible = false
		return  # Exit early to avoid errors
	

	# Handle image (background)
	if "img" in current_page and current_page["img"] != "":
		texture_rect.texture = load(current_page["img"])
		$AnimationPlayer2.play("texture_fade")
	else: 
		texture_rect.texture = null

	# Handle text
	if "text" in current_page and current_page["text"] != "":
		current_text = current_page["text"]
		counter = -5
		typewriting_animation()
	else:
		current_text = ""

	# Handle choices
	# Only show choices if they have text. Otherwise, hide them.

	# Choice 1
	if current_page["choice_1"]["choice"] != "":
		choice.text = current_page["choice_1"]["choice"]
		#choice.set_meta("outcome", current_page["choice_1"]["outcome_1"]["text"])
	else:
		choice.visible = false
	
	# Choice 2
	if current_page["choice_2"] != "":
		choice_2.text = current_page["choice_2"]
	else: 
		choice_2.visible = false
	
	# Choice 3
	if current_page["choice_3"] != "":
		choice_3.text = current_page["choice_3"]
	else:
		choice_3.visible = false
		
	# Choice 4
	if current_page["choice_4"] != "":
		choice_4.text = current_page["choice_4"]
	else:
		choice_4.visible = false



## When the choices are pressed
func _on_choice_pressed() -> void:
	# get current page
	current_page = get_current_page()
	
	# set the choice player clicked
	clicked_choice = choice
	
	# roll die and store current choice info
	$"../overlay".visible = true
	current_choice = current_page["choice_1"]
	

func _on_choice_2_pressed() -> void:
	## get current page
	#current_page = get_current_page()
	#
	## set the choice player clicked
	#clicked_choice = choice
	#
	## roll die and store current choice info
	#$"../overlay".visible = true
	#current_choice = current_page["choice_2"]
	pass # Replace with function body.


func _on_choice_3_pressed() -> void:
	## get current page
	#current_page = get_current_page()
	#
	## set the choice player clicked
	#clicked_choice = choice
	#
	## roll die and store current choice info
	#$"../overlay".visible = true
	#current_choice = current_page["choice_3"]
	pass # Replace with function body.


func _on_choice_4_pressed() -> void:
	## get current page
	#current_page = get_current_page()
	#
	## set the choice player clicked
	#clicked_choice = choice
	#
	## roll die and store current choice info
	#$"../overlay".visible = true
	#current_choice = current_page["choice_4"]
	pass # Replace with function body.



# Start the typewriter text animation
func typewriting_animation () -> void:
	timer.start()

# Called each time the timer triggers for the typewriter effect
func _on_timer_timeout() -> void:
	current_page = get_current_page()
	counter += 1

	text_box.text = "[fade start=" + str(counter) + " length=10]" + current_text + "[/fade]"

	# Show continue or options when text is fully revealed
	if counter >= text_box.get_total_character_count():
		if clicked_choice.has_meta("outcome") and current_text == clicked_choice.get_meta("outcome"):
			hide_options()
			show_continue()
		else:
			show_options()
			$continue.visible = false
	else:
		hide_options()
		$continue.visible = false
		
		

# Display the choices with animation
func show_options () -> void:
	if !animation_player.is_playing():
		animation_player.play("show_choice")


# Play the continue button fade animation
func show_continue () -> void:
	if !$AnimationPlayer2.is_playing():
		
		# show reward and continue button
		$reward_indicator.text = current_reward_text
		$AnimationPlayer2.play("show_continue")  # Looping animation should be defined in AnimationPlayer2
		give_reward_or_loss()



# Hide all option buttons
func hide_options() -> void:
	animation_player.play("hide_choices")
	#animation_player.stop()



# When the player hits "continue", move to next page
func _on_continue_pressed() -> void:
	current_page = get_current_page()
	
	# Set the next page index
	current_page_index = next_page
	
	
	continue_butn.visible = false
	$reward_indicator.visible = false
	texture_rect.visible = true
	load_page()



## when roll is being pressed
func _on_roll_pressed() -> void:
	$"../overlay/roll".visible = false
	$"../overlay/Sprite2D/AnimationPlayer".play("roll_animation")
	await get_tree().create_timer(3.2).timeout
	current_roll = randi_range(1, 20)      # Returns value from 1 to 20
	$"../overlay/Sprite2D/counter".text = str(current_roll)
	await  get_tree().create_timer(1.5).timeout
	$"../overlay".visible = false
	
	# reset
	$"../overlay/roll".visible = true
	$"../overlay/Sprite2D/counter".text = "20"
	set_choice_data()

	pass # Replace with function body.



func set_choice_data ():
	# get current page
	current_page = get_current_page()
	var stat_requirment = current_page["roll"]
	
	# check for the stats and their value
	if "atk" in stat_requirment:
		var required_value = stat_requirment["atk"] 
		var atk_support = int(Int.text) # Support stat for the main stat
		var stat = int(atk.text) # Store the and covart the main stat to an int value
		
		if stat >= required_value:

			# perform stats modifer
			var new_stat = (stat * current_roll) / 10.0 # new stat value (int)
			#print ("New stat: ", new_stat)
			var chance_modifer = clamp(float ((atk_support) / float( new_stat)), 0.1, 1.0)
			#print ("Chance modifer: ", chance_modifer)
			var die_chance_modifer = (current_roll - 2.5) / 5.0
			#print ("Die Chance Modifer: " ,die_chance_modifer)
			var final_chance = clamp(new_stat * chance_modifer * (1 + 0.2 * die_chance_modifer), 0, 100) # chnace of it being performed (float)
			final_chance = clamp(final_chance, 0, 100)
			#print ("Final chance: ", final_chance)
			
			if randi_range(1, 100) <= final_chance:
				clicked_choice.set_meta("outcome", current_choice["outcome_1"]["text"])
				current_outcome = current_choice["outcome_1"]
				
				# set reward text
				current_reward_text = current_choice["outcome_1"]["reward"]["reward_text"]
			else :
				clicked_choice.set_meta("outcome", current_choice["outcome_2"]["text"])
				current_outcome = current_choice["outcome_2"]
				
				# set loss text
				current_reward_text = current_choice["outcome_2"]["loss"]["loss_text"]
		
		else :
			clicked_choice.set_meta("outcome", current_choice["outcome_2"]["text"])
			current_outcome = current_choice["outcome_2"]
			
			# set loss text
			current_reward_text = current_choice["outcome_2"]["loss"]["loss_text"]
		
	elif "def" in stat_requirment:
		var required_value = stat_requirment["def"] 
		var def_support = int(con.text)
		var stat = int(def.text)
		
		if stat >= required_value:

			# perform stats modifer
			var new_stat = (stat * current_roll) / 10.0 # new stat value (int)
			#print ("New stat: ", new_stat)
			var chance_modifer = clamp(float ((def_support) / float( new_stat)), 0.1, 1.0)
			#print ("Chance modifer: ", chance_modifer)
			var die_chance_modifer = (current_roll - 2.5) / 5.0
			#print ("Die Chance Modifer: " ,die_chance_modifer)
			var final_chance = clamp(new_stat * chance_modifer * (1 + 0.2 * die_chance_modifer), 0, 100) # chnace of it being performed (float)
			final_chance = clamp(final_chance, 0, 100)
			#print ("Final chance: ", final_chance)
			
			if randi_range(1, 100) <= final_chance:
				clicked_choice.set_meta("outcome", current_choice["outcome_1"]["text"])
				current_outcome = current_choice["outcome_1"]
			else :
				clicked_choice.set_meta("outcome", current_choice["outcome_2"]["text"])
				current_outcome = current_choice["outcome_2"]
		
		else :
			clicked_choice.set_meta("outcome", current_choice["outcome_2"]["text"])
			current_outcome = current_choice["outcome_2"]	
		
	elif "con" in stat_requirment:
		var required_value = stat_requirment["con"] 
		var con_support = int(wis.text)
		var stat = int(con.text)
		
		if stat >= required_value:

			# perform stats modifer
			var new_stat = (stat * current_roll) / 10.0 # new stat value (int)
			#print ("New stat: ", new_stat)
			var chance_modifer = clamp(float ((con_support) / float( new_stat)), 0.1, 1.0)
			#print ("Chance modifer: ", chance_modifer)
			var die_chance_modifer = (current_roll - 2.5) / 5.0
			#print ("Die Chance Modifer: " ,die_chance_modifer)
			var final_chance = chance_modifer * (1 + 0.2 * die_chance_modifer) # chnace of it being performed (float)
			final_chance = clamp(final_chance, 0, 100)
			#print ("Final chance: ", final_chance)
			
			if randi_range(1, 100) <= final_chance:
				clicked_choice.set_meta("outcome", current_choice["outcome_1"]["text"])
				current_outcome = current_choice["outcome_1"]
			else :
				clicked_choice.set_meta("outcome", current_choice["outcome_2"]["text"])
				current_outcome = current_choice["outcome_2"]
		
		else :
			clicked_choice.set_meta("outcome", current_choice["outcome_2"]["text"])
			current_outcome = current_choice["outcome_2"]	
		
	elif "dex" in stat_requirment:
		var required_value = stat_requirment["dex"] 
		var dex_support = int(wis.text)
		var stat = int(dex.text)
		
		if stat >= required_value:

			# perform stats modifer
			var new_stat = (stat * current_roll) / 10.0 # new stat value (int)
			#print ("New stat: ", new_stat)
			var chance_modifer = clamp(float ((dex_support) / float( new_stat)), 0.1, 1.0)
			#print ("Chance modifer: ", chance_modifer)
			var die_chance_modifer = (current_roll - 2.5) / 5.0
			#print ("Die Chance Modifer: " ,die_chance_modifer)
			var final_chance = clamp(new_stat * chance_modifer * (1 + 0.2 * die_chance_modifer), 0, 100) # chnace of it being performed (float)
			final_chance = clamp(final_chance, 0, 100)
			#print ("Final chance: ", final_chance)
			
			if randi_range(1, 100) <= final_chance:
				clicked_choice.set_meta("outcome", current_choice["outcome_1"]["text"])
				current_outcome = current_choice["outcome_1"]
				
				# set reward text
				current_reward_text = current_choice["outcome_1"]["reward"]["reward_text"]
			else :
				clicked_choice.set_meta("outcome", current_choice["outcome_2"]["text"])
				current_outcome = current_choice["outcome_2"]
				
				# set loss text
				current_reward_text = current_choice["outcome_2"]["loss"]["loss_text"]
		
		else :
			clicked_choice.set_meta("outcome", current_choice["outcome_2"]["text"])
			current_outcome = current_choice["outcome_2"]
			
			# set loss text
			current_reward_text = current_choice["outcome_2"]["loss"]["loss_text"]
	
	elif "int" in stat_requirment:
		var required_value = stat_requirment["int"] 
		var int_support = int(wis.text)
		var stat = int(Int.text)
		
		if stat >= required_value:

			# perform stats modifer
			var new_stat = (stat * current_roll) / 10.0 # new stat value (int)
			#print ("New stat: ", new_stat)
			var chance_modifer = clamp(float ((int_support) / float( new_stat)), 0.1, 1.0)
			#print ("Chance modifer: ", chance_modifer)
			var die_chance_modifer = (current_roll - 2.5) / 5.0
			#print ("Die Chance Modifer: " ,die_chance_modifer)
			var final_chance = clamp(new_stat * chance_modifer * (1 + 0.2 * die_chance_modifer), 0, 100) # chnace of it being performed (float)
			final_chance = clamp(final_chance, 0, 100)
			#print ("Final chance: ", final_chance)
			
			if randi_range(1, 100) <= final_chance:
				clicked_choice.set_meta("outcome", current_choice["outcome_1"]["text"])
				current_outcome = current_choice["outcome_1"]
			else :
				clicked_choice.set_meta("outcome", current_choice["outcome_2"]["text"])
				current_outcome = current_choice["outcome_2"]
		
		else :
			clicked_choice.set_meta("outcome", current_choice["outcome_2"]["text"])
			current_outcome = current_choice["outcome_2"]
	
	elif "wis" in stat_requirment:
		var required_value = stat_requirment["wis"] 
		var wis_support = int(cha.text)
		var stat = int(wis.text)
		
		if stat >= required_value:

			# perform stats modifer
			var new_stat = float((stat * current_roll)) / 10.0 # new stat value (int)
			#print ("New stat: ", new_stat)
			var chance_modifer = clamp(float ((wis_support) / float( new_stat)), 0.1, 1.0)
			#print ("Chance modifer: ", chance_modifer)
			var die_chance_modifer = (current_roll - 2.5) / 5.0
			#print ("Die Chance Modifer: " ,die_chance_modifer)
			var final_chance = clamp(new_stat * chance_modifer * (1 + 0.2 * die_chance_modifer), 0, 100) # chnace of it being performed (float)
			final_chance = clamp(final_chance, 0, 100)
			#print ("Final chance: ", final_chance)
			
			if randi_range(1, 100) <= final_chance:
				clicked_choice.set_meta("outcome", current_choice["outcome_1"]["text"])
				current_outcome = current_choice["outcome_1"]
			else :
				clicked_choice.set_meta("outcome", current_choice["outcome_2"]["text"])
				current_outcome = current_choice["outcome_2"]
		
		else :
			clicked_choice.set_meta("outcome", current_choice["outcome_2"]["text"])
			current_outcome = current_choice["outcome_2"]

	elif "cha" in stat_requirment:
		var required_value = stat_requirment["cha"] 
		var cha_support = int(Int.text)
		var stat = int(cha.text)
		
		if stat >= required_value:

			# perform stats modifer
			var new_stat = (stat * current_roll) / 10.0 # new stat value (int)
			#print ("New stat: ", new_stat)
			var chance_modifer = clamp(float ((cha_support) / float( new_stat)), 0.1, 1.0)
			#print ("Chance modifer: ", chance_modifer)
			var die_chance_modifer = (current_roll - 2.5) / 5.0
			#print ("Die Chance Modifer: " ,die_chance_modifer)
			var final_chance = clamp(new_stat * chance_modifer * (1 + 0.2 * die_chance_modifer), 0, 100) # chnace of it being performed (float)
			final_chance = clamp(final_chance, 0, 100)
			#print ("Final chance: ", final_chance)
			
			if randi_range(1, 100) <= final_chance:
				clicked_choice.set_meta("outcome", current_choice["outcome_1"]["text"])
				current_outcome = current_choice["outcome_1"]
			else :
				clicked_choice.set_meta("outcome", current_choice["outcome_2"]["text"])
				current_outcome = current_choice["outcome_2"]
		
		else :
			clicked_choice.set_meta("outcome", current_choice["outcome_2"]["text"])
			current_outcome = current_choice["outcome_2"]
	
	# set outcome
	var outcome_text = clicked_choice.get_meta("outcome")
	current_text = outcome_text
	
	## set reward text
	#var _outcome_reward
	
	## set next page, reset counter and start the typewriter animation
	next_page = current_choice["outcome_1"]["next_page"]
	counter = -5
	typewriting_animation()
#
	## Hide all options and show the continue button instead
	hide_options()
	texture_rect.visible = false
	continue_butn.visible = true
	
	
	
	
func give_reward_or_loss():
	# check which outcome you are currently in then add up coins if it the first
	if current_outcome == current_choice["outcome_1"]:
		current_coin += current_choice["outcome_1"]["reward"]["coin"]
		coin.text = str(current_coin)
	# remove if its the second
	elif current_outcome == current_choice["outcome_2"]:
		current_coin -= current_choice["outcome_2"]["loss"]["coin"]
		current_hp -= current_choice["outcome_2"]["loss"]["hp"]
		$"../Camera2D".shake(5.0, 5.0)
		
		# check if the calculation is less the 0 if so set it back to 0
		if current_coin < 0:
			current_coin = 0
			coin.text = str(current_coin)
		else:
			coin.text = str(current_coin)
			
		# check for hp also
		if current_hp < 0:
			current_hp = 0
			hp.value = current_hp
		else:
			hp.value = current_hp



## UI BUTTONS (I know there are better ways to do this)
func _on_inventory_pressed() -> void:
	# track time the button was pressed
	counter_inventory += 1
	
	if counter_inventory == 1 :
		# bring forth the inventory
		$"../inventory_border/AnimationPlayer".play("inventory_open")
		shown.emit()
	elif  counter_inventory > 1:
		#close the inventory
		$"../inventory_border/AnimationPlayer".play("inventory_close")
		hides.emit()
		# hide the info board if it on
		if info_board.visible == true:
			info_board.visible = false
		else:
			pass
		# reset counter
		counter_inventory = 0
	pass # Replace with function body.
	
	
# show item info in the info board
func show_item_info_board () -> void:
	if GlobalGameSystem.button_data_inv == null or GlobalGameSystem.button_data_inv.item_data == null:
		info_board.visible = false
		return
	
	item_icon.texture = GlobalGameSystem.button_data_inv.item_data.texture
	buff_texture.texture = GlobalGameSystem.button_data_inv.item_data.buff_texture
	buff_texture_2.texture = GlobalGameSystem.button_data_inv.item_data.buff_texture2
	item_name.text = GlobalGameSystem.button_data_inv.item_data.name
	item_type.text = GlobalGameSystem.button_data_inv.item_data.item_type
	item_discription.text = GlobalGameSystem.button_data_inv.item_data.discription
	item_attribute.text = (GlobalGameSystem.button_data_inv.item_data.attribute + " " + "+" + str(GlobalGameSystem.button_data_inv.item_data.attribute_value))
	
	# Hide the action button
	$"../inventory_border/Control/Info_board/action".visible = true
	
	# check if the item selected can be equiped or used
	if item_type.text == "Consumable":
		action_label.text = "USE"
	elif  item_type.text == "Wearable":
		action_label.text = "EQUIP"
		
	info_board.visible = true
	pass


func _on_exit_pressed() -> void:
	info_board.visible = false
	pass # Replace with function body.

func show_selected_inventory_board () -> void:
	if GlobalGameSystem.button_data_inv == null or GlobalGameSystem.button_data_inv.item_data == null:
		info_board.visible = false
		return
	
	item_icon.texture = GlobalGameSystem.button_data_inv.item_data.texture
	buff_texture.texture = GlobalGameSystem.button_data_inv.item_data.buff_texture
	buff_texture_2.texture = GlobalGameSystem.button_data_inv.item_data.buff_texture2
	item_name.text = GlobalGameSystem.button_data_inv.item_data.name
	item_type.text = GlobalGameSystem.button_data_inv.item_data.item_type
	item_discription.text = GlobalGameSystem.button_data_inv.item_data.discription
	item_attribute.text = (GlobalGameSystem.button_data_inv.item_data.attribute + " " + "+" + str(GlobalGameSystem.button_data_inv.item_data.attribute_value))
	
	# Hide the action button
	$"../inventory_border/Control/Info_board/action".visible = false
	
	info_board.visible = true
	pass
	

# Moving from storage to selected inventory

func _on_action_pressed() -> void:
	if action_label.text == "EQUIP":
		var target_grid = selected_inventory
		var slot = GlobalGameSystem.button_data_inv
		
		# Set the specific wearable type to a specific slot
		if slot.item_data.wearable_class == "Weapon":
			target_grid.set_slot_at_index(slot, 4)
		
			remove_item_slot()
		## Other specific wearable conditions goes here
		
	elif action_label.text == "USE":
		var slot = GlobalGameSystem.button_data_inv
		var message : String
		
		# Safe check
		if slot == null:
			info_board.visible = false
			return
			
			
		# check the item attribute
		if slot.item_data.attribute == "Heal":
			if current_hp >= 100:
				notification.show_notification()
				return
				
			var notification_message : String = (slot.item_data.attribute + " " + "+" + str(slot.item_data.attribute_value))
			current_hp += slot.item_data.attribute_value
			hp.value = current_hp ## Dont forget to add the sound effect
			notification.chnage_notification_message(notification_message)
			remove_item_slot()
			

			
func remove_item_slot () -> void: ## Remove selected item from the inventory
	## Remove from storage but keep the slot
	var slot = GlobalGameSystem.button_data_inv
	var index = storage_inventory.data.slots.find(slot)
	if index != -1:
		storage_inventory.data.slots[index] = null
		
	storage_inventory.update_inventory()
	info_board.visible = false
	pass


# Jornal section
func _on_jornal_pressed() -> void:
	jornal_display.visible = true
	pass # Replace with function body.
