class_name JollyJoker extends Control

@onready var market_deck: MarketDeck = $market_deck
@onready var opp_deck_ai: AiDeck = $opp_deck_ai
@onready var player_deck: PlayerDeck = $player_deck
@onready var spawn: Spawn = $spawn
@onready var main_stack_holder: Control = $main_stack_holder
@onready var main: MainStack = $main
@onready var market_btn: Button = $market_deck/market_btn
@onready var player_btn: Button = $player_deck/player_btn
@onready var placeholder: Sprite2D = $placeholder
@onready var noti: Label = $notification/Label
@onready var noti_ani: AnimationPlayer = $notification/AnimationPlayer
@onready var result_text: Label = $CanvasLayer/result_text
@onready var canvas_layer: CanvasLayer = $CanvasLayer

@export var ost : String


var count : int = 0
var current_play_card
var current_player : String = "" # player or ai
var player_turn_taken := false
var ai_turn_taken := false
var card_blocking := false

## for player
var can_only_play_num_two : bool = false
var can_only_play_num_five : bool = false
var last_no_two_card_played_by = ""
var last_no_five_card_played_by = ""
var went_to_market : bool = false # for if player went to market but has either 2 or 5 on hand

const PLAYER_CARD = preload("res://Scene/jolly_joker/player_card.tscn")


func _ready() -> void:
	SceneTransition.fade_in()
	SignalManager.play_player_card.connect(play_player_card)
	if ost == "":
		pass
	else:
		print('play audio')
		GlobalGameSystem.global_audio.stream = load(ost)
		#GlobalGameSystem.delay(2)
		GlobalGameSystem.play_bg_audio()
	block_btn_press()
	move_starter_cards()
	await get_tree().create_timer(2).timeout
	starter_animation()
	

func move_starter_cards () -> void:
	for i in 4:
		var random_item = market_deck.res.stack.pop_at(randi() % market_deck.res.stack.size())
		player_deck.res.stack.append(random_item)
		var random_item_ai = market_deck.res.stack.pop_at(randi() % market_deck.res.stack.size())
		opp_deck_ai.res.stack.append(random_item_ai)
		
func starter_animation () -> void:
	for i in 4:
		var p = AudioStreamPlayer.new()
		p.stream = load ("res://Asset/ost/sound_effects/card_click.mp3")
		add_child(p)
		
		var sprite = Sprite2D.new()
		var texture_1 = "res://Scene/jolly_joker/assets/back_b.png"
		var texture_2 = "res://Scene/jolly_joker/assets/back_w.png"
		sprite.scale = Vector2(0.288,0.288)
		spawn.add_child(sprite)
		sprite.position = Vector2(105,147)
		var choice = [texture_1,texture_2].pick_random()
		sprite.texture = load (choice)
	
		var tween = create_tween()
		tween.tween_callback(p.play) # play sound
		tween.tween_property(sprite, "position", Vector2(105,1011), 0.15)
		p.finished.connect(p.queue_free)
		await tween.finished
		## counter
		var current_num = int($player_deck/counter/Label.text)
		current_num += 1
		$player_deck/counter/Label.text = str(current_num)
		
	for i in 4:
		var p = AudioStreamPlayer.new()
		p.stream = load ("res://Asset/ost/sound_effects/card_click.mp3")
		add_child(p)
		
		var sprite = Sprite2D.new()
		var texture_1 = "res://Scene/jolly_joker/assets/back_b.png"
		var texture_2 = "res://Scene/jolly_joker/assets/back_w.png"
		sprite.scale = Vector2(0.288,0.288)
		spawn.add_child(sprite)
		sprite.position = Vector2(105,147)
		var choice = [texture_1,texture_2].pick_random()
		sprite.texture = load (choice)
	
		var tween = create_tween()
		tween.tween_property(sprite, "position", Vector2(105,-625), 0.15)
		tween.parallel().tween_callback(p.play) # play sound
		tween.tween_property(sprite, "position", Vector2(898,-625), 0.15)
		#tween.parallel().tween_callback(p.play) # play sound
		p.finished.connect(p.queue_free)
		await tween.finished
		## counter
		var current_num = int($opp_deck_ai/counter/Label.text)
		current_num += 1
		$opp_deck_ai/counter/Label.text = str(current_num)
		
	var p = AudioStreamPlayer.new()
	p.stream = load ("res://Asset/ost/sound_effects/card_drop.mp3")
	add_child(p)
		
	var sprite = Sprite2D.new()
	var first_play_card : CardRes = market_deck.res.stack.pop_at(randi() % market_deck.res.stack.size())
	sprite.scale = Vector2(0.288,0.288)
	spawn.add_child(sprite)
	sprite.position = Vector2(105,147)
	sprite.texture = first_play_card.img
	first_play_card.first_card = true
	main.res.stack.append(first_play_card)
	
	sprite.reparent(main_stack_holder)
	var tween = create_tween()
	tween.tween_property(sprite, "position", Vector2(181,253.1), 0.15)
	tween.parallel().tween_callback(p.play) # play sound
	tween.parallel().tween_property(sprite, "scale", Vector2(0.499,0.499), 0.15)
	p.finished.connect(p.queue_free)
	
	spawn.clear_children()
	allow_btn_press()
	

