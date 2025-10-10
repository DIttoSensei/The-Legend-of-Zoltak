class_name Enemy extends Sprite2D

var atk : int
var def : int
var dex : int
var enemy_damage
var current_hp

@export var enemy_data : Enemies_res

@onready var enemy_hp: TextureProgressBar = $"../enemy_hp"
@onready var player: Player = $"../player"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_enemy_data()
	
	SignalManager.enemy_damaged.connect(take_damage)
	pass # Replace with function body.


func set_enemy_data () -> void:
	# set the HP
	enemy_hp.max_value = enemy_data.hp
	enemy_hp.value = enemy_hp.max_value
	current_hp = enemy_hp.value
	
	# set the stat
	atk = enemy_data.atk
	def = enemy_data.def
	dex = enemy_data.dex
	
func attack_player () -> void:
	# while true pick a random action 
	while true:
		var random_index = randi_range(0, enemy_data.actions.size() -1)
		var move = enemy_data.actions[random_index]
	
		# If the current cooldown is 0 proceed if not pick another action
	
		if move.current_cooldown == 0:
			var move_name : String = move.action_name # move name
			var move_damage : int = move.action_attribute
	
			var damage = move_damage + (move_damage * atk / 100) # new damage with state modifer
		
			var crit_rate = int(move.critical_rate.trim_suffix("%"))
	
			var roll = randi_range(0,100)
			
			
			if roll < crit_rate: # if you lucky higher critical rate
				damage *= 2
				
			# for the animation for the action
			var anim_name : String
			if random_index == 0:
				anim_name = "attack_1"
			elif random_index == 1:
				anim_name = "attack_2"
			elif random_index == 2:
				anim_name = "attack_3"
			elif random_index == 3:
				anim_name = "attack_4"
			elif random_index == 4:
				anim_name = "attack_5"
				
			# set cooldown
			move.current_cooldown = move.cooldown
			
			# send signal
			var enemy_name = enemy_data.name
			SignalManager.enemy_attack_data.emit(enemy_name, move_name, damage, anim_name)
			break

func take_damage (damage : int) -> void:
	enemy_damage = damage
	pass

func _on_hitbox_area_entered(_area: Area2D) -> void:
	$AnimationPlayer.play("hit")
	$"../enemy_dmg hit".text = str (enemy_damage)
	$emeny_dmg.play("dmg")
	current_hp -= enemy_damage
	enemy_hp.value = current_hp
	
	await get_tree().create_timer(0.5).timeout
	player.set_battle_stat()
	pass # Replace with function body.


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if _anim_name == "death":
		$AnimationPlayer.stop()
		return
		
	$AnimationPlayer.play("idle")
	$AnimationPlayer.seek(0.0, true)
	pass # Replace with function body.
