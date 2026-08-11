extends Node2D

export(Resource) var starting_step 

onready var dialogue_manager = $UI/DialoguePanel 

func _input(event):
	if event.is_action_pressed("ui_accept") and not dialogue_manager.visible:
		dialogue_manager.start_dialogue(starting_step)