func allow_btn_press () -> void:
	player_btn.disabled = false
	market_btn.disabled = false

func block_btn_press () -> void:
	player_btn.disabled = true
	market_btn.disabled = true
	

### MAIN GAME FUNCTIONS

func update_player_counter () -> void:
	var count = player_deck.res.stack.size()
	$player_deck/counter/Label.text = str(count)
	
func update_ai_counter () -> void:
	var count = opp_deck_ai.res.stack.size()
	$opp_deck_ai/counter/Label.text = str(count)

func _on_player_btn_pressed() -> void:
	
	
	if player_deck.res.stack.size() == null:
		count = 0
		return
	if count >= player_deck.res.stack.size():
		count = 0
		player_btn.disabled = true
		var children = placeholder.get_children() # reverse the children so the animation looks natural
		children.reverse()
		for i in children:
			var p = AudioStreamPlayer.new()
			p.stream = load ("res://Asset/ost/sound_effects/card_click.mp3")
			add_child(p)
	
			var tween = create_tween()
			tween.tween_property(i, "position", Vector2(-2753.472, 0), 0.1)
			tween.parallel().tween_callback(p.play)
			p.finished.connect(p.queue_free)
			await tween.finished
			i.queue_free()
		await get_tree().create_timer(0.2).timeout
		player_btn.disabled = false
	else:
		var p = AudioStreamPlayer.new()
		p.stream = load ("res://Asset/ost/sound_effects/card_click.mp3")
		add_child(p)
	
		var new_card : Sprite2D = PLAYER_CARD.instantiate()
		new_card.scale = Vector2(1,1)
		placeholder.add_child(new_card)
		new_card.position = Vector2(-2753.472, 0)
		new_card.texture = player_deck.res.stack[count].img
		
		
	
		var tween = create_tween()
		tween.tween_property(new_card, "position", Vector2(-3.472, 0), 0.15 )
		tween.parallel().tween_callback(p.play)
		tween.tween_property(new_card, "scale", Vector2(1.051,1.051), 0.05)
		tween.tween_property(new_card, "scale", Vector2(1,1), 0.1)
		p.finished.connect(p.queue_free)
		current_play_card = count
		count += 1
		#count %= player_deck.res.stack.size()
	

