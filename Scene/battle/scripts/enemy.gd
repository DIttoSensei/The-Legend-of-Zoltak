class_name Enemy extends Sprite2D

var text : String
var atk : int
var def : int
var dex : int
var current_dex : int
var current_atk : int
var current_def : int
var enemy_hex_modifier : int = 0
var value_multipliyer : int = 0
var enemy_damage
var current_hp
var current_move : Action
var current_animation
var enemy_name
var status_animation := false
var current_status_animation : String
var status_chance : int = 100


@export var enemy_data : Enemies_res

@onready var enemy_hp: TextureProgressBar = $"../enemy_hp"
@onready var player: Player = $"../player"
@onready var camera: Camera2D = $"../Camera2D"
@onready var battle_scene: Node2D = $"../.."

@onready var enemy_effects: AnimatedSprite2D = $enemy_effect
@onready var enemy_effects_2: AnimatedSprite2D = $enemy_effects2
@onready var enemy_effect_3: AnimatedSprite2D = $enemy_effect3
@onready var _4: AnimatedSprite2D = $"4"
@onready var _5: AnimatedSprite2D = $"5"
@onready var _6: AnimatedSprite2D = $"6"


## Status effect 1 (enemy to self or player)
var enemy_heal_status : Dictionary = {"active" : false, 'icon_on' : false, 'turn' : 0, 'duration' : 4, 
'texture' : 'res://Scene/battle/img/status_icon/heal.png', 'percentage' : 40.0, 'value' : 0}
var enemy_defence_status : Dictionary = {"active" : false, 'icon_on' : false, 'turn' : 0, 'duration' : 4, 
'texture' : 'res://Scene/battle/img/status_icon/defence.png', 'percentage' : 5.0, 'value' : 0}
var enemy_hex_status : Dictionary = {"active" : false, 'icon_on' : false, 'turn' : 0, 'duration' : 4, 
'texture' : 'res://Scene/battle/img/status_icon/hex.png', 'percentage' : 5.0, 'value' : 0}
var enemy_shadow_status : Dictionary = {"active" : false, 'icon_on' : false, 'turn' : 0, 'duration' : 4, 
'texture' : 'res://Scene/battle/img/status_icon/shadow.png', 'percentage' : 5.0, 'value' : 0}

# Status effecs
var fire_status : Dictionary = {"active" : false, 'icon_on' : false, 'turn' : 0, 'duration' : 5, 
'texture' : 'res://Scene/battle/img/status_icon/fire_2.png', 'percentage' : 5.0}
var water_status : Dictionary = {"active" : false, 'icon_on' : false, 'turn' : 0, 'duration' : 4, 
'texture' : 'res://Scene/battle/img/status_icon/water.png', 'percentage' : 5.0}
var lightning_status : Dictionary = {"active" : false, 'icon_on' : false, 'turn' : 0, 'duration' : 5, 
'texture' : 'res://Scene/battle/img/status_icon/lightning.png', 'percentage' : 5.0}
var ice_status : Dictionary = {"active" : false, 'icon_on' : false, 'turn' : 0, 'duration' : 3, 
'texture' : 'res://Scene/battle/img/status_icon/ice.png', 'percentage' : 5.0}
var wind_status : Dictionary = {"active" : false, 'icon_on' : false, 'turn' : 0, 'duration' : 4, 
'texture' : 'res://Scene/battle/img/status_icon/wind.png', 'percentage' : 5.0}
var earth_status : Dictionary = {"active" : false, 'icon_on' : false, 'turn' : 0, 'duration' : 4, 
'texture' : 'res://Scene/battle/img/status_icon/earth.png', 'percentage' : 5.0}


var attack_down_status : Dictionary = {"active" : false, 'icon_on' : false, 'turn' : 0, 'duration' : 4, 
'texture' : 'res://Scene/battle/img/status_icon/attack_down.png', 'percentage' : 5.0}
var def_breaker_status : Dictionary = {"active" : false, 'icon_on' : false, 'turn' : 0, 'duration' : 4, 
'texture' : 'res://Scene/battle/img/status_icon/def_breaker.png', 'percentage' : 5.0}
var psychic_status : Dictionary = {"active" : false, 'icon_on' : false, 'turn' : 0, 'duration' : 4, 
'texture' : 'res://Scene/battle/img/status_icon/psychic.png', 'percentage' : 5.0}
var shadow_status : Dictionary = {"active" : false, 'icon_on' : false, 'turn' : 0, 'duration' : 4, 
'texture' : 'res://Scene/battle/img/status_icon/shadow.png', 'percentage' : 5.0}
var bleed_status : Dictionary = {"active" : false, 'icon_on' : false, 'turn' : 0, 'duration' : 3, 
'texture' : 'res://Scene/battle/img/status_icon/bleed.png', 'percentage' : 5.0}
var poisen_status : Dictionary = {"active" : false, 'icon_on' : false, 'turn' : 0, 'duration' : 6, 
'texture' : 'res://Scene/battle/img/status_icon/poison.png', 'percentage' : 5.0}


