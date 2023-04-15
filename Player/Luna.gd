extends RigidBody2D

export var launch_force_magnitude = 200

var direction = Vector2.RIGHT
var mouse_press_position = Vector2.ZERO
var mouse_release_position = Vector2.ZERO
var charge_up
var seconds = Timer.new()
const TIME_LIMIT = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(seconds)
	seconds.wait_time = 0.1
	seconds.start()
	seconds.paused = true
	seconds.connect("timeout", $TimerDisplay, "set_timer", [TIME_LIMIT])
	sleeping = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if sleeping:
		if Input.is_action_just_pressed("mouse_down"):
			mouse_press_position = get_global_mouse_position()
		if Input.is_action_pressed("mouse_down"):
			mouse_release_position = get_global_mouse_position()
			charge_up = 1 - (mouse_press_position.distance_to(mouse_release_position) / 100)
			charge_up = clamp(charge_up, 0, 1)
			$ChargeUp/ShowCharge.scale.x = charge_up
			$LunaSprite.rotation = atan2(mouse_press_position.y - mouse_release_position.y, mouse_press_position.x - mouse_release_position.x)
			update_trajectory(direction, launch_force_magnitude, gravity_scale, delta)
		if Input.is_action_just_released("mouse_down"):
			$Trajectory/TrajectoryLine.clear_points()
			mouse_release_position = get_global_mouse_position()
			launch_player()
			seconds.paused = false
			
	# if mouse is not being pressed, player is not sleeping, and velocity is 0, stick the player
	if !sleeping && !Input.is_action_pressed("mouse_down") && linear_velocity == Vector2.ZERO:
		stick({})

func launch_player():
	var launch_direction = direction.normalized().rotated($LunaSprite.rotation)
	var launch_force = launch_direction * ((1 - charge_up) * launch_force_magnitude)
	apply_impulse(Vector2.ZERO, launch_force)


func stick(_body):
	sleeping = true
	charge_up = 1
	$ChargeUp/ShowCharge.scale.x = charge_up
	$Trajectory/TrajectoryLine.clear_points()
	seconds.paused = true

func update_trajectory(dir: Vector2, speed: float, gravity: float, delta: float) -> void:
	$Trajectory/TrajectoryLine.clear_points()
	var max_trajectory_points = 200
	var pos: Vector2 = Vector2.ZERO
	var vel = dir.normalized().rotated($LunaSprite.rotation) * speed * (1 - charge_up)
	for _n in range(max_trajectory_points):
		vel.y += gravity * 100 * delta
		pos += vel * delta
		$Trajectory/TrajectoryLine.add_point(pos)
		
func die():
	modulate = Color(1, 0, 0)

