extends ScrollContainer

var touch_dragging := false
var touch_start := Vector2()
var scroll_start := Vector2()

func _gui_input(event):
	# Touch press
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_dragging = true
			touch_start = event.position
			scroll_start = Vector2(scroll_horizontal, scroll_vertical)
			accept_event()
		else:
			touch_dragging = false

	# Touch drag
	elif event is InputEventScreenDrag and touch_dragging:
		scroll_horizontal = scroll_start.x - (event.position.x - touch_start.x)
		scroll_vertical   = scroll_start.y - (event.position.y - touch_start.y)
		accept_event()