var paralized : bool = false
var frozen : bool = false
var confused: bool = false

@onready var enemy_status_effect: Control = $"../enemy_status_effect"

# status icon



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_enemy_data()
	
	SignalManager.enemy_damaged.connect(take_damage)
	enemy_name = enemy_data.name
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
	
	current_dex = dex # store original dex value
	current_atk = atk # store original atk power
	current_def = def # store original def status
	
func attack_player () -> void:
	# while true pick a random action 
	while true:
		var random_index = randi_range(0, enemy_data.actions.size() -1)
		var move = enemy_data.actions[random_index]
		current_move = move
	
		# If the current cooldown is 0 proceed if not pick another action
	
		if move.current_cooldown == 0:
			var move_name : String = move.action_name # move name
			var move_damage : int = move.action_attribute
			var damage
			if enemy_hex_modifier == 0:
				damage = move_damage + (move_damage * atk / 100) # new damage with state modifer
			else:
				damage = enemy_hex_modifier + (enemy_hex_modifier * atk / 100) # new damage with state modifer
				
			var crit_rate = int(move.critical_rate.trim_suffix("%"))
	
			var roll = randi_range(0,100)
			
			
			if roll < crit_rate: # if you lucky higher critical rate
				battle_scene.enemy_critical_hit = true
				damage *= 2
				
			# for the animation for the action
			var anim_name : String
			if random_index == 0:
				anim_name = "attack_1"
				current_animation = anim_name
			elif random_index == 1:
				anim_name = "attack_2"
				current_animation = anim_name
			elif random_index == 2:
				anim_name = "attack_3"
				current_animation = anim_name
			elif random_index == 3:
				anim_name = "attack_4"
				current_animation = anim_name
			elif random_index == 4:
				anim_name = "attack_5"
				current_animation = anim_name
				
			# set cooldown
			move.current_cooldown = move.cooldown
			
			# send signal
			var enemy_name = enemy_data.name
			SignalManager.enemy_attack_data.emit(enemy_name, move_name, damage, anim_name)
			break
		
		else:
			move.current_cooldown -= 1
			if move.current_cooldown < 0:
				move.current_cooldown = 0
			break

func take_damage (damage : int) -> void:
	enemy_damage = damage
	pass

func _on_hitbox_area_entered(_area: Area2D) -> void:
	if battle_scene.player_critical_hit == true:
		GlobalGameSystem.hit_stop(0.05, 0.15) #perform hitstop
		Input.vibrate_handheld(50, 1.0) # VIBRATE DEVICE 
		battle_scene.player_critical_hit = false
		$criti.play("show")
		
	#GlobalGameSystem.hit_stop(0.05, 0.2) #perform hitstop
	camera.shake() # shake screen
	Input.vibrate_handheld(140, 1.0) # VIBRATE DEVICE 
	$AnimationPlayer.play("hit")
	$"../enemy_dmg hit".text = str (enemy_damage)
	$emeny_dmg.play("dmg")
	current_hp -= enemy_damage
	enemy_hp.value = current_hp
	
	await get_tree().create_timer(0.5).timeout
	player.set_battle_stat()
	
	# check set and control status effect
	
	pass # Replace with function body.


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if _anim_name == "death":
		$AnimationPlayer.stop()
		return
	if frozen == true:
		$AnimationPlayer.stop()
		return
		
	$AnimationPlayer.play("idle")
	$AnimationPlayer.seek(0.0, true)
	
	# once main animation ends check if we still have a status animation to play
	if status_animation == true:
			enemy_effects.play(current_status_animation)
			enemy_effects.visible = true
	pass # Replace with function body.



