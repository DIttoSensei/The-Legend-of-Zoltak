extends Node2D

var player_roll
var enemy_roll
var text
var battling : bool = false
var current_action : Actions
var enemy_take_turn : bool = false
var player_take_turn : bool = false

# modifers
var player_atk_mod 
var player_def_mod
var player_dex_mod

@onready var player: Player = $Control/player
@onready var enemy: Enemy = $Control/enemy
@onready var announcer: RichTextLabel = $"Control/top info/announcer"
@onready var timer: Timer = $"Control/top info/Timer"
@onready var enemy_animation: AnimationPlayer = $Control/enemy/AnimationPlayer
@onready var player_dmg_hit: Label = $"Control/player/dmg hit"
@onready var player_dmg_info: AnimationPlayer = $Control/player/dmg_info
@onready var attack: TextureButton = $Control/attack
@onready var inventory: TextureButton = $Control/inventory
@onready var run: TextureButton = $Control/run
@onready var action_container: ActionContainer = $"Control/action display/ScrollContainer/action container"
@onready var results: CanvasLayer = $results



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_player_actions()

	
	text = "YOU ENCOINTERED THE [color=red]RAGING KNIGHT[/color]"
	enable_button()
	SceneTransition.fade_in()
	announcer_text(text)
	randomize()
	SignalManager.player_attack_data.connect(player_attack)
	SignalManager.enemy_attack_data.connect(enemy_attack)
	SignalManager.player_attack.connect(show_and_store_attack)
	

func disable_button () -> void:
	attack.disabled = true
	inventory.disabled = true
	run.disabled = true

func enable_button () -> void:
	attack.disabled = false
	inventory.disabled = false
	run.disabled = false
	

func _on_attack_pressed() -> void:
	if battling == true:
		disable_button()
	else:
		enable_button()
		$"Control/action display".visible = true
	pass # Replace with function body.


func _on_roll_pressed() -> void:
	battling = true
	$overlay/roll.visible = false
	$overlay/Sprite2D/AnimationPlayer.play("roll_animation")
	await  get_tree().create_timer(1.2).timeout
	
	# roll
	player_roll = randi_range(1,20)
	player_roll_modifer(player_roll)
	enemy_roll = randi_range(1,20)
	
	$overlay/Sprite2D/counter.text = str(player_roll)
	await get_tree().create_timer(1.5).timeout
	$overlay.visible = false
	
	#reset
	$overlay/roll.visible = true
	$overlay/Sprite2D/counter.text = str(20)
	

	start_battle()
	
	
func player_roll_modifer (roll : int) -> void:
	player_atk_mod = int(player.final_atk * (0.5 + (roll/20.0)))
	
	var critical_rate = int(current_action.action_data.critical_rate.trim_suffix("%"))
	var chance = randi_range(0,100)
	if chance < critical_rate:
		player_atk_mod *= 2
	player_atk_mod += current_action.action_data.action_attribute
	
	player_def_mod = int(player.final_def * (0.5 + (roll/20.0)))
	player_dex_mod = int(player.final_dex * (0.5 + (roll/20.0)))
	pass
	
	player.set_roll_stat_view(player_atk_mod,player_def_mod,player_def_mod)
	
	
	
func start_battle () -> void:
	
	var p_speed = player_roll + player_dex_mod
	var e_speed = enemy_roll + enemy.dex
	
	if e_speed > p_speed:
		enemy.attack_player()
		enemy_take_turn = true
	else:
		player_attack()
		player_take_turn = true



func enemy_attack (enemy_name, move_name, damage, anim_name) -> void:
	text = "[center]" + "[color=red]"+ enemy_name + "[/color]" + " USED " + move_name + "[/center]"
	announcer_text(text)
	await get_tree().create_timer(2).timeout
	enemy_animation.play(anim_name)
	
	damage = max(0, damage - player_def_mod) # player def deducts damage
	SignalManager.player_damaged.emit(damage)
	
	
	await get_tree().create_timer(1.5).timeout
	# Check if player has no hp left
	if player.current_hp == 0:
		game_over()
		## Switch scene to game over menu
		return
		
	
	if player_take_turn == false:
		await get_tree().create_timer(1.5).timeout
		text = "[center]You took damage, now it's your turn[/center]"
		announcer_text(text)
		player_attack()
		return
		
	player_take_turn = false
	await get_tree().create_timer(3).timeout
	battling = false
	
	if battling == false:
		enable_button()


func player_attack() -> void:
	var action = current_action.action_data
	await get_tree().create_timer(2).timeout
	text = "[center]You used " +"[color=green]" + action.action_name + "[/color][/center]"
	announcer_text(text)
	await get_tree().create_timer(2).timeout
	player.play("attack")
	$Control/player/hit_box_hit.play("hit")
	SignalManager.enemy_damaged.emit(player_atk_mod)
	
	if enemy_take_turn == false: # check if enemy hasn't attacked
		await get_tree().create_timer(1.5).timeout
		text = "[center]Opponent took damage, now it's their turn[/center]"
		announcer_text(text)
		enemy.attack_player()
		
	enemy_take_turn = false
	battling = false
	if battling == false:
		enable_button()
		

func announcer_text (text) -> void:
	announcer.visible_characters = 0
	announcer.text = text
	timer.start()
	
func _on_timer_timeout() -> void:
	announcer.visible_characters += 1
	
	if announcer.text.length() == announcer.visible_characters:
		timer.stop()
		





# for action
func _on_exit_pressed() -> void:
	$"Control/action display".visible = false
	pass # Replace with function body.
	
func load_player_actions () -> void:
	var actions_container = action_container.data.actions
	actions_container.clear()
	actions_container.resize(GlobalGameSystem.current_player_actions.size())
	for i in range(GlobalGameSystem.current_player_actions.size()):
		actions_container[i] = GlobalGameSystem.current_player_actions[i]
		action_container.update_slots()


# for using attacks 
func show_and_store_attack (action_data) -> void:
	$"Control/action display/use_action".visible = true # make the use button visible 
	current_action = action_data # store the action selected in a var


func _on_use_action_pressed() -> void:
	$"Control/action display".visible = false
	$"Control/action display/use_action".visible = false
	$overlay.visible = true
	pass # Replace with function body.
	
	
# Game over function
func game_over () -> void:
	player.stop()
	player.modulate = "0000007f"
	$results/result_text.text = "DEFEAT"
	results.visible = true
		
	await  get_tree().create_timer(2).timeout
	results.visible = false
	SceneTransition.battle_open()
	await get_tree().create_timer(1.5).timeout
		
	LevelManager.load_new_level = "res://Scene/game_over.tscn"
	LevelManager.load_level()
	pass
