class_name Player extends AnimatedSprite2D

@onready var atk_value: Label = $"../stats_view/atk_value"
@onready var def_value: Label = $"../stats_view/def_value"
@onready var dex_value: Label = $"../stats_view/dex_value"
@onready var hp_value: Label = $"../stats_view/hp_value"
@onready var battle_scene: Battle_Scene = $"../.."
@onready var enemy: Enemy = $"../enemy"
@onready var player_status_effect: Control = $"../player_status_effect"

@onready var hp__: Label = $"../full_stats_info/Panel/stat/hp__"
@onready var atk__: Label = $"../full_stats_info/Panel/stat/atk__"
@onready var def__: Label = $"../full_stats_info/Panel/stat/def__"
@onready var dex__: Label = $"../full_stats_info/Panel/stat/dex__"
@onready var atk_negative_value: Label = $"../stats_view2/atk-_value" # bottom panel
@onready var _atk: Label = $"../full_stats_info/Panel/stat/-atk" # full status view 
@onready var brkr_full: Label = $"../full_stats_info/Panel/stat/brkr" # full status view
@onready var brkr_value: Label = $"../stats_view2/brkr_value" # bottom panel



@onready var _3: AnimatedSprite2D = $"../player_effects/3"


## Status effect 1 (player to enemy)
var player_heal_status : Dictionary = {"active" : false, 'icon_on' : false, 'turn' : 0, 'duration' : 4, 
'texture' : 'res://Scene/battle/img/status_icon/heal.png', 'percentage' : 5.0, 'value' : 0}
var player_defence_status : Dictionary = {"active" : false, 'icon_on' : false, 'turn' : 0, 'duration' : 4, 
'texture' : 'res://Scene/battle/img/status_icon/defence.png', 'percentage' : 5.0, 'value' : 0}
var player_hex_status : Dictionary = {"active" : false, 'icon_on' : false, 'turn' : 0, 'duration' : 4, 
'texture' : 'res://Scene/battle/img/status_icon/hex.png', 'percentage' : 5.0, 'value' : 0}
var player_shadow_status : Dictionary = {"active" : false, 'icon_on' : false, 'turn' : 0, 'duration' : 4, 
'texture' : 'res://Scene/battle/img/status_icon/shadow.png', 'percentage' : 5.0, 'value' : 0}

## Ststus effect 2 ( enemy to player)
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

var player_damage
var current_hp : int
var selected_inv : Array = []
var status_chance = 100
var text : String
var text_2 : String
var added_value_for_atk_down := 0
var added_value_for_def_brk := 0

var paralized : bool = false
var frozen : bool = false
var confused: bool = false
var player_shadow : bool = false

# Stats
var atk : int
var def : int
var dex : int
var wis : int
var con : int
var Int : int

# final stat
var final_atk
var final_def
var final_dex
var final_int
var final_wis
var final_con

# current stats
var original_def
var current_armor_def
var value_multipliyer : int = 0
var hex_modifier : int = 0
var current_dex : int
var current_atk : int
var current_def : int

# equipment mod
var headgear_def 
var chestplate_def
var rel_atr 
var rel_type 
var leggings_def
var weapon_atk 
var armor_def

@onready var player_hp: TextureProgressBar = $"../player_hp"
@onready var camera: Camera2D = $"../Camera2D"


 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_hp = GlobalGameSystem.player_hp
	#player_hp.value = current_hp
	load_selected_inv()
	set_battle_stat()
	
	current_hp += final_con
	player_hp.max_value = current_hp
	player_hp.value += current_hp
	hp_value.text = str (current_hp)
	
	SignalManager.player_damaged.connect(take_damage)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func modulate_player (r_value : int, g_value : int, b_value : int, a_value : int) -> void:
	self_modulate.r = r_value
	self_modulate.g = g_value
	self_modulate.b = b_value
	self_modulate.a = a_value
	
## for healing and such
func set_hp (value : int) -> void:
	current_hp += value
	if current_hp > player_hp.max_value:
		current_hp = player_hp.max_value
		player_hp.value = current_hp
		hp_value.text = str (current_hp)
	else:
		player_hp.value = current_hp
		hp_value.text = str (current_hp)
	
	
	
func _on_area_2d_area_entered(_area: Area2D) -> void:
	if battle_scene.enemy_critical_hit == true:
		GlobalGameSystem.hit_stop(0.05, 0.15) #perform hitstop
		Input.vibrate_handheld(50, 1.0)
		battle_scene.enemy_critical_hit = false
		$criti_hit.play("show")
		
	camera.shake() # shake screen
	Input.vibrate_handheld(140, 1.0)
	self.play("hit")
	$"dmg hit".text = str(player_damage)
	$dmg_info.play("dmg_p")
	current_hp -= player_damage
	if current_hp < 0:
		current_hp = 0
	player_hp.value = current_hp
	hp_value.text = str (current_hp)
	
	
	pass # Replace with function body.


