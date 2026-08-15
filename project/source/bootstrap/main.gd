extends Node2D

onready var dialogue_manager = $UI/DialoguePanel 
onready var menu = $UI/Menu 

const PlayerScene = preload("res://source/main/player/Player.tscn")

func _ready():
	menu.connect("start_game", self, "_on_menu_start_game")
	
	dialogue_manager.connect("dialogue_finished", self, "_on_dialogue_finished")

func _on_menu_start_game():
	if menu.starting_step:
		dialogue_manager.start_dialogue(menu.starting_step)

func _on_dialogue_finished():
	if not has_node("Player"):
		var player_instance = PlayerScene.instance()
		
		player_instance.global_position = Vector2(960, 540) 
		
		add_child(player_instance)

func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if not menu.visible:
			menu.show()
			menu.btn_start.grab_focus()
			
			if dialogue_manager.visible:
				dialogue_manager.force_reset()
			
			get_tree().set_input_as_handled()
