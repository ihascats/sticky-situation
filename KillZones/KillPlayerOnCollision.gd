extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var _connect_value = connect("body_entered", self, "kill")

func kill(body):
	if (body.name == "Luna"):
		body.die()
