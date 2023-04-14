extends RigidBody2D

export var launch_force_magnitude = 200

var direction = Vector2.RIGHT
var mouse_press_position = Vector2.ZERO
var mouse_release_position = Vector2.ZERO
var charge_up

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
			charge_up = 1 - (mouse_press_position.distance_to(mouse_release_position) / 100)
			charge_up = clamp(charge_up, 0, 1)
			$ChargeUp/ShowCharge.scale.x = charge_up
			$LunaSprite.rotation = atan2(mouse_press_position.y - mouse_release_position.y, mouse_press_position.x - mouse_release_position.x)
		if Input.is_action_just_released("mouse_down"):
			mouse_release_position = get_global_mouse_position()
			launch_player()

func launch_player():
	var launch_direction = direction.rotated($LunaSprite.rotation)
	var launch_force = launch_direction * ((1 - charge_up) * launch_force_magnitude)
	apply_impulse(Vector2.ZERO, launch_force)


func stick(_body):
	sleeping = true
	charge_up = 1
	$ChargeUp/ShowCharge.scale.x = charge_up
