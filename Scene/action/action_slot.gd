extends Button
class_name ActionSlotUi

var action_data : Actions : set = set_slot_data
var action_cooldown_adder : bool = false

@onready var texture_rect: TextureRect = $TextureRect
@onready var action_name: Label = $TextureRect/name


func _ready() -> void:
	action_name.text = ""
	SignalManager.turn_end.connect(process_action_timeout)
	#SignalManager.disable_action.connect(timeout)
	#SignalManager.enable_action.connect(activate_action)
	

func set_slot_data (value : Actions) -> void:
	action_data = value
	if action_data == null :
		return
	action_name.text = action_data.action_data.action_name
	var item = action_data.action_data.timeout
	if item == true:
		timeout()
		
	else:
		activate_action()

func process_action_timeout () -> void:
	if action_cooldown_adder == true:
		pass
	else:
		action_data.action_data.current_cooldown += 1
		action_cooldown_adder = true
	if action_data.action_data.timeout == true: 
		if action_data.action_data.current_cooldown > 0:
			action_data.action_data.current_cooldown -= 1
			print("script: ", action_data.action_data.current_cooldown)
			
			if action_data.action_data.current_cooldown <= 0:
				print("less than")
				action_data.action_data.current_cooldown = 0
				action_data.action_data.timeout = false
				action_cooldown_adder = false
				activate_action()



func _on_pressed() -> void:
	GlobalGameSystem.action_data_inv = action_data
	$"../../../img".visible = false
	SignalManager.show_action_info.emit()
	SignalManager.player_attack.emit(action_data)
	pass # Replace with function body.

func timeout () -> void:
	self.disabled = true
	texture_rect.modulate = 535353
	
func activate_action () -> void:
	self.disabled = false
	texture_rect.modulate = 'white'
