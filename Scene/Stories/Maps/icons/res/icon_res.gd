class_name IconData extends Resource

@export_enum("Inn", "Unknown", "Scroll", "Battle Quest", "Notice") var type : String
@export var name : String
@export var icon_image : Texture2D
@export_multiline var info : String
@export var battle_scene_path : String
@export_enum("coin", 'hp') var reward_type : String
@export var reward_value : int