func perform_action (damage, player_def_mod) -> void:
	
	## Physical modifer
	if current_move.action_type == "Physical":
		
		# if there is a status effect animation current stop it for the mean time
		if status_animation == true:
			enemy_effects.stop()
			enemy_effects.visible = false
		
		$AnimationPlayer.play(current_animation)
		damage = max(0, damage - int((player_def_mod / 2))) # player def deducts damage
		SignalManager.player_damaged.emit(damage)
		
	elif current_move.action_type == "Fire":
		
		# if there is a status effect animation current stop it for the mean time
		if status_animation == true:
			enemy_effects.stop()
			enemy_effects.visible = false
		
		$AnimationPlayer.play(current_animation)
		damage = max(0, damage - int((player_def_mod / 2))) # player def deducts damage
		SignalManager.player_damaged.emit(damage)
		
		if player.fire_status.active == true:
			return
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			player.fire_status.active = true
	
	elif current_move.action_type == "Water":
		# if there is a status effect animation current stop it for the mean time
		if status_animation == true:
			enemy_effects.stop()
			enemy_effects.visible = false
		
		$AnimationPlayer.play(current_animation)
		damage = max(0, damage - int((player_def_mod / 2))) # player def deducts damage
		SignalManager.player_damaged.emit(damage)
		
		if player.water_status.active == true:
			return
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			player.water_status.active = true
		pass
	
	elif current_move.action_type == "Lightning":
		# if there is a status effect animation current stop it for the mean time
		if status_animation == true:
			enemy_effects.stop()
			enemy_effects.visible = false
		
		$AnimationPlayer.play(current_animation)
		damage = max(0, damage - int((player_def_mod / 2))) # player def deducts damage
		SignalManager.player_damaged.emit(damage)
		
		if player.lightning_status.active == true:
			return
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			player.lightning_status.active = true
		
	elif current_move.action_type == "Ice":
		# if there is a status effect animation current stop it for the mean time
		if status_animation == true:
			enemy_effects.stop()
			enemy_effects.visible = false
		
		$AnimationPlayer.play(current_animation)
		damage = max(0, damage - int((player_def_mod / 2))) # player def deducts damage
		SignalManager.player_damaged.emit(damage)
		
		if player.ice_status.active == true:
			return
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			player.ice_status.active = true
		
	elif current_move.action_type == "Wind":
		# if there is a status effect animation current stop it for the mean time
		if status_animation == true:
			enemy_effects.stop()
			enemy_effects.visible = false
		
		$AnimationPlayer.play(current_animation)
		damage = max(0, damage - int((player_def_mod / 2))) # player def deducts damage
		SignalManager.player_damaged.emit(damage)
		
		if player.wind_status.active == true:
			return
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			player.wind_status.active = true
	
	elif current_move.action_type == "Earth":
		# if there is a status effect animation current stop it for the mean time
		if status_animation == true:
			enemy_effects.stop()
			enemy_effects.visible = false
		
		$AnimationPlayer.play(current_animation)
		damage = max(0, damage - int((player_def_mod / 2))) # player def deducts damage
		SignalManager.player_damaged.emit(damage)
		
		if player.earth_status.active == true:
			return
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			player.earth_status.active = true
		
	elif current_move.action_type == "Mystic":
		# if there is a status effect animation current stop it for the mean time
		if status_animation == true:
			enemy_effects.stop()
			enemy_effects.visible = false
		
		$"4".play('mystic')
		await get_tree().create_timer(1.8).timeout
		
		$AnimationPlayer.play(current_animation)
		#damage = max(0, damage - int((player_def_mod / 2))) # player def deducts damage
		SignalManager.player_damaged.emit(damage)
		
	elif current_move.action_type == "Heal":
		if enemy_heal_status.active == true:
			text = "[center]Opponent [color=green]Heal[/color] status fails[/center]"
			battle_scene.announcer_text(text)
			await get_tree().create_timer(1.5).timeout
			return
		enemy_heal_status.value = damage
		$"5".play("heal")
		text = "[center]Opponent [color=green]HP[/color] ticks up for 3 turns"
		battle_scene.announcer_text(text)
		await get_tree().create_timer(1.5).timeout
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			enemy_heal_status.active = true
		
	elif current_move.action_type == "Defence":
		if enemy_defence_status.active == true:
			text = "[center]Opponent [color=blue]ARMOR DEFENCE[/color] status failed[/center]"
			battle_scene.announcer_text(text)
			await get_tree().create_timer(1.5).timeout
			return
		enemy_defence_status.value = damage
		modulate_enemy_effects(_6, 0,0,100)
		_6.play("defence")
		text = "[center]Opponent [color=blue]ARMOR DEFENCE[/color] ticks up for 3 turns"
		battle_scene.announcer_text(text)
		await get_tree().create_timer(1.5).timeout
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			enemy_defence_status.active = true
	
	elif current_move.action_type == "Atk Down":
		# if there is a status effect animation current stop it for the mean time
		if status_animation == true:
			enemy_effects.stop()
			enemy_effects.visible = false
		
		$AnimationPlayer.play(current_animation)
		damage = max(0, damage - int((player_def_mod / 2))) # player def deducts damage
		SignalManager.player_damaged.emit(damage)
		
		if player.attack_down_status.active == true:
			return
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			player.attack_down_status.active = true
		
	elif current_move.action_type == "Def Breaker":
		# if there is a status effect animation current stop it for the mean time
		if status_animation == true:
			enemy_effects.stop()
			enemy_effects.visible = false
		
		$AnimationPlayer.play(current_animation)
		damage = max(0, damage - int((player_def_mod / 2))) # player def deducts damage
		SignalManager.player_damaged.emit(damage)
		
		if player.def_breaker_status.active == true:
			return
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			player.def_breaker_status.active = true
		
	elif current_move.action_type == "Psychic":
		# if there is a status effect animation current stop it for the mean time
		if status_animation == true:
			enemy_effects.stop()
			enemy_effects.visible = false
		
		$AnimationPlayer.play(current_animation)
		damage = max(0, damage - int((player_def_mod / 2))) # player def deducts damage
		SignalManager.player_damaged.emit(damage)
		
		if player.psychic_status.active == true:
			return
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			player.psychic_status.active = true
		
	elif current_move.action_type == "Hex":
		# if there is a status effect animation current stop it for the mean time
		if status_animation == true:
			enemy_effects.stop()
			enemy_effects.visible = false
		
		$AnimationPlayer.play(current_animation)
		
		damage = max(0, damage - int((player_def_mod / 2))) # player def deducts damage
		SignalManager.player_damaged.emit(damage)
		
		if enemy_hex_status.active == true:
			return
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			enemy_hex_status.active = true
			#text = "[center]Opponent activated [color=green]HEX[/color] status"
			#battle_scene.announcer_text(text)
		
	elif current_move.action_type == "Shadow":
		pass
		
	elif current_move.action_type == "Bleed":
		pass
		
	elif current_move.action_type == "Poison":
		pass


