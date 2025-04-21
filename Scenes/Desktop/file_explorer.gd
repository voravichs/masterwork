extends Control
class_name FileExplorer

@onready var breadcrumb_bar: BreadcrumbBar = %BreadcrumbBar
@onready var icon_input: Control = %IconInput
@onready var title_bar: HBoxContainer = %TitleBar
@onready var main_window: NinePatchRect = $MainWindow
@onready var resize_br: Control = %ResizeBR
@onready var resize_bl: Control = %ResizeBL

const ICON_MANAGER = preload("res://Scenes/Desktop/IconManager.tscn")
const MIN_SIZE = Vector2(240, 240)

var path : String
var icon_manager_ref : IconManager
var dragging := false
var drag_offset := Vector2.ZERO
var resizing = false
var resize_offset = Vector2.ZERO

signal close

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Folder path for breadcrumbs
	var debug_folder_path = "User/desktop"
	if !path:
		path = debug_folder_path
	breadcrumb_bar.set_breadcrumbs(path)
	# Setup Icon Manager
	var icons : IconManager = ICON_MANAGER.instantiate()
	icon_manager_ref = icons
	icons.path = path
	icons.parent_z = z_index
	icons.double_clicked.connect(_on_double_click_icon)
	icon_input.add_child(icons)

func _on_double_click_icon() -> void:
	print("poggies")

func _on_close() -> void:
	close.emit(self)

func _on_title_bar_mouse_entered() -> void:
	#print("enter title bar")
	pass # Replace with function body.

func _on_title_bar_mouse_exited() -> void:
	#print("exit title bar")
	pass # Replace with function body.

func _on_title_bar_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				# Where did the pointer first hit relative to window top-left?
				drag_offset = get_global_mouse_position() - main_window.global_position
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		# Keep the offset between mouse and window corner
		var target_pos = get_global_mouse_position() - drag_offset
		var desktop_size = get_viewport_rect().size
		var window_size = main_window.size
		var min_pos = Vector2(0, 0)
		var max_pos = desktop_size - window_size
		target_pos.x = clamp(target_pos.x, min_pos.x, max_pos.x)
		target_pos.y = clamp(target_pos.y, min_pos.y, max_pos.y)
		main_window.global_position = target_pos

func _on_resize_br_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			resizing = true
			resize_offset = get_global_mouse_position() - (main_window.global_position + main_window.size)
		elif event.button_index == MOUSE_BUTTON_LEFT and !event.pressed:
			resizing = false
	elif event is InputEventMouseMotion and resizing:
		var mouse = get_global_mouse_position()
		var new_size = (mouse - main_window.global_position - resize_offset)
		var desktop_rect = get_viewport_rect()
		var max_size = desktop_rect.size - main_window.global_position
		new_size = Vector2(
			clamp(new_size.x, MIN_SIZE.x, max_size.x),
			clamp(new_size.y, MIN_SIZE.y, max_size.y)
			)
		main_window.size = new_size

func _on_resize_bl_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.
