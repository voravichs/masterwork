extends Node2D
class_name InputManager

const COLLISION_MASK_DESKTOP_ICON = 4

signal left_mouse_button_clicked
signal left_mouse_button_released

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			left_mouse_button_clicked.emit()
		else:
			left_mouse_button_released.emit()

func raycast_at_cursor() -> Node:
	var space_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	var result = space_state.intersect_point(parameters)
	if result.size() > 0:
		var result_collision_mask = result[0].collider.collision_mask
		if result_collision_mask == COLLISION_MASK_DESKTOP_ICON:
			return result[0].collider.get_parent()
		else:
			return null
	else:
		return null