func play_player_card (card : Sprite2D) -> void:
	var p = AudioStreamPlayer.new()
	p.stream = load ("res://Asset/ost/sound_effects/card_drop.mp3")
	add_child(p)
	
	current_player = "player"
	if count < 0:
		count = 0
	count -= 1
	
	###################################
	if can_only_play_num_two == true:
		var play = player_deck.res.stack[current_play_card]
		if play.number != 2:
			count += 1
			return
		card_blocking = true
		## stop market glow animation
		var anin = $market_deck/glow
		var ani_res = anin.get_animation("glow")
		ani_res.loop_mode = Animation.LOOP_NONE
		can_only_play_num_two = false
		
	if can_only_play_num_five == true:
		var play = player_deck.res.stack[current_play_card]
		if play.number != 5:
			count += 1
			return
		card_blocking = true
		## stop market glow animation
		var anin = $market_deck/glow
		var ani_res = anin.get_animation("glow")
		ani_res.loop_mode = Animation.LOOP_NONE
		can_only_play_num_five = false
		###############################################
		
	card.reparent(main_stack_holder)
	var tween = create_tween()
	tween.tween_property(card, "position", Vector2(181,253.1), 0.15)
	tween.parallel().tween_property(card, "scale", Vector2(0.499,0.499), 0.15)
	tween.parallel().tween_callback(p.play)
	tween.tween_property(card, "scale", Vector2(0.55,0.55), 0.05)
	tween.tween_property(card, "scale", Vector2(0.499,0.499), 0.1)
	p.finished.connect(p.queue_free)
	var play_card : CardRes = player_deck.res.stack.pop_at(current_play_card)
	current_play_card -= 1
	if play_card.number == 2:
		if $market_deck/glow.is_playing():
			var anin = $market_deck/glow
			var anin_res = anin.get_animation("glow")
			anin_res.loop_mode = Animation.LOOP_NONE
	
	print ("Player played: ", play_card.type, " ", play_card.number) ####
	main.res.stack.append(play_card)
	player_turn_taken = true
	update_player_counter()
	
	stop_player_turn()
	await get_tree().create_timer(0.5).timeout
	table_rule_check()
	#ai_play_turn()


func take_from_market_player (itration : int = 1) -> void:
	if market_deck.res.stack.size() == 0:
		await refill_market()
	player_turn_taken = true
	for i in itration:
		var p = AudioStreamPlayer.new()
		p.stream = load ("res://Asset/ost/sound_effects/card_click.mp3")
		add_child(p)
		
		var sprite = Sprite2D.new()
		var texture_1 = "res://Scene/jolly_joker/assets/back_b.png"
		var texture_2 = "res://Scene/jolly_joker/assets/back_w.png"
		sprite.scale = Vector2(0.288,0.288)
		spawn.add_child(sprite)
		sprite.position = Vector2(105,147)
		var choice = [texture_1,texture_2].pick_random()
		sprite.texture = load (choice)
	
		var tween = create_tween()
		tween.tween_property(sprite, "position", Vector2(105,1011), 0.15)
		tween.parallel().tween_callback(p.play) # Play sound
		
		var random_item : CardRes = market_deck.res.stack.pop_at(randi() % market_deck.res.stack.size())
		print ("Player takes from market: ", random_item.type, " ", random_item.number)
		player_deck.res.stack.append(random_item)
		update_player_counter()
		
		p.finished.connect(p.queue_free)
		await tween.finished
	spawn.clear_children()
	
	#print ("player_new_decl: " ,player_deck.res.stack.size())
	stop_player_turn()
	
	if ai_wins():
		return
	await get_tree().create_timer(1).timeout
	ai_play_turn()

func stop_player_turn () -> void:
	var my_color = Color(0.494,0.494,0.494,1)
	var tween = create_tween()
	tween.tween_property(player_deck, "modulate", my_color, 0.2)
	market_btn.disabled = true
	player_btn.disabled = true
	
	for child in placeholder.get_children():
		var btn : Button = child.get_node_or_null("card_btn")
		btn.disabled = true
	
func resume_player_turn () -> void:
	#await get_tree().create_timer(1).timeout
	var my_color = Color(1,1,1,1)
	var tween = create_tween()
	tween.tween_property(player_deck, "modulate", my_color, 0.2)
	market_btn.disabled = false
	player_btn.disabled = false
	
	for child in placeholder.get_children():
		var btn : Button = child.get_node_or_null("card_btn")
		btn.disabled = false


func ai_play_turn () -> void:
	if main.res.stack.size() == 0: # if there is no card on the table play a random one
		var random_card = randi() % opp_deck_ai.res.stack.size()
		#print ("Ai picks random: ",opp_deck_ai.res.stack[random_card].number)
		opp_deck_ai.res.stack[random_card].first_card = true
		ai_play_card(opp_deck_ai.res.stack[random_card].img,random_card)
		
	else:
		# Check last card on the main table
		var index := 0
		var last_card = main.res.stack[-1]
		var go_to_market := true
	
		# Check if ai has similler cards
		for i in opp_deck_ai.res.stack:
			if i.type == last_card.type:
				ai_play_card(i.img,index)
				go_to_market = false
				break
			elif i.number == last_card.number:
				ai_play_card(i.img,index)
				go_to_market = false
				break
			else:
				#print ("Checking next card")
				index += 1
		if go_to_market == true:
			#print ("go to markey")
			ai_go_to_market()
	
