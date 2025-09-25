class_name Itemdata extends Resource

@export var name : String
@export_multiline var discription : String = ""
@export var texture : Texture2D 
@export var buff_texture : Texture2D 
@export var buff_texture2 : Texture2D 
@export_enum("Wearable", "Consumable", "item") var item_type : String = ""

@export_enum("Atk", "Def", "Heal", "Crit", "Fire") var attribute : String = ""
@export var attribute_value : int = 0
@export_enum("Headagear", "Chestplate", "Relics", "leggings", "Weapon") var wearable_class : String = ""
@export var item_cost : int
