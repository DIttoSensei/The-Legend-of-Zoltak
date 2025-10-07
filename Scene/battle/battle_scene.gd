extends Node2D

var player_roll
var enemy_roll
var text
var battling : bool = false

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



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_player_actions()
	text = "YOU ENCOINTERED THE [color=red]RAGING KNIGHT[/color]"
	enable_button()
	SceneTransition.fade_in()
	announcer_text(text)
	randomize()
	SignalManager.player_attack_data
	SignalManager.enemy_attack_data.connect(enemy_attack)
	

func disable_button () -> void:
	attack.disabled = true
	inventory.disabled = true
	run.disabled = true

func enable_button () -> void:
	attack.disabled = false
	inventory.disabled = false
	run.disabled = false
	
func _process(delta: float) -> void:
	if battling == true:
		disable_button()
	else:
		enable_button()

func _on_attack_pressed() -> void:
	$"Control/action display".visible = true
	#$overlay.visible = true
	pass # Replace with function body.


func _on_roll_pressed() -> void:
	battling = true
	$overlay/roll.visible = false
	$overlay/Sprite2D/AnimationPlayer.play("roll_animation")
	await  get_tree().create_timer(3.2).timeout
	player_roll = randi_range(1,20)
	enemy_roll = randi_range(1,20)
	$overlay/Sprite2D/counter.text = str(player_roll)
	await get_tree().create_timer(1.5).timeout
	$overlay.visible = false
	
	#reset
	$overlay/roll.visible = true
	$overlay/Sprite2D/counter.text = str(20)
	start_battle()
	
	
func start_battle () -> void:
	
	var p_speed = player_roll + player.dex
	var e_speed = enemy_roll + enemy.dex
	
	if e_speed > p_speed:
		enemy.attack_player()
	else:
		pass

func enemy_attack (enemy_name, move_name, damage, anim_name) -> void:
	text = "[center]" + "[color=red]"+ enemy_name + "[/color]" + " USED " + move_name + "[/center]"
	announcer_text(text)
	await get_tree().create_timer(2).timeout
	enemy_animation.play(anim_name)
	SignalManager.player_damaged.emit(damage)
	
	# Say it the player turn then run the player atk func
	
	await get_tree().create_timer(2).timeout
	battling = false






func announcer_text (text) -> void:
	announcer.visible_characters = 0
	announcer.text = text
	timer.start()
	
func _on_timer_timeout() -> void:
	announcer.visible_characters += 1
	
	if announcer.text.length() == announcer.visible_characters:
		timer.stop()
		


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	enemy_animation.play("idle")
	enemy_animation.seek(0.0, true)
	pass # Replace with function body.


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
		
