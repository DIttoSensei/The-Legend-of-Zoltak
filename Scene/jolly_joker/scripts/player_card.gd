class_name PlayerCard extends Sprite2D




func _on_card_btn_pressed() -> void:
	SignalManager.play_player_card.emit(self)
	$card_btn.disabled = true
	pass # Replace with function body.