func _on_animation_finished() -> void:
	self.play("idle")
	pass # Replace with function body.


func take_damage (damage) -> void:
	player_damage = damage
	
	
func load_selected_inv () -> void:
	var selected = GlobalGameSystem.selected_inv
	selected_inv = selected.duplicate(true)
	
	headgear_def = selected_inv[0].item_data.attribute_value
	chestplate_def = selected_inv[1].item_data.attribute_value
	rel_type = selected_inv[2].item_data.attribute
	rel_atr = selected_inv[2].item_data.attribute_value
	leggings_def = selected_inv[3].item_data.attribute_value
	weapon_atk = selected_inv[4].item_data.attribute_value
	
	armor_def = headgear_def + chestplate_def + leggings_def
	
	current_armor_def = armor_def
		
func set_battle_stat () -> void:
	atk = GlobalGameSystem.player_atk 
	def = GlobalGameSystem.player_def 
	dex = GlobalGameSystem.player_dex
	wis = GlobalGameSystem.player_wis
	Int = GlobalGameSystem.player_int
	con = GlobalGameSystem.player_con
	
	if wind_status.active or water_status.active: # if wind or water status is active dont reset final dex
		final_atk = atk + (min(Int , atk) - atk) * 0.7
		final_def = def + (min(con , def) - def) * 0.7
		final_con = con + (min(wis , con) - con) * 0.7
		set_stat_view()
		return
		
	if earth_status.active or def_breaker_status.active: # if wind dont reset def
		final_atk = atk + (min(Int , atk) - atk) * 0.7
		final_dex = dex + (min(wis , dex) - dex) * 0.7
		final_con = con + (min(wis , con) - con) * 0.7
		set_stat_view()
		return
		
	if attack_down_status.active: # if atk down is active
		final_def = def + (min(con , def) - def) * 0.7
		final_con = con + (min(wis , con) - con) * 0.7
		final_dex = dex + (min(wis , dex) - dex) * 0.7
		set_stat_view()
		return
	
	final_atk = atk + (min(Int , atk) - atk) * 0.7
	final_def = def + (min(con , def) - def) * 0.7
	final_dex = dex + (min(wis , dex) - dex) * 0.7
	final_con = con + (min(wis , con) - con) * 0.7
	
	current_dex = final_dex
	current_def = final_def
	current_atk = final_atk
	set_stat_view()
	
	


func set_stat_view () -> void:
	atk_value.text =  str (final_atk + weapon_atk)
	def_value.text = str (final_def + armor_def)
	dex_value.text = str (final_dex)
	
	
func set_roll_stat_view (roll_atk, roll_def, roll_dex) -> void:
	atk_value.text = str(roll_atk)
	def_value.text = str (roll_def)
	dex_value.text = str (roll_dex)
	$"../stats_view/AnimationPlayer".play("display")
	

# for full ststus screen first is for the main value second is for the red modifying value
func show_full_stat (hp_l : Label, atk_l : Label, def_l : Label, dex_l : Label, con_l : Label) -> void:
	hp_l.text = str(GlobalGameSystem.player_hp)
	atk_l.text = str(atk)
	def_l.text = str(def)
	dex_l.text = str(dex)
	con_l.text = str(con)
	pass

func show_full_mod_stat (hp_m : Label, atk_m : Label, def_m : Label, dex_m : Label, con_m : Label, wep_dmg : Label, arm_def : Label, relic_type : Label, crit : Label ) -> void:
	var atk_mod = final_atk - atk
	var def_mod = final_def - def
	var dex_mod = final_dex - dex
	var con_mod  = final_con - con
	
	hp_m.text = "(+" + str(final_con) + ")"
	# cal
	atk_m.text = "(" + str(atk_mod) + ")"
	def_m.text = "(" + str(def_mod) + ")"
	dex_m.text = "(" + str(dex_mod) + ")"
	con_m.text = "(" + str(con_mod) + ")"
	wep_dmg.text = str(weapon_atk)
	arm_def.text = str (armor_def)
	relic_type.text = rel_type + " +"
	
	if rel_type == "Crit":
		crit.text = str(rel_atr)
	else:
		crit.text = "0"
		
		
		
