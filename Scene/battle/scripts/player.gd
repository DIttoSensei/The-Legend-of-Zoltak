class_name Player extends AnimatedSprite2D

@onready var atk_value: Label = $"../stats_view/atk_value"
@onready var def_value: Label = $"../stats_view/def_value"
@onready var dex_value: Label = $"../stats_view/dex_value"
@onready var hp_value: Label = $"../stats_view/hp_value"
@onready var battle_scene: Node2D = $"../.."
@onready var enemy: Enemy = $"../enemy"



var player_damage
var current_hp : int
var selected_inv : Array = []
var status_chance = 100

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
		battle_scene.enemy_critical_hit = false
		$criti_hit.play("show")
		
	camera.shake() # shake screen
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
	
	
		
func set_battle_stat () -> void:
	atk = GlobalGameSystem.player_atk 
	def = GlobalGameSystem.player_def 
	dex = GlobalGameSystem.player_dex
	wis = GlobalGameSystem.player_wis
	Int = GlobalGameSystem.player_int
	con = GlobalGameSystem.player_con

	
	final_atk = atk + (min(Int , atk) - atk) * 0.7
	final_def = def + (min(con , def) - def) * 0.7
	final_dex = dex + (min(wis , dex) - dex) * 0.7
	final_con = con + (min(wis , con) - con) * 0.7
	
	
	
	set_stat_view()
	pass

func set_stat_view () -> void:
	atk_value.text =  str (final_atk + weapon_atk)
	def_value.text = str (final_def + armor_def)
	dex_value.text = str (final_dex)
	
	
func set_roll_stat_view (roll_atk, roll_def, roll_dex) -> void:
	atk_value.text = str(roll_atk)
	def_value.text = str (roll_def)
	dex_value.text = str (roll_dex)
	$"../stats_view/AnimationPlayer".play("display")
	

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
		
		
		
func perform_action (damage, action : Action) -> void:
	
	## Physical modifer
	if action.action_type == "Physical":
		self.play("attack")
		$hit_box_hit.play("hit")
		damage = max(0, damage - enemy.def) # deduct damage from enemy def
		SignalManager.enemy_damaged.emit(damage)
		
	elif action.action_type == "Fire":
		self.play("attack")
		$hit_box_hit.play("hit")
		damage = max(0, damage - enemy.def) # deduct damage from enemy def
		SignalManager.enemy_damaged.emit(damage)
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			enemy.fire_status.active = true
		
	elif action.action_type == "Water":
		self.play("attack")
		$hit_box_hit.play("hit")
		damage = max(0, damage - enemy.def) # deduct damage from enemy def
		SignalManager.enemy_damaged.emit(damage)
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			enemy.water_status.active = true
		
		pass
	
	elif action.action_type == "Lightning":
		self.play("attack")
		$hit_box_hit.play("hit")
		damage = max(0, damage - enemy.def) # deduct damage from enemy def
		SignalManager.enemy_damaged.emit(damage)
		var roll = randi_range(1, 100)
		if roll <= status_chance:
			enemy.lightning_status.active = true
		pass
		
	elif action.action_type == "Ice":
		pass
		
	elif action.action_type == "Wind":
		pass
	
	elif action.action_type == "Earth":
		pass
		
	elif action.action_type == "Mystic":
		pass
		
	elif action.action_type == "Heal":
		pass
		
	elif action.action_type == "Defence":
		pass
	
	elif action.action_type == "Atk Down":
		pass
		
	elif action.action_type == "Def Breaker":
		pass
		
	elif action.action_type == "Psychic":
		pass
		
	elif action.action_type == "Hex":
		pass
		
	elif action.action_type == "Shadow":
		pass
		
	elif action.action_type == "Bleed":
		pass
		
	elif action.action_type == "Poison":
		pass
