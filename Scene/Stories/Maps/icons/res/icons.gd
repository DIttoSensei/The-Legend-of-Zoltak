class_name MapIcon extends TextureButton

@export var icon_data : IconData

@onready var quest_name: Label = $CanvasLayer/quest_name
@onready var text: RichTextLabel = $CanvasLayer/info_panel/text
@onready var event_button: TextureButton = $CanvasLayer/event_button
@onready var exit: TextureButton = $CanvasLayer/exit
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var i_name: Label = $name


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canvas_layer.visible = false
	if icon_data == null:
		return
	self.texture_normal = icon_data.icon_image
	i_name.text = icon_data.name
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_pressed() -> void:
	canvas_layer.visible = false
	pass # Replace with function body.

func show_map_quest_data () -> void:
	quest_name.text = icon_data.name
	text.text = icon_data.info
	canvas_layer.visible = true


func _on_pressed() -> void:
	if icon_data == null:
		return
	show_map_quest_data()
	pass # Replace with function body.


func _on_event_button_pressed() -> void:
	pass # Replace with function body.