func status_effect () -> void:
	## FIRE
	if fire_status.active:
		text = "[center]" + enemy_name + ' has been ' + "[color=red]burned[/color][/center]"
		fire_status.turn += 1
		if fire_status.turn >= fire_status.duration:
			fire_status.active = false
			fire_status.icon_on = false
			fire_status.turn = 0
			clear_status_icon("fire_2.png")
	
		else:
			# deal damage, show status icon plus alart
			if fire_status.icon_on == true:
				var dmg = (fire_status.percentage / 100.0) * enemy_hp.max_value
				deal_status_dmg(dmg, "fire")
				
				
			else:
				check_if_status_icon_is_available(fire_status.texture) # set texture icon
				fire_status.icon_on = true
				battle_scene.announcer_text(text)
				var dmg = (fire_status.percentage / 100) * enemy_hp.max_value
				deal_status_dmg(dmg, "fire")
				
				
		await get_tree().create_timer(2.5).timeout
	
	## WATER
	if water_status.active:
		text = "[center]" + enemy_name  + "[color=blue] mobility[/color] has reduced[/center]"
		water_status.turn += 1
		if water_status.turn >= water_status.duration:
			water_status.active = false
			water_status.icon_on = false
			water_status.turn = 0
			clear_status_icon("water.png")
			dex = current_dex
			
		else:
			# Reduce speed and show status icon plus alart
			if water_status.icon_on == true:
				var dmg = (water_status.percentage / 45.0) * dex
				deal_status_dmg(dmg, "water")
				check_if_you_dead()
				
			else:
				check_if_status_icon_is_available(water_status.texture)
				water_status.icon_on = true
				battle_scene.announcer_text(text)
				var dmg = (water_status.percentage / 45.0) * dex
				deal_status_dmg(dmg, "water")
				check_if_you_dead()
	
		await get_tree().create_timer(2.5).timeout
	
	## LIGHTNING
	if lightning_status.active:
		text = "[center]" + enemy_name + ' has been ' + "[color=yellow]stunned[/color][/center]"
		lightning_status.turn += 1
		if lightning_status.turn >= lightning_status.duration:
			lightning_status.active = false
			lightning_status.icon_on = false
			lightning_status.turn = 0
			paralized = false
			battle_scene.status_active = false # allows status from main game check to be false
			clear_status_icon("lightning.png")
		
		else:
			if lightning_status.icon_on == true:
				# make enemy skip its turn
				check_if_you_dead()
			else:
				check_if_status_icon_is_available(lightning_status.texture)
				lightning_status.icon_on = true
				battle_scene.announcer_text(text)
				deal_status_dmg(0, "lightning")
				paralized = true
				check_if_you_dead()
				
		await get_tree().create_timer(2.5).timeout
	
	## ICE
	if ice_status.active:
		text = "[center]" + enemy_name + " has been[color=lightblue] frozen[/color] and can't move[/center]"
		ice_status.turn += 1
		if ice_status.turn >= ice_status.duration:
			$AnimationPlayer.play("idle")
			modulate = 'white'
			ice_status.active = false
			ice_status.icon_on = false
			ice_status.turn = 0
			frozen = false
			battle_scene.status_active = false # allows status from main game check to be false
			clear_status_icon("ice.png")
		
		else:
			if ice_status.icon_on == true:
				# make enemy skip its turn
				check_if_you_dead()
			else:
				check_if_status_icon_is_available(ice_status.texture)
				ice_status.icon_on = true
				battle_scene.announcer_text(text)
				deal_status_dmg(0, "ice")
				frozen = true
				check_if_you_dead()
				
	## WIND
	if wind_status.active:
		text = "[center]" + enemy_name + " is fighting against strong, pushing[color=lightgreen] wind[/color][/center]"
		wind_status.turn += 1
		if wind_status.turn >= wind_status.duration:
			wind_status.active = false
			wind_status.icon_on = false
			wind_status.turn = 0
			clear_status_icon("wind.png")
			dex = current_dex
		
		else:
			if wind_status.icon_on == true:
				# make enemy speed be reduced
				var dmg = (wind_status.percentage / 25.0) * dex
				deal_status_dmg(dmg, 'wind')
				check_if_you_dead()
			else:
				check_if_status_icon_is_available(wind_status.texture)
				wind_status.icon_on = true
				battle_scene.announcer_text(text)
				var dmg = (wind_status.percentage / 25.0) * dex
				deal_status_dmg(dmg, "wind")
				check_if_you_dead()
		await get_tree().create_timer(2.5).timeout
		
	## EARTH
	if earth_status.active:
		text = "[center]" + enemy_name + " defences have been pierced with [color=brown]rock [/color]shards[/center]"
		earth_status.turn += 1
		if earth_status.turn >= earth_status.duration:
			earth_status.active = false
			earth_status.icon_on = false
			earth_status.turn = 0
			clear_status_icon("earth.png")
			def = current_def
		
		else:
			if earth_status.icon_on == true:
				# make enemy def be reduced
				var dmg = (earth_status.percentage / 25.0) * def
				deal_status_dmg(dmg, 'earth')
				check_if_you_dead()
			else:
				check_if_status_icon_is_available(earth_status.texture)
				earth_status.icon_on = true
				battle_scene.announcer_text(text)
				var dmg = (earth_status.percentage / 25.0) * def
				deal_status_dmg(dmg, "earth")
				check_if_you_dead()
		await get_tree().create_timer(2.5).timeout
	
	## ENEMY HEAL
	if enemy_heal_status.active:
		text = "[center]Opponent [color=green]HP[/color] has slightly increased[/center]"
		enemy_heal_status.turn += 1
		if enemy_heal_status.turn >= enemy_heal_status.duration:
			enemy_heal_status.active = false
			enemy_heal_status.icon_on = false
			enemy_heal_status.turn = 0
			clear_status_icon("heal.png")
			
		
		else:
			if enemy_heal_status.icon_on == true:
				# increase enemy hp
				var value = (enemy_heal_status.percentage / 35.0) * enemy_heal_status.value
				await battle_scene.announcer_text(text)
				deal_status_dmg(value, 'heal')
				#check_if_you_dead()
			else:
				check_if_status_icon_is_available(enemy_heal_status.texture)
				enemy_heal_status.icon_on = true
				await battle_scene.announcer_text(text)
				var dmg = (enemy_heal_status.percentage / 35.0) * enemy_heal_status.value
				deal_status_dmg(dmg, "heal")
				#check_if_you_dead()
		await get_tree().create_timer(2.5).timeout
	
	## ENEMY DEFENCE
	if enemy_defence_status.active:
		text = "[center]Opponent [color=blue]ARMOR DEFENCE[/color] has slightly increased[/center]"
		enemy_defence_status.turn += 1
		if enemy_defence_status.turn >= enemy_defence_status.duration:
			enemy_defence_status.active = false
			enemy_defence_status.icon_on = false
			enemy_defence_status.turn = 0
			def = current_def
			clear_status_icon("defence.png")
			
		
		else:
			if enemy_defence_status.icon_on == true:
				# increase player defence
				var value = (enemy_defence_status.percentage /55.0) * enemy_defence_status.value
				battle_scene.announcer_text(text)
				deal_status_dmg(value, 'defence')
				#check_if_you_dead()
			else:
				check_if_status_icon_is_available(enemy_defence_status.texture)
				enemy_defence_status.icon_on = true
				battle_scene.announcer_text(text)
				var dmg = (enemy_defence_status.percentage / 55.0) * enemy_defence_status.value
				deal_status_dmg(dmg, "defence")
				#check_if_you_dead()
		await get_tree().create_timer(2.5).timeout
	
	## ATTACK DOWN
	if attack_down_status.active:
		text = "[center]" + enemy_name + "[color=red] ATTACK [/color]prowess is waning![/center]"
		attack_down_status.turn += 1
		if attack_down_status.turn >= attack_down_status.duration:
			attack_down_status.active = false
			attack_down_status.icon_on = false
			attack_down_status.turn = 0
			clear_status_icon("attack_down.png")
			modulate = "white"
			atk = current_atk
			enemy_effects.visible = false
			enemy_effects.stop()
			status_animation = false
			
		
		else:
			if attack_down_status.icon_on == true:
				# reduce enemy attacks
				var dmg = (attack_down_status.percentage / 25.0) * atk
				deal_status_dmg(dmg, 'attack_down')
				check_if_you_dead()
			else:
				check_if_status_icon_is_available(attack_down_status.texture)
				modulate_enemy_effects(enemy_effects, 100,0,0)
				enemy_effects.play("show")
				enemy_effects.visible = true
				current_status_animation = 'show'
				status_animation = true
				attack_down_status.icon_on = true
				battle_scene.announcer_text(text)
				var dmg = (attack_down_status.percentage / 25.0) * atk
				deal_status_dmg(dmg, "attack_down")
				check_if_you_dead()
		await get_tree().create_timer(2.5).timeout
	
	## DEFENCE BREAKER
	if def_breaker_status.active:
		text = "[center]" + enemy_name + "[color=blue] DEFENCE [/color]has been breached![/center]"
		def_breaker_status.turn += 1
		if def_breaker_status.turn >= def_breaker_status.duration:
			def_breaker_status.active = false
			def_breaker_status.icon_on = false
			def_breaker_status.turn = 0
			clear_status_icon("def_breaker.png")
			modulate = "white"
			def = current_def
			enemy_effects.visible = false
			enemy_effects.stop()
			status_animation = false
			
		
		else:
			if def_breaker_status.icon_on == true:
				# reduce enemy defence 
				var dmg = (def_breaker_status.percentage / 25.0) * def
				deal_status_dmg(dmg, 'def_breaker')
				check_if_you_dead()
			else:
				check_if_status_icon_is_available(def_breaker_status.texture)
				modulate_enemy_effects(enemy_effects, 0,0,100)
				enemy_effects.play("show")
				enemy_effects.visible = true
				current_status_animation = 'show'
				status_animation = true
				def_breaker_status.icon_on = true
				battle_scene.announcer_text(text)
				var dmg = (def_breaker_status.percentage / 25.0) * def
				deal_status_dmg(dmg, "def_breaker")
				check_if_you_dead()
		await get_tree().create_timer(2.5).timeout
	
	## PSYCHIC
	if psychic_status.active:
		text = "[center]" + enemy_name + ' has been drenched in' + "[color=purple] Psychic[/color] aura[/center]"
		psychic_status.turn += 1
		if psychic_status.turn >= psychic_status.duration:
			psychic_status.active = false
			psychic_status.icon_on = false
			psychic_status.turn = 0
			confused = false
			battle_scene.status_active = false # allows status from main game check to be false
			clear_status_icon("psychic.png")
			enemy_effects.visible = false
			enemy_effects.stop()
			status_animation = false
		
		else:
			if psychic_status.icon_on == true:
				# make enemy skip its turn
				check_if_you_dead()
			else:
				check_if_status_icon_is_available(psychic_status.texture)
				modulate_enemy_effects(enemy_effects, 100,1,100)
				modulate = "purple"
				$AnimationPlayer.play("hit")
				await get_tree().create_timer(0.4).timeout
				modulate = "white"
				enemy_effects.play("show")
				enemy_effects.visible = true
				current_status_animation = 'show'
				status_animation = true
				psychic_status.icon_on = true
				battle_scene.announcer_text(text)
				#deal_status_dmg(0, "lightning")
				confused = true
				
				
		await get_tree().create_timer(2.5).timeout
		pass

	## ENEMY HEX
	if enemy_hex_status.active:
		var hex_action = current_move
		text = "[center]Opponent [color=green]HEX[/color] based attack dmg grows 2x[/center]"
		enemy_hex_status.turn += 1
		if enemy_hex_status.turn >= enemy_hex_status.duration:
			enemy_hex_status.active = false
			enemy_hex_status.icon_on = false
			enemy_hex_modifier = 0
			enemy_hex_status.turn = 0
			clear_status_icon("hex.png")
			
		
		else:
			if enemy_hex_status.icon_on == true:
				# increase enemy hex dmg
				var value = value_multipliyer * 2
				value_multipliyer = value
				battle_scene.announcer_text(text)
				deal_status_dmg(value, 'hex')
				#check_if_you_dead()
			else:
				check_if_status_icon_is_available(enemy_hex_status.texture)
				enemy_hex_status.icon_on = true
				battle_scene.announcer_text(text)
				value_multipliyer += hex_action.action_attribute
				var value = value_multipliyer * 2
				value_multipliyer = value
				deal_status_dmg(value, "hex")
				#check_if_you_dead()
		await get_tree().create_timer(2.5).timeout

	## SHADOW
	if shadow_status.active:
		text = "[center]" + enemy_name + ' has been trapped in it own ' + "[color=929292]shadow[/color][/center]"
		shadow_status.turn += 1
		if shadow_status.turn >= shadow_status.duration:
			shadow_status.active = false
			shadow_status.icon_on = false
			shadow_status.turn = 0
			clear_status_icon("shadow.png")
	
		else:
			# deal damage, show status icon plus alart
			if shadow_status.icon_on == true:
				var dmg = (shadow_status.percentage / 100.0) * enemy_hp.max_value
				player.player_shadow_status.value = int (dmg)
				deal_status_dmg(dmg, "shadow")
				
				
			else:
				check_if_status_icon_is_available(shadow_status.texture) # set texture icon
				shadow_status.icon_on = true
				battle_scene.announcer_text(text)
				var dmg = (shadow_status.percentage / 100) * enemy_hp.max_value
				player.player_shadow_status.value = int (dmg)
				deal_status_dmg(dmg, "shadow")
				
				
		await get_tree().create_timer(2.5).timeout
		
	## BLEED
	if bleed_status.active:
		text = "[center]" + enemy_name + ' will begin to lose ' + "[color=red]blood[/color][/center]"
		bleed_status.turn += 1
		if bleed_status.turn >= bleed_status.duration:
			bleed_status.active = false
			bleed_status.icon_on = false
			bleed_status.turn = 0
			clear_status_icon("bleed.png")
	
		else:
			# deal damage, show status icon plus alart
			if bleed_status.icon_on == true:
				var dmg = (bleed_status.percentage / 60.0) * enemy_hp.max_value
				deal_status_dmg(dmg, "bleed")
				
				
			else:
				check_if_status_icon_is_available(bleed_status.texture) # set texture icon
				bleed_status.icon_on = true
				battle_scene.announcer_text(text)
				var dmg = (bleed_status.percentage / 60.0) * enemy_hp.max_value
				deal_status_dmg(dmg, "bleed")
				
				
		await get_tree().create_timer(2.5).timeout
	
	## POISEN
	if poisen_status.active:
		text = "[center]" + enemy_name + ' has been ' + "[color=purple]poisened[/color][/center]"
		poisen_status.turn += 1
		if poisen_status.turn >= poisen_status.duration:
			poisen_status.active = false
			poisen_status.icon_on = false
			poisen_status.turn = 0
			clear_status_icon("poisen.png")
	
		else:
			# deal damage, show status icon plus alart
			if poisen_status.icon_on == true:
				var dmg = (poisen_status.percentage / 50.0) * enemy_hp.max_value
				deal_status_dmg(dmg, "poisen")
				
				
			else:
				check_if_status_icon_is_available(poisen_status.texture) # set texture icon
				poisen_status.icon_on = true
				battle_scene.announcer_text(text)
				var dmg = (poisen_status.percentage / 50.0) * enemy_hp.max_value
				deal_status_dmg(dmg, "poisen")
				
				
		await get_tree().create_timer(2.5).timeout


