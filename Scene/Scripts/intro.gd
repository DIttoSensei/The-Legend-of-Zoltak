class_name Intro extends Node2D

@onready var timer: Timer = $Control/Label/Timer
@onready var label: RichTextLabel = $Control/Label


var counter = -5

var input_locked := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#label.visible_characters = 0
	timer.start()
	#SceneTransition.fade_in()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	counter += 1
	
	#label.visible_characters += 1
	label.text = "[fade start=" + str(counter) + " length=10]
Across this shadowed realm, where ancient stones hum with forgotten magic and the air tastes of ages past, there exists no single truth, but a tepestry woven from countless echoes. This is not the tale of one hero, nor a chronicle of a single evil, but a compilation of whispers from a forgotten time. Some speak of nobility and courage, others of nightmares given form, etched in blood and fear. from sorrow-cloaked peaks to lightless chasms, these are the sagas of ZOLTAK - a testament to what was, what is, and what yet might be...
[/fade]"
	
	#if label.visible_characters == label.text.length():
		#timer.stop()
		#print ("yes")
	
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if input_locked:
		return
	if ConfirmQuit.show == true:
		return
	if event is InputEventScreenTouch:
		if event.is_pressed():
			input_locked = true
			counter = 600
			
			ConfirmQuit.loading = true
			await get_tree().create_timer(2).timeout
			
			LevelManager.load_new_level = "res://Scene/Stories/story_select.tscn"
			LevelManager.load_level()
			
			
