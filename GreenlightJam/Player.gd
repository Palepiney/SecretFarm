extends KinematicBody

export var speed = 14
export var fall_acceleration = 75
export var jump_impulse = 20
export var is_carrying = false

var velocity = Vector3.ZERO
var mouse_sensitivity = 0.002
var capture_mouse = false


func _get_input():
	var direction = Vector3.ZERO
	
	# Interpret player input and update direction
	if Input.is_action_pressed("ui_right"):
		direction += global_transform.basis.x
	if Input.is_action_pressed("ui_left"):
		direction -= global_transform.basis.x
	if Input.is_action_pressed("ui_down"):
		direction += global_transform.basis.z
	if Input.is_action_pressed("ui_up"):
		direction -= global_transform.basis.z
	
	# Normalize speed
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	return direction


func _input(event):
	if event is InputEventMouseButton:
		if not capture_mouse:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			capture_mouse = true
		
		if is_carrying:
			drop_item()
	
	# Mouse movement controls camera
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotate_x(-event.relative.y * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -1.2, 1.2)
	
	# Esc allows mouse to exit game
	if event.is_action_pressed("ui_cancel") and capture_mouse:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		capture_mouse = false


func _physics_process(delta):
	# Ground velocity
	velocity.x = _get_input().x * speed
	velocity.z = _get_input().z * speed
	
	# Vertical velocity
	velocity.y -= fall_acceleration * delta
	
	# Move character
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
	# Jumping
	if is_on_floor() and Input.is_action_just_pressed("Jump"):
		velocity.y += jump_impulse

func drop_item():
	is_carrying = false
	if $Pivot/Carrying.get_child_count() != 0:
		var item = $Pivot/Carrying.get_child(0)
		item.queue_free()
