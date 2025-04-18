extends Control
class_name IconManager

const PADDING = 16
const MARGIN = 16
const ICON_SIZE = Vector2(128, 160)
const CELL_SIZE = ICON_SIZE + Vector2(PADDING, PADDING)
const ICON_SCENE = preload("res://Scenes/Desktop/FileEntryIcon.tscn")

@onready var input_manager: InputManager = %InputManager
@onready var local: Node2D = $Local

var grid_cols : int
var grid_rows : int
var selected_icon : FileEntryIcon
var slots = []
var path : String
var parent_z : int

signal double_clicked

func _ready() -> void:
	if !path:
		path = "desktop"
	if size == Vector2(0,0):
		resized.connect(_init_grid)
	else:
		_init_grid()
	GlobalDragHandler.register_drop_target(self)

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

func grid_cell_to_position(grid_pos: Vector2i) -> Vector2:
	return Vector2(
		grid_pos.x * CELL_SIZE.x + CELL_SIZE.x / 2 + MARGIN,
		grid_pos.y * CELL_SIZE.y + CELL_SIZE.y / 2
		)

func global_to_cell(global_mouse_pos: Vector2) -> Vector2i:
	var local = local.to_local(global_mouse_pos)
	var cell = Vector2i(
		floor((local.x - MARGIN) / CELL_SIZE.x),
		floor((local.y) / CELL_SIZE.y)
	)
	return cell

func next_open_pos():
	for row in grid_rows:
		for col in grid_cols:
			if !slots[col][row]:
				return Vector2(col, row)
	return null

func add_icon(icon: FileEntryIcon, cell: Vector2i):
	slots[cell.y][cell.x] = icon
	icon.coords = cell
	icon.position = grid_cell_to_position(cell)
	add_child(icon)

func can_accept_drop(cell: Vector2i, icon: FileEntryIcon) -> bool:
	# Check bounds
	if cell.x < 0 or cell.y < 0 or cell.x >= grid_cols or cell.y >= grid_rows:
		return false
	if slots[cell.y][cell.x] != null:
		return false
	return true

func receive_drop(icon: FileEntryIcon, cell: Vector2i) -> void:
	if icon.get_parent():
		icon.get_parent().remove_child(icon)
	add_icon(icon, cell)

func remove_icon(icon: FileEntryIcon) -> void:
	if has_node(icon.get_path()):
		remove_child(icon)
	# Remove from slots array
	slots[icon.coords.y][icon.coords.x] = null

func _input(event):
	if event is InputEventMouseButton and event.is_action_pressed("click"):
		if event.is_double_click():
			var item_clicked = input_manager.raycast_at_cursor()
			if item_clicked is FileEntryIcon:
				double_clicked.emit(item_clicked)
		else:
			var item_clicked = input_manager.raycast_at_cursor()
			if item_clicked is FileEntryIcon:
				if selected_icon != item_clicked:
					if selected_icon:
						selected_icon.panel.self_modulate = Color(1, 1, 1)
						selected_icon.panel.modulate = Color(1, 1, 1, 0)
					selected_icon = item_clicked
					item_clicked.panel.self_modulate = Color(0.31, 0.953, 1)
				if GlobalDragHandler.get_drop_target_at(get_global_mouse_position()) == self:
					GlobalDragHandler.start_drag(item_clicked, self)
			else:
				# Clicked an empty spot—deselect
				if selected_icon:
					selected_icon.panel.self_modulate = Color(1, 1, 1)
					selected_icon.panel.modulate = Color(1, 1, 1, 0)
					selected_icon = null

func _hover_on_icon(icon : FileEntryIcon):
	if selected_icon == icon:
		icon.panel.modulate = Color(1, 1, 1, 1)
	else:
		icon.panel.modulate = Color(1, 1, 1, 0.5)

func _hover_off_icon(icon : FileEntryIcon):
	if selected_icon == icon:
		icon.panel.modulate = Color(1, 1, 1, 0.5)
	else:
		icon.panel.modulate = Color(1, 1, 1, 0)