func refill_market () -> void:
	noti.text = "Restock"
	play_notification("second")
	var value = main.res.stack.size() - 1
	for i in value:
		market_deck.res.stack.append(main.res.stack[i])
	var children =  main_stack_holder.get_children()
	for i in range(children.size() - 1):
		var p = AudioStreamPlayer.new()
		p.stream = load ("res://Asset/ost/sound_effects/card_click.mp3")
		add_child(p)
	
		children[i].reparent(spawn)
		var tween = create_tween()
		tween.tween_property(children[i], "position", Vector2(105,147.1), 0.1)
		tween.parallel().tween_callback(p.play)
		tween.parallel().tween_property(children[i], "scale", Vector2(0.288,0.288), 0.1)
		p.finished.connect(p.queue_free)
		await tween.finished
	spawn.clear_children()

func ai_play_card (card_texture : Texture2D, index : int) -> void:
	var p = AudioStreamPlayer.new()
	p.stream = load ("res://Asset/ost/sound_effects/card_drop.mp3")
	add_child(p)
	
	current_player = "ai"
	var sprite = Sprite2D.new()
	main_stack_holder.add_child(sprite)
	sprite.scale = Vector2(0.288,0.288)
	sprite.position = Vector2(580,-503)
	sprite.texture = card_texture
	
	var tween = create_tween()
	tween.tween_property(sprite, "position", Vector2(181,253.1), 0.15)
	tween.parallel().tween_property(sprite, "scale", Vector2(0.499,0.499), 0.15)
	tween.parallel().tween_callback(p.play) # play sound
	tween.tween_property(sprite, "scale", Vector2(0.55,0.55), 0.05)
	tween.tween_property(sprite, "scale", Vector2(0.499,0.499), 0.1)
	p.finished.connect(p.queue_free)
	
	var play_card : CardRes = opp_deck_ai.res.stack.pop_at(index)
	print ("AI played: ", play_card.type, " ", play_card.number)
	main.res.stack.append(play_card)
	update_ai_counter()
	
	
	await get_tree().create_timer(0.5).timeout
	table_rule_check()
	
	


func ai_go_to_market (itration : int = 1) -> void:
	if market_deck.res.stack.size() == 0:
		await refill_market()
	for i in itration:
		var p = AudioStreamPlayer.new()
		p.stream = load ("res://Asset/ost/sound_effects/card_click.mp3")
		add_child(p)
		
		var sprite = Sprite2D.new()
		var texture_1 = "res://Scene/jolly_joker/assets/back_b.png"
		var texture_2 = "res://Scene/jolly_joker/assets/back_w.png"
		sprite.scale = Vector2(0.288,0.288)
		spawn.add_child(sprite)
		sprite.position = Vector2(105,147)
		var choice = [texture_1,texture_2].pick_random()
		sprite.texture = load (choice)
	
		var tween = create_tween()
		tween.tween_property(sprite, "position", Vector2(105,-625), 0.15)
		tween.parallel().tween_callback(p.play) # play sound
		tween.tween_property(sprite, "position", Vector2(898,-625), 0.15)
		p.finished.connect(p.queue_free)
		await tween.finished
		var random_item : CardRes = market_deck.res.stack.pop_at(randi() % market_deck.res.stack.size())
		print ("AI takes from market: ", random_item.type, " ", random_item.number)
		opp_deck_ai.res.stack.append(random_item)
		update_ai_counter()
		#print ("AI CARD: ", opp_deck_ai.res.stack.size())
	
	if player_wins():
		return
	spawn.clear_children()
	player_turn_taken = false
	card_blocking = false
	resume_player_turn()