## All status effect func
func check_if_status_icon_is_available (texture_res) -> void:
	if enemy_status_effect.status_1.texture == null:
		enemy_status_effect.status_1.modulate.a = 0.0 # start transparent
		enemy_status_effect.status_1.texture = load( texture_res ) # load texture
		var tween = get_tree().create_tween()
		tween.tween_property(enemy_status_effect.status_1, "modulate:a", 1.0, 1.0) # fade in
	elif enemy_status_effect.status_2.texture == null:
		enemy_status_effect.status_2.modulate.a = 0.0
		enemy_status_effect.status_2.texture = load( texture_res )
		var tween = get_tree().create_tween()
		tween.tween_property(enemy_status_effect.status_2, "modulate:a", 1.0, 1.0)
	elif enemy_status_effect.status_3.texture == null:
		enemy_status_effect.status_3.modulate.a = 0.0
		enemy_status_effect.status_3.texture = load( texture_res )
		var tween = get_tree().create_tween()
		tween.tween_property(enemy_status_effect.status_3, "modulate:a", 1.0, 1.0)
	elif enemy_status_effect.status_4.texture == null:
		enemy_status_effect.status_4.modulate.a = 0.0
		enemy_status_effect.status_4.texture = load( texture_res )
		var tween = get_tree().create_tween()
		tween.tween_property(enemy_status_effect.status_4, "modulate:a", 1.0, 1.0)
	elif enemy_status_effect.status_5.texture == null:
		enemy_status_effect.status_5.modulate.a = 0.0
		enemy_status_effect.status_5.texture = load( texture_res )
		var tween = get_tree().create_tween()
		tween.tween_property(enemy_status_effect.status_5, "modulate:a", 1.0, 1.0)
		
		
