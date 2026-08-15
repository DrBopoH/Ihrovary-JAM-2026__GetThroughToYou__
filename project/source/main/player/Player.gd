extends KinematicBody2D

export var speed: float = 150.0
var velocity: Vector2 = Vector2.ZERO
var last_direction: String = "front"

func _physics_process(_delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_back") - Input.get_action_strength("move_forward")
	
	input_vector = input_vector.normalized()
	
	velocity = input_vector * speed
	velocity = move_and_slide(velocity)
	
	update_animation(input_vector)

func update_animation(input_vector: Vector2):
	var state = "idle_"
	var direction = last_direction

	if input_vector != Vector2.ZERO:
		state = "run_"
		
		if abs(input_vector.x) > abs(input_vector.y):
			direction = "right" if input_vector.x > 0 else "left"
		else:
			direction = "front" if input_vector.y > 0 else "back" 
			
		last_direction = direction
	
	$sprite.play(state + direction)
