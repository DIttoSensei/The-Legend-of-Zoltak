extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer
@onready var effect_audio: AudioStreamPlayer = $effect_audio
@onready var fog: ColorRect = $fog/Parallax2D/ColorRect
@onready var fog_animation: AnimationPlayer = $"fog/Parallax2D/fog animation"
@onready var timer: Timer = $Timer
@onready var label: RichTextLabel = $Control/RichTextLabel
@onready var text_animation: AnimationPlayer = $"Control/RichTextLabel/text animation"
@onready var effect_audio_2: AudioStreamPlayer = $effect_audio_2

var counter := 1

@export_multiline var batch_1 : String
@export_multiline var batch_2 : String
@export_multiline var batch_3 : String
@export_multiline var batch_4 : String
@export_multiline var batch_5 : String
@export_multiline var batch_6 : String
@export_multiline var batch_7 : String


var transition_duration : float = 5.0

func _ready() -> void:
	await get_tree().create_timer(3.5).timeout
	timer.start()
	effect_audio.volume_db = -60
	effect_audio_2.volume_db = -60
	effect_audio.play()
	effect_audio_2.play()
	fade_in(effect_audio, -4)
	fade_in(effect_audio_2, -14)
	fog_animation.play('fade_fog_in')
	pass
	#GlobalGameSystem.global_audio.stream = preload("res://Asset/ost/White Woodlands - Alexander Nakarada.mp3")
	#GlobalGameSystem.play_bg_audio()
	#animation_player.play("loading")
	




func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "loading":
		LevelManager.load_new_level = "res://Scene/Stories/Ashes of Brinkwood/main.tscn"
		LevelManager.load_level_single_transition()
	
	pass # Replace with function body.


func fade_out(audio : AudioStreamPlayer):
	var tween_out = create_tween()
	tween_out.tween_property(audio, "volume_db", -80, transition_duration)
	tween_out.tween_callback(Callable(self, "_on_fade_out_complete"))
	
func _on_fade_out_complete ():
	effect_audio.stop()
	effect_audio_2.stop()
	effect_audio.volume_db = 0
	effect_audio_2.volume_db = 0

func fade_in(audio : AudioStreamPlayer, volume_value : int):
	var tween_in = create_tween()
	tween_in.tween_property(audio, "volume_db", volume_value, transition_duration)
	tween_in.tween_callback(Callable(self, "_on_fade_in_complete"))
	
func _on_fade_in_complete ():
	#effect_audio.stop()
	effect_audio.volume_db = -4
	effect_audio_2.volume_db = -14
	
	
func start_text () -> void: 
	text_animation.play('text_fade_in')
	


func _on_timer_timeout() -> void:
	if counter == 1:
		label.text = self.batch_1
		start_text()
	elif counter == 2:
		label.text = self.batch_2
		start_text()
	elif counter == 3:
		label.text = self.batch_3
		start_text()
	elif counter == 4:
		label.text = self.batch_4
		start_text()
	elif counter == 5:
		label.text = self.batch_5
		start_text()
	elif counter == 6:
		label.text = self.batch_6
		start_text()
	elif counter == 7:
		label.text = self.batch_7
		start_text()
	else:
		fog_animation.play('fade_fog_out')
		fade_out(effect_audio)
		fade_out(effect_audio_2)
		$Control/AnimationPlayer.play("loading")
	


func _on_text_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'text_fade_in':
		await get_tree().create_timer(15).timeout
		text_animation.play('text_fade_out')
	
	elif anim_name == 'text_fade_out':
		counter += 1
		timer.start()
	


func _on_button_pressed() -> void:
	fog_animation.play('fade_fog_out')
	fade_out(effect_audio)
	fade_out(effect_audio_2)
	$Control/AnimationPlayer.play("loading")
	pass # Replace with function body.
