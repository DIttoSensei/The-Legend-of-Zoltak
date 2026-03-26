class_name Obj extends TextureButton

@export var manual_res : ManualData
@onready var label: Label = $Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if manual_res == null:
		return
	label.text = manual_res.section_name
	pass # Replace with function body.



func _on_pressed() -> void:
	GlobalGameSystem.manual_data = manual_res
	SignalManager.show_manual_content.emit()
	pass # Replace with function body.
