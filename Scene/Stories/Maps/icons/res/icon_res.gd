class_name IconData extends Resource

@export_enum("Inn", "Unknown", "Scroll", "Battle Quest", "Notice") var type : String
@export var name : String
@export var icon_image : Texture2D
@export_multiline var info : String

@export_category("Battle")
@export var battle_scene_path : String
@export var completed : bool
@export_multiline var battle_fail : String
 
@export_category("Outcome")
@export var cost : int
@export_multiline var result_info : String
@export_multiline var no_coin_info : String
@export_enum("coin", 'hp') var reward_type : String
@export var reward_value : int

@export_category("SPECIAL")
@export var nsfw : bool
@export var nsfw_audio_start_path : String
@export var nsfw_audio_end_path : String
