extends CanvasLayer


@export var book : Player_Journal

# onready var
@onready var heading: Label = $Heading
@onready var page_image : TextureRect = $page/page_image
@onready var info : Label = $page/Label

@onready var texture_rect: TextureRect = $TextureRect
@onready var heading_text: Label = $Heading
@onready var page: VBoxContainer = $page
@onready var empty: Label = $empty


# var
var current_index : int = -1 # dont judge me
#
var head_text
var image 
var text 

func _ready() -> void:
	page.visible = false
	texture_rect.visible = false
	heading_text.visible = false
	empty.visible = true
	pass
	


func _on_exit_pressed() -> void:
	visible = false
	current_index = 0
	pass # Replace with function body.


func set_page_data () -> void:
	if book.pages[current_index].journal_data == null:
		return
	page.visible = true
	texture_rect.visible = true
	heading_text.visible = true
	empty.visible = false
		
	head_text = book.pages[current_index].journal_data.heading
	image = book.pages[current_index].journal_data.texture_rect
	text = book.pages[current_index].journal_data.info
	
	
	#book.pages[1].journal_data = load("res://Scene/Stories/Ashes of Brinkwood/journal_page_lit/testing2.tres")
	update_page()
	
	
# update page
func update_page () -> void:
	heading.text = head_text
	page_image.texture = image
	info.text = text
	pass
	
func add_page (new_page : String) -> void:
	#if book.pages[current_index].journal_data == null:
		#var next_index = current_index
		#var page_data = load(new_page)
		#book.add_items(next_index, page_data)
		#set_page_data()
		##current_index += 1
		#print("yo")
	#else:
	
	var next_index = current_index + 1
	var page_data = load(new_page)
	book.add_items(next_index, page_data)
	current_index += 1
	set_page_data()



func _on_left_screentouch_pressed() -> void:
	if current_index > book.pages.size():
		current_index = 0
	
	else:
		current_index -= 1
		if book.pages[current_index].journal_data == null:
			current_index += 1
			return
		current_index %= book.pages.size()
		set_page_data()
		


func _on_right_screentouch_pressed() -> void:
	if current_index > book.pages.size():
		current_index = 0
	
	else:
		current_index += 1
		if book.pages[current_index].journal_data == null:
			current_index -= 1
			return
		current_index %= book.pages.size()
		set_page_data()