func table_rule_check () -> void:
	if main.res.stack.size() == 1:
		if player_turn_taken == true:
			resume_player_turn()
		return
	var top_played_card : CardRes = main.res.stack[-1]
	var below_played_card : CardRes = main.res.stack[-2]
	
	## Junkie
	if current_player == 'player':
		await Junkie(top_played_card,below_played_card,player_deck)
		await snag_two(top_played_card,below_played_card)
		await snag_three(top_played_card,below_played_card)
		await halt(top_played_card,below_played_card)
		await cut(top_played_card,below_played_card)
		await fetch(top_played_card,below_played_card)
		if ai_wins():
			return
		await get_tree().create_timer(1).timeout
		
		#
	
	elif current_player == 'ai':
		
		print (card_blocking)
		await snag_two(top_played_card,below_played_card)
		await snag_three(top_played_card,below_played_card)
		await halt(top_played_card,below_played_card)
		await cut(top_played_card,below_played_card)
		await fetch(top_played_card,below_played_card)
		if player_wins():
			return
		
		if player_turn_taken == true:
			resume_player_turn()
			player_turn_taken = false
	
	if player_turn_taken == true:
			ai_play_turn()
		
		


## Table rules
func Junkie (top_card : CardRes, below_card : CardRes, target_deck) -> void:
	if top_card.type == 'joker':
		noti.text = "Wild Card"
		play_notification("first")
		return
	if below_card.type == 'joker':
		return
	if top_card.number != below_card.number and top_card.type != below_card.type:
		# first have the children of the nodes in reverse
		var children = main_stack_holder.get_children()
		children.reverse()
		for child in children: # go thorugh all children in reverse and perform animation
			var p = AudioStreamPlayer.new()
			p.stream = load ("res://Asset/ost/sound_effects/card_click.mp3")
			add_child(p)
			
			child.reparent(spawn)
			var tween = create_tween()
			tween.tween_property(child, "position", Vector2(105,1011.1), 0.1)
			tween.parallel().tween_callback(p.play)
			tween.parallel().tween_property(child, "scale", Vector2(0.288,0.288), 0.1)
			
			if current_player == 'player':
				## counter
				var current_num = int($player_deck/counter/Label.text)
				current_num += 1
				$player_deck/counter/Label.text = str(current_num)
			elif current_player == 'ai':
				update_ai_counter()
			
			p.finished.connect(p.queue_free)
			await tween.finished
		# show notification
		noti.text = "Junkie"
		play_notification("first")
		
		spawn.clear_children() # delete children node
		main.res.stack.reverse() # Doing this cause so the current card on top of the main deck becomes the last card in target deck
		target_deck.res.stack.append_array(main.res.stack) # remove all res from main and add to target
		main.res.stack.clear()
		

func snag_two(top_card: CardRes, below_card: CardRes) -> void:
	if top_card.number != 2:
		return # Not a pick 2 card, do nothing

	# If the previous player was forced to go to market, 
	# and the current player plays another 2, the effect restarts.
	if current_player == "player":
		# AI's turn to respond
		var found_block = false
		for i in range(opp_deck_ai.res.stack.size()):
			if opp_deck_ai.res.stack[i].number == 2:
				# AI blocks by playing its own 2
				noti.text = "Block!"
				play_notification("second")
				ai_play_card(opp_deck_ai.res.stack[i].img, i)
				found_block = true
				break
		
		if not found_block:
			noti.text = "Snag Two"
			play_notification("second")
			ai_go_to_market(2)
			# Reset this so if AI plays a 2 later it's fresh
			went_to_market = false 

	elif current_player == "ai":
		# Player's turn to respond
		noti.text = "Snag Two"
		play_notification("second")
		can_only_play_num_two = true
		# Toggle glow to show player must act
		var anin = $market_deck/glow
		anin.get_animation("glow").loop_mode = Animation.LOOP_LINEAR
		anin.play("glow")

