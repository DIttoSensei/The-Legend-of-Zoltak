class_name Spawn extends Control


func clear_children () -> void:
	for c in get_children():
		c.queue_free()