func clear_status_icon (filename : String) -> void:
	var status_1 : TextureRect =  enemy_status_effect.status_1
	var status_2 : TextureRect =  enemy_status_effect.status_2
	var status_3 : TextureRect =  enemy_status_effect.status_3
	var status_4 : TextureRect =  enemy_status_effect.status_4
	var status_5 : TextureRect =  enemy_status_effect.status_5
	
	if status_1.texture and status_1.texture.resource_path.get_file() == filename:
		status_1.texture = null
	elif status_2.texture and status_2.texture.resource_path.get_file() == filename:
		status_2.texture = null
	elif status_3.texture and status_3.texture.resource_path.get_file() == filename:
		status_3.texture = null
	elif status_4.texture and status_4.texture.resource_path.get_file() == filename:
		status_4.texture = null
	elif status_5.texture and status_5.texture.resource_path.get_file() == filename:
		status_5.texture = null


func deal_status_dmg (dmg, effect : String) -> void :
	if effect == "fire":
		dmg = int(dmg)
		modulate = "red"
		$AnimationPlayer.play("hit")
		await get_tree().create_timer(0.4).timeout
		modulate = "white"
		$"../enemy_dmg hit".text = str (dmg)
		$emeny_dmg.play("dmg")
		current_hp -= dmg
		enemy_hp.value = current_hp
		check_if_you_dead()
		
	elif effect == "water":
		dmg = int(dmg)
		modulate = 'blue'
		$AnimationPlayer.play("hit")
		await get_tree().create_timer(0.4).timeout
		modulate = "white"
		$"../enemy_dmg hit".text = str (dmg)
		$emeny_dmg.play("dmg")
		dex -= dmg
	
	elif effect == "lightning":
		dmg = int(dmg)
		modulate = 'yellow'
		$AnimationPlayer.play("hit")
		await get_tree().create_timer(0.4).timeout
		modulate = "white"
	
	elif effect == "ice":
		dmg = int(dmg)
		modulate = 'lightblue'
		$AnimationPlayer.play("hit")
		await get_tree().create_timer(0.5).timeout
		$AnimationPlayer.stop()
		
	elif effect == 'wind':
		dmg = int(dmg)
		modulate = 'lightgreen'
		$AnimationPlayer.play("hit")
		await get_tree().create_timer(0.4).timeout
		modulate = "white"
		$"../enemy_dmg hit".text = str (dmg)
		$emeny_dmg.play("dmg")
		dex -= dmg
		
	elif effect == 'earth':
		dmg = int (dmg)
		modulate = 'brown'
		$AnimationPlayer.play("hit")
		await get_tree().create_timer(0.4).timeout
		modulate = "white"
		$"../enemy_dmg hit".text = str (dmg)
		$emeny_dmg.play("dmg")
		def -= dmg
	
	elif effect == 'heal':
		dmg = int(dmg)
		_5.play("heal") # play enemy effect heal
		modulate_enemy(100,100,100,1) # flash enemy white
		await get_tree().create_timer(0.3).timeout # wait 0.3 sec
		modulate_enemy(1,1,1,1) # return enemy to normal
		current_hp += dmg
		if current_hp > enemy_hp.max_value:
			current_hp = enemy_hp.max_value
			enemy_hp.value = current_hp
			return
		
		enemy_hp.value = current_hp
		
	elif effect == 'defence':
		dmg = int(dmg)
		modulate_enemy_effects(_6, 0,0,100)
		_6.play("defence") # play enemy effect defence
		modulate_enemy(100,100,100,1) # flash player white
		await get_tree().create_timer(0.3).timeout # wait 0.3 sec
		modulate_enemy(1,1,1,1) # return player to normal
		def += dmg
		
	elif effect == 'attack_down':
		dmg = int (dmg)
		modulate = 'ff7f6e'
		$AnimationPlayer.play("hit")
		await get_tree().create_timer(0.4).timeout
		$"../enemy_dmg hit".text = str (dmg)
		$emeny_dmg.play("dmg")
		atk -= dmg

	elif effect == 'def_breaker':
		dmg = int (dmg)
		modulate = 'blue'
		$AnimationPlayer.play("hit")
		await get_tree().create_timer(0.4).timeout
		$"../enemy_dmg hit".text = str (dmg)
		$emeny_dmg.play("dmg")
		def -= dmg
	
	elif effect == 'confused': # for psychic effect
		# make enemy attack self
		dmg = int(dmg)
		modulate = 'purple'
		$AnimationPlayer.play("hit")
		camera.shake() # shake screen
		Input.vibrate_handheld(140, 1.0)
		await get_tree().create_timer(0.4).timeout
		modulate = "white"
		$"../enemy_dmg hit".text = str (dmg)
		$emeny_dmg.play("dmg")
		current_hp -= dmg
		enemy_hp.value = current_hp
		
	elif effect == 'hex':
		dmg = int(dmg)
		modulate_enemy_effects(_4, 0.018, 0.368, 0.014)
		_4.play("mystic")
		modulate_enemy(100,100,100,1) # flash player white
		await get_tree().create_timer(0.3).timeout # wait 0.3 sec
		modulate_enemy(1,1,1,1) # return player to normal
		enemy_hex_modifier = dmg
		
	elif effect == 'shadow':
		dmg = int(dmg)
		modulate = "black"
		$AnimationPlayer.play("hit")
		await get_tree().create_timer(0.4).timeout
		modulate = "white"
		$"../enemy_dmg hit".text = str (dmg)
		$emeny_dmg.play("dmg")
		current_hp -= dmg
		enemy_hp.value = current_hp
		check_if_you_dead()
	
	elif effect == 'bleed':
		dmg = int(dmg)
		modulate = "red"
		enemy_effects_2.play("show")
		$AnimationPlayer.play("hit")
		await get_tree().create_timer(0.4).timeout
		modulate = "white"
		$"../enemy_dmg hit".text = str (dmg)
		$emeny_dmg.play("dmg")
		current_hp -= dmg
		enemy_hp.value = current_hp
		check_if_you_dead()
		
	elif effect == 'poisen':
		dmg = int(dmg)
		modulate = "purple"
		enemy_effect_3.play("show")
		$AnimationPlayer.play("hit")
		await get_tree().create_timer(0.4).timeout
		modulate = "white"
		$"../enemy_dmg hit".text = str (dmg)
		$emeny_dmg.play("dmg")
		current_hp -= dmg
		enemy_hp.value = current_hp
		check_if_you_dead()
	
func check_if_you_dead () -> void:
	if current_hp <= 0:
		battle_scene.player_victory()
		## Switch scene to game over menu
		return
	pass


func modulate_enemy_effects (effect_node : AnimatedSprite2D , r : int, g : int, b : int):
	effect_node.self_modulate.r = r
	effect_node.self_modulate.g = g
	effect_node.self_modulate.b = b

func modulate_enemy (r_value : int, g_value : int, b_value : int, a_value : int) -> void:
	self_modulate.r = r_value
	self_modulate.g = g_value
	self_modulate.b = b_value
	self_modulate.a = a_value
