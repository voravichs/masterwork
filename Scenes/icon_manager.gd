extends Control
class_name IconManager

const CELL_SIZE = Vector2(128, 160)

@export var columns : int
@export var rows : int

@onready var input_manager: InputManager = %InputManager
@onready var shadow_icon: Control = %ShadowIcon
@onready var shadow_sprite: Sprite2D = %ShadowSprite
@onready var shadow_label: Label = %ShadowLabel

var selected_icon : DesktopIcon
var dragged_icon : DesktopIcon
var screen_size : Vector2
var icon_slots = []

signal double_clicked

func _ready() -> void:
	for row in rows:
		icon_slots.append([])
		for col in columns:
			icon_slots[row].append(null)

	input_manager.left_mouse_button_released.connect(_finish_drag)
	screen_size = get_viewport_rect().size
	for icon : Control in get_children():
		if icon is DesktopIcon:
			icon.hover_on.connect(_hover_on_icon)
			icon.hover_off.connect(_hover_off_icon)

func _process(delta: float) -> void:
	if dragged_icon:
		var mouse_pos = get_global_mouse_position()
		if !dragged_icon.drag_boundary.get_global_rect().has_point(mouse_pos):
			shadow_icon.position = mouse_pos
			shadow_icon.visible = true
		else:
			shadow_icon.visible = false

func _input(event):
	if event is InputEventMouseButton and event.is_action_pressed("click"):
		if event.is_double_click():
			var item_clicked = input_manager.raycast_at_cursor()
			if item_clicked is DesktopIcon:
				double_clicked.emit(item_clicked)
		elif event.pressed:
			var item_clicked = input_manager.raycast_at_cursor()
			if item_clicked is DesktopIcon and !selected_icon:
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

func _hover_on_icon(icon : DesktopIcon):
	if selected_icon == icon:
		icon.panel.modulate = Color(1, 1, 1, 1)
	else:
		icon.panel.modulate = Color(1, 1, 1, 0.5)

func _hover_off_icon(icon : DesktopIcon):
	if selected_icon == icon:
		icon.panel.modulate = Color(1, 1, 1, 0.5)
	else:
		icon.panel.modulate = Color(1, 1, 1, 0)

func start_drag(icon : DesktopIcon):
	dragged_icon = icon
	shadow_sprite.texture = dragged_icon.icon.texture
	shadow_label.text = dragged_icon.label.text

func _finish_drag():
	if dragged_icon:
		var mouse_pos = get_global_mouse_position()
		if !dragged_icon.drag_boundary.get_global_rect().has_point(mouse_pos):
			dragged_icon.position = get_global_mouse_position()
		dragged_icon = null
		shadow_icon.visible = false
