class_name Action extends Resource

@export var action_name : String
@export var action_img : Texture2D
@export_enum("Physical", "Fire","Water", "Lightning", "Ice", "Wind", "Earth",
 "Mystic", "Heal", "Defence","Atk Down", "Def Breaker", "Psychic", "Hex", 
"Shadow","Bleed", "Poison") var action_type : String = ""
@export var action_attribute : int
@export var critical_rate : String
@export var cooldown : int
@export var current_cooldown : int = 0
@export var cost : int
@export_multiline var action_info : String
@export var purchased : bool 
