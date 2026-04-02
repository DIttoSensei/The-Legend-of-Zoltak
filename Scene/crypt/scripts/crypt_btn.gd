class_name CryptBtn
extends TextureButton

@export var data : CryptBtnRes


@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var img: TextureRect = $CanvasLayer/TextureRect
@onready var text: RichTextLabel = $CanvasLayer/Control/info_panel/text
@onready var label: Label = $Control/Label

var counter : int = 0

func _ready() -> void:
	if data == null:
		return
	label.text = data.name


func _on_pressed() -> void:
	var audio = load("res://Asset/sound_effects/click_4_p.wav")
	GlobalGameSystem.play_sfx3_audio(audio)
		
	GlobalGameSystem.current_crpt_data = data
	if GlobalGameSystem.current_crpt_data != self.data:
		return
	counter += 1
	img.texture = GlobalGameSystem.current_crpt_data.img
	canvas_layer.visible = true


func _on_info_pressed() -> void:
	var audio = load("res://Asset/sound_effects/click_3.wav")
	GlobalGameSystem.play_sfx3_audio(audio)
	
	if GlobalGameSystem.current_crpt_data != self.data:
		return
	counter += 1
	text.text = GlobalGameSystem.current_crpt_data.info
	text.get_v_scroll_bar().value = 0
	$CanvasLayer/Control.visible = true


func _on_back_button_pressed() -> void:
	var audio = load("res://Asset/sound_effects/click_1.wav")
	GlobalGameSystem.play_sfx3_audio(audio)
	if counter == 1:
		canvas_layer.visible = false
		counter -= 1
		
	
	pass # Replace with function body.


func _on_back_button_2_pressed() -> void:
	var audio = load("res://Asset/sound_effects/click_1.wav")
	GlobalGameSystem.play_sfx3_audio(audio)
	if counter == 2:
		$CanvasLayer/Control.visible = false
		counter -= 1
	pass # Replace with function body.
