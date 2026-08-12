extends Node2D

onready var dialogue_manager = $UI/DialoguePanel 
onready var menu = $UI/Menu 

func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		if not menu.visible and not dialogue_manager.visible:
			if menu.starting_step:
				dialogue_manager.start_dialogue(menu.starting_step)
				get_tree().set_input_as_handled()
	
	elif event.is_action_pressed("ui_cancel"):
		if not menu.visible:
			menu.show()
			menu.btn_start.grab_focus()
			
			if dialogue_manager.visible:
				dialogue_manager.end_dialogue()
			
			get_tree().set_input_as_handled()
