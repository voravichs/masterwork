extends Node2D

@onready var shadow_icon: Control = $ShadowIcon
@onready var shadow_label: Label = $ShadowIcon/ShadowLabel
@onready var shadow_sprite: Sprite2D = $ShadowIcon/ShadowSprite
@onready var guide_panel: Panel = %GuidePanel

var dragged_icon : FileEntryIcon = null
var from_manager : IconManager = null
var drop_targets : Array[IconManager] = []

func _process(delta):
	if dragged_icon:
		var global_mouse : Vector2 = get_global_mouse_position()
		var hovered_target : IconManager = get_drop_target_at(global_mouse)
		if hovered_target:
			# Calculate local_pos, potential drop cell coordinate in target
			var local_pos = hovered_target.local.to_local(global_mouse)
			var snap_cell : Vector2 = hovered_target.global_to_cell(global_mouse)
			# Guides
			if hovered_target.can_accept_drop(snap_cell, dragged_icon):
				guide_panel.visible = true
				guide_panel.position = hovered_target.grid_cell_to_position(snap_cell) \
					+ hovered_target.local.global_position \
					- Vector2(hovered_target.ICON_SIZE.x / 2, hovered_target.ICON_SIZE.y / 3)
				if guide_panel.z_index < hovered_target.parent_z:
					guide_panel.z_index = hovered_target.parent_z + 1
				else:
					guide_panel.z_index = 0
				shadow_icon.visible = true
				shadow_icon.position = global_mouse
			else:
				guide_panel.visible = false
				shadow_icon.visible = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		finish_drag()

func get_drop_target_at(global_pos) -> IconManager:
	for i in range(drop_targets.size() - 1, -1, -1):
		var target = drop_targets[i]
		if not target.visible:
			continue
		var global_rect = Rect2(target.global_position, target.size)
		if global_rect.has_point(global_pos):
			return target
	return null

func register_drop_target(target: Control):
	drop_targets.append(target)

func unregister_drop_target(target: Control):
	drop_targets.erase(target)

func start_drag(icon : FileEntryIcon, from: IconManager):
	dragged_icon = icon
	from_manager = from
	shadow_sprite.texture = dragged_icon.icon.texture
	shadow_label.text = dragged_icon.label.text

func finish_drag():
	if dragged_icon:
		var global_mouse = get_global_mouse_position()
		var to_manager = get_drop_target_at(global_mouse)
		if to_manager:
			var local_pos : Vector2 = to_manager.local.to_local(global_mouse)
			var snap_cell : Vector2 = to_manager.global_to_cell(global_mouse)
			if to_manager.can_accept_drop(snap_cell, dragged_icon):
				from_manager.remove_icon(dragged_icon)
				to_manager.receive_drop(dragged_icon, snap_cell)
	dragged_icon = null
	guide_panel.visible = false
	shadow_icon.visible = false