func perform_action (value, action : Action) -> void:
	
	## Physical modifer
	if action.action_type == "Physical":
		self.play("attack")
		$hit_box_hit.play("hit")
		value = max(0, value - enemy.def) # deduct damage from enemy def
		SignalManager.enemy_damaged.emit(value)
		
	elif action.action_type == "Fire":
		self.play("attack")
		$hit_box_hit.play("hit")
		value = max(0, value - enemy.def) # deduct damage from enemy def
		SignalManager.enemy_damaged.emit(value)
		if enemy.fire_status.active == true:
			return
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			enemy.fire_status.active = true
	
	elif action.action_type == "Water":
		self.play("attack")
		$hit_box_hit.play("hit")
		value = max(0, value - enemy.def) # deduct damage from enemy def
		SignalManager.enemy_damaged.emit(value)
		if enemy.water_status.active == true:
			return
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			enemy.water_status.active = true
		
	elif action.action_type == "Lightning":
		self.play("attack")
		$hit_box_hit.play("hit")
		value = max(0, value - enemy.def) # deduct damage from enemy def
		SignalManager.enemy_damaged.emit(value)
		if enemy.lightning_status.active == true:
			return
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			enemy.lightning_status.active = true

	elif action.action_type == "Ice":
		self.play("attack")
		$hit_box_hit.play("hit")
		value = max(0, value - enemy.def) # deduct damage from enemy def
		SignalManager.enemy_damaged.emit(value)
		if enemy.ice_status.active == true:
			return
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			enemy.ice_status.active = true
		
	elif action.action_type == "Wind":
		self.play("attack")
		$hit_box_hit.play("hit")
		value = max(0, value - enemy.def) # deduct damage from enemy def
		SignalManager.enemy_damaged.emit(value)
		if enemy.wind_status.active == true:
			return
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			enemy.wind_status.active = true
		pass
	
	elif action.action_type == "Earth":
		self.play("attack")
		$hit_box_hit.play("hit")
		value = max(0, value - enemy.def) # deduct damage from enemy def
		SignalManager.enemy_damaged.emit(value)
		if enemy.earth_status.active == true:
			return
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			enemy.earth_status.active = true
		
	elif action.action_type == "Mystic":
		self.play("attack")
		player_effect_modulate($"../player_effects/mystic", 100.0,100.0,66.4)
		$"../player_effects/mystic".play("mystic") # Play mystic animation
		$hit_box_hit.play("hit")
		#damage = max(0, damage - enemy.def) ## Perfrom true damage ignoring enemy defence
		SignalManager.enemy_damaged.emit(value)
	
	elif action.action_type == "Heal":
		if player_heal_status.active == true:
			text = "[center][color=green]Heal[/color] status already in effect[/center]"
			battle_scene.announcer_text(text)
			await get_tree().create_timer(1.5).timeout
			return
		player_heal_status.value = value
		$"../player_effects/heal".play("show")
		text = "[center]Your [color=green]HP[/color] ticks up for 3 turns"
		battle_scene.announcer_text(text)
		await get_tree().create_timer(1.5).timeout
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			player_heal_status.active = true
		
	elif action.action_type == "Defence":
		if player_defence_status.active == true:
			text = "[center][color=blue]ARMOR DEFENCE[/color] status already in effect[/center]"
			battle_scene.announcer_text(text)
			return
		player_defence_status.value = value
		$"../player_effects/2".play("defence")
		text = "[center]Your [color=blue]ARMOR DEFENCE[/color] ticks up for 3 turns"
		battle_scene.announcer_text(text)
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			player_defence_status.active = true
	
	elif action.action_type == "Atk Down":
		self.play("attack")
		$hit_box_hit.play("hit")
		value = max(0, value - enemy.def) # deduct damage from enemy def
		SignalManager.enemy_damaged.emit(value)
		if enemy.attack_down_status.active == true:
			return
		var roll = randi_range(1,100)
		if roll <= status_chance:
			enemy.attack_down_status.active = true
		
	elif action.action_type == "Def Breaker":
		self.play("attack")
		$hit_box_hit.play("hit")
		value = max(0, value - enemy.def) # deduct damage from enemy def
		SignalManager.enemy_damaged.emit(value)
		if enemy.def_breaker_status.active == true:
			return
		var roll = randi_range(1,100)
		if roll <= status_chance:
			enemy.def_breaker_status.active = true
		pass
		
	elif action.action_type == "Psychic":
		self.play("attack")
		$hit_box_hit.play("hit")
		value = max(0, value - enemy.def) # deduct damage from enemy def
		SignalManager.enemy_damaged.emit(value)
		if enemy.psychic_status.active == true:
			return
		var roll = randi_range(1,100)
		if roll <= status_chance:
			enemy.psychic_status.active = true
		
	elif action.action_type == "Hex":
		self.play ("attack")
		$hit_box_hit.play("hit")
		value = max(0, value - enemy.def)
		SignalManager.enemy_damaged.emit(value)
		if player_hex_status.active == true:
			##text = "[center][color=green]HEX[/color] status already in effect[/center]"
			##battle_scene.announcer_text(text)
			return
		player_hex_status.value = value
		await get_tree().create_timer(2).timeout
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			player_hex_status.active = true
			text = "[center][color=green]HEX[/color] activated, doubles hex based attacks"
			battle_scene.announcer_text(text)
		
	elif action.action_type == "Shadow":
		self.play("attack")
		$hit_box_hit.play("hit")
		player_shadow_status.value = int(value)
		value = max(0, value - enemy.def)
		SignalManager.enemy_damaged.emit(value)
		if player_shadow_status.active == true:
			text = "[center][color=929292]SHADOW[/color] status already in effect[/center]"
			battle_scene.announcer_text(text)
			return
		
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			player_shadow_status.active = true
			enemy.shadow_status.active = true
			await get_tree().create_timer(2).timeout
			text = "[center][color=929292]SHADOW[/color] drain activated"
			battle_scene.announcer_text(text)
			await get_tree().create_timer(1.5).timeout
			text = "[center]HP increases from drained opponent[/center]"
			battle_scene.announcer_text(text)
			player_shadow = true
		pass
		
	elif action.action_type == "Bleed":
		self.play("attack")
		$hit_box_hit.play("hit")
		value = max(0, value - enemy.def) # deduct damage from enemy def
		SignalManager.enemy_damaged.emit(value)
		if enemy.bleed_status.active == true:
			return
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			enemy.bleed_status.active = true
		
	elif action.action_type == "Poison":
		self.play("attack")
		$hit_box_hit.play("hit")
		value = max(0, value - enemy.def) # deduct damage from enemy def
		SignalManager.enemy_damaged.emit(value)
		if enemy.poisen_status.active == true:
			return
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			enemy.poisen_status.active = true


