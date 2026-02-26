extends RichTextLabel

var touch_dragging := false
var touch_start := Vector2()
var scroll_start := Vector2()

func _gui_input(event):
	# Touch press
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_dragging = true
			touch_start = event.position
			# We capture the current scroll value from the internal scrollbar
			scroll_start.y = get_v_scroll_bar().value
			accept_event()
		else:
			touch_dragging = false

	# Touch drag
	elif event is InputEventScreenDrag and touch_dragging:
		# Calculate the new scroll position based on the drag distance
		var drag_distance = event.position.y - touch_start.y
		get_v_scroll_bar().value = scroll_start.y - drag_distance
		accept_event()
