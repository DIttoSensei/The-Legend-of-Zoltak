extends Button
class_name ActionSlotUi

var action_data : Actions : set = set_slot_data
@onready var texture_rect: TextureRect = $TextureRect
@onready var action_name_label: Label = $TextureRect/name

func _ready() -> void:
	action_name_label.text = ""
	#SignalManager.turn_end.connect(process_turn)

func set_slot_data(value: Actions) -> void:
	action_data = value
	if action_data == null:
		action_name_label.text = ""
		return
	action_name_label.text = action_data.action_data.action_name
	update_state()

func update_state() -> void:
	# Disable button if action is on cooldown
	if action_data.action_data.current_cooldown > 0:
		timeout()
		action_data.action_data.current_cooldown -= 1
		
	else:
		activate_action()
		action_data.action_data.current_cooldown = 0


func _on_pressed() -> void:
	if  action_data.action_data.current_cooldown > 0:
		return
		
	var sound = load ("res://Asset/sound_effects/click_2.wav")
	GlobalGameSystem.play_sfx_audio(sound)
	
	GlobalGameSystem.action_data_inv = action_data
	$"../../../img".visible = false
	SignalManager.show_action_info.emit()
	SignalManager.player_attack.emit(action_data)
	# Set cooldown after using action
	if GlobalGameSystem.battle_started == false:
		return
	
	

func timeout() -> void:
	self.disabled = true
	texture_rect.modulate = Color(0.33,0.33,0.33) # gray out

func activate_action() -> void:
	self.disabled = false
	texture_rect.modulate = Color(1,1,1) # normal
