class_name Player_Journal extends Resource


@export var pages : Array[Journal]

func add_items (next_index : int, page_data : JournalPage) -> void:
	if pages[next_index].journal_data != null:
		return
	pages[next_index].journal_data = page_data
	pass