func snag_three(top_card: CardRes, below_card: CardRes) -> void:
	if top_card.number != 5:
		return # Not a pick 3 card

	if current_player == "player":
		var found_block = false
		for i in range(opp_deck_ai.res.stack.size()):
			if opp_deck_ai.res.stack[i].number == 5:
				noti.text = "Block!"
				play_notification("second")
				ai_play_card(opp_deck_ai.res.stack[i].img, i)
				found_block = true
				break
		
		if not found_block:
			noti.text = "Snag Three"
			play_notification("second")
			ai_go_to_market(3)
			went_to_market = false

	elif current_player == "ai":
		noti.text = "Snag Three"
		play_notification("second")
		can_only_play_num_five = true
		var anin = $market_deck/glow
		anin.get_animation("glow").loop_mode = Animation.LOOP_LINEAR
		anin.play("glow")
			

func halt (top_card : CardRes, below_card : CardRes) -> void:
	var first_rule = (top_card.number != below_card.number)
	var first_rule_2 = (top_card.type == below_card.type)
	var second_rule = (top_card.number == below_card.number)
	var second_rule_2 = (top_card.type != below_card.type)
	if first_rule and first_rule_2 and top_card.number == 8 or second_rule and second_rule_2 and top_card.number == 8:
		if current_player == 'player':
			noti.text = "Halt"
			play_notification("second")
			player_turn_taken = false
			resume_player_turn()
		
		elif current_player == 'ai':
			noti.text = "Halt"
			play_notification("second")
			player_turn_taken = false
			stop_player_turn()
			await ai_play_turn()
			resume_player_turn()


func cut (top_card : CardRes, below_card : CardRes) -> void:
	var first_rule = (top_card.number != below_card.number)
	var first_rule_2 = (top_card.type == below_card.type)
	var second_rule = (top_card.number == below_card.number)
	var second_rule_2 = (top_card.type != below_card.type)
	if first_rule and first_rule_2 and top_card.number == 1 or second_rule and second_rule_2 and top_card.number == 1:
		if current_player == 'player':
			noti.text = "Cut"
			play_notification("second")
			player_turn_taken = false
			resume_player_turn()
		
		elif current_player == 'ai':
			noti.text = "Cut"
			play_notification("second")
			player_turn_taken = false
			stop_player_turn()
			await ai_play_turn()
			resume_player_turn()


func fetch (top_card : CardRes, below_card : CardRes) -> void:
	var first_rule = (top_card.number != below_card.number)
	var first_rule_2 = (top_card.type == below_card.type)
	var second_rule = (top_card.number == below_card.number)
	var second_rule_2 = (top_card.type != below_card.type)
	if first_rule and first_rule_2 and top_card.number == 10 or second_rule and second_rule_2 and top_card.number == 10:
		if current_player == "player":
			noti.text = "Fetch"
			play_notification("second")
			ai_go_to_market()
		elif current_player == "ai":
			noti.text = "Fetch"
			play_notification("second")
			await take_from_market_player()
			resume_player_turn()


func _on_market_btn_pressed() -> void:
	if can_only_play_num_two == true or can_only_play_num_five == true:
		if market_deck.res.stack.size() < 3:
			await refill_market()
		if can_only_play_num_five == true:
			take_from_market_player(3)
			can_only_play_num_five = false
			last_no_five_card_played_by = 'ai'
			#card_blocking = false
			went_to_market = true
		else:
			take_from_market_player(2)
			last_no_two_card_played_by = 'ai'
			#card_blocking = false
			can_only_play_num_two = false
			went_to_market = true
		
		## stop market glow animation
		var anin = $market_deck/glow
		var ani_res = anin.get_animation("glow")
		ani_res.loop_mode = Animation.LOOP_NONE
		stop_player_turn()
	else:
		take_from_market_player()
		stop_player_turn()


func play_notification (value : String) -> void:
	# first, second
	if value == 'first':
		$notification/AnimationPlayer.play("fade")
	else :
		$notification/AnimationPlayer.play("show")
		
func player_wins () -> bool:
	if player_deck.res.stack.size() == 0 and can_only_play_num_two == false and can_only_play_num_five == false:
		result_text.text = "VICTORY"
		canvas_layer.visible = true
		return true
	return false
	
func ai_wins () -> bool:
	if opp_deck_ai.res.stack.size() == 0 and can_only_play_num_two == false and can_only_play_num_five == false:
		result_text.text = "DEFEAT"
		canvas_layer.visible = true
		return true
	return false
