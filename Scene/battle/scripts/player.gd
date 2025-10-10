class_name Player extends AnimatedSprite2D

@onready var atk_value: Label = $"../stats_view/atk_value"
@onready var def_value: Label = $"../stats_view/def_value"
@onready var dex_value: Label = $"../stats_view/dex_value"
@onready var hp_value: Label = $"../stats_view/hp_value"


var player_damage
var current_hp : int

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

@onready var player_hp: TextureProgressBar = $"../player_hp"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_hp = GlobalGameSystem.player_hp
	#player_hp.value = current_hp
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
	atk_value.text =  str (final_atk)
	def_value.text = str (final_def)
	dex_value.text = str (final_dex)
	
	
func set_roll_stat_view (roll_atk, roll_def, roll_dex) -> void:
	atk_value.text = str(roll_atk)
	def_value.text = str (roll_def)
	dex_value.text = str (roll_dex)
	$"../stats_view/AnimationPlayer".play("display")
	
