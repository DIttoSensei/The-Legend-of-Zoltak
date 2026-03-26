class_name Manual extends Control

@onready var img: TextureRect = $img
@onready var info: RichTextLabel = $info
@onready var section_1: ScrollContainer = $section_1

var can_transition : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneTransition.fade_in()
	SignalManager.show_manual_content.connect(show_content)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func show_content () -> void:
	info.get_v_scroll_bar().value = 0
	can_transition = false
	var data = GlobalGameSystem.manual_data
	section_1.visible = false
	img.texture = data.img
	info.text = data.info
	img.visible = true
	info.visible = true

func return_to_list () -> void:
	img.visible = false
	info.visible = false
	section_1.visible = true
	can_transition = true


func _on_back_button_pressed() -> void:
	if can_transition == true:
		var audio = load("res://Asset/sound_effects/click_1.wav")
		GlobalGameSystem.play_sfx_audio(audio)
		LevelManager.load_new_level = "res://Scene/options_scene.tscn"
		LevelManager.load_level()
	else:
		return_to_list()
	
