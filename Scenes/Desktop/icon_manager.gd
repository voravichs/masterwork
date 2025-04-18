extends Control
class_name IconManager

const PADDING = 16
const MARGIN = 16
const ICON_SIZE = Vector2(128, 160)
const CELL_SIZE = ICON_SIZE + Vector2(PADDING, PADDING)
const ICON_SCENE = preload("res://Scenes/Desktop/FileEntryIcon.tscn")

@onready var input_manager: InputManager = %InputManager
@onready var shadow_sprite: Sprite2D = $ShadowIcon/ShadowSprite
@onready var shadow_label: Label = $ShadowIcon/ShadowLabel
@onready var shadow_icon: Control = $ShadowIcon
@onready var local: Node2D = $Local
@onready var guide_panel: Panel = $GuidePanel

var grid_cols : int
var grid_rows : int
var selected_icon : FileEntryIcon
var dragged_icon : FileEntryIcon
var slots = []
var path : String
var drag_enabled : bool = true

signal double_clicked

func _ready() -> void:
	if !path:
		path = "desktop"
	if size == Vector2(0,0):
		resized.connect(_init_grid)
	else:
		_init_grid()
	input_manager.left_mouse_button_released.connect(_finish_drag)

func _init_grid():
	grid_cols = (size.x - MARGIN * 2) / CELL_SIZE.x
	grid_rows = (size.y - MARGIN * 2) / CELL_SIZE.y
	slots.clear()
	for row in grid_rows:
		var row_arr = []
		for col in grid_cols:
			row_arr.append(null)
		slots.append(row_arr)
	var folder : Folder = FileSystem.find_by_path(path)
	if !folder:
		print("ERR: File not defined!")
		return
	for child : FileSystemEntry in folder.list_entries():
		var icon = ICON_SCENE.instantiate()
		var resource_path : String = child.resource_path
		var resource = load(resource_path)
		icon.desktop_resource = resource
		var pos = next_open_pos()
		if pos != null:
			add_icon(icon, pos)
	for icon : Node in get_children():
		if icon is FileEntryIcon:
			icon.hover_on.connect(_hover_on_icon)
			icon.hover_off.connect(_hover_off_icon)

func add_icon(icon : FileEntryIcon, grid_pos: Vector2i):
	# Remove previous icon in slot if any
	#if slots[grid_pos.y][grid_pos.x]:
		#remove_child(slots[grid_pos.y][grid_pos.x])
	slots[grid_pos.y][grid_pos.x] = icon
	icon.position = grid_cell_to_position(grid_pos)
	icon.coords = grid_pos
	add_child(icon)

func grid_cell_to_position(grid_pos: Vector2i) -> Vector2:
	return Vector2(
		grid_pos.x * CELL_SIZE.x + CELL_SIZE.x / 2 + MARGIN,
		grid_pos.y * CELL_SIZE.y + CELL_SIZE.y / 2
		)

func next_open_pos():
	for row in grid_rows:
		for col in grid_cols:
			if !slots[col][row]:
				return Vector2(col, row)
	return null

func _process(delta: float) -> void:
	if dragged_icon && drag_enabled:
		var mouse_pos = get_global_mouse_position()
		var local_pos = local.to_local(mouse_pos)
		if !dragged_icon.drag_boundary.get_global_rect().has_point(mouse_pos):
			var new_cell = Vector2i(
				clamp(floor(local_pos.x / CELL_SIZE.x), 0, grid_cols-1),
				clamp(floor(local_pos.y / CELL_SIZE.y), 0, grid_rows-1)
			)
			if !slots[new_cell.y][new_cell.x]:
				guide_panel.visible = true
				guide_panel.position = grid_cell_to_position(new_cell) - Vector2(ICON_SIZE.x / 2, ICON_SIZE.y / 3)
			shadow_icon.position = local_pos
			shadow_icon.visible = true
		else:
			guide_panel.visible = false
			shadow_icon.visible = false

func _input(event):
	if event is InputEventMouseButton and event.is_action_pressed("click"):
		if event.is_double_click():
			var item_clicked = input_manager.raycast_at_cursor()
			if item_clicked is FileEntryIcon:
				double_clicked.emit(item_clicked)
		elif event.pressed:
			var item_clicked = input_manager.raycast_at_cursor()
			if item_clicked is FileEntryIcon and !selected_icon:
				selected_icon = item_clicked
				item_clicked.panel.self_modulate = Color(0.31, 0.953, 1)
				start_drag(item_clicked)
			elif !item_clicked and selected_icon:
				selected_icon.panel.self_modulate = Color(1, 1, 1)
				selected_icon.panel.modulate = Color(1, 1, 1, 0)
				selected_icon = null
			elif selected_icon != item_clicked:
				selected_icon.panel.self_modulate = Color(1, 1, 1)
				selected_icon.panel.modulate = Color(1, 1, 1, 0)
				selected_icon = item_clicked
				item_clicked.panel.self_modulate = Color(0.31, 0.953, 1)
				start_drag(item_clicked)
			elif selected_icon && selected_icon == item_clicked:
				start_drag(item_clicked)

func _hover_on_icon(icon : FileEntryIcon):
	if !dragged_icon:
		if selected_icon == icon:
			icon.panel.modulate = Color(1, 1, 1, 1)
		else:
			icon.panel.modulate = Color(1, 1, 1, 0.5)

func _hover_off_icon(icon : FileEntryIcon):
	if !dragged_icon:
		if selected_icon == icon:
			icon.panel.modulate = Color(1, 1, 1, 0.5)
		else:
			icon.panel.modulate = Color(1, 1, 1, 0)

func start_drag(icon : FileEntryIcon):
	if drag_enabled:
		dragged_icon = icon
		shadow_sprite.texture = dragged_icon.icon.texture
		shadow_label.text = dragged_icon.label.text

func _finish_drag():
	if dragged_icon and drag_enabled:
		var mouse_pos = get_global_mouse_position()
		var local_pos = local.to_local(mouse_pos)
		if !dragged_icon.drag_boundary.get_global_rect().has_point(mouse_pos):
			var new_cell = Vector2i(
				clamp(floor(local_pos.x / CELL_SIZE.x), 0, grid_cols-1),
				clamp(floor(local_pos.y / CELL_SIZE.y), 0, grid_rows-1)
			)
			if !slots[new_cell.y][new_cell.x]:
				slots[dragged_icon.coords.y][dragged_icon.coords.x] = null
				add_icon(dragged_icon, new_cell)
	dragged_icon = null
	guide_panel.visible = false
	shadow_icon.visible = false
