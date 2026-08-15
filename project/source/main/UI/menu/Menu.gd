extends Control

export(Resource) var menu_style
export(Resource) var starting_step

onready var btn_start = $VBoxContainer/Start
onready var btn_settings = $VBoxContainer/Settings
onready var btn_credits = $VBoxContainer/Credits
onready var btn_exit = $VBoxContainer/Exit

func _ready():
	var buttons = [btn_start, btn_settings, btn_credits, btn_exit]
	
	for btn in buttons:
		apply_button_style(btn)
		btn.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	btn_start.connect("pressed", self, "_on_Start_pressed")
	btn_settings.connect("pressed", self, "_on_Settings_pressed")
	btn_credits.connect("pressed", self, "_on_Credits_pressed")
	btn_exit.connect("pressed", self, "_on_Exit_pressed")
	
	btn_start.grab_focus()

func apply_button_style(btn: Button):
	if menu_style:
		if "custom_font" in menu_style and menu_style.custom_font:
			btn.add_font_override("font", menu_style.custom_font)
		
		if "button_normal_style" in menu_style and menu_style.button_normal_style:
			btn.add_stylebox_override("normal", menu_style.button_normal_style)
		if "button_hover_style" in menu_style and menu_style.button_hover_style:
			btn.add_stylebox_override("hover", menu_style.button_hover_style)
		if "button_pressed_style" in menu_style and menu_style.button_pressed_style:
			btn.add_stylebox_override("pressed", menu_style.button_pressed_style)
			btn.add_stylebox_override("focus", menu_style.button_hover_style) 
			
	if not menu_style or not menu_style.get("button_normal_style"):
		var normal_style = StyleBoxFlat.new()
		normal_style.bg_color = Color(0, 0, 0, 0.7) 
		normal_style.border_width_left = 4          
		normal_style.border_color = Color(0.8, 0.4, 0.1, 1.0) 
		
		var hover_style = normal_style.duplicate()
		hover_style.bg_color = Color(0.2, 0.2, 0.2, 0.9) 
		
		btn.add_stylebox_override("normal", normal_style)
		btn.add_stylebox_override("hover", hover_style)
		btn.add_stylebox_override("pressed", hover_style)
		btn.add_stylebox_override("focus", hover_style)

func _on_Start_pressed():
	hide()

func _on_Settings_pressed():
	print("Открываем меню настроек...")

func _on_Credits_pressed():
	print("Открываем титры...")

func _on_Exit_pressed():
	get_tree().quit()
