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


var count : int = 0
var current_play_card
var current_player : String = "" # player or ai
var player_turn_taken := false
var ai_turn_taken := false
var card_blocking := false

## for player
var can_only_play_num_two : bool = false

const PLAYER_CARD = preload("res://Scene/jolly_joker/player_card.tscn")


func _ready() -> void:
	SceneTransition.fade_in()
	SignalManager.play_player_card.connect(play_player_card)
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
		await tween.finished
		## counter
		var current_num = int($player_deck/counter/Label.text)
		current_num += 1
		$player_deck/counter/Label.text = str(current_num)
		
	for i in 4:
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
		tween.tween_property(sprite, "position", Vector2(898,-625), 0.15)
		await tween.finished
		## counter
		var current_num = int($opp_deck_ai/counter/Label.text)
		current_num += 1
		$opp_deck_ai/counter/Label.text = str(current_num)
		
	var sprite = Sprite2D.new()
	var first_play_card : CardRes = market_deck.res.stack.pop_at(randi() % market_deck.res.stack.size())
	sprite.scale = Vector2(0.288,0.288)
	spawn.add_child(sprite)
	sprite.position = Vector2(105,147)
	sprite.texture = first_play_card.img
	main.res.stack.append(first_play_card)
	
	sprite.reparent(main_stack_holder)
	var tween = create_tween()
	tween.tween_property(sprite, "position", Vector2(181,253.1), 0.15)
	tween.parallel().tween_property(sprite, "scale", Vector2(0.499,0.499), 0.15)
	
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
			var tween = create_tween()
			tween.tween_property(i, "position", Vector2(-2753.472, 0), 0.1)
			await tween.finished
			i.queue_free()
		await get_tree().create_timer(0.2).timeout
		player_btn.disabled = false
	else:
		var new_card : Sprite2D = PLAYER_CARD.instantiate()
		new_card.scale = Vector2(1,1)
		placeholder.add_child(new_card)
		new_card.position = Vector2(-2753.472, 0)
		new_card.texture = player_deck.res.stack[count].img
		
		
	
		var tween = create_tween()
		tween.tween_property(new_card, "position", Vector2(-3.472, 0), 0.15 )
		tween.tween_property(new_card, "scale", Vector2(1.051,1.051), 0.05)
		tween.tween_property(new_card, "scale", Vector2(1,1), 0.1)
		current_play_card = count
		count += 1
		#count %= player_deck.res.stack.size()
	

func play_player_card (card : Sprite2D) -> void:
	current_player = "player"
	if count < 0:
		count = 0
	count -= 1
	
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
		
	card.reparent(main_stack_holder)
	var tween = create_tween()
	tween.tween_property(card, "position", Vector2(181,253.1), 0.15)
	tween.parallel().tween_property(card, "scale", Vector2(0.499,0.499), 0.15)
	tween.tween_property(card, "scale", Vector2(0.55,0.55), 0.05)
	tween.tween_property(card, "scale", Vector2(0.499,0.499), 0.1)
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
	player_turn_taken = true
	for i in itration:
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
		var random_item : CardRes = market_deck.res.stack.pop_at(randi() % market_deck.res.stack.size())
		print ("Player takes from market: ", random_item.type, " ", random_item.number)
		player_deck.res.stack.append(random_item)
		update_player_counter()
		await tween.finished
	spawn.clear_children()
	
	#print ("player_new_decl: " ,player_deck.res.stack.size())
	stop_player_turn()
	
	await get_tree().create_timer(1).timeout
	ai_play_turn()

func stop_player_turn () -> void:
	market_btn.disabled = true
	player_btn.disabled = true
	
	for child in placeholder.get_children():
		var btn : Button = child.get_node_or_null("card_btn")
		btn.disabled = true
	
func resume_player_turn () -> void:
	await get_tree().create_timer(1).timeout
	market_btn.disabled = false
	player_btn.disabled = false
	
	for child in placeholder.get_children():
		var btn : Button = child.get_node_or_null("card_btn")
		btn.disabled = false


func ai_play_turn () -> void:
	if main.res.stack.size() == 0: # if there is no card on the table play a random one
		var random_card = randi() % opp_deck_ai.res.stack.size()
		#print ("Ai picks random: ",opp_deck_ai.res.stack[random_card].number)
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
			
			

