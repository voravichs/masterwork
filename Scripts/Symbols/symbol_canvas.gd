extends Control

@export var MAX_LENGTH : int
@onready var cursor_line: Line2D = $CursorLine
@onready var canvas_panel: PanelContainer = %CanvasPanel
@onready var lines: Node2D = $Lines
@onready var symbol_pattern: SymbolPattern = $SymbolPattern

var queue : Array
var tracing : bool = false
var draw_toggle = false
var current_line : Line2D
var line_refs : Array[Line2D] = []


func _ready() -> void:
	symbol_pattern.new_origin.connect(_begin_tracing)
	symbol_pattern.new_destination.connect(_finish_tracing)

func _begin_tracing():
	current_line = Line2D.new()
	current_line.default_color = Color8(0xef, 0xce, 0x89)
	line_refs.append(current_line)
	lines.add_child(current_line)
	tracing = true

func _finish_tracing():
	current_line.clear_points()
	current_line.add_point(symbol_pattern.origin_dot.global_position)
	current_line.add_point(symbol_pattern.destination_dot.global_position)
	tracing = false
	symbol_pattern.reset_tracing()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("draw_toggle"):
		draw_toggle = not draw_toggle
		symbol_pattern.draw_toggle = not symbol_pattern.draw_toggle
	if event.is_action_pressed("clear_symbol_canvas"):
		symbol_pattern.reset_all_dots()
		current_line.clear_points()
	if draw_toggle:
		var mouse_pos = event.position
		var canvas_rect : Rect2 = Rect2(canvas_panel.position, canvas_panel.size)
		if event is InputEventMouseMotion and canvas_rect.has_point(mouse_pos):
			if current_line and tracing and symbol_pattern.origin_dot:
				current_line.clear_points()
				current_line.add_point(symbol_pattern.origin_dot.global_position)
				current_line.add_point(mouse_pos)

func _process(_delta: float) -> void:
	if draw_toggle:
		# Get mouse position, update collision
		var global_pos = get_global_mouse_position()
		var adj_pos = global_pos - position
		var panel_rect = Rect2(canvas_panel.global_position, canvas_panel.size)
		
		# Check in bounds of panel
		if (panel_rect.has_point(global_pos)):
			# Add position to queue, remove oldest item if queue is full
			queue.push_front(adj_pos)
			if queue.size() > MAX_LENGTH:
				queue.pop_back()
			
			# Clear all points, draw the current points
			cursor_line.clear_points()
			for point in queue:
				cursor_line.add_point(point)
		else:
			queue.clear()
			cursor_line.clear_points()
	else:
			queue.clear()
			cursor_line.clear_points()
