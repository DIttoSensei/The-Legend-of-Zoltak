class_name Achievement extends VBoxContainer

const ACHIVEMENT_SLOT = preload("res://Scene/achievements/achievement_ui.tscn")
@export var data : PlayerAchivements



func _ready() -> void:
	
	update_slot()
	pass
	
	
	
func clear_slots () -> void:
	var padding = $PADDING
	
	for child in self.get_children():
		if child != padding:
			child.queue_free()
	
func update_slot () -> void:
	var padding = $PADDING
	clear_slots()
	for s in data.slots:
		var new_slot = ACHIVEMENT_SLOT.instantiate()
		add_child(new_slot)
		move_child(padding, get_child_count() - 1)
		new_slot.data = s