func status_effect () -> void:
	#await get_tree().create_timer(2.5).timeout
	
	## FIRE
	if fire_status.active:
		text = "[center]" + ' you have been ' + "[color=red]burned[/color][/center]"
		fire_status.turn += 1
		if fire_status.turn >= fire_status.duration:
			fire_status.active = false
			fire_status.icon_on = false
			fire_status.turn = 0
			clear_status_icon("fire_2.png")
	
		else:
			# deal damage, show status icon plus alart
			if fire_status.icon_on == true:
				var dmg = (fire_status.percentage / 30.0) * player_hp.max_value
				deal_status_dmg(dmg, "fire")
				
				
			else:
				check_if_status_icon_is_available(fire_status.texture) # set texture icon
				fire_status.icon_on = true
				battle_scene.announcer_text(text)
				var dmg = (fire_status.percentage / 100.0) * player_hp.max_value
				deal_status_dmg(dmg, "fire")
				
				
		await get_tree().create_timer(2.5).timeout
	
	## WATER
	if water_status.active:
		text = "[center]"  + "[color=blue] Your mobility[/color] has reduced[/center]"
		water_status.turn += 1
		if water_status.turn >= water_status.duration:
			water_status.active = false
			water_status.icon_on = false
			water_status.turn = 0
			clear_status_icon("water.png")
			final_dex = current_dex
			dex__.text = "(" + str(final_dex - dex) + ")"
			dex_value.text = str (final_dex)
			
		else:
			# Reduce speed and show status icon plus alart
			if water_status.icon_on == true:
				var dmg = (water_status.percentage / 15.0) * final_dex
				deal_status_dmg(dmg, "water")
				check_if_you_dead()
				
			else:
				check_if_status_icon_is_available(water_status.texture)
				water_status.icon_on = true
				battle_scene.announcer_text(text)
				var dmg = (water_status.percentage / 15.0) * final_dex
				deal_status_dmg(dmg, "water")
				check_if_you_dead()
	
		await get_tree().create_timer(2.5).timeout
	
	## LIGHTING
	if lightning_status.active:
		text = "[center]"  + ' You have been ' + "[color=yellow]stunned[/color][/center]"
		lightning_status.turn += 1
		if lightning_status.turn >= lightning_status.duration:
			lightning_status.active = false
			lightning_status.icon_on = false
			lightning_status.turn = 0
			paralized = false
			battle_scene.player_status_active = false # allows status from main game check to be false
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
		text = "[center]You have been[color=lightblue] frozen[/color] and can't move[/center]"
		ice_status.turn += 1
		if ice_status.turn >= ice_status.duration:
			self.play("idle")
			modulate = 'white'
			ice_status.active = false
			ice_status.icon_on = false
			ice_status.turn = 0
			frozen = false
			battle_scene.player_status_active = false # allows status from main game check to be false
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
		text = "[center]You are fighting against strong, pushing[color=lightgreen] wind[/color][/center]"
		wind_status.turn += 1
		if wind_status.turn >= wind_status.duration:
			wind_status.active = false
			wind_status.icon_on = false
			wind_status.turn = 0
			clear_status_icon("wind.png")
			final_dex = current_dex
			dex__.text = "(" + str(final_dex - dex) + ")"
			dex_value.text = str (final_dex)
		
		else:
			if wind_status.icon_on == true:
				# make enemy speed be reduced
				var dmg = (wind_status.percentage / 25.0) * final_dex
				deal_status_dmg(dmg, 'wind')
				check_if_you_dead()
			else:
				check_if_status_icon_is_available(wind_status.texture)
				wind_status.icon_on = true
				battle_scene.announcer_text(text)
				var dmg = (wind_status.percentage / 25.0) * final_dex
				deal_status_dmg(dmg, "wind")
				check_if_you_dead()
		await get_tree().create_timer(2.5).timeout
	
	## EARTH
	if earth_status.active:
		text = "[center]Your defences have been pierced with [color=brown]rock [/color]shards[/center]"
		earth_status.turn += 1
		if earth_status.turn >= earth_status.duration:
			earth_status.active = false
			earth_status.icon_on = false
			earth_status.turn = 0
			clear_status_icon("earth.png")
			final_def = current_def
			def_value.text = str (final_def + armor_def)
			def__.text = "(" + str(final_def - def) + ")"
		
		else:
			if earth_status.icon_on == true:
				# make enemy def be reduced
				var dmg = (earth_status.percentage / 25.0) * final_def
				deal_status_dmg(dmg, 'earth')
				check_if_you_dead()
			else:
				check_if_status_icon_is_available(earth_status.texture)
				earth_status.icon_on = true
				battle_scene.announcer_text(text)
				var dmg = (earth_status.percentage / 25.0) * final_def
				deal_status_dmg(dmg, "earth")
				check_if_you_dead()
		await get_tree().create_timer(2.5).timeout
	
	## ATTACK DOWN
	if attack_down_status.active:
		text = "[center]Player[color=red] ATTACK [/color]prowess is waning![/center]"
		attack_down_status.turn += 1
		if attack_down_status.turn >= attack_down_status.duration:
			attack_down_status.active = false
			attack_down_status.icon_on = false
			attack_down_status.turn = 0
			clear_status_icon("attack_down.png")
			modulate = "white"
			final_atk = current_atk
			atk_value.text =  str (final_atk + weapon_atk) #bottom panel update to normal
			atk__.text = "(" + str(final_atk - atk) + ")" # full status board shows to normal
			atk_negative_value.text = str(0)
			added_value_for_atk_down = 0
			_atk.text = str(0)
			_3.visible = false
			_3.stop()
			
		else:
			if attack_down_status.icon_on == true:
				# reduce enemy attacks
				var dmg = (attack_down_status.percentage / 25.0) * final_atk
				deal_status_dmg(dmg, 'attack_down')
				check_if_you_dead()
			else:
				check_if_status_icon_is_available(attack_down_status.texture)
				player_effect_modulate(_3, 100.0, 0, 0)
				_3.play("show")
				_3.visible = true
				attack_down_status.icon_on = true
				battle_scene.announcer_text(text)
				var dmg = (attack_down_status.percentage / 25.0) * final_atk
				deal_status_dmg(dmg, "attack_down")
				check_if_you_dead()
		await get_tree().create_timer(2.5).timeout
	
	## DEFENCE BREAKER
	if def_breaker_status.active:
		text = "[center]Your [color=blue] DEFENCE [/color]has been breached![/center]"
		def_breaker_status.turn += 1
		if def_breaker_status.turn >= def_breaker_status.duration:
			def_breaker_status.active = false
			def_breaker_status.icon_on = false
			def_breaker_status.turn = 0
			clear_status_icon("def_breaker.png")
			modulate = "white"
			final_def = current_def
			def_value.text = str (final_def + armor_def) #bottom panel update to normal
			def__.text = "(" + str(final_def - def) + ")" # full status board shows to normal
			added_value_for_def_brk = 0
			brkr_full.text = str(0)
			brkr_value.text = str(0)
			_3.visible = false
			_3.stop()
			
		
		else:
			if def_breaker_status.icon_on == true:
				# reduce enemy defence 
				var dmg = (def_breaker_status.percentage / 25.0) * final_def
				deal_status_dmg(dmg, 'def_breaker')
				check_if_you_dead()
			else:
				check_if_status_icon_is_available(def_breaker_status.texture)
				player_effect_modulate(_3,0,0,100.0)
				_3.play("show")
				_3.visible = true
				def_breaker_status.icon_on = true
				battle_scene.announcer_text(text)
				var dmg = (def_breaker_status.percentage / 25.0) * final_def
				deal_status_dmg(dmg, "def_breaker")
				check_if_you_dead()
		await get_tree().create_timer(2.5).timeout
	
	## PLAYER HEAL
	if player_heal_status.active:
		text = "[center][color=green]HP[/color] has slightly increased[/center]"
		player_heal_status.turn += 1
		if player_heal_status.turn >= player_heal_status.duration:
			player_heal_status.active = false
			player_heal_status.icon_on = false
			player_heal_status.turn = 0
			clear_status_icon("heal.png")
			
		
		else:
			if player_heal_status.icon_on == true:
				# increase player hp
				var value = (player_heal_status.percentage / 50.0) * player_heal_status.value
				await battle_scene.announcer_text(text)
				deal_status_dmg(value, 'heal')
				#check_if_you_dead()
			else:
				check_if_status_icon_is_available(player_heal_status.texture)
				player_heal_status.icon_on = true
				await battle_scene.announcer_text(text)
				var dmg = (player_heal_status.percentage / 50.0) * player_heal_status.value
				deal_status_dmg(dmg, "heal")
				#check_if_you_dead()
		await get_tree().create_timer(2.5).timeout
		
	##PLAYER DEFENCE
	if player_defence_status.active:
		text = "[center][color=blue]ARMOR DEFENCE[/color] has slightly increased[/center]"
		player_defence_status.turn += 1
		if player_defence_status.turn >= player_defence_status.duration:
			player_defence_status.active = false
			player_defence_status.icon_on = false
			player_defence_status.turn = 0
			armor_def = current_armor_def
			set_battle_stat() ## original stat points
			$"../full_stats_info/Panel/stat2/arm_def".text = str(armor_def)
			def_value.text = str (final_def + armor_def)
			clear_status_icon("defence.png")
			
		
		else:
			if player_defence_status.icon_on == true:
				# increase player defence
				var value = (player_defence_status.percentage /75.0) * player_defence_status.value
				battle_scene.announcer_text(text)
				deal_status_dmg(value, 'defence')
				#check_if_you_dead()
			else:
				check_if_status_icon_is_available(player_defence_status.texture)
				player_defence_status.icon_on = true
				battle_scene.announcer_text(text)
				var dmg = (player_defence_status.percentage / 75.0) * player_defence_status.value
				deal_status_dmg(dmg, "defence")
				#check_if_you_dead()
		await get_tree().create_timer(2.5).timeout
		
	## PSYCHIC
	if psychic_status.active:
		text = "[center]You have been drenched in[color=purple] Psychic[/color] aura[/center]"
		psychic_status.turn += 1
		if psychic_status.turn >= psychic_status.duration:
			psychic_status.active = false
			psychic_status.icon_on = false
			psychic_status.turn = 0
			confused = false
			battle_scene.player_status_active = false # allows status from main game check to be false
			clear_status_icon("psychic.png")
			_3.visible = false
			_3.stop()
		
		else:
			if psychic_status.icon_on == true:
				# make enemy skip its turn
				check_if_you_dead()
			else:
				check_if_status_icon_is_available(psychic_status.texture)
				player_effect_modulate(_3, 100,1,100)
				modulate = "purple"
				self.play("hit")
				await get_tree().create_timer(0.4).timeout
				modulate = "white"
				_3.play("show")
				_3.visible = true
				psychic_status.icon_on = true
				battle_scene.announcer_text(text)
				confused = true
		
	## PLAYER HEX
	if player_hex_status.active:
		var hex_action = battle_scene.current_action.action_data
		text = "[center][color=green]HEX[/color] based attack dmg grows 2x[/center]"
		player_hex_status.turn += 1
		if player_hex_status.turn >= player_hex_status.duration:
			player_hex_status.active = false
			player_hex_status.icon_on = false
			hex_modifier = 0
			player_hex_status.turn = 0
			clear_status_icon("hex.png")
			
		
		else:
			if player_hex_status.icon_on == true:
				# increase player hex dmg
				var value = value_multipliyer * 2
				value_multipliyer = value
				battle_scene.announcer_text(text)
				deal_status_dmg(value, 'hex')
				#check_if_you_dead()
			else:
				check_if_status_icon_is_available(player_hex_status.texture)
				player_hex_status.icon_on = true
				battle_scene.announcer_text(text)
				value_multipliyer += hex_action.action_attribute
				var value = value_multipliyer * 2
				value_multipliyer = value
				deal_status_dmg(value, "hex")
				#check_if_you_dead()
		await get_tree().create_timer(2.5).timeout
		
	## PLAYER SHADOW
	if player_shadow_status.active:
		text = "[center][color=929292]SHADOW[/color] drain increases your HP[/center]"
		text_2 = "[center]Opponent [color=929292]SHADOW[/color] drain reduces your HP[/center]"
		player_shadow_status.turn += 1
		if player_shadow_status.turn >= player_shadow_status.duration:
			player_shadow_status.active = false
			player_shadow_status.icon_on = false
			player_shadow_status.value = 0
			player_shadow = false
			clear_status_icon("shadow.png")
			
		
		else:
			if player_shadow_status.icon_on == true:
				# increase player hp
				if player_shadow == true:
					var value = player_shadow_status.value
					battle_scene.announcer_text(text)
					deal_status_dmg(value, 'shadow_p')
				elif enemy.enemy_shadow == true:
					var dmg = (player_shadow_status.percentage / 20) * player_hp.max_value
					enemy.shadow_status.value = int (dmg)
					deal_status_dmg(dmg, "shadow")
				#check_if_you_dead()
			else:
				check_if_status_icon_is_available(player_shadow_status.texture)
				player_shadow_status.icon_on = true
				
				if player_shadow == true:
					battle_scene.announcer_text(text)
					var value = player_shadow_status.value
					deal_status_dmg(value, "shadow_p")
				elif enemy.enemy_shadow == true:
					battle_scene.announcer_text(text_2)
					var dmg = (player_shadow_status.percentage / 20) * player_hp.max_value
					enemy.shadow_status.value = int (dmg)
					deal_status_dmg(dmg, "shadow")
				#check_if_you_dead()
		await get_tree().create_timer(2.5).timeout


