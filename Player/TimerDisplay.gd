extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var time_elapsed = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_timer(max_time):
	time_elapsed += 0.1
	if time_elapsed >= 10:
		time_elapsed = 10
		text = str(max_time - time_elapsed)
		get_parent().die()
		return
	text = str(max_time - time_elapsed)
