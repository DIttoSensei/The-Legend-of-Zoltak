extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneTransition.fade_in()
	$AnimationPlayer.play("display")
	GlobalGameSystem.global_audio.stream = preload("res://Asset/ost/Crown and Steel - Medieval Free Song(2).mp3")
	
	await get_tree().create_timer(1.5).timeout
	GlobalGameSystem.play_bg_audio()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
