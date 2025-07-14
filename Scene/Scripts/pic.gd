extends TextureRect

@export var images : Array [Player_apperance]

var count : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	$".".texture = images[count].texture
	
	if images.is_empty():
		return
	
	pass


func _on_left_click_pressed() -> void:
	if count > images.size():
		count = 0
	
	else:
		count -= 1
		count %= images.size()
	pass # Replace with function body.


func _on_right_click_pressed() -> void:
	if count > images.size():
		count = 0
	
	else:
		count += 1
		count %= images.size()
	pass # Replace with function body.
