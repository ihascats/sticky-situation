extends RigidBody2D

var direction = Vector2.RIGHT
var mouse_press_position = Vector2.ZERO
var mouse_release_position = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	sleeping = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if sleeping:
		if Input.is_action_just_pressed("mouse_down"):
			mouse_press_position = get_global_mouse_position()
		if Input.is_action_pressed("mouse_down"):
			mouse_release_position = get_global_mouse_position()
			rotation = atan2(mouse_press_position.y - mouse_release_position.y, mouse_press_position.x - mouse_release_position.x)
		if Input.is_action_just_released("mouse_down"):
			mouse_release_position = get_global_mouse_position()
			launch_player()
	
	
func launch_player():
	var launch_direction = direction.rotated(rotation)
	var launch_force = launch_direction * 200
	apply_impulse(Vector2.ZERO, launch_force)


func stick(_body):
	set_linear_velocity(Vector2.ZERO)
	sleeping = true
