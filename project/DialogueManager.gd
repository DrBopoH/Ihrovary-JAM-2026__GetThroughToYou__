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
			create_choice_button(step.choices[i], i)
	else:
		create_choice_button("Далее...", 0)

func create_choice_button(btn_text: String, index: int):
	var btn = Button.new()
	btn.text = btn_text
	btn.rect_min_size = Vector2(0, 36)
	
	if default_style and default_style is DialogueStyles:
		var style = default_style as DialogueStyles
		if style.custom_font:
			btn.add_font_override("font", style.custom_font)
			
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
	get_tree().paused = false
	emit_signal("dialogue_finished")
