extends VBoxContainer

@onready var profile_creation: ProfileCreation = $"../.."
@onready var atk_slider: HSlider = $Atk/Atk_slider
@onready var def_slider: HSlider = $Def/Def_slider
@onready var dex_slider: HSlider = $Dex/Dex_slider
@onready var con_slider: HSlider = $Con/Con_slider
@onready var int_slider: HSlider = $Int/Int_slider
@onready var cha_slider: HSlider = $Cha/Cha_slider
@onready var wis_slider: HSlider = $Wis/Wis_slider


func _on_atk_slider_value_changed(_value: float) -> void:
	profile_creation.current_slider = $Atk/Atk_slider
	#atk_slider.get_node("counter").set_deferred("text", str(atk_slider.value))
	#$Atk/Atk_slider/counter.text = str (atk_slider.value)
	pass # Replace with function body.


func _on_def_slider_value_changed(_value: float) -> void:
	profile_creation.current_slider = $Def/Def_slider
	#def_slider.get_node("counter").set_deferred("text", str(def_slider.value))
	#$Def/Def_slider/counter.text = str (def_slider.value)
	pass # Replace with function body.


func _on_dex_slider_value_changed(_value: float) -> void:
	profile_creation.current_slider = $Dex/Dex_slider
	#$Dex/Dex_slider/counter.text = str (dex_slider.value)
	#pass # Replace with function body.


func _on_con_slider_value_changed(_value: float) -> void:
	profile_creation.current_slider = $Con/Con_slider
	#$Con/Con_slider/counter.text = str (con_slider.value)
	#pass # Replace with function body.


func _on_int_slider_value_changed(_value: float) -> void:
	profile_creation.current_slider = $Int/Int_slider
	#$Int/Int_slider/counter.text = str (int_slider.value)
	#pass # Replace with function body.


func _on_cha_slider_value_changed(_value: float) -> void:
	profile_creation.current_slider = $Cha/Cha_slider
	#$Cha/Cha_slider/counter.text = str (cha_slider.value)
	#pass # Replace with function body.


func _on_wis_slider_value_changed(_value: float) -> void:
	profile_creation.current_slider = $Wis/Wis_slider
	#$Wis/Wis_slider/counter.text = str (wis_slider.value)
	#pass # Replace with function body.
