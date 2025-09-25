extends VBoxContainer

const ACHIVEMENT_SLOT = preload("res://Scene/achievements/achievement_ui.tscn")
@export var data : PlayerAchivements



func _ready() -> void:
	update_slot()
	pass
	
	
	
func clear_slots () -> void:
	for i in range(data.slots.size()):
		if data.slots[i] == null:
			for chid in self.get_children():
				chid.queue_free()
			pass
	
func update_slot () -> void:
	clear_slots()
	for s in data.slots:
		var new_slot = ACHIVEMENT_SLOT.instantiate()
		add_child(new_slot)
		new_slot.data = s
