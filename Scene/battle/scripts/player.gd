class_name Player extends AnimatedSprite2D

var atk : int = 0
var def : int = 0
var dex : int = 0

var player_damage
var current_hp : int

@onready var player_hp: TextureProgressBar = $"../player_hp"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_hp = player_hp.value
	SignalManager.player_damaged.connect(take_damage)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	self.play("hit")
	$"dmg hit".text = str(player_damage)
	$dmg_info.play("dmg")
	current_hp -= player_damage
	player_hp.value = current_hp
	pass # Replace with function body.


func _on_animation_finished() -> void:
	self.play("idle")
	pass # Replace with function body.


func take_damage (damage) -> void:
	player_damage = damage
	
	