func check_if_status_icon_is_available (texture_res) -> void:
	if player_status_effect.status_1.texture == null:
		player_status_effect.status_1.modulate.a = 0.0 # start transparent
		player_status_effect.status_1.texture = load( texture_res ) # load texture
		var tween = get_tree().create_tween()
		tween.tween_property(player_status_effect.status_1, "modulate:a", 1.0, 1.0) # fade in
	elif player_status_effect.status_2.texture == null:
		player_status_effect.status_2.modulate.a = 0.0
		player_status_effect.status_2.texture = load( texture_res )
		var tween = get_tree().create_tween()
		tween.tween_property(player_status_effect.status_2, "modulate:a", 1.0, 1.0)
	elif player_status_effect.status_3.texture == null:
		player_status_effect.status_3.modulate.a = 0.0
		player_status_effect.status_3.texture = load( texture_res )
		var tween = get_tree().create_tween()
		tween.tween_property(player_status_effect.status_3, "modulate:a", 1.0, 1.0)
	elif player_status_effect.status_4.texture == null:
		player_status_effect.status_4.modulate.a = 0.0
		player_status_effect.status_4.texture = load( texture_res )
		var tween = get_tree().create_tween()
		tween.tween_property(player_status_effect.status_4, "modulate:a", 1.0, 1.0)
	elif player_status_effect.status_5.texture == null:
		player_status_effect.status_5.modulate.a = 0.0
		player_status_effect.status_5.texture = load( texture_res )
		var tween = get_tree().create_tween()
		tween.tween_property(player_status_effect.status_5, "modulate:a", 1.0, 1.0)
		
		
