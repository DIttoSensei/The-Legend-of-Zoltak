class_name MapIcon extends TextureButton

@export var icon_data : IconData

@onready var quest_name: Label = $CanvasLayer/quest_name
@onready var text: RichTextLabel = $CanvasLayer/info_panel/text
@onready var event_button: TextureButton = $CanvasLayer/event_button
@onready var exit: TextureButton = $CanvasLayer/exit
@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var i_name: Label = $name

var current_hp


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.battle_quest_won.connect(battle_victory)
	
	canvas_layer.visible = false
	if icon_data == null:
		return
	self.texture_normal = icon_data.icon_image
	i_name.text = icon_data.name
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_exit_pressed() -> void:
	var sound = load ("res://Asset/sound_effects/click_4_p.wav")
	GlobalGameSystem.play_sfx_audio(sound)
	canvas_layer.visible = false
	SignalManager.map_rewards.emit()
	print ("Global Hp: " + str(GlobalGameSystem.player_hp))
	pass # Replace with function body.

func show_map_quest_data () -> void:
	text.get_v_scroll_bar().value = 0
	quest_name.text = icon_data.name
	text.text = icon_data.info
	canvas_layer.visible = true


func _on_pressed() -> void:
	var sound = load ("res://Asset/sound_effects/click_3.wav")
	GlobalGameSystem.play_sfx_audio(sound)
	GlobalGameSystem.current_icon_data = icon_data
	var current_data = GlobalGameSystem.current_icon_data
	if icon_data == null:
		return
	show_map_quest_data()
	if current_data.type == 'Inn':
		if current_data.nsfw == true:
			sound = load ("res://Asset/ost/sound_effects/giggle1.mp3")
			GlobalGameSystem.play_sfx_audio(sound)
		if GlobalGameSystem.player_hp == 100:
			event_button.visible = false
		else:
			event_button.visible = true
	elif current_data.type == 'Unknown':
		event_button.visible = false
	elif current_data.type == 'Battle Quest':
		GlobalGameSystem.main_battle = false
		GlobalGameSystem.current_icon_data = current_data
		event_button.visible = true
	elif current_data.type == 'Scroll':
		event_button.visible = false 
	elif current_data.type == 'Notice':
		event_button.visible = false
	pass # Replace with function body.


func _on_event_button_pressed() -> void:
	## FOR INN
	if GlobalGameSystem.current_icon_data.type == 'Inn':
		if GlobalGameSystem.player_coin < GlobalGameSystem.current_icon_data.cost:
			var sound = load ("res://Asset/sound_effects/033_Denied_03.wav")
			GlobalGameSystem.play_sfx_audio(sound)
			event_button.visible = false
			text.text = GlobalGameSystem.current_icon_data.no_coin_info
		else:
			if GlobalGameSystem.current_icon_data.nsfw == true:
				var sound = load ("res://Asset/ost/sound_effects/giggle.mp3")
				GlobalGameSystem.play_sfx_audio(sound)
			else:
				var sound = load ('res://Asset/sound_effects/battle_sfx/8bit-powerup1.wav')
				GlobalGameSystem.play_sfx_audio(sound)
			text.text = icon_data.result_info
			event_button.visible = false
			GlobalGameSystem.player_coin -= GlobalGameSystem.current_icon_data.cost
			GlobalGameSystem.player_hp += GlobalGameSystem.current_icon_data.reward_value
			if GlobalGameSystem.player_hp > 100:
				GlobalGameSystem.player_hp = 100
				
	elif GlobalGameSystem.current_icon_data.type == 'Battle Quest':
		current_hp = GlobalGameSystem.player_hp
		GlobalGameSystem.global_sfx_2.stop()
		#$CanvasLayer/ColorRect.MOUSE_FILTER_IGNORE
		SignalManager.battle_action_copy.emit()
		SignalManager.battle_inv_copy.emit()
		var battle_scene = load (icon_data.battle_scene_path)
		SceneTransition.battle_open()
		await get_tree().create_timer(1).timeout
		var add_battle_scene = battle_scene.instantiate()
		$CanvasLayer.add_child(add_battle_scene)
		add_battle_scene.z_index = 11
		add_battle_scene.visible = true
		SceneTransition.battle_close()


func battle_victory () -> void:
	if GlobalGameSystem.current_icon_data != self.icon_data:
		return
	if GlobalGameSystem.can_accept_victory == false:
		return
	SignalManager.reset_action_cooldown.emit()
	#GlobalGameSystem.player_hp = current_hp
	#GlobalGameSystem.reduce_bg_music_by_half = true
	#GlobalGameSystem.global_audio.volume_db = -12
	var sound = load ("res://Asset/ost/sound_effects/cold_wind.mp3")
	GlobalGameSystem.play_sfx2_audio(sound, 10.0)
	#$CanvasLayer/ColorRect.MOUSE_FILTER_STOP
	#battle.visible = false
	
	if GlobalGameSystem.map_battle_quest_won == true:
		text.text = GlobalGameSystem.current_icon_data.result_info
		event_button.visible = false
		SceneTransition.battle_close()
		# give reward
		GlobalGameSystem.player_coin += GlobalGameSystem.current_icon_data.reward_value
	else:
		text.text = GlobalGameSystem.current_icon_data.battle_fail
		event_button.visible = false
		SceneTransition.battle_close()
	GlobalGameSystem.can_accept_victory = false
