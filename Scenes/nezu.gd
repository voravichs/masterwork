extends Node2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# Get the global mouse position
	var mouse_pos = get_global_mouse_position()
	# Update the position of this node to the mouse position
	position = mouse_pos