func ai_play_card (card_texture : Texture2D, index : int) -> void:
	current_player = "ai"
	var sprite = Sprite2D.new()
	main_stack_holder.add_child(sprite)
	sprite.scale = Vector2(0.288,0.288)
	sprite.position = Vector2(580,-503)
	sprite.texture = card_texture
	
	var tween = create_tween()
	tween.tween_property(sprite, "position", Vector2(181,253.1), 0.15)
	tween.parallel().tween_property(sprite, "scale", Vector2(0.499,0.499), 0.15)
	tween.tween_property(sprite, "scale", Vector2(0.55,0.55), 0.05)
	tween.tween_property(sprite, "scale", Vector2(0.499,0.499), 0.1)
	
	var play_card : CardRes = opp_deck_ai.res.stack.pop_at(index)
	print ("AI played: ", play_card.type, " ", play_card.number)
	main.res.stack.append(play_card)
	update_ai_counter()
	
	
	await get_tree().create_timer(0.5).timeout
	table_rule_check()
	
	


func ai_go_to_market (itration : int = 1) -> void:
	for i in itration:
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
		tween.tween_property(sprite, "position", Vector2(898,-625), 0.15)
		await tween.finished
		var random_item : CardRes = market_deck.res.stack.pop_at(randi() % market_deck.res.stack.size())
		print ("AI takes from market: ", random_item.type, " ", random_item.number)
		opp_deck_ai.res.stack.append(random_item)
		update_ai_counter()
		#print ("AI CARD: ", opp_deck_ai.res.stack.size())
	
	spawn.clear_children()
	
	resume_player_turn()


func table_rule_check () -> void:
	if main.res.stack.size() == 1:
		if player_turn_taken == true:
			resume_player_turn()
		return
	var top_played_card : CardRes = main.res.stack[-1]
	var below_played_card : CardRes = main.res.stack[-2]
	
	# Junkie
	if current_player == 'player':
		await Junkie(top_played_card,below_played_card,player_deck)
		if card_blocking != true:
			await snag_two(top_played_card,below_played_card)
		else:
			card_blocking = false
		await get_tree().create_timer(1).timeout
		
		#
	
	elif current_player == 'ai':
		if card_blocking != true: # if ai playing same card to block player card effects
			await snag_two(top_played_card,below_played_card)
		else:
			card_blocking = false
		if player_turn_taken == true:
			resume_player_turn()
			player_turn_taken = false
	
	if player_turn_taken == true:
			ai_play_turn()
		
		


## Table rules
func Junkie (top_card : CardRes, below_card : CardRes, target_deck) -> void:
	if top_card.number != below_card.number and top_card.type != below_card.type:
		# first have the children of the nodes in reverse
		var children = main_stack_holder.get_children()
		children.reverse()
		for child in children: # go thorugh all children in reverse and perform animation
			child.reparent(spawn)
			var tween = create_tween()
			tween.tween_property(child, "position", Vector2(105,1011.1), 0.1)
			tween.parallel().tween_property(child, "scale", Vector2(0.288,0.288), 0.1)
			
			if current_player == 'player':
				## counter
				var current_num = int($player_deck/counter/Label.text)
				current_num += 1
				$player_deck/counter/Label.text = str(current_num)
			elif current_player == 'ai':
				update_ai_counter()
			await tween.finished
		# show notification
		noti.text = "Junkie"
		noti_ani.play('fade')
		
		spawn.clear_children() # delete children node
		main.res.stack.reverse() # Doing this cause so the current card on top of the main deck becomes the last card in target deck
		target_deck.res.stack.append_array(main.res.stack) # remove all res from main and add to target
		main.res.stack.clear()
		

func snag_two (top_card : CardRes, below_card : CardRes) -> void:
	var set_type = (top_card.number == below_card.number) if card_blocking else (top_card.number != below_card.number)
	# pick 2
	if top_card.type == below_card.type and top_card.number == 2 and set_type:
		# AI to pick two or block
		if current_player == "player":
			var not_found : bool = false
			for i in opp_deck_ai.res.stack:
				var index : int = 0
				if i.number == 2: #found card to block
					#print ("i have 2:", i.number)
					ai_play_card(i.img,index)
					card_blocking = true
					index = 0
					not_found = false
					break
				else:
					index += 1
					not_found = true
			# AI dosen't have two? pick from market
			if not_found == true:
				ai_go_to_market(2)
		
		# Player to pick two or block
		if current_player == 'ai':
			# block all card that are not two to prvent play
			can_only_play_num_two = true
			
			## Play market glow animation
			var anin = $market_deck/glow
			var ani_res = anin.get_animation("glow")
			ani_res.loop_mode = Animation.LOOP_LINEAR
			anin.play("glow")


func _on_market_btn_pressed() -> void:
	if can_only_play_num_two == true:
		take_from_market_player(2)
		can_only_play_num_two = false
		## stop market glow animation
		var anin = $market_deck/glow
		var ani_res = anin.get_animation("glow")
		ani_res.loop_mode = Animation.LOOP_NONE
		stop_player_turn()
	else:
		take_from_market_player()
		stop_player_turn()
