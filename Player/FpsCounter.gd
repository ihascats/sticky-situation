extends Label

func _process(_delta):
	var fps = Engine.get_frames_per_second()
	set_text("FPS: " + str(fps))
