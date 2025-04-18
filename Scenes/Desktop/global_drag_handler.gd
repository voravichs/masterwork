extends Node2D
var drop_targets: Array[Control] = []
var dragging = false

func register_drop_target(target: Control):
	drop_targets.append(target)

func get_drop_target_at(global_pos: Vector2):
	for target in drop_targets:
		if target.visible and target.get_global_rect().has_point(global_pos):
			return target
	return null