func clear_status_icon (filename : String) -> void:
	var status_1 : TextureRect =  player_status_effect.status_1
	var status_2 : TextureRect =  player_status_effect.status_2
	var status_3 : TextureRect =  player_status_effect.status_3
	var status_4 : TextureRect =  player_status_effect.status_4
	var status_5 : TextureRect =  player_status_effect.status_5
	
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


func deal_status_dmg (value, effect : String) -> void :
	if effect == "fire":
		value = int(value)
		modulate = "red"
		self.play("hit")
		await get_tree().create_timer(0.4).timeout
		modulate = "white"
		$"dmg hit".text = str (value)
		$dmg_info.play("dmg_p")
		current_hp -= value
		player_hp.value = current_hp
		check_if_you_dead()
	
	elif  effect == "water":
		value = int(value)
		modulate = 'blue'
		self.play("hit")
		await get_tree().create_timer(0.4).timeout
		modulate = "white"
		$"dmg hit".text = str (value)
		$dmg_info.play("dmg_p")
		final_dex -= value
		dex_value.text = str (final_dex)
		dex__.text = "(" + str(final_dex - dex) + ")"
		#show_full_mod_stat(hp__, atk__, def__, dex__, con__, wep_dmg, arm_def, itm_tp, crit)

	elif effect == "lightning":
		value = int(value)
		modulate = 'yellow'
		self.play("hit")
		await get_tree().create_timer(0.4).timeout
		modulate = "white"

	elif effect == "ice":
		value = int(value)
		modulate = 'lightblue'
		self.play("hit")
		await get_tree().create_timer(0.5).timeout
		self.stop()

	elif effect == 'wind':
		value = int(value)
		modulate = 'lightgreen'
		self.play("hit")
		await get_tree().create_timer(0.4).timeout
		modulate = "white"
		$"dmg hit".text = str (value)
		$dmg_info.play("dmg_p")
		final_dex -= value
		dex_value.text = str (final_dex)
		dex__.text = "(" + str(final_dex - dex) + ")"

	elif effect == 'earth':
		value = int (value)
		modulate = 'brown'
		self.play("hit")
		await get_tree().create_timer(0.4).timeout
		modulate = "white"
		$"dmg hit".text = str (value)
		$dmg_info.play("dmg_p")
		final_def -= value
		def_value.text = str (final_def + armor_def)
		def__.text = "(" + str(final_def - def) + ")"

	elif  effect == 'heal':
		value = int(value)
		$"../player_effects/heal".play("show") # play player effect heal
		modulate_player(100,100,100,1) # flash player white
		await get_tree().create_timer(0.3).timeout # wait 0.3 sec
		modulate_player(1,1,1,1) # return player to normal
		current_hp += value
		if current_hp > player_hp.max_value:
			current_hp = player_hp.max_value
			player_hp.value = current_hp
			$"../stats_view/hp_value".text = str (current_hp)
			return
		
		player_hp.value = current_hp
		$"../stats_view/hp_value".text = str (current_hp)
		
	elif effect == 'defence':
		set_battle_stat() ## original stat points
		value = int(value)
		player_effect_modulate($"../player_effects/2", 0, 0 , 100.0)
		$"../player_effects/2".play("defence") # play player effect defence
		modulate_player(100,100,100,1) # flash player white
		await get_tree().create_timer(0.3).timeout # wait 0.3 sec
		modulate_player(1,1,1,1) # return player to normal
		armor_def += value
		$"../full_stats_info/Panel/stat2/arm_def".text = str(armor_def)
		def_value.text = str (final_def + armor_def)
	
	elif effect =='attack_down':
		added_value_for_atk_down += value
		value = int (value)
		modulate = 'ff7f6e'
		self.play("hit")
		await get_tree().create_timer(0.4).timeout
		$"dmg hit".text = str (value)
		$dmg_info.play("dmg_p")
		final_atk -= value
		atk_value.text =  str (final_atk + weapon_atk) #bottom panel update reductions
		atk__.text = "(" + str(final_atk - atk) + ")" # full status board shows reduction
		if atk_negative_value.text and _atk.text == '0':
			atk_negative_value.text = str(value)
			_atk.text = str(value)
		else:
			atk_negative_value.text = str(added_value_for_atk_down)
			_atk.text = str(added_value_for_atk_down)
	
	elif effect == 'def_breaker':
		added_value_for_def_brk += value
		value = int (value)
		modulate = 'blue'
		self.play("hit")
		await get_tree().create_timer(0.4).timeout
		$"dmg hit".text = str (value)
		$dmg_info.play("dmg_p")
		final_def -= value
		def_value.text = str (final_def + armor_def)
		def__.text = "(" + str(final_def - def) + ")"
		if brkr_full.text and brkr_value.text == '0':
			brkr_full.text = str(value)
			brkr_value.text = str(value)
		else:
			brkr_full.text = str(added_value_for_def_brk)
			brkr_value.text = str(added_value_for_def_brk)
	
	elif effect == 'confused': # for psychic effect
		# make enemy attack self
		value = int(value)
		modulate = 'purple'
		self.play("hit")
		camera.shake() # shake screen
		Input.vibrate_handheld(140, 1.0)
		await get_tree().create_timer(0.4).timeout
		modulate = "white"
		$"dmg hit".text = str (value)
		$dmg_info.play("dmg_p")
		current_hp -= value
		player_hp.value = current_hp
		$"../stats_view/hp_value".text = str (current_hp)
		
	elif effect == 'hex':
		value = int(value)
		player_effect_modulate($"../player_effects/mystic", 0.018, 0.368, 0.014)
		$"../player_effects/mystic".play("hex")
		modulate_player(100,100,100,1) # flash player white
		await get_tree().create_timer(0.3).timeout # wait 0.3 sec
		modulate_player(1,1,1,1) # return player to normal
		hex_modifier = value
		
	elif effect == 'shadow':
		value = int(value)
		modulate = "black"
		self.play("hit")
		await get_tree().create_timer(0.4).timeout
		modulate = "white"
		$"dmg hit".text = str (value)
		$dmg_info.play("dmg_p")
		current_hp -= value
		player_hp.value = current_hp
		$"../stats_view/hp_value".text = str (current_hp)
		check_if_you_dead()
		
	elif effect == "shadow_p":
		value = int(value)
		player_effect_modulate($"../player_effects/2", 0, 0, 0)
		$"../player_effects/2".play("shadow")
		modulate_player(100,100,100,1) # flash player white
		await get_tree().create_timer(0.3).timeout # wait 0.3 sec
		modulate_player(1,1,1,1) # return player to normal
		current_hp += value
		if current_hp > player_hp.max_value:
			current_hp = player_hp.max_value
			player_hp.value = current_hp
			player_shadow_status.value = 0
			$"../stats_view/hp_value".text = str (current_hp)
			return
			
		player_hp.value = current_hp
		player_shadow_status.value = 0
		$"../stats_view/hp_value".text = str (current_hp)


func player_effect_modulate (effect_node : AnimatedSprite2D, r : float, g : float, b : float):
	effect_node.self_modulate.r = r
	effect_node.self_modulate.g = g
	effect_node.self_modulate.b = b
	
func check_if_you_dead () -> void:
	if current_hp <= 0:
		battle_scene.game_over()
		## Switch scene to game over menu
		return
