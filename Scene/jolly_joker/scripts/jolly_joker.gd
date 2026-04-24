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
	card.reparent(main_stack_holder)
	var tween = create_tween()
	tween.tween_property(card, "position", Vector2(181,253.1), 0.15)
	tween.parallel().tween_property(card, "scale", Vector2(0.499,0.499), 0.15)
	tween.tween_property(card, "scale", Vector2(0.55,0.55), 0.05)
	tween.tween_property(card, "scale", Vector2(0.499,0.499), 0.1)
	var play_card : CardRes = player_deck.res.stack.pop_at(current_play_card)
	main.res.stack.append(play_card)
	
	stop_player_turn()
	await get_tree().create_timer(0.5).timeout
	table_rule_check()
	#ai_play_turn()



func stop_player_turn () -> void:
	market_btn.disabled = true
	player_btn.disabled = true
	
	for child in placeholder.get_children():
		var btn : Button = child.get_node_or_null("card_btn")
		btn.disabled = true
	
func resume_player_turn () -> void:
	market_btn.disabled = false
	player_btn.disabled = false
	
	for child in placeholder.get_children():
		var btn : Button = child.get_node_or_null("card_btn")
		btn.disabled = false


func ai_play_turn () -> void:
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
			print ("Checking next card")
			index += 1
	if go_to_market == true:
		print ("go to markey")
		ai_go_to_market()
		pass
			

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
	main.res.stack.append(play_card)
	
	for m in main.res.stack:
		print(m.number)


func ai_go_to_market () -> void:
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
	
	var random_item : CardRes = market_deck.res.stack.pop_at(randi() % market_deck.res.stack.size())
	opp_deck_ai.res.stack.append(random_item)
	print ("AI CARD: ", opp_deck_ai.res.stack.size())
	await tween.finished
	spawn.clear_children()


func table_rule_check () -> void:
	var last_played_card_res : CardRes = main.res.stack[-1]
	var current_played_card_res : CardRes = main.res.stack[-2]
	
	# Eating the pile
	if current_played_card_res.number != last_played_card_res.number and current_played_card_res.type != last_played_card_res.type:
		# first have the children of the nodes in reverse
		var children = main_stack_holder.get_children()
		children.reverse()
		for child in children: # go thorugh all children in reverse and perform animation
			child.reparent(spawn)
			var tween = create_tween()
			tween.tween_property(child, "position", Vector2(105,1011.1), 0.1)
			tween.parallel().tween_property(child, "scale", Vector2(0.288,0.288), 0.1)
			await tween.finished
		# show notification
		noti.text = "Eating the Pile"
		noti_ani.play('fade')
		
		spawn.clear_children() # delete children node
		player_deck.res.stack.append_array(main.res.stack) # remove all res from main and add to player
		main.res.stack.clear()
		
			
		
