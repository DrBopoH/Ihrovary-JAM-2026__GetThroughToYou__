extends Control

signal dialogue_finished
signal game_event_triggered(event_name)

export(Resource) var default_style

var current_step: DialogueStep

onready var text_label = $ContentArea/UIStack/TextLabel
onready var name_label = $ContentArea/UIStack/NameLabel
onready var portrait_rect = $PortraitRect
onready var choices_container = $ContentArea/UIStack/ChoicesContainer
onready var background = $Background

func _ready():
	hide()

func _input(event):
	if not visible or current_step == null:
		return
	
	if current_step.choices.size() > 0:
		return
	
	var is_space = event.is_action_pressed("ui_accept")
	var is_click = (event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed)
	var is_touch = (event is InputEventScreenTouch and event.pressed)
	
	if is_space or is_click or is_touch:
		get_tree().set_input_as_handled() 
		
		if current_step.next_steps.size() > 0:
			display_step(current_step.next_steps[0])
		else:
			end_dialogue()

func start_dialogue(start_step: DialogueStep):
	get_tree().paused = true
	show()
	display_step(start_step)

func display_step(step: DialogueStep):
	if step == null:
		end_dialogue()
		return
	
	current_step = step
	
	text_label.text = step.text
	
	if step.character and step.character is CharacterData:
		var char_data = step.character as CharacterData
		name_label.text = char_data.character_name
		name_label.modulate = char_data.name_color
		
		var active_portrait = char_data.get_portrait(step.emotion)
		if active_portrait:
			portrait_rect.texture = active_portrait
			portrait_rect.show()
		else:
			portrait_rect.hide()
	else:
		name_label.text = ""
		portrait_rect.hide()
	
	var active_style: DialogueStyles = null
	
	if step.style_override and step.style_override is DialogueStyles:
		active_style = step.style_override as DialogueStyles
	elif default_style and default_style is DialogueStyles:
		active_style = default_style as DialogueStyles
	
	if active_style:
		if active_style.panel_background:
			background.texture = active_style.panel_background
		if active_style.text_color:
			text_label.modulate = active_style.text_color
		if active_style.custom_font:
			name_label.add_font_override("font", active_style.custom_font)
			text_label.add_font_override("normal_font", active_style.custom_font)
	
	if step.trigger_event != "":
		emit_signal("game_event_triggered", step.trigger_event)
	
	clear_choices()
	
	if step.choices.size() > 0:
		for i in range(step.choices.size()):
			create_choice_button(step.choices[i], i, active_style)

func create_choice_button(btn_text: String, index: int, style: DialogueStyles):
	var btn = Button.new()
	btn.text = btn_text
	btn.rect_min_size = Vector2(0, 45) 
	btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	if style:
		if style.custom_font:
			btn.add_font_override("font", style.custom_font)
		
		if style.button_normal_style:
			btn.add_stylebox_override("normal", style.button_normal_style)
		if style.button_hover_style:
			btn.add_stylebox_override("hover", style.button_hover_style)
		if style.button_pressed_style:
			btn.add_stylebox_override("pressed", style.button_pressed_style)
	
	if not style or not style.button_normal_style:
		var normal_style = StyleBoxFlat.new()
		normal_style.bg_color = Color(0, 0, 0, 0.7) 
		normal_style.border_width_left = 4          
		normal_style.border_color = Color(0.8, 0.4, 0.1, 1.0) 
		
		var hover_style = normal_style.duplicate()
		hover_style.bg_color = Color(0.2, 0.2, 0.2, 0.9) 
		
		btn.add_stylebox_override("normal", normal_style)
		btn.add_stylebox_override("hover", hover_style)
		btn.add_stylebox_override("pressed", hover_style)
	
	btn.connect("pressed", self, "_on_choice_made", [index])
	choices_container.add_child(btn)

func _on_choice_made(index: int):
	if index < current_step.next_steps.size():
		display_step(current_step.next_steps[index])
	else:
		end_dialogue()

func clear_choices():
	for child in choices_container.get_children():
		child.queue_free()

func end_dialogue():
	hide()
	current_step = null
	get_tree().paused = false
	emit_signal("dialogue_finished")
