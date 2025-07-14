extends VBoxContainer



func _on_atk_slider_value_changed(value: float) -> void:
	$Atk/Atk_slider/counter.text = str (value)
	pass # Replace with function body.


func _on_def_slider_value_changed(value: float) -> void:
	$Def/Def_slider/counter.text = str (value)
	pass # Replace with function body.


func _on_dex_slider_value_changed(value: float) -> void:
	$Dex/Dex_slider/counter.text = str (value)
	pass # Replace with function body.


func _on_con_slider_value_changed(value: float) -> void:
	$Con/Con_slider/counter.text = str (value)
	pass # Replace with function body.


func _on_int_slider_value_changed(value: float) -> void:
	$Int/Int_slider/counter.text = str (value)
	pass # Replace with function body.


func _on_cha_slider_value_changed(value: float) -> void:
	$Cha/Cha_slider/counter.text = str (value)
	pass # Replace with function body.


func _on_wis_slider_value_changed(value: float) -> void:
	$Wis/Wis_slider/counter.text = str (value)
	pass # Replace with function body.
