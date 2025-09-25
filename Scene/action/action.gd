class_name Action extends Resource

@export var action_name : String
@export var action_img : Texture2D
@export_enum("Physical", "Fire","Water", "Lightling", "Ice", "Wind", "Mystic", "Heal", "Defence", "Defence Breaker", "Psychic", "Hex", "Poison") var action_type : String = ""
@export var action_attribute : int
@export var critical_rate : String
@export var cooldown : int
@export var cost : int
@export_multiline var action_info : String
