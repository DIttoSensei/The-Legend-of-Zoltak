extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneTransition.fade_in()
	
	$ScrollContainer.set_deferred("scroll_vertical", 205)
	$ScrollContainer.set_deferred("scroll_horizontal", 485)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
