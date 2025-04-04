extends Control
class_name SymbolCanvas

@export var MAX_LENGTH : int

@onready var canvas_panel: PanelContainer = %CanvasPanel
@onready var symbol_match_label: Label = %SymbolMatchLabel
@onready var cursor_line: Line2D = %CursorLine
@onready var lines: Node2D = %Lines
@onready var symbol_pattern: SymbolPattern = %SymbolPattern

var queue : Array
var tracing : bool = false
var draw_toggle : bool = false
var current_line : Line2D
var line_refs : Array[Line2D] = []
var symbol_res : Dictionary

signal symbol_drawn

func _ready() -> void:
	symbol_pattern.new_origin.connect(_begin_tracing)
	symbol_pattern.new_destination.connect(_finish_tracing)
	symbol_pattern.found_match.connect(_update_match)

func _begin_tracing() -> void:
	current_line = Line2D.new()
	current_line.default_color = Color8(0xef, 0xce, 0x89)
	line_refs.append(current_line)
	lines.add_child(current_line)
	tracing = true

func _finish_tracing() -> void:
	current_line.clear_points()
	current_line.add_point(symbol_pattern.origin_dot.global_position)
	current_line.add_point(symbol_pattern.destination_dot.global_position)
	tracing = false
	symbol_match_label.text = ""
	symbol_pattern.update_graph()
	symbol_pattern.reset_tracing()

func _update_match(matched_symbol : Dictionary) -> void:
	if matched_symbol:
		symbol_match_label.text = "Matched: " + matched_symbol.name
		symbol_res = matched_symbol
	else:
		symbol_match_label.text = ""

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("draw_toggle"):
		draw_toggle = true
		symbol_pattern.draw_toggle = true
		symbol_pattern.reset_all_dots()
		if current_line:
			current_line.clear_points()
	elif event.is_action_released("draw_toggle"):
		draw_toggle = false
		symbol_pattern.draw_toggle = false
		symbol_pattern.reset_all_dots()
		if current_line:
			current_line.clear_points()
	if event.is_action_pressed("clear_symbol_canvas"):
		symbol_pattern.reset_all_dots()
		symbol_pattern.reset_graph()
		symbol_res = {}
		current_line.clear_points()
		clear_lines()
		symbol_match_label.text = ""
	if draw_toggle and event is InputEventMouseMotion:
		var mouse_pos : Vector2 = event.position
		var canvas_rect : Rect2 = Rect2(canvas_panel.position, canvas_panel.size)
		if canvas_rect.has_point(mouse_pos):
			if current_line and tracing and symbol_pattern.origin_dot:
				current_line.clear_points()
				current_line.add_point(symbol_pattern.origin_dot.global_position)
				current_line.add_point(mouse_pos)

func _process(_delta: float) -> void:
	
	if draw_toggle:
		# Get mouse position, update collision
		var global_pos : Vector2 = get_global_mouse_position()
		var adj_pos : Vector2 = global_pos - position
		var panel_rect : Rect2 = Rect2(canvas_panel.global_position, canvas_panel.size)
		
		# Check in bounds of panel
		if (panel_rect.has_point(global_pos)):
			# Add position to queue, remove oldest item if queue is full
			queue.push_front(adj_pos)
			if queue.size() > MAX_LENGTH:
				queue.pop_back()
			
			# Clear all points, draw the current points
			cursor_line.clear_points()
			for point : Vector2 in queue:
				cursor_line.add_point(point)
		else:
			queue.clear()
			cursor_line.clear_points()
	else:
			queue.clear()
			cursor_line.clear_points()

func clear_lines() -> void:
	for line in line_refs:
		lines.remove_child(line)
	line_refs.clear()

func _on_confirm_pressed() -> void:
	if symbol_res:
		symbol_drawn.emit(symbol_res)

func _on_close_pressed() -> void:
	symbol_res = {}
	symbol_drawn.emit(symbol_res)
